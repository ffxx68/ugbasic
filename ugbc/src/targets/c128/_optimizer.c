/*****************************************************************************
 * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
 *****************************************************************************
 * Copyright 2021-2022 Marco Spedaletti (asimov@mclink.it)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *----------------------------------------------------------------------------
 * Concesso in licenza secondo i termini della Licenza Apache, versione 2.0
 * (la "Licenza"); è proibito usare questo file se non in conformità alla
 * Licenza. Una copia della Licenza è disponibile all'indirizzo:
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Se non richiesto dalla legislazione vigente o concordato per iscritto,
 * il software distribuito nei termini della Licenza è distribuito
 * "COSÌ COM'È", SENZA GARANZIE O CONDIZIONI DI ALCUN TIPO, esplicite o
 * implicite. Consultare la Licenza per il testo specifico che regola le
 * autorizzazioni e le limitazioni previste dalla medesima.
 ****************************************************************************/

 /* MOS 6502/6510 optimizations for ugBasic by M.Spedaletti
  * Based on Motorola 6809 optimizations for ugBasic by S.Devulder
  *
  * The idea here is to look for specific patterns over consecutive (1 to 4)
  * lines of code generated by ugBasic compiler, and reorganize it locally
  * by another pattern that contains a more efficent code achieving the same
  * result.
  *
  * It does multiple passes over the source as local rewrites can be
  * applied on previous rewrites, resulting in a avalanche effects that
  * optimizes the source far away from one can guess from the basic patterns.
  *
  * The optimizer can also perform some data flow analysis. It can for
  * instance see that one of the accumulator is $00 to simplify code. It can
  * also detect that some data in memory are written but never read. These
  * are called dead-data. It will then remove all reference to these data in
  * the code making it smaller and faster (as a useless write is not
  * performed anymore).
  *
  * Real full data-flow analysis should normally be able to detect data which
  * is written two times in a row whithout being read in-between. These are
  * also called dead-data since the first written value is also lost. These
  * dead-data typically appear during the avalanche effect occuring during
  * previous optimizations passes. Write operation to these dead-data can
  * also be removed harmlessly.
  *
  * Unfortunately this version of the optimized doesn't have yet a complete
  * data-flow analyzer. Instead, heuristics is used to guess whether a memory
  * operation accesses a dead data. In that case the optimizer will indicate
  * in the commented-out code that the data is *presumed dead*. The
  * heuristics are carefully choosen from the patterns generated by ugBasic
  * and make good guesses. But if you consider these as too dangerous you
  * can disable all of them with the "ALLOW_UNSAFE" flag below.
  *
  * Last the optimizer will also attempt to reorganize the data to get a
  * faster & shorter code. Some data will be "inlined" in the code, making
  * the code auto-modifiable which is no problem for the mc6809. And some
  * "heavily used" data will be moved into the direct-page location for
  * faster accesses.
  */

/****************************************************************************
 * INCLUDE SECTION 
 ****************************************************************************/

#include "../../ugbc.h"
#include <stdarg.h>

/****************************************************************************
 * CODE SECTION 
 ****************************************************************************/

#define DIRECT_PAGE     0x2100
#define LOOK_AHEAD      5
#define ALLOW_UNSAFE    1
#define KEEP_COMMENTS   1

#define DO_DIRECT_PAGE  1
#define DO_INLINE       1
#define DO_UNREAD       1

/* expanable string */
typedef struct {
    char *str; /* actual string */
    int   len; /* string length (not counting null char) */
    int   cap; /* capacity of buffer */
} *buffer;

/* deallocate a buffer */
static buffer buf_del(buffer buf) {
    if(buf != NULL) {
        free(buf->str);
        buf->str = NULL;
        buf->cap = 0;
        buf->len = 0;
        free(buf);
    }

    return NULL;
}

/* allocate a buffer */
static buffer buf_new(int size) {
    buffer buf = malloc(sizeof(*buf));
    if(buf != NULL) {
        buf->len = 0;
        buf->cap = size+1;
        buf->str = malloc(buf->cap);
        buf->str[0] = '\0';
    }
    return buf;
}

