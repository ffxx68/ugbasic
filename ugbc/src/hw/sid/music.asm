; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2025 Marco Spedaletti (asimov@mclink.it)
;  *
;  * Licensed under the Apache License, Version 2.0 (the "License");
;  * you may not use this file eXcept in compliance with the License.
;  * You may obtain a copy of the License at
;  *
;  * http://www.apache.org/licenses/LICENSE-2.0
;  *
;  * Unless required by applicable law or agreed to in writing, software
;  * distributed under the License is distributed on an "AS IS" BASIS,
;  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either eXpress or implied.
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
;*                           MUSIC PLAYER ROUTINE ON SID                       *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

WAVEFORM_TRIANGLE                           = $10
WAVEFORM_SAW                                = $20
WAVEFORM_RECTANGLE                          = $40
WAVEFORM_NOISE                              = $80

IMF_TOKEN_WAIT1								= $ff
IMF_TOKEN_WAIT2								= $fe
IMF_TOKEN_CONTROL							= $d0
IMF_TOKEN_PROGRAM_CHANGE					= $e0
IMF_TOKEN_NOTE								= $40

IMF_INSTRUMENT_ACOUSTIC_GRAND_PIANO			= $01
IMF_INSTRUMENT_BRIGHT_ACOUSTIC_PIANO		= $02
IMF_INSTRUMENT_ELECTRIC_GRAND_PIANO			= $03
IMF_INSTRUMENT_HONKY_TONK_PIANO				= $04
IMF_INSTRUMENT_ELECTRIC_PIANO1				= $05
IMF_INSTRUMENT_ELECTRIC_PIANO2				= $06
IMF_INSTRUMENT_HARPSICHORD					= $07
IMF_INSTRUMENT_CLAVI						= $08

