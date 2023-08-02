;@Ahk2Exe-SetName Quick Checksum Tool
;@Ahk2Exe-SetDescription Herramienta de verificación de la integridad de archivos
;@Ahk2Exe-SetCompanyName MauTech05
#SingleInstance Force
#Warn All, Off
#NoTrayIcon

;Configuraciones del Script
global installation_base_dir := A_ScriptDir
global buttons_dir := installation_base_dir "\buttons"
global script_icon := buttons_dir "\QuickChecksumTool.ico"
global home_checksum_path := installation_base_dir "\tmp.txt"

;Configuraciones de la Interfaz de Usuario (GUI)
OnMessage(0x0201, WM_LBUTTONDOWN)
quickCT_GUI := Gui()
quickCT_GUI.Title := "Quick Checksum Tool by MauTech05"
quickCT_GUI.OnEvent("Close", GuiEscape)
quickCT_GUI.OnEvent("Escape", GuiEscape)
quickCT_GUI.Opt("-Caption +Border")
quickCT_GUI.BackColor := "191919"

;Declaraciones iniciales
global home_file := ""
global foreign_checksum := ""

;Encabezado
quickCT_GUI.Add("Picture", "x15 y6 w30 h-1", script_icon)
quickCT_GUI.SetFont("s16 w900 cffffff", "Roboto")
quickCT_GUI.Add("Text", "x60 y7", "Quick Checksum Tool")
botonMinimizarGUI := quickCT_GUI.Add("Picture", "x405 y10 w15 h-1", buttons_dir "\button.png")
	botonMinimizarGUI.OnEvent("Click", GuiMinimize)
botonCerrarGUI := quickCT_GUI.Add("Picture", "x435 y10 w15 h-1", buttons_dir "\button_x.png")
	botonCerrarGUI.OnEvent("Click", GuiEscape)

;Créditos
quickCT_GUI.SetFont("s9 w400 c5f656d", "Open Sans")
quickCT_GUI.Add("Link", "x15 y250", 'Interfaz por <a href="https://github.com/mautech05">MauTech05</a>')
quickCT_GUI.Add("Link", "x190 y250", 'Ícono creado por Smashicons para <a href="https://www.flaticon.com/free-icon/laptop_4071601">Flaticon</a>')

;Pestaña No.1
quickCT_GUI.SetFont("s9 w400 cffffff", "Open Sans")
global guiTabs := quickCT_GUI.Add("Tab3", "x15 y50 w480 h190 section 0x182", ["Verificar","Generar"])
quickCT_GUI.Add("Picture", "x15 y75 h160 w435", buttons_dir "\tabs_border.png")
verifyTab:= quickCT_GUI.Add("Picture", "xs ys w-1 h25", buttons_dir "\maintab_verificar.png")
generateTab:= quickCT_GUI.Add("Picture", "xs+61 ys+5 w-1 h20", buttons_dir "\tab_generar.png")
	generateTab.OnEvent("Click", goToGenerate)
quickCT_GUI.Add("Edit", "xs+10 ys+40 w325 h21 section -VScroll Disabled", "Seleccione un archivo para verificar su integridad")
buttonSelectFile:= quickCT_GUI.Add("Picture", "xs+335 ys w80 h-1", buttons_dir "\button_seleccionar.png")
	buttonSelectFile.OnEvent("Click", selectFile)
quickCT_GUI.SetFont("s9 w400 c000000", "Open Sans")
editForeignChecksum:= quickCT_GUI.Add("Edit", "xs ys+35 w325 h21 -VScroll")
	SendMessage(0x1501, 1, StrPtr("Ingrese el Checksum original y/o de comprobación"), , "ahk_id " editForeignChecksum.hwnd)
buttonInsertChecksum:= quickCT_GUI.Add("Picture", "xs+335 ys+35 w80 h-1", buttons_dir "\button_enviar.png")
	buttonInsertChecksum.OnEvent("Click", insertChecksum)
buttonChangeChecksum:= quickCT_GUI.Add("Picture", "xs+335 ys+35 w80 h-1", buttons_dir "\button_cambiar.png")
	buttonChangeChecksum.OnEvent("Click", changeChecksum)
	buttonChangeChecksum.Visible := false
quickCT_GUI.SetFont("s9 w400 cffffff", "Open Sans")
quickCT_GUI.Add("Text", "xs ys+71 w150 h18 +0x200", "Formato del Checksum:")
dropdownChecksumFormat := quickCT_GUI.Add("DropDownList", "xs+150 ys+70 w175", ["sha256", "md5", "----------------------", "md2", "md4", "sha1", "sha384", "sha512"])
	dropdownChecksumFormat.OnEvent("Change", prepareChecksum)
buttonVerifyChecksum:= quickCT_GUI.Add("Picture", "xs ys+110 w416 h-1", buttons_dir "\button_comenzar-verificacion.png")
	buttonVerifyChecksum.OnEvent("Click", verifyChecksum)
	buttonVerifyChecksum.Visible := false

