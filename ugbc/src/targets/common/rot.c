/*****************************************************************************
 * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
 *****************************************************************************
 * Copyright 2021-2024 Marco Spedaletti (asimov@mclink.it)
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
@keyword ROT

@english

@italian

@example DRAW "BM0,0;R10;U10;L10;D10"

@usedInExample graphics_draw_01.bas

@target all
</usermanual> */
void rot( Environment * _environment, char * _angle, char * _step ) {

    MAKE_LABEL
    
    if ( _angle ) {

        char rotate0CommandLabel[MAX_TEMPORARY_STORAGE]; sprintf( rotate0CommandLabel, "%sr000", label );
        char rotate45CommandLabel[MAX_TEMPORARY_STORAGE]; sprintf( rotate45CommandLabel, "%sr045", label );
        char rotate90CommandLabel[MAX_TEMPORARY_STORAGE]; sprintf( rotate90CommandLabel, "%sr090", label );
        char rotate135CommandLabel[MAX_TEMPORARY_STORAGE]; sprintf( rotate135CommandLabel, "%sr135", label );
        char rotate180CommandLabel[MAX_TEMPORARY_STORAGE]; sprintf( rotate180CommandLabel, "%sr180", label );
        char rotate225CommandLabel[MAX_TEMPORARY_STORAGE]; sprintf( rotate225CommandLabel, "%sr225", label );
        char rotate270CommandLabel[MAX_TEMPORARY_STORAGE]; sprintf( rotate270CommandLabel, "%sr270", label );
        char rotate315CommandLabel[MAX_TEMPORARY_STORAGE]; sprintf( rotate315CommandLabel, "%sr315", label );
        char done2CommandLabel[MAX_TEMPORARY_STORAGE]; sprintf( done2CommandLabel, "%srdon", label );

        Variable * drawUCommandLetter = variable_retrieve( _environment, "DRAWUCOMMAND" );
        Variable * drawDCommandLetter = variable_retrieve( _environment, "DRAWDCOMMAND" );
        Variable * drawLCommandLetter = variable_retrieve( _environment, "DRAWLCOMMAND" );
        Variable * drawRCommandLetter = variable_retrieve( _environment, "DRAWRCOMMAND" );
        Variable * drawECommandLetter = variable_retrieve( _environment, "DRAWECOMMAND" );
        Variable * drawFCommandLetter = variable_retrieve( _environment, "DRAWFCOMMAND" );
        Variable * drawGCommandLetter = variable_retrieve( _environment, "DRAWGCOMMAND" );
        Variable * drawHCommandLetter = variable_retrieve( _environment, "DRAWHCOMMAND" );

        Variable * drawUDCommandLetter = variable_retrieve( _environment, "DRAWUDCOMMAND" );
        Variable * drawDDCommandLetter = variable_retrieve( _environment, "DRAWDDCOMMAND" );
        Variable * drawLDCommandLetter = variable_retrieve( _environment, "DRAWLDCOMMAND" );
        Variable * drawRDCommandLetter = variable_retrieve( _environment, "DRAWRDCOMMAND" );
        Variable * drawEDCommandLetter = variable_retrieve( _environment, "DRAWEDCOMMAND" );
        Variable * drawFDCommandLetter = variable_retrieve( _environment, "DRAWFDCOMMAND" );
        Variable * drawGDCommandLetter = variable_retrieve( _environment, "DRAWGDCOMMAND" );
        Variable * drawHDCommandLetter = variable_retrieve( _environment, "DRAWHDCOMMAND" );

        Variable * angle = variable_retrieve_or_define( _environment, _angle, VT_BYTE, 0 );

        cpu_compare_and_branch_8bit_const( _environment, angle->realName, 0, rotate0CommandLabel, 1 );
        cpu_compare_and_branch_8bit_const( _environment, angle->realName, 1, rotate45CommandLabel, 1 );
        cpu_compare_and_branch_8bit_const( _environment, angle->realName, 2, rotate90CommandLabel, 1 );
        cpu_compare_and_branch_8bit_const( _environment, angle->realName, 3, rotate135CommandLabel, 1 );
        cpu_compare_and_branch_8bit_const( _environment, angle->realName, 4, rotate180CommandLabel, 1 );
        cpu_compare_and_branch_8bit_const( _environment, angle->realName, 5, rotate225CommandLabel, 1 );
        cpu_compare_and_branch_8bit_const( _environment, angle->realName, 6, rotate270CommandLabel, 1 );
        cpu_compare_and_branch_8bit_const( _environment, angle->realName, 7, rotate315CommandLabel, 1 );

        cpu_label( _environment, rotate0CommandLabel );
        cpu_store_char( _environment, drawUCommandLetter->realName, '1' );
        cpu_store_char( _environment, drawDCommandLetter->realName, '2' );
        cpu_store_char( _environment, drawLCommandLetter->realName, '3' );
        cpu_store_char( _environment, drawRCommandLetter->realName, '0' );
        cpu_store_char( _environment, drawFCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawGCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawECommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawHCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawUDCommandLetter->realName, '6' );
        cpu_store_char( _environment, drawDDCommandLetter->realName, '7' );
        cpu_store_char( _environment, drawLDCommandLetter->realName, '8' );
        cpu_store_char( _environment, drawRDCommandLetter->realName, '5' );
        cpu_store_char( _environment, drawFDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawGDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawEDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawHDCommandLetter->realName, 'x' );
        cpu_jump( _environment, done2CommandLabel );

        cpu_label( _environment, rotate45CommandLabel );
        cpu_store_char( _environment, drawUCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawLCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawRCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawFCommandLetter->realName, '1' );
        cpu_store_char( _environment, drawGCommandLetter->realName, '2' );
        cpu_store_char( _environment, drawECommandLetter->realName, '3' );
        cpu_store_char( _environment, drawHCommandLetter->realName, '0' );
        cpu_store_char( _environment, drawUDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawDDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawLDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawRDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawFDCommandLetter->realName, '6' );
        cpu_store_char( _environment, drawGDCommandLetter->realName, '7' );
        cpu_store_char( _environment, drawEDCommandLetter->realName, '8' );
        cpu_store_char( _environment, drawHDCommandLetter->realName, '5' );
        cpu_jump( _environment, done2CommandLabel );

        cpu_label( _environment, rotate90CommandLabel );
        cpu_store_char( _environment, drawUCommandLetter->realName, '3' );
        cpu_store_char( _environment, drawDCommandLetter->realName, '0' );
        cpu_store_char( _environment, drawLCommandLetter->realName, '2' );
        cpu_store_char( _environment, drawRCommandLetter->realName, '1' );
        cpu_store_char( _environment, drawFCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawGCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawECommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawHCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawUDCommandLetter->realName, '8' );
        cpu_store_char( _environment, drawDDCommandLetter->realName, '5' );
        cpu_store_char( _environment, drawLDCommandLetter->realName, '7' );
        cpu_store_char( _environment, drawRDCommandLetter->realName, '6' );
        cpu_store_char( _environment, drawFDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawGDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawEDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawHDCommandLetter->realName, 'x' );
        cpu_jump( _environment, done2CommandLabel );

        cpu_label( _environment, rotate135CommandLabel );
        cpu_store_char( _environment, drawUCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawLCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawRCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawFCommandLetter->realName, '3' );
        cpu_store_char( _environment, drawGCommandLetter->realName, '0' );
        cpu_store_char( _environment, drawECommandLetter->realName, '2' );
        cpu_store_char( _environment, drawHCommandLetter->realName, '1' );
        cpu_store_char( _environment, drawUDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawDDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawLDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawRDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawFDCommandLetter->realName, '8' );
        cpu_store_char( _environment, drawGDCommandLetter->realName, '5' );
        cpu_store_char( _environment, drawEDCommandLetter->realName, '7' );
        cpu_store_char( _environment, drawHDCommandLetter->realName, '6' );
        cpu_jump( _environment, done2CommandLabel );

        cpu_label( _environment, rotate180CommandLabel );
        cpu_store_char( _environment, drawUCommandLetter->realName, '2' );
        cpu_store_char( _environment, drawDCommandLetter->realName, '1' );
        cpu_store_char( _environment, drawLCommandLetter->realName, '0' );
        cpu_store_char( _environment, drawRCommandLetter->realName, '3' );
        cpu_store_char( _environment, drawFCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawGCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawECommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawHCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawUDCommandLetter->realName, '7' );
        cpu_store_char( _environment, drawDDCommandLetter->realName, '6' );
        cpu_store_char( _environment, drawLDCommandLetter->realName, '5' );
        cpu_store_char( _environment, drawRDCommandLetter->realName, '8' );
        cpu_store_char( _environment, drawFDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawGDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawEDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawHDCommandLetter->realName, 'x' );
        cpu_jump( _environment, done2CommandLabel );

        cpu_label( _environment, rotate225CommandLabel );
        cpu_store_char( _environment, drawUCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawLCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawRCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawFCommandLetter->realName, '2' );
        cpu_store_char( _environment, drawGCommandLetter->realName, '1' );
        cpu_store_char( _environment, drawECommandLetter->realName, '0' );
        cpu_store_char( _environment, drawHCommandLetter->realName, '3' );
        cpu_store_char( _environment, drawUDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawDDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawLDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawRDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawFDCommandLetter->realName, '7' );
        cpu_store_char( _environment, drawGDCommandLetter->realName, '8' );
        cpu_store_char( _environment, drawEDCommandLetter->realName, '5' );
        cpu_store_char( _environment, drawHDCommandLetter->realName, '8' );
        cpu_jump( _environment, done2CommandLabel );

        cpu_label( _environment, rotate270CommandLabel );
        cpu_store_char( _environment, drawUCommandLetter->realName, '0' );
        cpu_store_char( _environment, drawDCommandLetter->realName, '3' );
        cpu_store_char( _environment, drawLCommandLetter->realName, '1' );
        cpu_store_char( _environment, drawRCommandLetter->realName, '2' );
        cpu_store_char( _environment, drawFCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawGCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawECommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawHCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawUDCommandLetter->realName, '5' );
        cpu_store_char( _environment, drawDDCommandLetter->realName, '8' );
        cpu_store_char( _environment, drawLDCommandLetter->realName, '6' );
        cpu_store_char( _environment, drawRDCommandLetter->realName, '7' );
        cpu_store_char( _environment, drawFDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawGDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawEDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawHDCommandLetter->realName, 'x' );
        cpu_jump( _environment, done2CommandLabel );

        cpu_label( _environment, rotate315CommandLabel );
        cpu_store_char( _environment, drawUCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawLCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawRCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawFCommandLetter->realName, '0' );
        cpu_store_char( _environment, drawGCommandLetter->realName, '3' );
        cpu_store_char( _environment, drawECommandLetter->realName, '1' );
        cpu_store_char( _environment, drawHCommandLetter->realName, '2' );
        cpu_store_char( _environment, drawUDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawDDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawLDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawRDCommandLetter->realName, 'x' );
        cpu_store_char( _environment, drawFDCommandLetter->realName, '5' );
        cpu_store_char( _environment, drawGDCommandLetter->realName, '8' );
        cpu_store_char( _environment, drawEDCommandLetter->realName, '6' );
        cpu_store_char( _environment, drawHDCommandLetter->realName, '7' );
        cpu_jump( _environment, done2CommandLabel );

        cpu_label( _environment, done2CommandLabel );

    }

    if ( _step ) {

        Variable * step = variable_retrieve_or_define( _environment, _step, VT_BYTE, 0 );
        variable_move( _environment, step->name, "DRAWSCALE" );

    }

}