IMF_INSTRUMENT_CELESTA						= $09
IMF_INSTRUMENT_GLOCKENSPIEL					= $0A
IMF_INSTRUMENT_MUSIC_BOX					= $0B
IMF_INSTRUMENT_VIBRAPHONE					= $0C
IMF_INSTRUMENT_MARIMBA						= $0D
IMF_INSTRUMENT_XYLOPHONE					= $0E
IMF_INSTRUMENT_TUBULAR_BELLS				= $0F
IMF_INSTRUMENT_DULCIMER						= $10
IMF_INSTRUMENT_DRAWBAR_ORGAN				= $11
IMF_INSTRUMENT_PERCUSSIVE_ORGAN				= $12
IMF_INSTRUMENT_ROCK_ORGAN					= $13
IMF_INSTRUMENT_CHURCH_ORGAN					= $14
IMF_INSTRUMENT_REED_ORGAN					= $15
IMF_INSTRUMENT_ACCORDION					= $16
IMF_INSTRUMENT_HARMONICA					= $17
IMF_INSTRUMENT_TANGO_ACCORDION				= $18
IMF_INSTRUMENT_ACOUSTIC_GUITAR_NYLON			= $19
IMF_INSTRUMENT_ACOUSTIC_GUITAR_STEEL			= $1A
IMF_INSTRUMENT_ELECTRIC_GUITAR_JAZZ			= $1B
IMF_INSTRUMENT_ELECTRIC_GUITAR_CLEAN			= $1C
IMF_INSTRUMENT_ELECTRIC_GUITAR_MUTED			= $1D
IMF_INSTRUMENT_OVERDRIVEN_GUITAR			= $1E
IMF_INSTRUMENT_DISTORTION_GUITAR			= $1F
IMF_INSTRUMENT_GUITAR_HARMONICS				= $20
IMF_INSTRUMENT_ACOUSTIC_BASS				= $21
IMF_INSTRUMENT_ELECTRIC_BASS_FINGER			= $22
IMF_INSTRUMENT_ELECTRIC_BASS_PICK			= $23
IMF_INSTRUMENT_FRETLESS_BASS				= $24
IMF_INSTRUMENT_SLAP_BASS_1					= $25
IMF_INSTRUMENT_SLAP_BASS_2					= $26
IMF_INSTRUMENT_SYNTH_BASS_1					= $27
IMF_INSTRUMENT_SYNTH_BASS_2					= $28
IMF_INSTRUMENT_VIOLIN						= $29
IMF_INSTRUMENT_VIOLA						= $2A
IMF_INSTRUMENT_CELLO						= $2B
IMF_INSTRUMENT_CONTRABASS					= $2C
IMF_INSTRUMENT_TREMOLO_STRINGS				= $2D
IMF_INSTRUMENT_PIZZICATO_STRINGS			= $2E
IMF_INSTRUMENT_ORCHESTRAL_HARP				= $2F
IMF_INSTRUMENT_TIMPANI						= $30
IMF_INSTRUMENT_STRING_ENSEMBLE_1			= $31
IMF_INSTRUMENT_STRING_ENSEMBLE_2			= $32
IMF_INSTRUMENT_SYNTHSTRINGS_1				= $33
IMF_INSTRUMENT_SYNTHSTRINGS_2				= $34
IMF_INSTRUMENT_CHOIR_AAHS					= $35
IMF_INSTRUMENT_VOICE_OOHS					= $36
IMF_INSTRUMENT_SYNTH_VOICE					= $37
IMF_INSTRUMENT_ORCHESTRA_HIT				= $38
IMF_INSTRUMENT_TRUMPET						= $39
IMF_INSTRUMENT_TROMBONE						= $3A
IMF_INSTRUMENT_TUBA							= $3B
IMF_INSTRUMENT_MUTED_TRUMPET				= $3C
IMF_INSTRUMENT_FRENCH_HORN					= $3D
IMF_INSTRUMENT_BRASS_SECTION				= $3E
IMF_INSTRUMENT_SYNTHBRASS_1					= $3F
IMF_INSTRUMENT_SYNTHBRASS_2					= $40
IMF_INSTRUMENT_SOPRANO_SAX					= $41
IMF_INSTRUMENT_ALTO_SAX						= $42
IMF_INSTRUMENT_TENOR_SAX					= $43
IMF_INSTRUMENT_BARITONE_SAX					= $44
IMF_INSTRUMENT_OBOE							= $45
IMF_INSTRUMENT_ENGLISH_HORN					= $46
IMF_INSTRUMENT_BASSOON						= $47
IMF_INSTRUMENT_CLARINET						= $48
IMF_INSTRUMENT_PICCOLO						= $49
IMF_INSTRUMENT_FLUTE						= $4A
IMF_INSTRUMENT_RECORDER						= $4B
IMF_INSTRUMENT_PAN_FLUTE					= $4C
IMF_INSTRUMENT_BLOWN_BOTTLE					= $4D
IMF_INSTRUMENT_SHAKUHACHI					= $4E
IMF_INSTRUMENT_WHISTLE						= $4F
IMF_INSTRUMENT_OCARINA						= $50
IMF_INSTRUMENT_LEAD_1_SQUARE				= $51
IMF_INSTRUMENT_LEAD_2_SAWTOOTH				= $52
IMF_INSTRUMENT_LEAD_3_CALLIOPE				= $53
IMF_INSTRUMENT_LEAD_4_CHIFF					= $54
IMF_INSTRUMENT_LEAD_5_CHARANG				= $55
IMF_INSTRUMENT_LEAD_6_VOICE					= $56
IMF_INSTRUMENT_LEAD_7_FIFTHS				= $57
IMF_INSTRUMENT_LEAD_8_BASS_LEAD				= $58
IMF_INSTRUMENT_PAD_1_NEW_AGE				= $59
IMF_INSTRUMENT_PAD_2_WARM					= $5A
IMF_INSTRUMENT_PAD_3_POLYSYNTH				= $5B
IMF_INSTRUMENT_PAD_4_CHOIR					= $5C
IMF_INSTRUMENT_PAD_5_BOWED					= $5D
IMF_INSTRUMENT_PAD_6_METALLIC				= $5E
IMF_INSTRUMENT_PAD_7_HALO					= $5F
IMF_INSTRUMENT_PAD_8_SWEEP					= $60
IMF_INSTRUMENT_FX_1_RAIN					= $61
IMF_INSTRUMENT_FX_2_SOUNDTRACK				= $62
IMF_INSTRUMENT_FX_3_CRYSTAL					= $63
IMF_INSTRUMENT_FX_4_ATMOSPHERE				= $64
IMF_INSTRUMENT_FX_5_BRIGHTNESS				= $65
IMF_INSTRUMENT_FX_6_GOBLINS					= $66
IMF_INSTRUMENT_FX_7_ECHOES					= $67
IMF_INSTRUMENT_FX_8_SCI_FI					= $68
IMF_INSTRUMENT_SITAR						= $69
IMF_INSTRUMENT_BANJO						= $6A
IMF_INSTRUMENT_SHAMISEN						= $6B
IMF_INSTRUMENT_KOTO							= $6C
IMF_INSTRUMENT_KALIMBA						= $6D
IMF_INSTRUMENT_BAG_PIPE						= $6E
IMF_INSTRUMENT_FIDDLE						= $6F
IMF_INSTRUMENT_SHANAI						= $70
IMF_INSTRUMENT_TINKLE_BELL					= $71
IMF_INSTRUMENT_AGOGO						= $72
IMF_INSTRUMENT_STEEL_DRUMS					= $73
IMF_INSTRUMENT_WOODBLOCK					= $74
IMF_INSTRUMENT_TAIKO_DRUM					= $75
IMF_INSTRUMENT_MELODIC_TOM					= $76
IMF_INSTRUMENT_SYNTH_DRUM					= $77
IMF_INSTRUMENT_REVERSE_CYMBAL				= $78
IMF_INSTRUMENT_GUITAR_FRET_NOISE			= $79
IMF_INSTRUMENT_BREATH_NOISE					= $7A
IMF_INSTRUMENT_SEASHORE						= $7B
IMF_INSTRUMENT_BIRD_TWEET					= $7C
IMF_INSTRUMENT_TELEPHONE_RING				= $7D
IMF_INSTRUMENT_HELICOPTER					= $7E
IMF_INSTRUMENT_APPLAUSE						= $7F
IMF_INSTRUMENT_GUNSHOT						= $80

