#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

^0::
    ControlGet, exist, Visible,, ThunderRT6CommandButton6, Print Labels Wizard
    MsgBox, Visible: %exist%

    return