/* ensure the buffer can hold len data */
static buffer _buf_cap(buffer buf, int len) {
    if(len+1 >= buf->cap) {
        buf->cap = len + 1 + MAX_TEMPORARY_STORAGE;
        buf->str = realloc(buf->str, buf->cap);
    }
    return buf;
}

/* append a string to a buffer */
static buffer buf_cat(buffer buf, char *string) {
    if(buf != NULL) {
        int len = strlen(string);
        _buf_cap(buf, buf->len + len);
        strcpy(&buf->str[buf->len], string);
        buf->len += len;
    }
    return buf;
}

/* copy a string into a buffer */
static buffer buf_cpy(buffer buf, char *string) {
    if(buf != NULL) buf->len = 0;
    return buf_cat(buf, string);
}

/* append a char at the end of the buffer */
static inline buffer buf_add(buffer buf, char c) {
    if(buf) {
        _buf_cap(buf, buf->len + 1);
        buf->str[buf->len] = c;
        ++buf->len;
        buf->str[buf->len] = '\0';
    }
    return buf;
}

/* vprintf like function */
static buffer buf_vprintf(buffer buf, const char *fmt, va_list ap) {
    if(buf != NULL) {
        int len = 0, avl;
        do {
            _buf_cap(buf, buf->len + len);
            avl = buf->cap - buf->len;
            len = vsnprintf(&buf->str[buf->len], avl, fmt, ap);
        } while(len >= avl);
        buf->len += len;
    }
    return buf;
}

/* sprintf like function */
#ifdef __GNUC__
static buffer buf_printf(buffer buf, const char *fmt, ...)
    __attribute__ ((format (printf, 2, 3)));
#endif
static buffer buf_printf(buffer buf, const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    buf_vprintf(buf, fmt, ap);
    va_end(ap);
    return buf;
}

/* fgets-like */
static buffer buf_fgets(buffer buf, FILE *f) {
    int c;

    buf_cpy(buf, "");

    while( (c = fgetc(f)) != EOF) {
        buf_add(buf, (char)c);
        if(c=='\n') break;
    }

    return buf;
}

/* strcmp */
static int buf_cmp(buffer a, buffer b) {
    if(a) return b ? strcmp(a->str, b->str) : 1;
    else return -1;
}

#define TMP_BUF_POOL 32
static struct tmp_buf_pool {
    buffer buf;
    void *key1;
    int key2;
} tmp_buf_pool[TMP_BUF_POOL];

/* an integer hash
   https://gist.github.com/badboy/6267743
*/
static unsigned int tmp_buf_hash(unsigned int key) {
    key ^= (key<<17) | (key>>16);
    return key;
}

/* a static one-time buffer */
static buffer tmp_buf(void *key1, unsigned int key2) {
    int hash = tmp_buf_hash(((intptr_t)key1)*31 + key2) % TMP_BUF_POOL;
    struct tmp_buf_pool *tmp = &tmp_buf_pool[hash];
    int count = 0;

    while(tmp->buf!=NULL && (tmp->key1!=key1 || tmp->key2!=key2)) {
        ++count;
        if(++tmp == &tmp_buf_pool[TMP_BUF_POOL]) {
            tmp = tmp_buf_pool;
        }
    }

    if(tmp->buf == NULL) {
        if(count == TMP_BUF_POOL) {
            fprintf(stderr, "TMP_BUF_POOL to short\n");
            exit(-1);
        }
        tmp->buf  = buf_new(0);
        tmp->key1 = key1;
        tmp->key2 = key2;
    }

    return tmp->buf;
}
#define TMP_BUF tmp_buf(__FILE__, __LINE__)

static void tmp_buf_clr(void *key1) {
    struct tmp_buf_pool *tmp = &tmp_buf_pool[0];
    for(;tmp!=&tmp_buf_pool[TMP_BUF_POOL];++tmp) {
        if(tmp->key1 == key1) tmp->buf = buf_del(tmp->buf);
    }
}
#define TMP_BUF_CLR tmp_buf_clr(__FILE__)

/* returns true if the buffer matches a comment or and empty line */
int isAComment( buffer buf ) {
    char * _buffer = buf->str;

    if ( ! *_buffer ) {
        return 1;
    }
    if ( *_buffer == '\r' || *_buffer == '\n' ) {
        return 1;
    }
    while( * _buffer ) {
        if ( *_buffer == ' ' || *_buffer == '\t' ) { 
            ++_buffer;
        } else if ( *_buffer == ';' ) {
            return 1;
        } else {
            return 0;
        }
    }
    return 0;
}

