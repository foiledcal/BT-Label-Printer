#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#include functions.ahk

checkFile := ""

^5::

FileSelectFile, inFile, 3
if (inFile = "") {
	keepWinRunning := False
	return
}

lastSlash := InStr(InFile, "\", 0, -1)
lastDot := InStr(InFile, ".", 0, -1)

inFileName := SubStr(inFile, lastSlash+1, (lastDot - lastSlash-1))

;msgbox, file name is %inFileName%

checkFile := inFileName " - Problem SKUs.txt"

if !FileExist(checkFile) {
	msgbox, no
	FileAppend,, %checkFile%

	FileObj := FileOpen(checkFile, "w")
	FileObj.Write("test`r`n")
	FileObj.Close()
} else {
	msgbox, yes %checkFile%
}
return