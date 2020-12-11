#NoEnv
#MaxThreadsPerHotkey 2
#Include P:\Float\GitHub\BT-Label-Printer\ExcelToArray-master\ExcelToArray.ahk

^1::
	if (keepWinRunning) {
		keepWinRunning := false
		return
	}
	keepWinRunning := true
	
	FileSelectFile, fileIn, 3
	if (fileIn = "") {
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

	sleep, 500
	ControlClick, %nextbutton%, Print Labels Wizard,,,, NA
	sleep, 500
	ControlClick, %radiobutton%, Print Labels Wizard,,,, NA
	sleep, 500
	ControlClick, %addbutton%, Print Labels Wizard,,,, NA
	WinWait, New Product Criteria
	sleep, 500
	ControlClick, %productsbutton%, New Product Criteria,,,, NA
	WinWait, Selected Products for Labels


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

showBistrack()
hideBistrack()
error()
	error message block


plans
convert loop file read to loop through arrays
gui
	progress bar
	show/hide bistrack button


*/