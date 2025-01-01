/*****************************************************************************
 * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
 *****************************************************************************
 * Copyright 2021-2025 Marco Spedaletti (asimov@mclink.it)
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

/****************************************************************************
 * INCLUDE SECTION 
 ****************************************************************************/

#include "../../ugbc.h"

/****************************************************************************
 * CODE SECTION 
 ****************************************************************************/

/**
 * @brief Emit code for <strong>DOUBLE BUFFER ...</strong>
 * 
 * @param _environment Current calling environment
 * @param _enabled if double buffer is enabled
 */
/* <usermanual>
@keyword DOUBLE BUFFER
@target coco3
</usermanual> */
void double_buffer( Environment * _environment, int _enabled ) {

    outhead0("; double buffer");
    outhead0("doublebuffer");

    if ( _environment->doubleBufferEnabled != _enabled ) {

        _environment->doubleBufferEnabled = _enabled;

        if ( ! _environment->doubleBufferEnabled ) {
            outline0( "LDA #$8" );
            outline0( "STA GIMESCREENCURRENT" );
            outline0( "LDD #$c000" );
            outline0( "STD GIMEVOFF1" );
            outline0( "JSR GIMERAM" );
        } else {
            outline0( "LDA #$0" );
            outline0( "STA GIMESCREENCURRENT" );
            outline0( "LDD #$c000" );
            outline0( "STD GIMEVOFF1" );
            outline0( "JSR GIMERAM" );
        }

    }

}