;Pestaña No.2
guiTabs.UseTab(2)
quickCT_GUI.Add("Picture", "x15 y75 h160 w435", buttons_dir "\tabs_border.png")
verifyTab:= quickCT_GUI.Add("Picture", "x15 y55 w-1 h20", buttons_dir "\tab_verificar.png")
	verifyTab.OnEvent("Click", goToVerify)
generateTab:= quickCT_GUI.Add("Picture", "x96 y50 w-1 h25", buttons_dir "\maintab_generar.png")
quickCT_GUI.SetFont("s9 w400 cffffff", "Open Sans")
quickCT_GUI.Add("Edit", "x25 y90 w325 h21 section -VScroll Disabled", "Seleccione un archivo para generar su Checksum")
buttonSelectFile2:= quickCT_GUI.Add("Picture", "xs+335 ys w80 h-1", buttons_dir "\button_seleccionar.png")
	buttonSelectFile2.OnEvent("Click", selectFile)
quickCT_GUI.Add("Text", "xs ys+36 w150 h18 +0x200", "Formato del Checksum:")
dropdownChecksumFormat2:= quickCT_GUI.Add("DropDownList", "xs+150 ys+35 w175", ["sha256", "md5", "----------------------", "md2", "md4", "sha1", "sha384", "sha512"])
	dropdownChecksumFormat2.OnEvent("Change", prepareChecksum)
buttonGenerateChecksum:= quickCT_GUI.Add("Picture", "xs ys+75 w416 h-1", buttons_dir "\button_generar.png")
	buttonGenerateChecksum.OnEvent("Click", generateChecksum)
	buttonGenerateChecksum.Visible := false

quickCT_GUI.Show("w465 h272")
Return

;Funciones de la Interfaz de Usuario (GUI)
WM_LBUTTONDOWN(*) {
	Try PostMessage(0xA1, 2, , , "A")
}
GuiEscape(*) {
	GuiClose:
    ExitApp()
}
GuiMinimize(*) {
	quickCT_GUI.Minimize()
}
goToGenerate(*) {
	guiTabs.Choose(2)
}
goToVerify(*) {
	guiTabs.Choose(1)
}

;Funciones de procesamiento
selectFile(*) {
	global home_file := FileSelect("3", , "Seleccione un archivo para utilizarlo en Quick Checksum Tool")
	if (guiTabs.Value = 1) {
		guiTabs.UseTab(1)
		quickCT_GUI.Add("Edit", "x25 y90 w325 h21 -VScroll Disabled", home_file)
	} else {
		guiTabs.UseTab(2)
		quickCT_GUI.Add("Edit", "x25 y90 w325 h21 -VScroll Disabled", home_file)
	}
}
insertChecksum(*) {
	global foreign_checksum := editForeignChecksum.Text
	if foreign_checksum = "" {
		MsgBox "Es necesario ingresar un texto Checksum para continuar", "Quick Checksum Tool", "Iconx"
		return
	}
	editForeignChecksum.Enabled := false
	buttonInsertChecksum.Enabled := false
	buttonInsertChecksum.Visible := false
	buttonChangeChecksum.Visible := true
}
changeChecksum(*) {
	editForeignChecksum.Enabled := true
	buttonInsertChecksum.Enabled := true
	buttonInsertChecksum.Visible := true
	buttonChangeChecksum.Visible := false
}
prepareChecksum(*) {
	if (guiTabs.Value = 1)
		buttonVerifyChecksum.Visible := true
	else
		buttonGenerateChecksum.Visible := true
}
verifyChecksum(*) {
	if (home_file = "" || foreign_checksum = "") {
		MsgBox "Es necesario rellenar toda la información para continuar", "Quick Checksum Tool", "Iconx"
		return
	}

	checksum_command := Format("certutil -hashfile {1}{3}{2} {4} > {1}{5}{2}", '"', '"', home_file, dropdownChecksumFormat.Text, home_checksum_path)
	RunWait A_ComSpec " /c " checksum_command, , "Hide"
	home_checksum := StrSplit(FileRead(home_checksum_path), '`n', '`r')

	if (home_checksum[2] == foreign_checksum)
		MsgBox "¡Felicidades! Ambos Checksum coincidieron, por lo que el archivo es LEGÍTIMO.", "Quick Checksum Tool", "Iconi"
	else
		MsgBox "¡Cuidado! No se detectaron coincidencias en los Checksum, por lo que la integridad del archivo está COMPROMETIDA.", "Quick Checksum Tool", "Icon!"
}
generateChecksum(*) {
	checksum_command := Format("certutil -hashfile {1}{3}{2} {4} > {1}{5}{2}", '"', '"', home_file, dropdownChecksumFormat2.Text, home_checksum_path)
	RunWait A_ComSpec " /c " checksum_command, , "Hide"
	generated_checksum := StrSplit(FileRead(home_checksum_path), '`n', '`r')
	A_Clipboard := generated_checksum[2]
	MsgBox "Se ha copiado al portapapeles el Checksum " dropdownChecksumFormat2.Text " correspondiente al archivo seleccionado.", "Quick Checksum Tool", "Iconi"
}