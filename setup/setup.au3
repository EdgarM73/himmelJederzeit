#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Oxygen-Icons.org-Oxygen-Status-weather-clouds-night.ico
#AutoIt3Wrapper_Outfile=setup_x86.exe
#AutoIt3Wrapper_Outfile_x64=setup_x64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=himmel JEderzeit Installation
#AutoIt3Wrapper_Res_Fileversion=0.9.4
#AutoIt3Wrapper_Res_LegalCopyright=GNU Public Licence v2
#AutoIt3Wrapper_Res_Language=1031
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

Global $IPAddress1

Global $jederzeitCFG
Local $lPasswort;
Local $lBenutzerName;
Local $lmediaVerzeichnis;
Local $configTxt
Local $lStartMinute, $lStartStunde, $lEndMinute, $lEndStunde;


#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <GuiIPAddress.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>
#cs
	#Region ### START Koda GUI section ### Form=C:\entwicklung\himmelJederzeit\himmelJederzeitGUI.kxf
	$Form1_1 = GUICreate("Neutrino HD himmel Jederzeit", 1280, 730, 199, 127)
	$Label1 = GUICtrlCreateLabel("himmel Jederzeit Installation", 80, 16, 277, 29)
	GUICtrlSetFont(-1, 15, 800, 0, "MS Sans Serif")
	$Genres = GUICtrlCreateGroup("Genres", 40, 96, 193, 249)
	$Abenteuer = GUICtrlCreateCheckbox("Abenteuer", 56, 120, 97, 17)
	$Action = GUICtrlCreateCheckbox("Action", 56, 144, 97, 17)
	$Drama = GUICtrlCreateCheckbox("Drama", 56, 168, 97, 17)
	$Family = GUICtrlCreateCheckbox("Family", 56, 192, 97, 17)
	$Horror = GUICtrlCreateCheckbox("Horror", 56, 216, 97, 17)
	$Comedy = GUICtrlCreateCheckbox("Comedy", 56, 240, 97, 17)
	$SciFi = GUICtrlCreateCheckbox("SciFi", 56, 264, 97, 17)
	$Thriller = GUICtrlCreateCheckbox("Thriller", 56, 288, 97, 17)
	$Western = GUICtrlCreateCheckbox("Western", 56, 312, 97, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Coolstream = GUICtrlCreateGroup("Coolstream", 272, 96, 305, 177)
	$Label2 = GUICtrlCreateLabel("IP-Adresse:", 296, 128, 58, 17)
	$Label3 = GUICtrlCreateLabel("Benutzer", 304, 160, 46, 17)
	$Benutzer = GUICtrlCreateInput("root", 400, 160, 121, 21)
	$Label4 = GUICtrlCreateLabel("Passwort", 304, 192, 47, 17)
	$Passwort = GUICtrlCreateInput("coolstream", 400, 192, 121, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Installieren = GUICtrlCreateButton("Installieren", 728, 352, 131, 41)
	$Timecontrol = GUICtrlCreateGroup("Timecontrol", 608, 104, 249, 201)
	$Startzeit = GUICtrlCreateGroup("Startzeit", 640, 160, 185, 57)
	$StartStunde = GUICtrlCreateCombo("Stunde", 656, 184, 65, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23")
	$StartMinute = GUICtrlCreateCombo("Minute", 736, 184, 65, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "00|05|10|15|20|25|30|35|40|45|50|55")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Endzeit = GUICtrlCreateGroup("Endzeit", 640, 232, 185, 65)
	$EndStunde = GUICtrlCreateCombo("Stunde", 656, 259, 65, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23")
	$EndMinute = GUICtrlCreateCombo("Minute", 737, 259, 65, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "00|05|10|15|20|25|30|35|40|45|50|55")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$aktivieren = GUICtrlCreateCheckbox("aktivieren", 640, 128, 177, 17)
	GUICtrlSetTip(-1, "Timecontrol bestimmt, zu welchen Zeiten NICHT augenommen werden darf")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Progress1 = GUICtrlCreateProgress(240, 376, 358, 17,)
	$Pic1 = GUICtrlCreatePic("C:\entwicklung\himmelJederzeit\schritt1.jpg", 232, 408, 708, 316)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
#ce

#include <guiPart.au3>

#include<_Zip.au3>

_prepare()

$configTxt = @WorkingDir & "/config.txt"
$jederzeitCFG = @WorkingDir & "/himmelJederzeit.cfg"

FileCopy($jederzeitCFG & ".template", $jederzeitCFG, 1)

Func setCheckBoxes($name, $variable)

	$CBox_State = IniRead($jederzeitCFG, "Genres", $name, "")
	;	MsgBox(0,$name,$CBox_State)
	If $CBox_State Then GUICtrlSetState($variable, $CBox_State)
EndFunc   ;==>setCheckBoxes


#include <File.au3>
Func parseConfigTxt($ip, $lPasswort, $lBenutzerName)
	FileCopy($configTxt & ".template", $configTxt, 1)
	_ReplaceStringInFile($configTxt, "ipadresse", _GUICtrlIpAddress_Get($IPAddress1))
	_ReplaceStringInFile($configTxt, "Benutzername", $lBenutzerName)
	_ReplaceStringInFile($configTxt, "passwort", $lPasswort)

EndFunc   ;==>parseConfigTxt

Func _prepare()
	$fil = @WorkingDir & "\himmelJederzeit.zip"
	$dir = @WorkingDir;
	_Zip_UnzipAll($fil, $dir)
EndFunc   ;==>_prepare

Func _install()
	GUICtrlSetState($Progress1, $GUI_SHOW)
	GUICtrlSetState($Pic1, $GUI_SHOW)
	GUICtrlSetData($Progress1, 25)
	GUICtrlSetState($Weiter, $GUI_SHOW)
	GUICtrlSetState($Installieren, $GUI_HIDE)
	Run(@WorkingDir & "/update.bat", @WorkingDir)
	$step = 1
EndFunc   ;==>_install

func _transfer_Config()

	EndFunc

Global $step = 0
Func _install_schritt_2()
	$step = $step + 1

	If $step == 2 Then
		GUICtrlSetState($Pic2, $GUI_SHOW)
		GUICtrlSetState($Pic1, $GUI_HIDE)
	ElseIf $step == 3 Then
		GUICtrlSetState($Pic3, $GUI_SHOW)
		GUICtrlSetState($Pic2, $GUI_HIDE)
	ElseIf $step == 4 Then
		GUICtrlSetState($Pic4, $GUI_SHOW)
		GUICtrlSetState($Pic3, $GUI_HIDE)
		GUICtrlSetState($ConfigPut, $GUI_SHOW)
		GUICtrlSetState($Weiter, $GUI_HIDE)
	EndIf
	GUICtrlSetData($Progress1, 25 * $step)
EndFunc   ;==>_install_schritt_2

setCheckBoxes("Adventure", $Abenteuer)
setCheckBoxes("Action", $Action)
setCheckBoxes("Horror", $Horror)
setCheckBoxes("Drama", $Drama)
setCheckBoxes("Family", $Family)
setCheckBoxes("Comedy", $Comedy)
setCheckBoxes("SciFi", $SciFi)
setCheckBoxes("Thriller", $Thriller)
setCheckBoxes("Western", $Western)


GUICtrlSetState($StartMinute, $GUI_DISABLE)
GUICtrlSetState($StartStunde, $GUI_DISABLE)
GUICtrlSetState($EndStunde, $GUI_DISABLE)
GUICtrlSetState($EndMinute, $GUI_DISABLE)
$lStartStunde = "20"
$lStartMinute = "00"
$lEndStunde = "22"
$lEndMinute = "30"
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case ConfigPut
			_transfer_Config()
		Case $Weiter
			_install_schritt_2()
		Case $aktivieren
			If GUICtrlRead($aktivieren) = $GUI_CHECKED Then
				GUICtrlSetState($StartMinute, $GUI_ENABLE)
				GUICtrlSetState($StartStunde, $GUI_ENABLE)
				GUICtrlSetState($EndMinute, $GUI_ENABLE)
				GUICtrlSetState($EndStunde, $GUI_ENABLE)
				$lStartStunde = GUICtrlRead($StartStunde);
				$lStartMinute = GUICtrlRead($StartMinute);
				$lEndStunde = GUICtrlRead($EndStunde);
				$lEndMinute = GUICtrlRead($EndMinute);
			Else
				$lStartStunde = ""
				$lStartMinute = ""
				$lEndStunde = ""
				$lEndMinute = ""
				GUICtrlSetState($StartMinute, $GUI_DISABLE)
				GUICtrlSetState($StartStunde, $GUI_DISABLE)
				GUICtrlSetState($EndStunde, $GUI_DISABLE)
				GUICtrlSetState($EndMinute, $GUI_DISABLE)
			EndIf
		Case $StartStunde, $aktivieren
			$lStartStunde = GUICtrlRead($StartStunde);
		Case $StartMinute, $aktivieren
			$lStartMinute = GUICtrlRead($StartMinute);
		Case $EndStunde, $aktivieren
			$lEndStunde = GUICtrlRead($EndStunde);
		Case $EndMinute, $aktivieren
			$lEndMinute = GUICtrlRead($EndMinute);
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Abenteuer
			If GUICtrlRead($Abenteuer) = $GUI_CHECKED Then
				IniWrite($jederzeitCFG, "Genres", "Adventure", 1)
			Else
				IniWrite($jederzeitCFG, "Genres", "Adventure", 0)
			EndIf
		Case $Action
			If GUICtrlRead($Action) = $GUI_CHECKED Then
				IniWrite($jederzeitCFG, "Genres", "Action", 1)
			Else
				IniWrite($jederzeitCFG, "Genres", "Action", 0)
			EndIf
		Case $Drama
			If GUICtrlRead($Drama) = $GUI_CHECKED Then
				IniWrite($jederzeitCFG, "Genres", "Drama", 1)
			Else
				IniWrite($jederzeitCFG, "Genres", "Drama", 0)
			EndIf
		Case $Family
			If GUICtrlRead($Family) = $GUI_CHECKED Then
				IniWrite($jederzeitCFG, "Genres", "Family", 1)
			Else
				IniWrite($jederzeitCFG, "Genres", "Family", 0)
			EndIf
		Case $Horror
			If GUICtrlRead($Horror) = $GUI_CHECKED Then
				IniWrite($jederzeitCFG, "Genres", "Horror", 1)
			Else
				IniWrite($jederzeitCFG, "Genres", "Horror", 0)
			EndIf
		Case $Comedy
			If GUICtrlRead($Comedy) = $GUI_CHECKED Then
				IniWrite($jederzeitCFG, "Genres", "Comedy", 1)
			Else
				IniWrite($jederzeitCFG, "Genres", "Comedy", 0)
			EndIf
		Case $SciFi
			If GUICtrlRead($SciFi) = $GUI_CHECKED Then
				IniWrite($jederzeitCFG, "Genres", "SciFi", 1)
			Else
				IniWrite($jederzeitCFG, "Genres", "SciFi", 0)
			EndIf
		Case $Thriller
			If GUICtrlRead($Thriller) = $GUI_CHECKED Then
				IniWrite($jederzeitCFG, "Genres", "Thriller", 1)
			Else
				IniWrite($jederzeitCFG, "Genres", "Thriller", 0)
			EndIf
		Case $Western
			If GUICtrlRead($Western) = $GUI_CHECKED Then
				IniWrite($jederzeitCFG, "Genres", "Western", 1)
			Else
				IniWrite($jederzeitCFG, "Genres", "Western", 0)
			EndIf
		Case $Installieren
			If GUICtrlRead($aktivieren) == $GUI_CHECKED Then
				If $lStartStunde <> "Stunde" And $lStartMinute <> "Minute" And $EndStunde <> "Stunde" And $EndMinute <> "Minute" Then
					IniWrite($jederzeitCFG, "control", "timeSpan", $lStartStunde & ":" & $lStartMinute & "-" & $lEndStunde & ":" & $lEndMinute)
				Else
					MsgBox(0, "selt", "sam")
				EndIf
			Else
				IniWrite($jederzeitCFG, "control", "timeSpan", "")
			EndIf

			IniWrite($jederzeitCFG, "control", "Film", "1")
			IniWrite($jederzeitCFG, "control", "Welt", "0")
			IniWrite($jederzeitCFG, "control", "Serie", "0")
			$lPasswort = GUICtrlRead($Passwort);
			$lBenutzerName = GUICtrlRead($Benutzer);

			parseConfigTxt(GUICtrlRead($IPAddress1), $lPasswort, $lBenutzerName)
			_install()
	EndSwitch
WEnd