/* returns an UPPER-cased char */
static inline char _toUpper(char a) {
    return (a>='a' && a<='z') ? a-'a'+'A' : a;
}

/* returns true if char is end of line ? */
static inline int _eol(char c) {
    return c=='\0' || c=='\n';
}

/* returns true if both char matches */
static inline int _eq(char pat, char txt) {
    return (pat<=' ') ? (txt<=' ') : (_toUpper(pat)==_toUpper(txt));
}

/* a version of strcmp that ends at EOL and deal our special equality. */
int _strcmp(buffer _s, buffer _t) {
    char *s = _s->str, *t = _t->str;

    while(!_eol(*s) && !_eol(*t) && _eq(*s,*t)) {
        ++s;
        ++t;
    }
    return _eol(*s) && _eol(*t) ? 0 : _eol(*s) ? 1 : -1;
}

/* Matches a string:
    - ' ' maches anthing <= ' ' (eg 'r', \n', '\t' or ' ' )
    - '*' matches up to the next one in the pattern.
   Matched content is copied into buffers passed as varargs. If
   a passed variable is NULL the matched content corresponding
   to it is not copied.

   Returns the last matched '*' or the buffer if pattern is fully
   matched, or NULL otherwise meaning "no match".
*/
static buffer match(buffer _buf, const char *_pattern, ...) {
    buffer ret = _buf;
    const char *s = _buf->str, *p = _pattern;
    va_list ap;

    va_start(ap, _pattern);

    while(!_eol(*s) && *p) {
        if(*p==' ') {while(*p==' ') ++p;
            if(!_eq(' ', *s)) {
                ret = NULL;
                break;
            }
            while(!_eol(*s) && _eq(' ', *s)) ++s;
        } else if(*p=='*') {
            buffer m = va_arg(ap, buffer); ++p;
            if(m != NULL) {
                ret = buf_cpy(m, "");
            }
            while(!_eol(*s) && !_eq(*p, *s)) buf_add(m, *s++);
            if(!_eq(*p,*s)) {
                ret = NULL;
                break;
            }
        } else if(_toUpper(*s++) != _toUpper(*p++)) {
            ret = NULL;
            break;
        }
    }

    va_end(ap);

    return *p=='\0' ? ret : NULL;
}

/* number of lines changed */
static int change        = 0;
static int peephole_pass = 0;
static int num_dp        = 0; /* number of variables relocated to direct-page */
static int num_inlined   = 0; /* number of variables inlined */
static int num_unread    = 0; /* number of variables not read */

#ifdef __GNUC__
static void optim(buffer buf, const char *rule, const char *repl, ...)
    __attribute__ ((format (printf, 3, 4)));
#endif

#define R__(X)  #X
#define R_(X)  R__(X)
#define RULE "r" R_(__LINE__) " "

/* replaces the buffer with an optimized code */
/* original buffer is kept as comment */
static void optim(buffer buf, const char *rule, const char *repl, ...) {
    va_list ap;
    buffer tmp = TMP_BUF;
    char *s;

    va_start(ap, repl);
    buf_cpy(tmp, "");

    /* add our own comment if any */
    if(rule) buf_printf(tmp, "; peephole(%d): %s\n", peephole_pass, rule);

    /* comment out line */
    buf_cat(tmp, ";");

    /* copy upto the end of string or upto end of string */
    if ( (s = strchr(buf->str, '\n')) != NULL) *s = '\0'; /* cut at \n */
    buf_cat(tmp, buf->str);
    if( s != NULL ) buf_add(tmp, *s++ = '\n'); /* restore \n */

    /* insert replacement if provided */
    if(repl) {
        buf_vprintf(tmp, repl, ap);
        buf_cat(tmp, "\n");
    }

    /* copy remaining comments */
    if(s) buf_cat(tmp, s);

    /* write result back into input buffer */
    buf_cpy(buf, tmp->str);

    /* one more change */
    ++change;

    va_end(ap);
}

