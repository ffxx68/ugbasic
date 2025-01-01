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

/* <usermanual>
@keyword POINT (function)

@target zx
 </usermanual> */
Variable * point( Environment * _environment, char * _x, char * _y ) {

    MAKE_LABEL

    Variable * result = variable_temporary( _environment, VT_COLOR, "(point's result)");

    if ( !_x ) {
        _x = variable_retrieve( _environment, "XGR" )->name;
    }

    if ( !_y ) {
        _y = variable_retrieve( _environment, "YGR" )->name;
    }

    deploy( zxvars, src_hw_zx_vars_asm);
    deploy( plot, src_hw_zx_plot_asm );

    Variable * x = variable_retrieve_or_define( _environment, _x, VT_POSITION, 0 );
    Variable * y = variable_retrieve_or_define( _environment, _y, VT_POSITION, 0 );

    outline1("LD A, (%s)", address_displacement(_environment, x->realName, "1") );
    outline0("CP 0");
    outline1("JR NZ, %s", label );
    outline1("LD A, (%s)", x->realName );
    outline0("LD H, A");
    outline1("LD A, (%s)", y->realName );
    outline0("LD L, A");
    outline0("CALL PLOTG");
    outhead1("%s:", label );
    outline1("LD (%s), A", result->realName );

    return result;

}