MUSICTMP:           .BYTE 0

; X: CHANNEL
SIDEXPLOSION:
    TXA
    LDX #WAVEFORM_NOISE
    JSR SIDPROGCTR
    LDX #2
    LDY #11
    JSR SIDPROGAD
    LDX #0
    LDY #1
    JSR SIDPROGSR
    RTS

; X: CHANNEL
SIDGUNSHOT:
    TXA
    LDX #WAVEFORM_NOISE
    JSR SIDPROGCTR
    LDX #2
    LDY #4
    JSR SIDPROGAD
    LDX #0
    LDY #1
    JSR SIDPROGSR
    RTS

; X: CHANNEL
SIDPIANO:
SIDCLAVI:
    TXA
    LDX #$00
    LDY #$06
    JSR SIDPROGPULSE
    LDX #2
    LDY #11
    JSR SIDPROGAD
    LDX #5
    LDY #0
    JSR SIDPROGSR
    RTS

; X: CHANNEL
SIDXYLOPHONE:
    TXA
    LDX #$00
    LDY #$06
    JSR SIDPROGPULSE    
    LDX #0
    LDY #9
    JSR SIDPROGAD
    LDX #0
    LDY #0
    JSR SIDPROGSR
    RTS

; X: CHANNEL
SIDROCKORGAN:
    TXA
    LDX #$00
    LDY #$08
    JSR SIDPROGPULSE
    JSR SIDPROGCTR
    LDX #0
    LDY #9
    JSR SIDPROGAD
    LDX #9
    LDY #0
    JSR SIDPROGSR
    RTS

; X: CHANNEL
SIDGUITAR:
SIDBANJO:
    TXA
    LDX #WAVEFORM_SAW
    JSR SIDPROGCTR
    LDX #0
    LDY #9
    JSR SIDPROGAD
    LDX #2
    LDY #1
    JSR SIDPROGSR
    RTS

; X: CHANNEL
SIDGUITARMUTED:
SIDBASS:
    TXA
    LDX #WAVEFORM_SAW
    JSR SIDPROGCTR
    LDX #0
    LDY #9
    JSR SIDPROGAD
    LDX #1
    LDY #1
    JSR SIDPROGSR
    RTS

; X: CHANNEL
SIDVIOLIN:
    TXA
    LDX #WAVEFORM_TRIANGLE + WAVEFORM_RECTANGLE
    JSR SIDPROGCTR
    LDX #128
    LDY #0
    JSR SIDPROGPULSE
    LDX #10
    LDY #8
    JSR SIDPROGAD
    LDX #10
    LDY #9
    JSR SIDPROGSR
    RTS

; X: CHANNEL
SIDTIMPANI:
SIDDRUMS:
    TXA
    LDX #WAVEFORM_NOISE
    JSR SIDPROGCTR
    LDX #0
    LDY #5
    JSR SIDPROGAD
    LDX #0
    LDY #0
    JSR SIDPROGSR
    RTS

; X: CHANNEL
SIDTRUMPET:
    TXA
    LDX #WAVEFORM_SAW
    JSR SIDPROGCTR
    LDX #8
    LDY #9
    JSR SIDPROGAD
    LDX #4
    LDY #1
    JSR SIDPROGSR
    RTS

; X: CHANNEL
SIDFLUTE:
    TXA
    LDX #WAVEFORM_TRIANGLE
    JSR SIDPROGCTR
    LDX #9
    LDY #4
    JSR SIDPROGAD
    LDX #4
    LDY #0
    JSR SIDPROGSR
    RTS

; X: CHANNEL
SIDACCORDION:
    TXA
    LDX #WAVEFORM_SAW
    JSR SIDPROGCTR
    LDX #9
    LDY #4
    JSR SIDPROGAD
    LDX #4
    LDY #0
    JSR SIDPROGSR
    RTS

; X: CHANNEL
SIDCALLIOPE:
    TXA
    LDX #WAVEFORM_TRIANGLE
    JSR SIDPROGCTR
    LDX #0
    LDY #0
    JSR SIDPROGAD
    LDX #15
    LDY #0
    JSR SIDPROGSR
    RTS

; A: PROGRAM, X: CHANNEL
SIDSETPROGRAM:

; General MIDI Level 1 Instrument Families
; The General MIDI Level 1 instrument sounds are grouped by families. 
; In each family are 8 specific instruments.

; 0 special -> drums!

SIDSETPROGRAM0:
    CMP #$0
    BNE SIDSETPROGRAM1
    JSR SIDDRUMS
    JMP SIDSETPROGRAMNN

; 1-8	Piano

SIDSETPROGRAM1:
    SBC #1
    BNE SIDSETPROGRAM2
    JSR SIDPIANO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ACOUSTIC_GRAND_PIANO			= $01
SIDSETPROGRAM2:
    SBC #1
    BNE SIDSETPROGRAM3
    JSR SIDPIANO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_BRIGHT_ACOUSTIC_PIANO			= $02
SIDSETPROGRAM3:
    SBC #1
    BNE SIDSETPROGRAM4
    JSR SIDPIANO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ELECTRIC_GRAND_PIANO			= $03
