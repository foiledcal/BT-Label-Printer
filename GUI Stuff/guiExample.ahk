Gui, Add, GroupBox, x-678 y1040 w940 h-1070 , GroupBox
Gui, Add, Text, x17 y8 w120 h20 , Your Name:
Gui, Add, Text, x17 y38 w120 h20 , Your Year of Birth (yyy):
Gui, Add, Edit, x157 y8 w100 h20 vName, Name
Gui, Add, Edit, x157 y38 w70 h20 vYear, yyyy
Gui, Add, Button, x27 y68 w70 h20 , OK
Gui, Add, Button, x117 y68 w70 h20 , Cancel
; Generated using SmartGUI Creator for SciTE
Gui, Show, w277 h98, Untitled GUI

return

ButtonCancel:
GuiClose:
ExitApp

ButtonOK:
Gui, submit
Age = %A_year%
Age -= %Year%
MsgBox, %name% is %Age% years old
ExitApp