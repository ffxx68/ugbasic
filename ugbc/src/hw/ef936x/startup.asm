; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2022 Marco Spedaletti (asimov@mclink.it)
;  *
;  * Licensed under the Apache License, Version 2.0 (the "License");
;  * you may not use this file except in compliance with the License.
;  * You may obtain a copy of the License at
;  *
;  * http://www.apache.org/licenses/LICENSE-2.0
;  *
;  * Unless required by applicable law or agreed to in writing, software
;  * distributed under the License is distributed on an "AS IS" BASIS,
;  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;  * See the License for the specific language governing permissions and
;  * limitations under the License.
;  *----------------------------------------------------------------------------
;  * Concesso in licenza secondo i termini della Licenza Apache, versione 2.0
;  * (la "Licenza"); è proibito usare questo file se non in conformità alla
;  * Licenza. Una copia della Licenza è disponibile all'indirizzo:
;  *
;  * http://www.apache.org/licenses/LICENSE-2.0
;  *
;  * Se non richiesto dalla legislazione vigente o concordato per iscritto,
;  * il software distribuito nei termini della Licenza è distribuito
;  * "COSì COM'è", SENZA GARANZIE O CONDIZIONI DI ALCUN TIPO, esplicite o
;  * implicite. Consultare la Licenza per il testo specifico che regola le
;  * autorizzazioni e le limitazioni previste dalla medesima.
;  ****************************************************************************/
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                                                                             *
;*                          STARTUP ROUTINE ON EF936X                          *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

EF936XSTARTUP
    LDU #COMMONPALETTE
    LDY #$A7DA
    LDX #16
    LDA #0
    STA 1,Y
EF936XSTARTUPL1
    PULU D
    STB ,Y
    STA ,Y
    LEAX -1,X
    BNE EF936XSTARTUPL1
    RTS

WAITVBL
	PSHS D,CC
	ORCC #$50
WAITVBL0X
	LDB $A7E7
	ANDB #$80
	BEQ WAITVBL0X
WAITVBL1X
	LDB $A7E7
	ANDB #$80
	BNE WAITVBL1X
	PULS D,CC
	RTS

ONSWITCHTILEMAPVOID
    RTS

ONSWITCHTILEMAP
    JMP ONSWITCHTILEMAPVOID

DOUBLEBUFFERINIT
    JSR SWITCHTILEMAP0
    JSR CLS
    JSR SWITCHTILEMAP1
    JSR CLS
    JSR SWITCHTILEMAP0
    RTS

DOUBLEBUFFERCLEANUP
    LDD $0000
    STD BITMAPADDRESS
DOUBLEBUFFERCLEANUP2
    LDB #$00
    STB $A7DD
    LDB #$00
    STB $A7E5
    JSR ONSWITCHTILEMAP
    LDA #$0
    STA TILEMAPVISIBLE
    RTS

SWITCHTILEMAP
    LDA TILEMAPVISIBLE
    BEQ SWITCHTILEMAP1

SWITCHTILEMAP0
    LDB #$80
    STB $A7DD
    LDB #$03
    STB $A7E5
    JSR ONSWITCHTILEMAP
    LDA #$0
    STA TILEMAPVISIBLE
    LDD #$6000
    STD BITMAPADDRESS
    RTS

SWITCHTILEMAP1
    LDB #$C0
    STB $A7DD
    LDB #$02
    STB $A7E5
    JSR ONSWITCHTILEMAP
    LDA #$1
    STA TILEMAPVISIBLE
    LDD #$6000
    STD BITMAPADDRESS
    RTS
    