/* returns true if the buffer matches a zero value */
static int isZero(char *s) {
    if(*s == '$') ++s;
    while(*s == '0') ++s;
    return _eq(' ', *s);
}
static int _isZero(buffer buf) {
    return buf!=NULL && isZero(buf->str);
}

/* returns true if buf matches any op using the ALU between memory and a register */
static int chg_reg(buffer buf, char * REG) {
    if ( strcmp( REG, "A" ) == 0 ) {
        if(match(buf, " ADC")) return 1;
        if(match(buf, " AND")) return 1;
        if(match(buf, " EOR")) return 1;
        if(match(buf, " LDA")) return 1;
        if(match(buf, " ORA")) return 1;
        if(match(buf, " SBC")) return 1;
    } else if ( strcmp( REG, "X" ) == 0 ) {
        if(match(buf, " LDX")) return 1;
    } else if ( strcmp( REG, "Y" ) == 0 ) {
        if(match(buf, " LDY")) return 1;
    }
    return 0;
}

/* perform basic peephole optimization with a length-4 look-ahead */
static void basic_peephole(buffer buf[LOOK_AHEAD], int zA, int zB) {
    /* allows presumably safe operations */
    int unsafe = ALLOW_UNSAFE;

    /* various local buffers */
    buffer v1 = TMP_BUF;
    buffer v2 = TMP_BUF;
    buffer v3 = TMP_BUF;
    buffer v4 = TMP_BUF;
    
    /* a bunch of rules */

    // Avoid a jsr + rts chain
    // 
    // A tail call occurs when a subroutine finishes by calling another subroutine. 
    // This can be optimised into a JMP instruction:
    // 
    // MySubroutine
    //  lda Foo
    //  sta Bar
    //  jsr SomeRandomRoutine
    //  rts
    //
    // becomes :
    //
    // MySubroutine
    //  lda Foo
    //  sta Bar
    //  jmp SomeRandomRoutine
    //
    // Savings : 9 cycles, 1 byte

	if( match( buf[0], " JSR *", v1 ) && match( buf[1], " RTS " ) ) {
		optim( buf[0], RULE "(JSR, RTS)->(JMP)", "\tJMP %s", v1->str );
		optim( buf[1], RULE "(JSR, RTS)->(JMP)", NULL );
    }

    // // ;Instead of
	// // ld b,$20
	// // ld c,$30
    // // ;try this
    // //     ld bc,$2030
    // // ;or this
    // //     ld bc,(b_num * 256) + c_num		;where b_num goes to b register and c_num to c register
    // // ; -> save 1 byte and 4 T-states
	// if( match( buf[0], " LD B, $*", v1) && match( buf[1], " LD C, $*", v2) ) {
	// 	optim( buf[0], RULE "(LD B, x; LD C, x)->(LD BC, xx)", "\tLD BC, ($%s * 256) + $%s", v1->str, v2->str );
	// 	optim( buf[1], "", NULL );
    // }

    // //
	// if( match( buf[0], " LD A, *", v1) && 
    //     match( buf[1], " LD (*), A", v2) &&
    //     match( buf[2], " LD A, *", v3) &&
    //     _strcmp(v1,v3)==0
    //     ) {
	// 	optim( buf[2], RULE "(LD A, x; LD (x), A; LD A, x)->(LD A, x; LD (x), A)", NULL );
    // }

    // // ;Instead of
    // // ld a,$42
    // // ld (hl),a
    // // ;try this
    // // ld (hl),$42
    // // ; -> save 1 byte and 4 T-states
	// if( match( buf[0], " LD A, $*", v1) && 
    //     match( buf[1], " LD (HL), A")
    //     ) {
	// 	optim( buf[0], RULE "(LD A, x; LD (HL), A)->(LD (HL), x)", "\tLD HL, $%s", v1->str );
	// 	optim( buf[1], NULL, NULL );
    // }

    // // ;Instead of
    // //     ld a,(var)
    // //     inc a
    // //     ld (var),a
    // // ;try this	;Note: if hl is not tied up, use indirection:
    // //     ld hl,var
    // //     inc (hl)
    // //     ld a,(hl) ;if you don't need (hl) in a, delete this line
    // // ; -> save 2 bytes and 2 T-states
	// if( match( buf[0], " LD A, (*)", v1) && 
    //     match( buf[1], " INC A") &&
    //     match( buf[2], " LD (*), A", v2 ) &&
    //     _strcmp( v1, v2 ) == 0
    //     ) {
	// 	optim( buf[0], RULE "(LD A, (x); INC A; LD (x), A)->(LD HL, x; INC (HL))", "\tLD HL, %s", v1->str );
	// 	optim( buf[1], NULL, "\tINC (HL)" );
	// 	optim( buf[2], NULL, NULL );
    // }

    // // ; Instead of :
    // // ld a, (hl)
    // // ld (de), a
    // // inc hl
    // // inc de
    // // ; Use :
    // // ldi
    // // inc bc
    // // ; -> save 1 byte and 4 T-states
	// if( match( buf[0], " LD A, (HL)") && 
    //     match( buf[1], " LD (DE), A" ) &&
    //     match( buf[2], " INC HL" ) &&
    //     match( buf[3], " INC DE" )
    //     ) {
	// 	optim( buf[0], RULE "(LD A, (HL); LD (DE), A; INC HL; INC DE)->(LDI; INC BC)", "\tLDI" );
	// 	optim( buf[1], NULL, "\tINC BC" );
	// 	optim( buf[2], NULL, NULL );
	// 	optim( buf[3], NULL, NULL );
    // }

    // // ;Instead of:
    // //  cp 0
    // // ;Use
    // //  or a
    // // ; -> save 1 byte and 3 T-states
	// if( match( buf[0], " CP 0") ) {
	// 	optim( buf[0], RULE "(CP 0)->(OR A)", "\tOR A" );
    // }

    // //   xor %11111111
    // // ; >
    // //   cpl
    // // ; -> save 1 byte and 3 T-states
	// if( match( buf[0], " XOR $FF") ) {
	// 	optim( buf[0], RULE "(XOR $FF)->(CPL)", "\tCPL" );
    // }

    // // ;Instead of
    // //     ld de,767
    // //     or a       ;reset carry so sbc works as a sub
    // //     sbc hl,de
    // // ;try this
    // //     ld de,-767 ;negation of de
    // //     add hl,de
    // // ; -> 2 bytes and 8 T-states !
	// if( 
    //     match( buf[0], " LD DE, $*", v1 ) &&
    //     match( buf[1], " OR A" ) &&
    //     match( buf[2], " SBC HL, DE" ) 
    // ) {
	// 	optim( buf[0], RULE "(LD DE, x; OR A; SBC HL, DE)->(LD DE, -x; ADD HL, DE)", "\tLD DE, -$%s", v1->str );
	// 	optim( buf[1], NULL, "\tADD HL, DE" );
    // }

    // // ;Instead of
    // //   sla l
    // //   rl h         ; I've actually seen this!
    // // ; >
    // //   add hl,hl
    // // ; -> save 3 bytes and 5 T-states
	// if( 
    //     match( buf[0], " SLA L" ) &&
    //     match( buf[1], " RL H" )
    // ) {
	// 	optim( buf[0], RULE "(SLA+RL)->(ADD)", "\tADD HL, HL" );
	// 	optim( buf[1], NULL, NULL );
    // }

    // // ; Instead of
    // //   and 1
    // //   cp 1
    // //   jr z,foo
    // // ; >
    // //   and 1         ;and sets zero flag, no need for cp
    // //   jr nz,foo
    // // ; -> save 2 bytes and 7 T-states
	// if( 
    //     match( buf[0], " AND $*", v1 ) &&
    //     match( buf[1], " CP $*", v2 ) &&
    //     match( buf[2], " JR Z, *", v3 ) &&
    //     _strcmp( v1, v2 ) == 0
    // ) {
	// 	optim( buf[1], NULL, NULL );
	// 	optim( buf[2], RULE "(AND+CP+JZ)->(AND+JNZ)", " JR NZ, %s", v3->str );
    // }

    // // ;Instead of
    // // call xxxx
    // // ret
    // // ;try this
    // // jp xxxx
    // // ;only do this if the pushed pc to stack is not passed to the call. Example: some kind of inline vputs.
    // // ; -> save 1 byte and 17 T-states
	// if( 
    //     match( buf[0], " CALL *", v1 ) &&
    //     match( buf[1], " RET" )
    // ) {
	// 	optim( buf[0], RULE "(CALL+RET)->(JP)", "\tJP %s", v1->str );
	// 	optim( buf[1], NULL, NULL );
    // }

    // // ;Never use:
    // //     dec B
    // //     jr NZ,loop    ;I have seen this...
    // // ;Use:
    // //     djnz loop
    // // ; save 1 byte and 3 T-states
	// if( 
    //     match( buf[0], " DEC B" ) &&
    //     match( buf[1], " JR NZ, *", v1 )
    // ) {
	// 	optim( buf[0], RULE "(DEC B+JR NZ)->(DJNZ)", "\tDJNZ %s", v1->str );
	// 	optim( buf[1], NULL, NULL );
    // }

	if( match( buf[0], " LDA *", v1 ) && match( buf[1], " LDA *", v2 )
        && strcmp( v1->str, v2->str ) == 0 ) {
        optim( buf[1], RULE "(LDA x, LDA x)->(LDA x) [1]", NULL );
    }

	if( match( buf[0], " LDA *", v1 ) && match( buf[2], " LDA *", v2 ) &&
        ! chg_reg(buf[1], "A")
        && strcmp( v1->str, v2->str ) == 0 ) {
        optim( buf[2], RULE "(LDA x, LDA x)->(LDA x) [2]", NULL );
    }

	if( match( buf[0], " LDA *", v1 ) && match( buf[3], " LDA *", v2 ) &&
        ! chg_reg(buf[1], "A") &&
        ! chg_reg(buf[2], "A")
        && strcmp( v1->str, v2->str ) == 0 ) {
        optim( buf[3], RULE "(LDA x, LDA x)->(LDA x) [3]", NULL );
    }

}

