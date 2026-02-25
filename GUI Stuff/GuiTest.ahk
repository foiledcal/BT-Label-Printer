Gui, Add, ListBox, x12 y10 w80 h130 , ListBox
Gui, Add, Button, x102 y10 w90 h30 , Select File
Gui, Add, Button, x102 y40 w90 h30 , Start/Stop
Gui, Add, Button, x102 y70 w90 h30 , Show BisTrack
Gui, Add, Button, x102 y100 w90 h30 , Hide BisTrack
Gui, Add, Progress, x10 y280 w280 h10 , 25
Gui, Show, w300 h300, Label Printer
return

GuiClose:
ExitApp