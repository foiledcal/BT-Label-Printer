#NoEnv
#MaxThreadsPerHotkey 2
#Include C:\Users\Public\Public Programs\VSCode-win32-x64-1.67.2\Projects\BT-Label-Printer\ExcelToArray-master\ExcelToArray.ahk
#Include functions.ahk
#include settings.config
SendMode Input
SetWorkingDir, %A_ScriptDir%
DetectHiddenWindows, On


^1::
	;if other thread already running, this tells it to stop
	if (keepWinRunning) {
		keepWinRunning := false
		return
	}
	keepWinRunning := true
	;keep this block at the top

	if (!WinExist("BisTrack - New Pullman Store"))
		keepWinRunning := error(5)

	;timings and declarations


	pasteAdd := 300
	addF := 1800
	Fpaste := 1800

	skuArray := []
	skuArrSize := 0
	initState := 3
	step := 1

	pasteStart := 0
	addStart := 0
	Fstart := 0
	index := 0
	linesDone := 0

	;prompt user file
    FileSelectFile, inFile, 3
	if (inFile = "") {			;if user cancels file selection, exits program
		keepWinRunning := False
		return
	}

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
			skuArrSize := skuArrSize + 1
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
		MsgBox, Invalid file type

	}
	
	;Push through start screens
	While (initState < 6) {

		;check if script needs to stop
		if (!keepWinRunning) {
			msgbox, Loop stopped
			return
		}

		switch initState {
			case 1:		;only Print Labels Wizard visible
				ControlSend,, !n, Print Labels Wizard
				ControlSend,, !c, Print Labels Wizard
				ControlSend,, !d, Print Labels Wizard
				intiState := 2
			case 2:
				if (!WinExist("New Product Criteria")) {
					initState := 2
				} else {
					initState := 3
				}
			case 3:
				;msgbox, 2
				If (!WinExist("New Product Criteria")) {
					initState := 1
				} else {
					ControlSend,, !p, New Product Criteria
					initState := 4
				}
			case 4:
				if (!WinExist("Selected Products for Labels")) {
					initState := 4
				} else {
					initState := 5
				}
			case 5:
				;msgbox, 3
				if (!WinExist("Selected Products for Labels")) {
					;msgbox, 3.1 
					initState := 3
				} else {
					;msgbox, 3.2
					initState := 6
				}
		}
	}

	if (HideBisTrackonStart) {
		hideBistrack()
	}

	;flip skuArray if told to
	if (ReversePrintOrder) {
		Loop % Floor(skuArrSize/2)	;floor leaves middle value alone if odd-sized array
		{
			temp3 := skuArray[A_Index]
			skuArray[A_Index] := skuArray[skuArrSize - (A_Index - 1)]
			skuArray[skuArrSize - (A_Index - 1)] := temp3
		}
	}

	;main loop
	Loop % skuArray.MaxIndex()
	{
		;while loop for entering each sku
		index := A_Index	;A_Index doesn't work within nested loops or something idk
		while (step < 4) {

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

			Switch step {
				case 1:
					if (pasteStart = 0) {
						pasteStart := A_TickCount
						temp2 := skuArray[index]
						;ControlSetText, ThunderRT6TextBox1, %temp2%, Selected Products for Labels
						ControlSend,, {Alt down}{q down}{q up}{Alt up}, Selected Products for Labels
						ControlSend,, %temp2%, Selected Products for Labels
					}
					if (A_TickCount - pasteStart >= pasteAdd) {
						step := 2
						pasteStart := 0
					}
				case 2:
					if (addStart = 0) {
						addStart := A_TickCount
						;ControlClick, ThunderRT6CommandButton1, Selected Products for Labels,,,, NA
						ControlSend,, {Alt down}{A down}{A up}{Alt up}, Selected Products for Labels
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
						;Alt+o, e: turns on exact match, likely gives best result
						;ControlSend,, {Alt down}{o down}{o up}{alt up}, Find Products
						;ControlSend,, e, Find Products	;turn on exact match
						;sleep, 200
						;ControlSend,, {Alt down}{o down}{o up}{alt up}, Find Products
						;ControlSend,, n, Find Products	;turn on non-stocked
						;sleep, 200
						;ControlClick, SSCommandWndClass1, Find Products,,,, NA
						ControlSend,, {F12}, Find Products
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

	showBistrack()
	if (DisplayBisTrackonStop)
		WinActivate, BisTrack - New Pullman Store
	
	if (linesDone = 1) {
		msgbox, Done, %linesDone% product entered.
	} else if (linesDone >= 0) {
		msgbox, Done, %linesDone% products entered.
	} else {
		msgbox, Invalid number of products entered, gg.
	}

	keepWinRunning := false
	Return


;toggle bistrack visibility
^2::
	WinGet, winVisible, Style, BisTrack - New Pullman Store
    Transform, Result, BitAnd, %winVisible%, 0x10000000
    if (Result > 0) {
		;msgbox, a
        hideBistrack()
    } else {
		;msgbox, b
        showBistrack()
    }
	return

^3::
	hideBistrack()
	Return

^4::
	showBistrack()
	return
	



/*

if filetype excel, use exceltoarray
	look for column headers like sku, upc, quantity, etc

;hideBistrack()

in return file of bad skus, instead duplicate user's file with bad skus marked
option to reverse array order

plans
limit types of files selectable
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