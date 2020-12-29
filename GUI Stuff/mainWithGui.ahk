#NoEnv
#MaxThreadsPerHotkey 2
#Include P:\Float\GitHub\BT-Label-Printer\ExcelToArray-master\ExcelToArray.ahk
#Include functions.ahk
SendMode Input
SetWorkingDir, %A_ScriptDir%

if (!WinExist("BisTrack - New Pullman Store"))
	keepWinRunning := error(5)

Gui, Add, ListBox, x12 y10 w80 h130 , ListBox
Gui, Add, Button, x102 y10 w90 h30 , Select File
Gui, Add, Button, x102 y40 w90 h30 , Start/Stop
Gui, Add, Button, x102 y70 w90 h30 , Show BisTrack
Gui, Add, Button, x102 y100 w90 h30 , Hide BisTrack
Gui, Add, Progress, x12 y140 w180 h10 , 25
; Generated using SmartGUI Creator for SciTE
Gui, Show, w209 h166, Untitled GUI


;timings and declarations
pasteAdd := 300
addF := 1800
Fpaste := 1800
skuArray := []
step := 1
pasteStart := 0
addStart := 0
Fstart := 0
index := 0
linesDone := 0

ButtonSelectFile:
;prompt user file
FileSelectFile, inFile, 3
if (inFile = "") {
	ExitApp
}

;Window: Print Labels Wizard
	nextbutton := "ThunderRT6CommandButton2"
	radiobutton := "ThunderRT6OptionButton6"
	addbutton := "ThunderRT6CommandButton6"
;Window: New Product Criteria
	productsbutton := "SSCommandWndClass1"
;window: Selected Products for Labels
	textfield := "ThunderRT6TextBox1"
	skuaddbutton := "ThunderRT6CommandButton1"

;Push through starting windows
if (!WinExist("Selected Products for Labels")) {
	if (WinExist("New Product Criteria")) {
		ControlClick, %productsbutton%, New Product Criteria,,,, NA
		sleep, 500
	} else if (WinExist("Print Labels Wizard")) {
		ControlGet, radioVisible, Visible,, ThunderRT6OptionButton6, Print Labels Wizard	
		if (radioVisible) {
			ControlClick, %radiobutton%, Print Labels Wizard,,,, NA
			sleep, 500
			ControlClick, %addbutton%, Print Labels Wizard,,,, NA
			WinWait, New Product Criteria
			sleep, 500
			ControlClick, %productsbutton%, New Product Criteria,,,, NA
			sleep, 500
		} else {
			ControlClick, %nextbutton%, Print Labels Wizard,,,, NA
			sleep, 500
			ControlClick, %radiobutton%, Print Labels Wizard,,,, NA
			sleep, 500
			ControlClick, %addbutton%, Print Labels Wizard,,,, NA
			WinWait, New Product Criteria
			sleep, 500
			ControlClick, %productsbutton%, New Product Criteria,,,, NA
			sleep, 500
		}
	}
}

;hideBistrack()

;extract file extension
if (FileExist(inFile)) {
	Loop, %inFile%
	{
		StringGetPos, PosA, A_LoopFileName, ., R
		StringRight, fileExt, A_LoopFileName, % StrLen(A_LoopFileName)-PosA-1
	}
} else {
	keepWinRunning := keepWinRunning := error(6)
}

;Convert files to arrays
if (fileExt = "txt") {
	Loop, Read, %inFile%
	{
		skuArray.Push(A_LoopReadLine)
	}
} else if (fileExt = "xlsx") {
	MsgBox, xlsx
	ImportData:
		skuArray := ExcelToArray(inFile)
	;MsgBox % skuArray[1,1]
	;send to function to extract sku column
} else if (fileExt = "csv") {
	MsgBox, csv
	;make array out of, send to function to extract sku column
} else {
	MsgBox, invalid file type
}

;main loop
temp := skuArray.MaxIndex()		;dunno how to put maxindex in the loop call directly
Loop, %temp%
{
	;check if any important windows broke
	if (!WinExist("BisTrack - New Pullman Store"))
		keepWinRunning := error(1)
	if (!WinExist("Print Labels Wizard"))
		keepWinRunning := error(2)
	if (!WinExist("New Product Criteria"))
		keepWinRunning := error(3)
	if (!WinExist("Selected Products for Labels"))
		keepWinRunning := error(4)

	;check if script needs to stop
	if (!keepWinRunning) {
		msgbox, Loop stopped
		return
	}

	;while loop for entering each sku
	index := A_Index	;A_Index doesn't work within nested loops
	while (step < 4) {
		Switch step {
			case 1:
				if (pasteStart = 0) {
					pasteStart := A_TickCount
					temp2 := skuArray[index]
					ControlSetText, ThunderRT6TextBox1, %temp2%, Selected Products for Labels
				}
				if (A_TickCount - pasteStart >= pasteAdd) {
					step := 2
					pasteStart := 0
				}
			case 2:
				if (addStart = 0) {
					addStart := A_TickCount
					ControlClick, ThunderRT6CommandButton1, Selected Products for Labels,,,, NA
				}
				if (A_TickCount - addStart >= addF) {
					if (WinExist("Find Products")) {
						step := 3
					} else {
						linesDone := linesDone + 1
						step := 4
					}
					addStart := 0
				}
			case 3:
				if (Fstart = 0 && WinExist("Find Products")) {
					Fstart := A_TickCount
					ControlClick, SSCommandWndClass1, Find Products,,,, NA
					linesDone := linesDone + 1
				}
				if (A_TickCount - Fstart >= Fpaste) {
					step := 4
					Fstart := 0
				}
		}
	}
	;reset the while loop conditional
	step := 1
}

if (linesDone = 1) {
	msgbox, Done, %linesDone% product entered.
} else if (linesDone >= 0) {
	msgbox, Done, %linesDone% products entered.
} else {
	msgbox, Invalid number of products entered, gg.
}

showBistrack()
keepWinRunning := false
Return


GuiClose:
ExitApp



/*

push through opening prompts
	check if at end, progress checks backwards through menus
	delay and winait used
prompt user file
	parse filename with "." to take final file extension
if filetype .txt
	convert to array through loop file read
	count number of lines
if filetype excel, use exceltoarray
	look for column headers like sku, upc, quantity, etc

;hideBistrack()

loop to progress through sku entering windows
	check for:
	switch case for stepping through windows
	if !keepwinrunning {
		showBistrack()
		return
	}
	if any bistrack window closed unexpectedly
		
showBistrack()

functions

in return file of bad skus, instead duplicate user's file with bad skus marked
option to reverse array order

plans
limit types of files selectable
convert loop file read to loop through arrays
gui
	progress bar
	show/hide bistrack button
	running list of bad skus
	settings
		reverse order
		skip Find Products
	start/stop
	pause/resume
*/