SIDSETPROGRAM4:
    SBC #1
    BNE SIDSETPROGRAM5
    JSR SIDPIANO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_HONKY_TONK_PIANO				= $04
SIDSETPROGRAM5:
    SBC #1
    BNE SIDSETPROGRAM6
    JSR SIDPIANO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ELECTRIC_PIANO1				= $05
SIDSETPROGRAM6:
    SBC #1
    BNE SIDSETPROGRAM7
    JSR SIDPIANO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ELECTRIC_PIANO2				= $06
SIDSETPROGRAM7:
    SBC #1
    BNE SIDSETPROGRAM8
    JSR SIDPIANO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_HARPSICHORD					= $07
SIDSETPROGRAM8:
    SBC #1
    BNE SIDSETPROGRAM9
    JSR SIDPIANO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_CLAVI						= $08


SIDSETPROGRAM9:
    SBC #1
    BNE SIDSETPROGRAMA
    JSR SIDCLAVI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_CELESTA						= $09
SIDSETPROGRAMA:
    SBC #1
    BNE SIDSETPROGRAMB
    JSR SIDXYLOPHONE
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_GLOCKENSPIEL					= $0A
SIDSETPROGRAMB:
    SBC #1
    BNE SIDSETPROGRAMC
    JSR SIDXYLOPHONE
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_MUSIC_BOX					= $0B
SIDSETPROGRAMC:
    SBC #1
    BNE SIDSETPROGRAMD
    JSR SIDXYLOPHONE
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_VIBRAPHONE					= $0C
SIDSETPROGRAMD:
    SBC #1
    BNE SIDSETPROGRAME
    JSR SIDXYLOPHONE
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_MARIMBA						= $0D
SIDSETPROGRAME:
    SBC #1
    BNE SIDSETPROGRAMF
    JSR SIDXYLOPHONE
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_XYLOPHONE					= $0E
SIDSETPROGRAMF:
    SBC #1
    BNE SIDSETPROGRAM10
    JSR SIDXYLOPHONE
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_TUBULAR_BELLS				= $0F
SIDSETPROGRAM10:
    SBC #1
    BNE SIDSETPROGRAM11
    JSR SIDXYLOPHONE
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_DULCIMER						= $10
SIDSETPROGRAM11:
    SBC #1
    BNE SIDSETPROGRAM12
    JSR SIDROCKORGAN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_DRAWBAR_ORGAN				= $11
SIDSETPROGRAM12:
    SBC #1
    BNE SIDSETPROGRAM13
    JSR SIDROCKORGAN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_PERCUSSIVE_ORGAN				= $12
SIDSETPROGRAM13:
    SBC #1
    BNE SIDSETPROGRAM14
    JSR SIDROCKORGAN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ROCK_ORGAN					= $13
SIDSETPROGRAM14:
    SBC #1
    BNE SIDSETPROGRAM15
    JSR SIDROCKORGAN
    JMP SIDSETPROGRAMNN   
; IMF_INSTRUMENT_CHURCH_ORGAN					= $14
SIDSETPROGRAM15:
    SBC #1
    BNE SIDSETPROGRAM16
    JSR SIDROCKORGAN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_REED_ORGAN					= $15
SIDSETPROGRAM16:
    SBC #1
    BNE SIDSETPROGRAM17
    JSR SIDROCKORGAN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ACCORDION					= $16
SIDSETPROGRAM17:
    SBC #1
    BNE SIDSETPROGRAM18
    JSR SIDACCORDION
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_HARMONICA					= $17
SIDSETPROGRAM18:
    SBC #1
    BNE SIDSETPROGRAM19
    JSR SIDROCKORGAN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_TANGO_ACCORDION				= $18