/* optimizations related to variables */

/* variables database */
static struct {
    struct var {
        char *name;
#define NO_REORG  1
#define NO_DP     2
#define NO_INLINE 4
#define NO_REMOVE 8
        int flags;
        int size;
        int nb_rd;
        int nb_wr;
        int offset; /* 0=unchanged, >0 offset to page 0; -1 = candidate for inlining, -2 = inlined */
        char *init;
    } *tab;
    int capacity;
    int size;
    int page0_max;
} vars;

/* clears the database */
static void vars_clear(void) {
    int i;
    for(i=0; i<vars.size; ++i) {
        struct var *v = &vars.tab[i];
        free(v->name);
        if(v->init) free(v->init);
    }
    vars.size = 0;
    vars.page0_max = 0;
}

/* gets (or creates) an entry for a variable from the data-base */
struct var *vars_get(buffer _name) {
    char *name = _name->str;
    struct var *ret = NULL;
    int i;

    char *s=strchr(name,'+');
    if(s) *s='\0';

    for(i=0; i<vars.size ; ++i) {
        if(strcmp(vars.tab[i].name, name)==0) {
            ret = &vars.tab[i];
        }
    }
    if(ret == NULL) {
        if(vars.size == vars.capacity) {
            vars.capacity += 16;
            vars.tab = realloc(vars.tab, sizeof(*vars.tab)*vars.capacity);
        }
        ret = &vars.tab[vars.size++];
        ret->name   = strdup(name);
        ret->flags  = 0;
        ret->size   = 0;
        ret->nb_rd  = 0;
        ret->nb_wr  = 0;
        ret->offset = 0;
        ret->init   = NULL;
    }
    if(s) *s='+';

