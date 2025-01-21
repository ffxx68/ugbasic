; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2024 Marco Spedaletti (asimov@mclink.it)
;  * Inspired from modules/z80float, copyright 2018 Zeda A.K. Thomas
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

FPFASTCMP:

	LD B, A
	AND $7F
	INC A
	PUSH AF
	AND $80
	CP $80
	POP AF
	JP Z, FPFASTCMP_SPECIAL
	LD A, B

	PUSH AF
	CALL FPFASTSUB

	POP BC

	XOR 80H
	RET Z
	XOR 80H
	RET Z

	LD C, A
	RES 7, B
	AND $7F
	ADD A, 14
	SUB B
	JR NC, $+4
	XOR A
	RET

	LD A, C
RETURN_NZ_SIGN_A:
	OR $7F
	ADD A, A
	RET

FPFASTCMP_SPECIAL:
	LD A, H
	OR L
	CCF
	RET NZ

	LD A, C
	AND $7F
	INC A
	LD A, B
	PUSH AF
	AND $80
	CP $00
	POP AF
	JP Z, RETURN_NZ_SIGN_A

	LD A, D
	OR E
	RET NZ

	LD A, C
	CP B
	RET
	