SIDSETPROGRAM19:
    SBC #1
    BNE SIDSETPROGRAM1A
    JSR SIDGUITAR
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ACOUSTIC_GUITAR_NYLON			= $19
SIDSETPROGRAM1A:
    SBC #1
    BNE SIDSETPROGRAM1B
    JSR SIDGUITAR
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ACOUSTIC_GUITAR_STEEL			= $1A
SIDSETPROGRAM1B:
    SBC #1
    BNE SIDSETPROGRAM1C
    JSR SIDGUITAR
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ELECTRIC_GUITAR_JAZZ			= $1B
SIDSETPROGRAM1C:
    SBC #1
    BNE SIDSETPROGRAM1D
    JSR SIDGUITAR
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ELECTRIC_GUITAR_CLEAN			= $1C
SIDSETPROGRAM1D:
    SBC #1
    BNE SIDSETPROGRAM1E
    JSR SIDGUITARMUTED
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ELECTRIC_GUITAR_MUTED			= $1D
SIDSETPROGRAM1E:
    SBC #1
    BNE SIDSETPROGRAM1F
    JSR SIDGUITAR
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_OVERDRIVEN_GUITAR			= $1E
SIDSETPROGRAM1F:
    SBC #1
    BNE SIDSETPROGRAM20
    JSR SIDGUITAR
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_DISTORTION_GUITAR			= $1F
SIDSETPROGRAM20:
    SBC #1
    BNE SIDSETPROGRAM21
    JSR SIDGUITAR
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_GUITAR_HARMONICS				= $20
SIDSETPROGRAM21:
    SBC #1
    BNE SIDSETPROGRAM22
    JSR SIDBASS
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ACOUSTIC_BASS				= $21
SIDSETPROGRAM22:
    SBC #1
    BNE SIDSETPROGRAM23
    JSR SIDBASS
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ELECTRIC_BASS_FINGER			= $22
SIDSETPROGRAM23:
    SBC #1
    BNE SIDSETPROGRAM24
    JSR SIDBASS
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ELECTRIC_BASS_PICK			= $23
SIDSETPROGRAM24:
    SBC #1
    BNE SIDSETPROGRAM25
    JSR SIDBASS
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_FRETLESS_BASS				= $24
SIDSETPROGRAM25:
    SBC #1
    BNE SIDSETPROGRAM26
    JSR SIDBASS
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SLAP_BASS_1					= $25
SIDSETPROGRAM26:
    SBC #1
    BNE SIDSETPROGRAM27
    JSR SIDBASS
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SLAP_BASS_2					= $26
SIDSETPROGRAM27:
    SBC #1
    BNE SIDSETPROGRAM28
    JSR SIDBASS
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SYNTH_BASS_1					= $27
SIDSETPROGRAM28:
    SBC #1
    BNE SIDSETPROGRAM29
    JSR SIDBASS
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SYNTH_BASS_2					= $28
SIDSETPROGRAM29:
    SBC #1
    BNE SIDSETPROGRAM2A
    JSR SIDVIOLIN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_VIOLIN						= $29
SIDSETPROGRAM2A:
    SBC #1
    BNE SIDSETPROGRAM2B
    JSR SIDVIOLIN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_VIOLA						= $2A
SIDSETPROGRAM2B:
    SBC #1
    BNE SIDSETPROGRAM2C
    JSR SIDVIOLIN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_CELLO						= $2B
SIDSETPROGRAM2C:
    SBC #1
    BNE SIDSETPROGRAM2D
    JSR SIDVIOLIN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_CONTRABASS					= $2C
SIDSETPROGRAM2D:
    SBC #1
    BNE SIDSETPROGRAM2E
    JSR SIDVIOLIN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_TREMOLO_STRINGS				= $2D
SIDSETPROGRAM2E:
    SBC #1
    BNE SIDSETPROGRAM2F
    JSR SIDVIOLIN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_PIZZICATO_STRINGS			= $2E
SIDSETPROGRAM2F:
    SBC #1
    BNE SIDSETPROGRAM30
    JSR SIDVIOLIN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ORCHESTRAL_HARP				= $2F
SIDSETPROGRAM30:
    SBC #1
    BNE SIDSETPROGRAM31
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_TIMPANI						= $30
SIDSETPROGRAM31:
    SBC #1
    BNE SIDSETPROGRAM32
    JSR SIDVIOLIN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_STRING_ENSEMBLE_1			= $31
SIDSETPROGRAM32:
    SBC #1
    BNE SIDSETPROGRAM33
    JSR SIDVIOLIN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_STRING_ENSEMBLE_2			= $32
SIDSETPROGRAM33:
    SBC #1
    BNE SIDSETPROGRAM34
    JSR SIDVIOLIN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SYNTHSTRINGS_1				= $33
SIDSETPROGRAM34:
    SBC #1
    BNE SIDSETPROGRAM35
    JSR SIDVIOLIN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SYNTHSTRINGS_2				= $34
SIDSETPROGRAM35:
    SBC #1
    BNE SIDSETPROGRAM36
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_CHOIR_AAHS					= $35
SIDSETPROGRAM36:
    SBC #1
    BNE SIDSETPROGRAM37
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_VOICE_OOHS					= $36
SIDSETPROGRAM37:
    SBC #1
    BNE SIDSETPROGRAM38
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SYNTH_VOICE					= $37
SIDSETPROGRAM38:
    SBC #1
    BNE SIDSETPROGRAM39
    JSR SIDROCKORGAN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ORCHESTRA_HIT				= $38