    return ret;
}

static int vars_ok(buffer name) {
    if(match(name, "_Tstr"))   return 0;
    if(match(name, "_label"))  return 0;

    if(name->str[0]=='_')      return 1;
    if(match(name, "CLIP"))    return 1;
    if(match(name, "XCUR"))    return 1;
    if(match(name, "YCUR"))    return 1;
    if(match(name, "CURRENT")) return 1;
    if(match(name, "FONT"))    return 1;
    if(match(name, "TEXT"))    return 1;
    if(match(name, "LAST"))    return 1;
    if(match(name, "XGR"))     return 1;
    if(match(name, "YGR"))     return 1;
    if(match(name, "FREE_"))   return 1;

    return 0;
}

/* look for variable uses and collect data about he variables */
static void vars_scan(buffer buf[LOOK_AHEAD]) {
    buffer tmp = TMP_BUF;
    buffer arg = TMP_BUF;

    // if( match( buf[0], " * _*+", NULL, buf) ) {
        // struct var *v = vars_get(buf);
        // v->flags |= NO_INLINE;
    // }

    if( match( buf[0], " LD* *",  tmp, arg ) && strstr("A X Y", tmp->str)!=NULL ) 
        if(vars_ok(arg)) {
            struct var *v = vars_get(arg);
            v->nb_rd++;
        };

    if( match( buf[0], " ST* *",  tmp, arg ) && strstr("A X Y", tmp->str)!=NULL ) 
        if(vars_ok(arg)) {
            struct var *v = vars_get(arg);
            v->nb_wr++;
        };

    if( match( buf[0], " *: .byte *", tmp, arg) && vars_ok(tmp) && strchr(buf[0]->str,',')==NULL) {
        struct var *v = vars_get(tmp);
        v->size = 1;
        v->init = strdup(isZero(arg->str) ? "1-1" : arg->str);
    }

    if( match(buf[0], " *: .word *", tmp, arg) && vars_ok(tmp) && strchr(buf[0]->str,',')==NULL) {
        struct var *v = vars_get(tmp);
        v->size = 2;
        v->init = strdup(arg->str);
    }

}

