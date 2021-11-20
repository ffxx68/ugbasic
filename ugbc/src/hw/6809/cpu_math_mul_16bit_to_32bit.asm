; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021 Marco Spedaletti (asimov@mclink.it)
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

CPUMATHMUL16BITTO32BIT
    STD   <MATHPTR0
    STX   <MATHPTR2
CPUMATHMUL16BITTO32BIT0    
    LDB   <MATHPTR2
    MUL            
    PSHS  D

    LDA   <MATHPTR1
    LDB   <MATHPTR3
    MUL
    PSHS  D

    LDD   <MATHPTR1
    MUL
    STD   CPUMATHMUL16BITTO32BIT1-2
    
    LDA   <MATHPTR0
    LDB   <MATHPTR3
    MUL
    ADDD  #$5555
CPUMATHMUL16BITTO32BIT1
    BNE   CPUMATHMUL16BITTO32BIT2
    INC   2,S
    
CPUMATHMUL16BITTO32BIT2
    ADDB  ,S
    STB   ,S
    ADCA  3,S
    STA   3,S
    BCC   CPUMATHMUL16BITTO32BIT3
    INC   2,S
CPUMATHMUL16BITTO32BIT3
    PULS  D,X,PC

CPUMATHMUL16BITTO32BIT_SIGNED
    STX   <MATHPTR2
    STD   <MATHPTR0
    EORA  <MATHPTR2     ; sign of product
    STA   CPUMATHMUL16BITTO32BIT_SIGNED2a+1
    
    LDD   <MATHPTR2     ; Y<0 ?
    BPL   CPUMATHMUL16BITTO32BIT_SIGNED1
    NEGA                ; yes ==> negate
    NEGB
    SBCA  #0
CPUMATHMUL16BITTO32BIT_SIGNED1
    TFR   D,X

    LDD   <MATHPTR0     ; X<0 ?
    BPL   CPUMATHMUL16BITTO32BIT_SIGNED2
    NEGA                ; yes ==> negate
    NEGB
    SBCA  #0
    
CPUMATHMUL16BITTO32BIT_SIGNED2
    BSR   CPUMATHMUL16BITTO32BIT

CPUMATHMUL16BITTO32BIT_SIGNED2a    
    LDA   #$55       ; result<0 ?
    BMI   CPUMATHMUL16BITTO32BIT_SIGNED3
    RTS
CPUMATHMUL16BITTO32BIT_SIGNED3    
    PSHS  X
    COM   1,S     ; yes ==> negate
    COM   ,S
    COMA
    NEGB
    BNE   CPUMATHMUL16BITTO32BIT_SIGNED4
    INCA
    BNE   CPUMATHMUL16BITTO32BIT_SIGNED4
    INC   1,S
    BNE   CPUMATHMUL16BITTO32BIT_SIGNED4
    INC   ,S
CPUMATHMUL16BITTO32BIT_SIGNED4
    PULS  X,PC