SIDSETPROGRAM39:
    SBC #1
    BNE SIDSETPROGRAM3A
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_TRUMPET						= $39
SIDSETPROGRAM3A:
    SBC #1
    BNE SIDSETPROGRAM3B
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_TROMBONE						= $3A
SIDSETPROGRAM3B:
    SBC #1
    BNE SIDSETPROGRAM3C
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_TUBA							= $3B
SIDSETPROGRAM3C:
    SBC #1
    BNE SIDSETPROGRAM3D
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_MUTED_TRUMPET				= $3C
SIDSETPROGRAM3D:
    SBC #1
    BNE SIDSETPROGRAM3E
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_FRENCH_HORN					= $3D
SIDSETPROGRAM3E:
    SBC #1
    BNE SIDSETPROGRAM3F
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_BRASS_SECTION				= $3E
SIDSETPROGRAM3F:
    SBC #1
    BNE SIDSETPROGRAM40
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SYNTHBRASS_1					= $3F
SIDSETPROGRAM40:
    SBC #1
    BNE SIDSETPROGRAM41
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SYNTHBRASS_2					= $40
SIDSETPROGRAM41:
    SBC #1
    BNE SIDSETPROGRAM42
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SOPRANO_SAX					= $41
SIDSETPROGRAM42:
    SBC #1
    BNE SIDSETPROGRAM43
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ALTO_SAX						= $42
SIDSETPROGRAM43:
    SBC #1
    BNE SIDSETPROGRAM44
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_TENOR_SAX					= $43
SIDSETPROGRAM44:
    SBC #1
    BNE SIDSETPROGRAM45
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_BARITONE_SAX					= $44
SIDSETPROGRAM45:
    SBC #1
    BNE SIDSETPROGRAM46
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_OBOE							= $45
SIDSETPROGRAM46:
    SBC #1
    BNE SIDSETPROGRAM47
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_ENGLISH_HORN					= $46
SIDSETPROGRAM47:
    SBC #1
    BNE SIDSETPROGRAM48
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_BASSOON						= $47
SIDSETPROGRAM48:
    SBC #1
    BNE SIDSETPROGRAM49
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_CLARINET						= $48
SIDSETPROGRAM49:
    SBC #1
    BNE SIDSETPROGRAM4A
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_PICCOLO						= $49
SIDSETPROGRAM4A:
    SBC #1
    BNE SIDSETPROGRAM4B
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_FLUTE						= $4A
SIDSETPROGRAM4B:
    SBC #1
    BNE SIDSETPROGRAM4C
    JSR SIDFLUTE
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_RECORDER						= $4B
SIDSETPROGRAM4C:
    SBC #1
    BNE SIDSETPROGRAM4D
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_PAN_FLUTE					= $4C
SIDSETPROGRAM4D:
    SBC #1
    BNE SIDSETPROGRAM4E
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_BLOWN_BOTTLE					= $4D
SIDSETPROGRAM4E:
    SBC #1
    BNE SIDSETPROGRAM4F
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SHAKUHACHI					= $4E
SIDSETPROGRAM4F:
    SBC #1
    BNE SIDSETPROGRAM50
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_WHISTLE						= $4F
SIDSETPROGRAM50:
    SBC #1
    BNE SIDSETPROGRAM51
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_OCARINA						= $50
SIDSETPROGRAM51:
    SBC #1
    BNE SIDSETPROGRAM52
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_LEAD_1_SQUARE				= $51
SIDSETPROGRAM52:
    SBC #1
    BNE SIDSETPROGRAM53
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_LEAD_2_SAWTOOTH				= $52
SIDSETPROGRAM53:
    SBC #1
    BNE SIDSETPROGRAM54
    JSR SIDCALLIOPE
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_LEAD_3_CALLIOPE				= $53
SIDSETPROGRAM54:
    SBC #1
    BNE SIDSETPROGRAM55
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_LEAD_4_CHIFF					= $54
SIDSETPROGRAM55:
    SBC #1
    BNE SIDSETPROGRAM56
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_LEAD_5_CHARANG				= $55
SIDSETPROGRAM56:
    SBC #1
    BNE SIDSETPROGRAM57
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_LEAD_6_VOICE					= $56
SIDSETPROGRAM57:
    SBC #1
    BNE SIDSETPROGRAM58
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_LEAD_7_FIFTHS				= $57
SIDSETPROGRAM58:
    SBC #1
    BNE SIDSETPROGRAM59
    JSR SIDGUITAR
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_LEAD_8_BASS_LEAD				= $58
SIDSETPROGRAM59:
    SBC #1
    BNE SIDSETPROGRAM5A
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_PAD_1_NEW_AGE				= $59
SIDSETPROGRAM5A:
    SBC #1
    BNE SIDSETPROGRAM5B
    JSR SIDTRUMPET
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_PAD_2_WARM					= $5A
SIDSETPROGRAM5B:
    SBC #1
    BNE SIDSETPROGRAM5C
    JSR SIDROCKORGAN
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_PAD_3_POLYSYNTH				= $5B
SIDSETPROGRAM5C:
    SBC #1
    BNE SIDSETPROGRAM5D
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_PAD_4_CHOIR					= $5C
SIDSETPROGRAM5D:
    SBC #1
    BNE SIDSETPROGRAM5E
    JSR SIDPIANO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_PAD_5_BOWED					= $5D
SIDSETPROGRAM5E:
    SBC #1
    BNE SIDSETPROGRAM5F
    JSR SIDPIANO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_PAD_6_METALLIC				= $5E
SIDSETPROGRAM5F:
    SBC #1
    BNE SIDSETPROGRAM60
    JSR SIDPIANO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_PAD_7_HALO					= $5F
SIDSETPROGRAM60:
    SBC #1
    BNE SIDSETPROGRAM61
    JSR SIDPIANO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_PAD_8_SWEEP					= $60
