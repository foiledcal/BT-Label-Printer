#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

^0::
    ControlGet, exist, Visible,, ThunderRT6CommandButton6, Print Labels Wizard
    MsgBox, Visible: %exist%
    exit

^9::
    ControlGet, addEnabled, Enabled,, ThunderRT6CommandButton2, Print Labels Wizard
    MsgBox, Enabled: %addEnabled%
    return 

^8::
    ControlGet, radioVisible, Visible,, ThunderRT6OptionButton6, Print Labels Wizard
    MsgBox, Radio Visible: %radioVisible%
    return

^7::
    FileName = P:\Float\GitHub\BT-Label-Printer\Product Lists\test.s
    IfExist %FileName%
    {
        Loop, %FileName%
        {
            StringGetPos, PosA, A_LoopFileName, ., R
            StringRight, CurrentExt, A_LoopFileName, % StrLen(A_LoopFileName)-PosA-1
            MsgBox, %CurrentExt%
        }
    }
    else
    MsgBox 64, %A_ScriptName% - Rad %A_LineNumber%, The file is missing! ,3
    Return

^6::
    ControlSetText, ThunderRT6TextBox1, test, Selected Products for Labels
