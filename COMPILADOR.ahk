;@Ahk2Exe-SetName Compilador de Quick Checksum Tool
;@Ahk2Exe-SetDescription Compilador de Quick Checksum Tool
;@Ahk2Exe-SetCompanyName MauTech05
#Requires AutoHotkey >=2.0- <2.1
#SingleInstance Force
#Warn All, Off


;Compilar con Ahk2Exe
InstallDir := RegRead("HKLM\SOFTWARE\AutoHotkey", "InstallDir", "")
if A_Is64bitOS == 1 {
	RunWait Format("{1}{2}\Compiler\Ahk2Exe.exe{1}", '"', InstallDir)
	. ' /in ' Format("{1}{2}\Quick_Checksum_Tool.ahk{1}", '"', A_ScriptDir)
	. ' /out ' Format("{1}{2}\Quick Checksum Tool.exe{1}", '"', A_ScriptDir)
	. ' /icon ' Format("{1}{2}\buttons\QuickChecksumTool.ico{1}", '"', A_ScriptDir)
	. ' /base ' Format("{1}{2}\v2\AutoHotkey64.exe{1}", '"', InstallDir)
	. ' /compress 0'
} else {
	RunWait Format("{1}{2}\Compiler\Ahk2Exe.exe{1}", '"', InstallDir)
	. ' /in ' Format("{1}{2}\Quick_Checksum_Tool.ahk{1}", '"', A_ScriptDir)
	. ' /out ' Format("{1}{2}\Quick Checksum Tool.exe{1}", '"', A_ScriptDir)
	. ' /icon ' Format("{1}{2}\buttons\QuickChecksumTool.ico{1}", '"', A_ScriptDir)
	. ' /base ' Format("{1}{2}\v2\AutoHotkey32.exe{1}", '"', InstallDir)
	. ' /compress 0'
}


;Acceso directo de Escritorio
shortcut:= MsgBox("¿Quieres que dejemos un acceso directo en el escritorio?", "Compilador de Quick Checksum Tool", "36")
if shortcut = "Yes"
	FileCreateShortcut A_ScriptDir "\Quick Checksum Tool.exe", A_Desktop "\Quick Checksum Tool.lnk", , , "Quick Checksum Tool", A_ScriptDir "\buttons\QuickChecksumTool.ico"
ExitApp