SIDSETPROGRAM61:
    SBC #1
    BNE SIDSETPROGRAM62
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_FX_1_RAIN					= $61
SIDSETPROGRAM62:
    SBC #1
    BNE SIDSETPROGRAM63
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_FX_2_SOUNDTRACK				= $62
SIDSETPROGRAM63:
    SBC #1
    BNE SIDSETPROGRAM64
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_FX_3_CRYSTAL					= $63
SIDSETPROGRAM64:
    SBC #1
    BNE SIDSETPROGRAM65
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_FX_4_ATMOSPHERE				= $64
SIDSETPROGRAM65:
    SBC #1
    BNE SIDSETPROGRAM66
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_FX_5_BRIGHTNESS				= $65
SIDSETPROGRAM66:
    SBC #1
    BNE SIDSETPROGRAM67
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_FX_6_GOBLINS					= $66
SIDSETPROGRAM67:
    SBC #1
    BNE SIDSETPROGRAM68
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_FX_7_ECHOES					= $67
SIDSETPROGRAM68:
    SBC #1
    BNE SIDSETPROGRAM69
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_FX_8_SCI_FI					= $68
SIDSETPROGRAM69:
    SBC #1
    BNE SIDSETPROGRAM6A
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SITAR						= $69
SIDSETPROGRAM6A:
    SBC #1
    BNE SIDSETPROGRAM6B
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_BANJO						= $6A
SIDSETPROGRAM6B:
    SBC #1
    BNE SIDSETPROGRAM6C
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SHAMISEN						= $6B
SIDSETPROGRAM6C:
    SBC #1
    BNE SIDSETPROGRAM6D
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_KOTO							= $6C
SIDSETPROGRAM6D:
    SBC #1
    BNE SIDSETPROGRAM6E
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_KALIMBA						= $6D
SIDSETPROGRAM6E:
    SBC #1
    BNE SIDSETPROGRAM6F
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_BAG_PIPE						= $6E
SIDSETPROGRAM6F:
    SBC #1
    BNE SIDSETPROGRAM70
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_FIDDLE						= $6F
SIDSETPROGRAM70:
    SBC #1
    BNE SIDSETPROGRAM71
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SHANAI						= $70
SIDSETPROGRAM71:
    SBC #1
    BNE SIDSETPROGRAM72
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_TINKLE_BELL					= $71
SIDSETPROGRAM72:
    SBC #1
    BNE SIDSETPROGRAM73
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_AGOGO						= $72
SIDSETPROGRAM73:
    SBC #1
    BNE SIDSETPROGRAM74
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_STEEL_DRUMS					= $73
SIDSETPROGRAM74:
    SBC #1
    BNE SIDSETPROGRAM75
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_WOODBLOCK					= $74
SIDSETPROGRAM75:
    SBC #1
    BNE SIDSETPROGRAM76
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_TAIKO_DRUM					= $75
SIDSETPROGRAM76:
    SBC #1
    BNE SIDSETPROGRAM77
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_MELODIC_TOM					= $76
SIDSETPROGRAM77:
    SBC #1
    BNE SIDSETPROGRAM78
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SYNTH_DRUM					= $77
SIDSETPROGRAM78:
    SBC #1
    BNE SIDSETPROGRAM79
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_REVERSE_CYMBAL				= $78
SIDSETPROGRAM79:
    SBC #1
    BNE SIDSETPROGRAM7A
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_GUITAR_FRET_NOISE			= $79
SIDSETPROGRAM7A:
    SBC #1
    BNE SIDSETPROGRAM7B
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_BREATH_NOISE					= $7A
SIDSETPROGRAM7B:
    SBC #1
    BNE SIDSETPROGRAM7C
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_SEASHORE						= $7B
SIDSETPROGRAM7C:
    SBC #1
    BNE SIDSETPROGRAM7D
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_BIRD_TWEET					= $7C
SIDSETPROGRAM7D:
    SBC #1
    BNE SIDSETPROGRAM7E
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_TELEPHONE_RING				= $7D
SIDSETPROGRAM7E:
    SBC #1
    BNE SIDSETPROGRAM7F
    JSR SIDBANJO
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_HELICOPTER					= $7E
SIDSETPROGRAM7F:
    SBC #1
    BNE SIDSETPROGRAM80
    JSR SIDTIMPANI
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_APPLAUSE						= $7F
SIDSETPROGRAM80:
    SBC #1
    BNE SIDSETPROGRAM81
    JSR SIDGUNSHOT
    JMP SIDSETPROGRAMNN
; IMF_INSTRUMENT_GUNSHOT						= $80
SIDSETPROGRAM81:
SIDSETPROGRAMNN:
    RTS

SIDMUSICLOOP: .byte $0
SIDMUSICREADY: .byte $0
SIDMUSICPAUSE: .byte $0
SIDBLOCKS: .word $0
SIDLASTBLOCK: .byte $0

SIDBLOCKS_BACKUP: .word $0
SIDLASTBLOCK_BACKUP: .byte $0
SIDTMPPTR_BACKUP: .word $0

SIDTMPPTR = $05 ; $06
SIDTMPOFS = $07
SIDTMPLEN = $08
SIDJIFFIES = $09 ; $0A

