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
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiIPAddress.au3>
#include <GuiStatusBar.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Global $IPAddress1

Global $jederzeitCFG
Local $lPasswort;
Local $lBenutzerName;
Local $lmediaVerzeichnis;
Local $configTxt


Local $lStartMinute, $lStartStunde, $lEndMinute, $lEndStunde;

#region ### START Koda GUI section ### Form=C:\entwicklung\himmelJederzeit-0.9.4_beta3\himmelGUI.kxf
$Form1_1 = GUICreate("Neutrino HD himmel Jederzeit", 957, 432, 199, 127)
$Label1 = GUICtrlCreateLabel("himmel Jederzeit Installation", 80, 16, 277, 29)
GUICtrlSetFont(-1, 15, 800, 0, "MS Sans Serif")
$Genres = GUICtrlCreateGroup("Genres", 40, 96, 193, 249)
$Abenteuer = GUICtrlCreateCheckbox("Abenteuer", 56, 120, 97, 17)
;GUICtrlSetState(-1, $GUI_CHECKED)
$Action = GUICtrlCreateCheckbox("Action", 56, 144, 97, 17)
;GUICtrlSetState(-1, $GUI_CHECKED)
$Drama = GUICtrlCreateCheckbox("Drama", 56, 168, 97, 17)
;GUICtrlSetState(-1, $GUI_CHECKED)
$Family = GUICtrlCreateCheckbox("Family", 56, 192, 97, 17)
;GUICtrlSetState(-1, $GUI_CHECKED)
$Horror = GUICtrlCreateCheckbox("Horror", 56, 216, 97, 17)
;GUICtrlSetState(-1, $GUI_CHECKED)
$Comedy = GUICtrlCreateCheckbox("Comedy", 56, 240, 97, 17)
;GUICtrlSetState(-1, $GUI_CHECKED)
$SciFi = GUICtrlCreateCheckbox("SciFi", 56, 264, 97, 17)
;GUICtrlSetState(-1, $GUI_CHECKED)
$Thriller = GUICtrlCreateCheckbox("Thriller", 56, 288, 97, 17)
;GUICtrlSetState(-1, $GUI_CHECKED)
$Western = GUICtrlCreateCheckbox("Western", 56, 312, 97, 17)
;GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Coolstream = GUICtrlCreateGroup("Coolstream", 272, 96, 305, 177)
$Label2 = GUICtrlCreateLabel("IP-Adresse:", 296, 128, 58, 17)
$Label3 = GUICtrlCreateLabel("Benutzer", 304, 160, 46, 17)
$IPAddress1 = _GUICtrlIpAddress_Create($Form1_1, 400, 128, 130, 21)
_GUICtrlIpAddress_Set($IPAddress1, "192.168.178.222")
$Benutzer = GUICtrlCreateInput("root", 400, 160, 121, 21)
$Label4 = GUICtrlCreateLabel("Passwort", 304, 192, 47, 17)
$Passwort = GUICtrlCreateInput("coolstream", 400, 192, 121, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Installieren = GUICtrlCreateButton("Installieren", 728, 352, 131, 41)
$Timecontrol = GUICtrlCreateGroup("Timecontrol", 608, 104, 249, 201)
$Startzeit = GUICtrlCreateGroup("Startzeit", 640, 160, 185, 57)
$StartStunde = GUICtrlCreateCombo("Stunde", 656, 184, 65, 25)
GUICtrlSetData(-1, "00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23")
$StartMinute = GUICtrlCreateCombo("Minute", 736, 184, 65, 25)
GUICtrlSetData(-1, "00|05|10|15|20|25|30|35|40|45|50|55")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Endzeit = GUICtrlCreateGroup("Endzeit", 640, 232, 185, 65)
$EndStunde = GUICtrlCreateCombo("Stunde", 656, 259, 65, 25)
GUICtrlSetData(-1, "00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23")
$EndMinute = GUICtrlCreateCombo("Minute", 737, 259, 65, 25)
GUICtrlSetData(-1, "00|05|10|15|20|25|30|35|40|45|50|55")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$aktivieren = GUICtrlCreateCheckbox("aktivieren", 640, 128, 177, 17)
GUICtrlSetTip(-1, "Timecontrol bestimmt, zu welchen Zeiten NICHT augenommen werden darf")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###




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

Func _install()
	Run(@WorkingDir & "/update.bat", @WorkingDir)
EndFunc   ;==>_install


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
					MsgBox(0, "sel", "sam")
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





