; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2023 Marco Spedaletti (asimov@mclink.it)
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
;*                          IMAGES ROUTINE FOR GIME                            *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

; ----------------------------------------------------------------------------
; - Get image to bitmap
; ----------------------------------------------------------------------------

GETIMAGE

    ; We must do nothing if we are in text mode!
    LDA CURRENTTILEMODE
    BEQ GETIMAGEGO
    RTS

GETIMAGEGO

    ; Convert PLOTX, PLOTY into the first byte of video RAM.

    LDD IMAGEX
    STD PLOTX
    LDD IMAGEY
    STD PLOTY

    JSR GIMECALCPOSBM

    ; Based on bpp, we 

    LDB PALETTELIMIT
    CMPB #2
    BEQ GETIMAGEGOS3
    CMPB #4
    BEQ GETIMAGEGOS2
    CMPB #16
    BEQ GETIMAGEGOS1
    RTS

    ; Load the width from the header, and calculate
    ; the size of the writing in bytes.

GETIMAGEGOS3
    LDD , Y
    LSRA
    RORB
    LSRA
    RORB
    LSRA
    RORB
    JMP GETIMAGEGOSX

GETIMAGEGOS2
    LDD , Y
    LSRA
    RORB
    LSRA
    RORB
    JMP GETIMAGEGOSX

GETIMAGEGOS1
    LDD , Y
    LSRA
    RORB
    JMP GETIMAGEGOSX

GETIMAGEGOSX
    STD IMAGEW
    LDA 2, Y
    STA IMAGEH
    
    LEAY 3,Y

    LDU IMAGEW
GETIMAGEL1    
    LDA , X+
    STA , Y+
    LEAU -1, U
    CMPU #0
    LBNE GETIMAGEL1
    
    CLRA
    LDB CURRENTSL
    SUBD IMAGEW
    LEAX D, X

    DEC IMAGEH
    LDB IMAGEH
    CMPB #0
    BEQ GETIMAGECOMMONE

    LDU IMAGEW
    JMP GETIMAGEL1

GETIMAGECOMMONE
    LDA #0
GETIMAGECOMMONEL1
    JSR GIMEGETPALETTE
    STB , Y+
    INCA
    CMPA PALETTELIMIT
    BNE GETIMAGECOMMONEL1
    RTS