MUSICPLAYERRESET:
    LDA #$0
    STA SIDJIFFIES
    STA SIDTMPOFS
    LDA #$1
    STA SIDMUSICREADY
    LDA SIDTMPPTR_BACKUP
    STA SIDTMPPTR
    LDA SIDTMPPTR_BACKUP+1
    STA SIDTMPPTR+1
    LDA SIDLASTBLOCK_BACKUP
    STA SIDLASTBLOCK
    LDA SIDBLOCKS_BACKUP
    STA SIDBLOCKS
    BEQ MUSICPLAYERRESET3
    LDA #$FF
    JMP MUSICPLAYERRESET2
MUSICPLAYERRESET3:
    LDA SIDLASTBLOCK_BACKUP
MUSICPLAYERRESET2:
    STA SIDTMPLEN
    RTS

; This is the entry point for music play routine
; using the interrupt. 
MUSICPLAYER:
    PHP
    PHA
    LDA SIDMUSICREADY
    BEQ MUSICPLAYERQ2
    LDA SIDMUSICPAUSE
    BNE MUSICPLAYERQ2
    TXA
    PHA
    TYA
    PHA
    JSR MUSICPLAYERR
    PLA
    TAY
    PLA
    TAX
MUSICPLAYERQ2:
    PLA
    PLP
    RTS

MUSICPLAYERR:

; This is the entry point to wait until the waiting jiffies
; are exausted.
MUSICPLAYERL1:
    LDA SIDJIFFIES
    BEQ MUSICPLAYERL1B
    DEC SIDJIFFIES
    RTS

; This is the entry point to read the next instruction.
MUSICPLAYERL1B:
    ; Read the next byte.
    JSR MUSICREADNEXTBYTE

    ; Is the file NOT finished?
    CPX #$0
    BNE MUSICPLAYERL1X

    ; Let's stop the play!
    LDA #$0
    STA SIDMUSICREADY
    STA SIDTMPPTR
    STA SIDTMPPTR+1
    STA SIDJIFFIES
    RTS

; This is the entry point to decode the instruction
; (contained into the A register).
MUSICPLAYERL1X:
    ASL
    BCS MUSICPLAYERL1X0
    JMP MUSICWAIT
MUSICPLAYERL1X0:
    ASL
    BCS MUSICPLAYERL1X0A
    JMP MUSICSETPROGRAM
MUSICPLAYERL1X0A:
    ASL
    BCS MUSICPLAYERL1X1
    JMP MUSICNOTEON
MUSICPLAYERL1X1:
    ASL
    BCS MUSICPLAYERL1X2
    JMP MUSICNOTEOFF
MUSICPLAYERL1X2:
    RTS

MUSICWAIT:
    LSR
    STA SIDJIFFIES
    RTS

MUSICSETPROGRAM:
    LSR
    LSR
    STA MUSICTMP
    JSR MUSICREADNEXTBYTE
    PHA
    LDA MUSICTMP
    TAX
    PLA
    JSR SIDSETPROGRAM
    JMP MUSICPLAYERL1B

MUSICNOTEOFF:
    LSR
    LSR
    LSR
    LSR
    JSR SIDSTOP
    JMP MUSICPLAYERL1B

MUSICNOTEON:
    LSR
    LSR
    LSR
    PHA
    JSR MUSICREADNEXTBYTE
    ASL
    TAY
    LDA (SIDTMPPTR2),Y
    TAX
    INY
    LDA (SIDTMPPTR2),Y
    TAY
    PLA
    PHA
    JSR SIDPROGFREQ
    PLA
    PHA
    JSR MUSICREADNEXTBYTE
    PLA
    JMP MUSICPLAYERL1B

; This routine has been added in order to read the
; next byte in a "blocked" byte stream.
MUSICREADNEXTBYTE:
    ; Let's check if we arrived at the end of the block.
    ; In that case, we must "load" the next block (or end
    ; the reading).
    LDY SIDTMPOFS
    CPY SIDTMPLEN
    BEQ MUSICREADNEXTBYTELE

MUSICREADNEXTBYTE2:
    LDX #$ff
    LDA (SIDTMPPTR), Y
    INY
    STY SIDTMPOFS
    RTS

; This is the entry point if a block (256 or less bytes)
; is finished, and we must move forward to the next block.
MUSICREADNEXTBYTELE:
    ; Is file finished?
    LDA SIDBLOCKS
    BEQ MUSICREADNEXTBYTEEND

    ; Increment the base address by 255
    INC SIDTMPPTR+1
    DEC SIDTMPPTR

    ; Decrement the number of remaining blocks
    DEC SIDBLOCKS

    ; If remaining blocks are 0, the last block
    ; length is different from 256 bytes.
    BEQ MUSICPLAYERLE2

    ; Remaining block is 256 bytes lenght.
    LDY #$ff
    STY SIDTMPLEN

    ; Put the index to 0
    LDY #$0
    STY SIDTMPOFS

    JMP MUSICREADNEXTBYTE2

    ; Remaining block is <256 bytes lenght.
MUSICPLAYERLE2:
    LDY SIDLASTBLOCK
    STY SIDTMPLEN

    ; Put the index to 0
    LDY #$0
    STY SIDTMPOFS

    JMP MUSICREADNEXTBYTE2

MUSICREADNEXTBYTEEND:
    LDX #$0
    RTS
