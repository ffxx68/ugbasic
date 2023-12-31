﻿REM @english
REM STORAGE MANAGEMENT LOADING A FILE
REM
REM This example shows how to load a file at runtime, comparing
REM to the fact of loading a file at compile time.
REM
REM @italian
REM MEMORIE DI MASSA CARICARE UN FILE
REM
REM Questo esempio mostra come caricare un file al momento dell'esecuzione,
REM comparato al caricamento al momento della compilazione.

CLS

STORAGE "DISCHETTO" AS "DISK1"
    FILE "test.txt" AS "test.dat"
ENDSTORAGE

DIM textRuntime AS STRING

textRuntime = "                "

DLOAD "test.dat" FROM 2 TO STRPTR(textRuntime) SIZE 16

INK WHITE
PRINT "ok"
PRINT textRuntime



