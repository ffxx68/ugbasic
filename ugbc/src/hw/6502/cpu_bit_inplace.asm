; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2025 Marco Spedaletti (asimov@mclink.it)
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
;*                        SET/UNSET A BIT INSIDE A BYTE                        *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

; Set/reset bit A of byte DE
;  - TEMPPTR = byte to operate
;  - A = position
;  - set to 1 if carry flag is set
CPUBITINPLACE:
    BCC CPUBITINPLACE0

CPUBITINPLACE1:
    PHA
    LDA #<BITMASK
    STA TMPPTR2
    LDA #>BITMASK
    STA TMPPTR2+1
    PLA
    TAY
    LDA (TMPPTR2), Y
    LDY #0
    ORA (TMPPTR), Y
    STA (TMPPTR), Y
    RTS

CPUBITINPLACE0:
    PHA
    LDA #<BITMASKN
    STA TMPPTR2
    LDA #>BITMASKN
    STA TMPPTR2+1
    PLA
    TAY
    LDA (TMPPTR2), Y
    LDY #0
    AND (TMPPTR), Y
    STA (TMPPTR), Y
    RTS
