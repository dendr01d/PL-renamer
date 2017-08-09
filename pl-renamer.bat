@ECHO off
setlocal EnableDelayedExpansion
S:

REM turn echo off, allow dynamic eval of variables
REM move to the S directory manually bc most processes don't work across partitions

set pScanned="S:\Projects\MiWorkspace Depot\Scanned Documents\Inventory"
set pLists="S:\Projects\MiWorkspace Depot\Orders\packing Lists"

REM 26 spaces. Used to make sure the example lines up with the input
set "spacer=                          "

set horzBar=------------------------------------------------------------

REM Define CR to contain a carriage return (0x0D)
REM It must be dynamically evaluated, ie !CR! not %CR%
REM This is the bit that lets you write over a line - ie for variable output spacing
for /f %%A in ('copy /Z "%~dpf0" nul') do set "CR=%%A"



for %%f in (%pScanned%\*.pdf) do (
	echo %horzBar%

REM open the pdf in adobe reader, prompt for INC, then close it
REM output the spacer, then the example s.t. it lines up with the input field
REM then return to the beginning of the line
REM and output the filename without path or extension
REM definitely more complicated than it needs to be, but it looks nicer

	start AcroRd32.exe %%f
	echo %spacer%eg "INC1234567"!CR!"%%~nf" opened
	set /p inputName="What's the FULL ticket name?: "
	taskkill /im AcroRd32.exe /f /t > nul


REM count how many files in the final folder share this INC name
REM this INC PL will be that plus 1
REM use !exc points! to dynamically evaluate variables

	set count=0
	for %%a in (%pLists%\!inputName!*.pdf) do ( set /a count+=1 )
	echo !count! match/es found
	set /a count+=1


REM create the final name of the file

	set "inputName=!inputName!-PL-!count!.pdf"


REM sometimes adobe reader takes time to kill
REM this just helps make sure it's no longer locking the file
REM we don't want to actually see the timer tho so nullify output

	timeout /t 1 /nobreak > nul


REM move and rename the file into the final folder
REM those path declarations may work for FOR loops,
REM but here we need to manually remove the quotes (:"=)

	move "%%f" "%pLists:"=%\!inputName!" > nul
	echo !inputName! moved to permanent folder


REM use parens to give echo blank input - ie print a blank line

	echo()
)
echo %horzBar%
echo All done!
timeout /t 1 /nobreak > nul
