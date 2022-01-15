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

/****************************************************************************
 * INCLUDE SECTION 
 ****************************************************************************/

#include "../../ugbc.h"

/****************************************************************************
 * CODE SECTION 
 ****************************************************************************/

/**
 * @brief Emit code for <strong>SPRITE(...)</strong>
 * 
 * @param _environment Current calling environment
 * @param _image image to use as SPRITE
 */
/* <usermanual>
@keyword SPRITE

@target c64
</usermanual> */
Variable * csprite_init( Environment * _environment, char * _image, char * _sprite ) {

    Variable * index;
    Variable * startIndex;

    Variable * spriteCount;

    if ( _sprite ) {
        index = variable_retrieve_or_define( _environment, _sprite );   
        startIndex = variable_temporary( _environment, VT_SPRITE, "(sprite index)" );
        cpu_move_8bit( _environment, index->realName, startIndex->realName );
        cpu_math_and_const_8bit( _environment, startIndex->realName, 0x0f );
        Variable * spriteCount = variable_retrieve( _environment, "SPRITECOUNT" );
        spriteCount = variable_retrieve( _environment, "SPRITECOUNT" );

    } else {
        index = variable_temporary( _environment, VT_SPRITE, "(sprite index)" );   
        startIndex = variable_temporary( _environment, VT_SPRITE, "(sprite index)" );
        variable_move_naked( _environment, spriteCount->name, startIndex->name );
        spriteCount = variable_retrieve( _environment, "SPRITECOUNT" );
    }

    Variable * image = variable_retrieve( _environment, _image );

    int i = 0;

    for (i=1; i<image->originalColors; ++i ) {
        variable_move_naked( _environment, spriteCount->name, index->name );
        Variable * realImage = sprite_converter( _environment, image->originalBitmap, image->originalWidth, image->originalHeight, &image->originalPalette[i] );
        vic2_sprite_data_from( _environment, index->name, realImage->name );
        cpu_inc( _environment, spriteCount->realName );
    }

    cpu_combine_nibbles( _environment, startIndex->realName, index->realName, index->realName );

    return index;

}
