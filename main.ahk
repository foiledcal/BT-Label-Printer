#NoEnv
#MaxThreadsPerHotkey 2
#Include P:\Float\GitHub\BT-Label-Printer\ExcelToArray-master\ExcelToArray.ahk
#Include functions.ahk
SendMode Input
SetWorkingDir, %A_ScriptDir%


^1::
	;if other thread already running, this tells it to stop
	if (keepWinRunning) {
		keepWinRunning := false
		return
	}
	keepWinRunning := true
	;keep this block at the top

	;timings and declarations
	pasteAdd := 2000
	addF := 2000
	Fpaste := 2000
	skuArray := []
	step := 1
	pasteStart := 0
	addStart := 0
	Fstart := 0
	
	if (!WinExist("BisTrack - New Pullman Store"))
		keepWinRunning := error(5)
	
	;prompt user file
	FileSelectFile, inFile, 3
	if (inFile = "") {
		keepWinRunning := False
		return
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
	temp := skuArray.MaxIndex()

	Loop, %temp%
	{
		;msgbox, 2
		if (!keepWinRunning) {
			return
		}

		if (!WinExist("BisTrack - New Pullman Store"))
			keepWinRunning := error(1)
		if (!WinExist("Print Labels Wizard"))
			keepWinRunning := error(2)
		if (!WinExist("New Product Criteria"))
			keepWinRunning := error(3)
		if (!WinExist("Selected Products for Labels"))
			keepWinRunning := error(4)
	
		Switch step {
			case 1:
				;msgbox, 3
				if (pasteStart = 0) {
					;msgbox, 3a
					pasteStart := A_TickCount
					;msgbox, 3b, A_TickCount = %pasteStart%
					temp2 := skuArray[A_Index]
					ControlSetText, ThunderRT6TextBox1, %temp2%, Selected Products for Labels
					;msgbox, 3c
				}
				if (A_TickCount - pasteStart >= pasteAdd) {
					;msgbox, 3d
					step := 2
					;msgbox, 3e
					pasteStart := 0
					;msgbox, 3f
				}
			case 2:
				;msgbox, 4
				if (addStart = 0) {
					;msgbox, 4a
					addStart := A_TickCount
					ControlClick, ThunderRT6CommandButton1, Selected Products for Labels,,,, NA
					;msgbox, 4b
				}
				if (A_TickCount - addStart >= addF) {
					step := 3
					;msgbox, 4c
					addStart := 0
				}
			case 3:
				;msgbox, 5
				if (Fstart = 0 && WinExist("Find Products")) {
					Fstart := A_TickCount
					ControlClick, SSCommandWndClass1, Find Products,,,, NA
				}
				if (A_TickCount - Fstart >= Fpaste) {
					step := 1
					Fstart := 0
				}
		}
	}


	keepWinRunning := false
	Return





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


plans
limit types of files selectable
convert loop file read to loop through arrays
gui
	progress bar
	show/hide bistrack button


*/