error(stopCode) {
	msg := ""
	Switch stopCode {
		case 1:		msg := "'BisTrack' closed unexpectedly."
		case 2:		msg := "'Print Labels Wizard' closed unexpectedly."
		case 3: 	msg := "'New Prodcut Criteria' closed unexpectedly."
		case 4: 	msg := "'Selected Products for Labels' closed unexpectedly."
        case 5:     msg := "BisTrack needs to be open and the Print Labels Wizard started."
        case 6:     msg := "Something happened to your file."
    }
	MsgBox % "Error " stopCode ": " msg
    showBistrack()
    return false
}

showBistrack() {
    WinShow, "BisTrack"
    WinShow, "Print Labels Wizard"
    WinShow, "New Product Criteria"
    WinShow, "Selected Products for Labels"
}

hideBistrack() {
    WinHide, "BisTrack"
    WinHide, "Print Labels Wizard"
    Winhide, "New Product Criteria"
    WinHide, "Selected Products for Labels"
}