/* compares two variables according to their access-count */
static int vars_cmp(const void *_a, const void *_b) {
    const struct var *a = _a;
    const struct var *b = _b;

    int diff = ((a->nb_rd + a->nb_wr) - (b->nb_rd + b->nb_wr));

    return -(diff!=0 ? diff : strcmp(a->name, b->name)); // Ttmp < Tstr
}

/* removes unread variables */
static void vars_remove(buffer buf[LOOK_AHEAD]) {
    buffer var = TMP_BUF;
    buffer op  = TMP_BUF;
    
    if(!DO_UNREAD) return;
    
    /* unread */
    if(match( buf[0], " ST* *", op, var) && vars_ok(var)) {
        struct var *v = vars_get(var);
        if(v->nb_rd == 0 && v->offset!=-2) {
            v->offset = 0;
            optim(buf[0], "unread", NULL);
        }
    }

    /* remove changed variables */
    if(match( buf[0], " *: .byte ", var)
    || match( buf[0], " *: .word ", var)
    ) if(vars_ok(var)) {
        struct var *v = vars_get(var);
        if(v->nb_rd==0 && 0<v->size && v->size<=4 && 0==(v->flags & NO_REMOVE) && v->offset!=-2) {
            optim(buf[0], "unread",NULL);
            ++num_unread;
        }             
     }
}            

/* collapse all heading spaces into a single tabulation */
static void out(FILE *f, buffer _buf) {
    char *s = _buf->str;
    int tab = 0;
    while(*s==' ' || *s=='\t') {tab = 1; ++s;}
    if(tab) fputs("\t", f);
    fputs(s, f);
}

/* remove space that is sometimes used in indexing mode and makes the optimized produce bad dcode */
static void fixes_indexed_syntax(buffer buf) {
    char *s = buf->str;

    /* not an instruction */
    if(!_eq(' ', *s)) return;

    /* skip over spaces */
    do ++s; while(*s && _eq(' ', *s));

    /* comment */
    if(*s==';') return;

    /* skip over instruction */
    while(*s && !_eq(' ', *s)) ++s;
    if(!*s) return;

    /* skip over spaces */
    do ++s; while(*s && _eq(' ', *s));
    if(!*s) return;

    /* process argment */
    do ++s; while(*s && !_eq(' ', *s));
    if(!*s) return;

}

