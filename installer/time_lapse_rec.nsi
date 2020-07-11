# This installs two files, app.exe and logo.ico, creates a start menu shortcut, builds an uninstaller, and
# adds uninstall information to the registry for Add/Remove Programs
 
# To get started, put this script into a folder with the two files (app.exe, logo.ico, and license.rtf -
# You'll have to create these yourself) and run makensis on it
 
# If you change the names "app.exe", "logo.ico", or "license.rtf" you should do a search and replace - they
# show up in a few places.
# All the other settings can be tweaked by editing the !defines at the top of this script
!define APPNAME "Monitor dimmer"
!define COMPANYNAME "Gavitka Software"
!define DESCRIPTION "Small utility used to dim inactive monitor."

!define APPNAMELC "monitor_dimmer"
!define BUILDDIR "..\build1\"

# These three must be integers
!define VERSIONMAJOR 1
!define VERSIONMINOR 0
!define VERSIONBUILD 0
# These will be displayed by the "Click here for support information" link in "Add/Remove Programs"
# It is possible to use "mailto:" links in here to open the email client
!define HELPURL "http://..." # "Support Information" link
!define UPDATEURL "http://..." # "Product Updates" link
!define ABOUTURL "http://..." # "Publisher" link
# This is the size (in kB) of all the files copied into "Program Files"
# to update
!define INSTALLSIZE 149352
 
RequestExecutionLevel admin ;Require admin rights on NT6+ (When UAC is turned on)
 
InstallDir "$PROGRAMFILES64\${COMPANYNAME}\${APPNAME}"
 
# rtf or txt file - remember if it is txt, it must be in the DOS text format (\r\n)
LicenseData "license.rtf"
# This will be in the installer/uninstaller's title bar
Name "${APPNAME}"
Icon "../images/monitor_dimmer_icon.ico"
outFile "${APPNAME}.win-x64.exe"
 
!include LogicLib.nsh
!include "x64.nsh"
 
# Just three pages - license agreement, install location, and installation
page license
page directory
Page instfiles
 
!macro VerifyUserIsAdmin
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
        messageBox mb_iconstop "Administrator rights required!"
        setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
        quit
${EndIf}
!macroend
 
function .onInit
	setShellVarContext all
	!insertmacro VerifyUserIsAdmin
functionEnd
 
section "install"

	SetRegView 64

	# Files for the install directory - to build the installer, these should be in the same directory as the install script (this file)
	setOutPath $INSTDIR
	# Files added here should be removed by the uninstaller (see section "uninstall")
	# file "app.exe"
	# file "logo.ico"
	
	# Executable

	File "${BUILDDIR}monitor_dimmer.exe"

	# Dll's

	File "${BUILDDIR}*.dll"

	# QML stuff
	setOutPath $INSTDIR\bearer
	File /nonfatal /r "${BUILDDIR}bearer\"

	setOutPath $INSTDIR\iconengines
	File /nonfatal /r "${BUILDDIR}iconengines\"

	setOutPath $INSTDIR\imageformats
	File /nonfatal /r "${BUILDDIR}imageformats\"

	setOutPath $INSTDIR\platforms
	File /nonfatal /r "${BUILDDIR}platforms\"

	setOutPath $INSTDIR\qmltooling
	File /nonfatal /r "${BUILDDIR}qmltooling\"

	setOutPath $INSTDIR\Qt
	File /nonfatal /r "${BUILDDIR}Qt\"

	setOutPath $INSTDIR\QtGraphicalEffects
	File /nonfatal /r "${BUILDDIR}QtGraphicalEffects\"

	setOutPath $INSTDIR\QtQuick
	File /nonfatal /r "${BUILDDIR}QtQuick\"

	setOutPath $INSTDIR\QtQuick.2
	File /nonfatal /r "${BUILDDIR}QtQuick.2\"

	setOutPath $INSTDIR\scenegraph
	File /nonfatal /r "${BUILDDIR}scenegraph\"

	setOutPath $INSTDIR\styles
	File /nonfatal /r "${BUILDDIR}styles\"

	setOutPath $INSTDIR\translations
	File /nonfatal /r "${BUILDDIR}translations\"

	# Add any other files for the install directory (license files, app data, etc) here
 
	ExecWait "$INSTDIR\vcredist_x64.exe /q /norestart"
 
	# Uninstaller - See function un.onInit and section "uninstall" for configuration
	writeUninstaller "$INSTDIR\uninstall.exe"
 
 	# Start Menu
	createDirectory "$SMPROGRAMS\${COMPANYNAME}"
	createShortCut "$SMPROGRAMS\${COMPANYNAME}\${APPNAME}.lnk" "$INSTDIR\monitor_dimmer.exe" "" "$INSTDIR\logo.ico"
 
	# Registry information for add/remove programs
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayIcon" "$\"$INSTDIR\logo.ico$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "Publisher" "$\"${COMPANYNAME}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "HelpLink" "$\"${HELPURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "URLUpdateInfo" "$\"${UPDATEURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "URLInfoAbout" "$\"${ABOUTURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayVersion" "$\"${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}$\""
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMinor" ${VERSIONMINOR}
	# There is no option for modifying or repairing the install
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoRepair" 1
	# Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "EstimatedSize" ${INSTALLSIZE}

sectionEnd
 
# Uninstaller
 
function un.onInit
	SetShellVarContext all
 
	#Verify the uninstaller - last chance to back out
	MessageBox MB_OKCANCEL "Permanantly remove ${APPNAME}?" IDOK next
		Abort
	next:
	!insertmacro VerifyUserIsAdmin
functionEnd
 
section "uninstall"
 
	# Remove Start Menu launcher
	delete "$SMPROGRAMS\${COMPANYNAME}\${APPNAME}.lnk"
 
	# Remove files

	rmDir /r $INSTDIR\bearer
	rmDir /r $INSTDIR\iconengines
	rmDir /r $INSTDIR\imageformats
	rmDir /r $INSTDIR\platforms
	rmDir /r $INSTDIR\qmltooling
	rmDir /r $INSTDIR\Qt
	rmDir /r $INSTDIR\QtGraphicalEffects
	rmDir /r $INSTDIR\QtQuick
	rmDir /r $INSTDIR\QtQuick.2
	rmDir /r $INSTDIR\scenegraph
	rmDir /r $INSTDIR\styles
	rmDir /r $INSTDIR\translations
	
	delete $INSTDIR\*
 
	# Always delete uninstaller as the last action
	delete $INSTDIR\uninstall.exe
 
	# Try to remove the install directory - this will only happen if it is empty

	rmDir /r $INSTDIR

	# Try to remove the Start Menu folder - this will only happen if it is empty
	rmDir "$PROGRAMFILES64\${COMPANYNAME}"
 
	# Remove uninstaller information from the registry
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"

sectionEnd