/* various kind of optimization */
enum OPT_KIND {PEEPHOLE, DEADVARS, RELOCATION1, RELOCATION2};
static int optim_pass( Environment * _environment, buffer buf[LOOK_AHEAD], enum OPT_KIND kind) {
    char fileNameOptimized[MAX_TEMPORARY_STORAGE];
    FILE * fileAsm;
    FILE * fileOptimized;
    int i;
    int still_to_go = LOOK_AHEAD;

    int line = 0;
    int zA = 0, zB = 0;

    sprintf( fileNameOptimized, "%s.asm", get_temporary_filename( _environment ) );
        
    /* prepare for phase */
    switch(kind) {
        case DEADVARS:
        ++peephole_pass;
        num_unread  = 0;
        break;
        
        case RELOCATION1:
        ++peephole_pass;
        // vars_prepare_relocation();
        break;
        
        case RELOCATION2:
        break;
        
        case PEEPHOLE:
        ++peephole_pass;
        // vars_clear();
        break;
    }

    fileAsm = fopen( _environment->asmFileName, "rt" );
    if(fileAsm == NULL) {
        perror(_environment->asmFileName);
        exit(-1);
    }

    fileOptimized = fopen( fileNameOptimized, "wt" );
    if(fileOptimized == NULL) {
        perror(fileNameOptimized);
        exit(-1);
    }            
    
    /* clears our look-ahead buffers */
    for(i = 0; i<LOOK_AHEAD; ++i) buf_cpy(buf[i], "");

    /* global change flag */
    change = 0;

    while( still_to_go ) {
        /* print out oldest buffer */
        if ( line >= LOOK_AHEAD ) out(fileOptimized, buf[0]);

        /* shift the buffers */
        for(i=0; i<LOOK_AHEAD-1; ++i) buf_cpy(buf[i], buf[i+1]->str);

        /* read next line, merging adjacent comments */
        if(feof(fileAsm)) {
            --still_to_go;
            buf_cpy(buf[LOOK_AHEAD-1], "");
        } else do {
            /* read next line */
            buf_fgets( buf[LOOK_AHEAD-1], fileAsm );
            fixes_indexed_syntax(buf[LOOK_AHEAD-1]);
            /* merge comment with previous line if we do not overflow the buffer */
            if(isAComment(buf[LOOK_AHEAD-1])) {
                if(KEEP_COMMENTS) buf_cat(buf[LOOK_AHEAD-2], buf[LOOK_AHEAD-1]->str);
                buf_cpy(buf[LOOK_AHEAD-1], "");
            } else break;
        } while(!feof(fileAsm));

        switch(kind) {
            case PEEPHOLE:
            basic_peephole(buf, zA, zB);
            
            /* only look fo variable when no peephole has been performed */
            if(change == 0) vars_scan(buf);
            break;
            
            case DEADVARS:
            vars_remove(buf);
            break;
            
            case RELOCATION1:
            case RELOCATION2:
            // vars_relocate(buf);
            break;
        }

        ++line;
    }

    /* log info at the end of the file */
    switch(kind) {
        case PEEPHOLE:
        fprintf(fileOptimized, "; peephole: pass %d, %d change%s.\n", peephole_pass, 
            change, change>1 ?"s":"");
        break;
        
        case DEADVARS:
        fprintf(fileOptimized, "; peephole: pass %d, %d var%s removed.\n", peephole_pass, 
            num_unread, num_unread>1 ?"s":"");
        break;
        
        case RELOCATION2:
        fprintf(fileOptimized, "; peephole: pass %d, %d var%s moved to dp, %d var%s inlined.\n", peephole_pass, 
            num_dp, num_dp>1 ?"s":"", 
            num_inlined, num_inlined>1 ? "s":"");
        break;
        
        default:
        break;
    }
    
    (void)fclose(fileAsm);
    (void)fclose(fileOptimized);

    /* makes our generated file the new asm file */
    remove(_environment->asmFileName);
    (void)rename( fileNameOptimized, _environment->asmFileName );
    
    return change;
}

/* main entry-point for this service */
void target_peephole_optimizer( Environment * _environment ) {
    if ( _environment->peepholeOptimizationLimit > 0 ) {
        buffer buf[LOOK_AHEAD];
        int i;

        for(i=0; i<LOOK_AHEAD; ++i) buf[i] = buf_new(0);

        int optimization_limit_count = _environment->peepholeOptimizationLimit;

        do {
            while(optim_pass(_environment, buf, PEEPHOLE)&&optimization_limit_count) {
                --optimization_limit_count;
            };
            optim_pass(_environment, buf, DEADVARS);
        } while(change&&optimization_limit_count);
        optim_pass(_environment, buf, RELOCATION1);
        optim_pass(_environment, buf, RELOCATION2);

        for(i=0; i<LOOK_AHEAD; ++i) buf[i] = buf_del(buf[i]);
        TMP_BUF_CLR;
    }
}
