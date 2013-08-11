; 폴더 설정

!define BASE_F '.' 
!define NSIS_F '${BASE_F}\Base'
!define DOCS_F '${BASE_F}\Documentation'
!define STUB_F '${BASE_F}\Stubs'

;NSIS Setup Script
;--------------------------------

!ifdef VER_MAJOR & VER_MINOR
  !define /ifndef VER_REVISION 0
  !define /ifndef VER_BUILD 0
!endif

!ifndef VERSION
  !define VERSION 'DevTester-build'
!endif

;--------------------------------
;Configuration

!ifdef OUTFILE
  OutFile "${OUTFILE}"
!else
  OutFile nsis-${VERSION}-setup.exe
!endif
  

Unicode true
SetCompressor /SOLID lzma

InstType "Full"
InstType "Lite"
InstType "Minimal"

InstallDir $PROGRAMFILES\NSIS
InstallDirRegKey HKLM Software\NSIS ""

RequestExecutionLevel admin

;--------------------------------
;Header Files

!include "MUI2.nsh"
!include "Sections.nsh"
!include "LogicLib.nsh"
!include "Memento.nsh"
!include "WordFunc.nsh"

;--------------------------------
;Definitions

!define SHCNE_ASSOCCHANGED 0x8000000
!define SHCNF_IDLIST 0

;--------------------------------
;Configuration

;Names
Name "NSIS"
Caption "NSIS ${VERSION} Setup"

;Memento Settings
!define MEMENTO_REGISTRY_ROOT HKLM
!define MEMENTO_REGISTRY_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSIS"

;Interface Settings
!define MUI_ABORTWARNING

!define MUI_HEADERIMAGE
!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\nsis.bmp"

!define MUI_COMPONENTSPAGE_SMALLDESC

;Pages
!define MUI_WELCOMEPAGE_TITLE "Welcome to the NSIS ${VERSION} Setup Wizard"
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of NSIS (Nullsoft Scriptable Install System) ${VERSION}, the next generation of the Windows installer and uninstaller system that doesn't suck and isn't huge.$\r$\n$\r$\nNSIS 2 includes a new Modern User Interface, LZMA compression, support for multiple languages and an easy plug-in system.$\r$\n$\r$\n$_CLICK"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "Base\COPYING"
!ifdef VER_MAJOR & VER_MINOR & VER_REVISION & VER_BUILD
Page custom PageReinstall PageLeaveReinstall
!endif
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_LINK "Visit the NSIS site for the latest news, FAQs and support"
!define MUI_FINISHPAGE_LINK_LOCATION "http://nsis.sf.net/"

!define MUI_FINISHPAGE_RUN "$INSTDIR\NSIS.exe"
!define MUI_FINISHPAGE_NOREBOOTSUPPORT

!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Show release notes"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION ShowReleaseNotes

!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Korean"

;--------------------------------
;Version information
!ifdef VER_MAJOR & VER_MINOR & VER_REVISION & VER_BUILD
VIProductVersion ${VER_MAJOR}.${VER_MINOR}.${VER_REVISION}.${VER_BUILD}
VIAddVersionKey "FileVersion" "${VERSION}"
VIAddVersionKey "FileDescription" "NSIS Setup"
VIAddVersionKey "LegalCopyright" "http://nsis.sf.net/License"
!endif

;--------------------------------
;Installer Sections

!macro InstallPlugin pi
  File "/oname=$InstDir\Plugins\x86-ansi\${pi}.dll" '${NSIS_F}\Plugins\x86-ansi\${pi}.dll'
  File "/oname=$InstDir\Plugins\x86-unicode\${pi}.dll" '${NSIS_F}\Plugins\x86-unicode\${pi}.dll'
!macroend

!macro InstallStub type stub
    File ${STUB_F}\${type}\stubs\${stub}-x86-ansi
    File ${STUB_F}\${type}\stubs\${stub}-x86-unicode
!macroend

SectionGroup /e 'NSIS 핵심 파일 (필수)' SecCoreGrp
${MementoUnselectedSection} "Normal Stub" SecNormal
    SetOutPath $INSTDIR
    File ${STUB_F}\Normal\makensis.exe

    SetOutPath $INSTDIR\Bin
    File ${STUB_F}\Normal\Bin\makensis.exe
    
    !ifdef USE_NEW_ZLIB
        File ${STUB_F}\Normal\Bin\zlib.dll
    !else
        File ${STUB_F}\Normal\Bin\zlib1.dll
    !endif

    SetOutPath $INSTDIR\Stubs
    File ${STUB_F}\Normal\Stubs\uninst
    !insertmacro InstallStub Normal bzip2
    !insertmacro InstallStub Normal bzip2_solid
    !insertmacro InstallStub Normal lzma
    !insertmacro InstallStub Normal lzma_solid
    !insertmacro InstallStub Normal zlib
    !insertmacro InstallStub Normal zlib_solid
${MementoSectionEnd}

${MementoSection} "Advanced Log Stub" SecAdvLog
    SetOutPath $INSTDIR
    File ${STUB_F}\Advanced-Log\makensis.exe

    SetOutPath $INSTDIR\Bin
    File ${STUB_F}\Advanced-Log\Bin\makensis.exe
    
    !ifdef USE_NEW_ZLIB
        File ${STUB_F}\Advanced-Log\Bin\zlib.dll
    !else
        File ${STUB_F}\Advanced-Log\Bin\zlib1.dll
    !endif

    SetOutPath $INSTDIR\Stubs
    File ${STUB_F}\Advanced-Log\Stubs\uninst
    !insertmacro InstallStub Advanced-Log bzip2
    !insertmacro InstallStub Advanced-Log bzip2_solid
    !insertmacro InstallStub Advanced-Log lzma
    !insertmacro InstallStub Advanced-Log lzma_solid
    !insertmacro InstallStub Advanced-Log zlib
    !insertmacro InstallStub Advanced-Log zlib_solid
${MementoSectionEnd}

${MementoUnselectedSection} "String Length 8192 Stub" SecStrMAX
    SetOutPath $INSTDIR
    File ${STUB_F}\StrLength8192\makensis.exe

    SetOutPath $INSTDIR\Bin
    File ${STUB_F}\StrLength8192\Bin\makensis.exe
    
    !ifdef USE_NEW_ZLIB
        File ${STUB_F}\StrLength8192\Bin\zlib.dll
    !else
        File ${STUB_F}\StrLength8192\Bin\zlib1.dll
    !endif

    SetOutPath $INSTDIR\Stubs
    File ${STUB_F}\StrLength8192\Stubs\uninst
    !insertmacro InstallStub StrLength8192 bzip2
    !insertmacro InstallStub StrLength8192 bzip2_solid
    !insertmacro InstallStub StrLength8192 lzma
    !insertmacro InstallStub StrLength8192 lzma_solid
    !insertmacro InstallStub StrLength8192 zlib
    !insertmacro InstallStub StrLength8192 zlib_solid
${MementoSectionEnd}

${MementoSection} "NSIS Core Files (required)" SecCore

  SetDetailsPrint textonly
  DetailPrint "Installing NSIS Core Files..."
  SetDetailsPrint listonly

  SectionIn 1 2 3 RO
  SetOutPath $INSTDIR
  RMDir /r $SMPROGRAMS\NSIS

  IfFileExists $INSTDIR\nsisconf.nsi "" +2
  Rename $INSTDIR\nsisconf.nsi $INSTDIR\nsisconf.nsh
  SetOverwrite off
  File ${NSIS_F}\nsisconf.nsh

  SetOverwrite on
  File ${NSIS_F}\makensisw.exe
  File ${NSIS_F}\COPYING
  File ${DOCS_F}\NSIS.chm
  File ${NSIS_F}\NSIS.exe
  File /nonfatal ${NSIS_F}\NSIS.exe.manifest

  SetOutPath $INSTDIR\Include
  File ${NSIS_F}\Include\WinMessages.nsh
  File ${NSIS_F}\Include\Sections.nsh
  File ${NSIS_F}\Include\Library.nsh
  File ${NSIS_F}\Include\UpgradeDLL.nsh
  File ${NSIS_F}\Include\LogicLib.nsh
  File ${NSIS_F}\Include\StrFunc.nsh
  File ${NSIS_F}\Include\Colors.nsh
  File ${NSIS_F}\Include\FileFunc.nsh
  File ${NSIS_F}\Include\TextFunc.nsh
  File ${NSIS_F}\Include\WordFunc.nsh
  File ${NSIS_F}\Include\WinVer.nsh
  File ${NSIS_F}\Include\x64.nsh
  File ${NSIS_F}\Include\Memento.nsh
  File ${NSIS_F}\Include\LangFile.nsh
  File ${NSIS_F}\Include\InstallOptions.nsh
  File ${NSIS_F}\Include\MultiUser.nsh
  File ${NSIS_F}\Include\VB6RunTime.nsh
  File ${NSIS_F}\Include\Util.nsh
  File ${NSIS_F}\Include\WinCore.nsh

  SetOutPath $INSTDIR\Include\Win
  File ${NSIS_F}\Include\Win\WinDef.nsh
  File ${NSIS_F}\Include\Win\WinError.nsh
  File ${NSIS_F}\Include\Win\WinNT.nsh
  File ${NSIS_F}\Include\Win\WinUser.nsh
  File ${NSIS_F}\Include\Win\COM.nsh
  File ${NSIS_F}\Include\Win\Propkey.nsh

  SetOutPath $INSTDIR\Docs\StrFunc
  File ${NSIS_F}\Docs\StrFunc\StrFunc.txt

  SetOutPath $INSTDIR\Docs\MultiUser
  File ${NSIS_F}\Docs\MultiUser\Readme.html

  SetOutPath $INSTDIR\Docs\makensisw
  File ${NSIS_F}\Docs\makensisw\*.txt

  SetOutPath $INSTDIR\Menu
  File ${NSIS_F}\Menu\*.html
  SetOutPath $INSTDIR\Menu\images
  File ${NSIS_F}\Menu\images\header.gif
  File ${NSIS_F}\Menu\images\line.gif
  File ${NSIS_F}\Menu\images\site.gif

  Delete $INSTDIR\makensis.htm
  Delete $INSTDIR\Docs\*.html
  Delete $INSTDIR\Docs\style.css
  RMDir $INSTDIR\Docs

  SetOutPath $INSTDIR\Bin
  File ${NSIS_F}\Bin\LibraryLocal.exe
  File ${NSIS_F}\Bin\RegTool.bin

  CreateDirectory $INSTDIR\Plugins\x86-ansi
  CreateDirectory $INSTDIR\Plugins\x86-unicode
  !insertmacro InstallPlugin TypeLib

  ReadRegStr $R0 HKCR ".nsi" ""
  StrCmp $R0 "NSISFile" 0 +2
    DeleteRegKey HKCR "NSISFile"

  WriteRegStr HKCR ".nsi" "" "NSIS.Script"
  WriteRegStr HKCR "NSIS.Script" "" "NSIS Script File"
  WriteRegStr HKCR "NSIS.Script\DefaultIcon" "" "$INSTDIR\makensisw.exe,1"
  ReadRegStr $R0 HKCR "NSIS.Script\shell\open\command" ""
  StrCmp $R0 "" 0 no_nsiopen
    WriteRegStr HKCR "NSIS.Script\shell" "" "open"
    WriteRegStr HKCR "NSIS.Script\shell\open\command" "" 'notepad.exe "%1"'
  no_nsiopen:
  WriteRegStr HKCR "NSIS.Script\shell\compile" "" "Compile NSIS Script"
  WriteRegStr HKCR "NSIS.Script\shell\compile\command" "" '"$INSTDIR\makensisw.exe" "%1"'
  WriteRegStr HKCR "NSIS.Script\shell\compile-compressor" "" "Compile NSIS Script (Choose Compressor)"
  WriteRegStr HKCR "NSIS.Script\shell\compile-compressor\command" "" '"$INSTDIR\makensisw.exe" /ChooseCompressor "%1"'

  ReadRegStr $R0 HKCR ".nsh" ""
  StrCmp $R0 "NSHFile" 0 +2
    DeleteRegKey HKCR "NSHFile"

  WriteRegStr HKCR ".nsh" "" "NSIS.Header"
  WriteRegStr HKCR "NSIS.Header" "" "NSIS Header File"
  WriteRegStr HKCR "NSIS.Header\DefaultIcon" "" "$INSTDIR\makensisw.exe,1"
  ReadRegStr $R0 HKCR "NSIS.Header\shell\open\command" ""
  StrCmp $R0 "" 0 no_nshopen
    WriteRegStr HKCR "NSIS.Header\shell" "" "open"
    WriteRegStr HKCR "NSIS.Header\shell\open\command" "" 'notepad.exe "%1"'
  no_nshopen:

  System::Call 'Shell32::SHChangeNotify(i ${SHCNE_ASSOCCHANGED}, i ${SHCNF_IDLIST}, i 0, i 0)'

${MementoSectionEnd}
SectionGroupEnd

${MementoSection} "Script Examples" SecExample

  SetDetailsPrint textonly
  DetailPrint "Installing Script Examples..."
  SetDetailsPrint listonly

  SectionIn 1 2
  SetOutPath $INSTDIR\Examples
  File ${NSIS_F}\Examples\makensis.nsi
  File ${NSIS_F}\Examples\example1.nsi
  File ${NSIS_F}\Examples\example2.nsi
  File ${NSIS_F}\Examples\viewhtml.nsi
  File ${NSIS_F}\Examples\waplugin.nsi
  File ${NSIS_F}\Examples\bigtest.nsi
  File ${NSIS_F}\Examples\primes.nsi
  File ${NSIS_F}\Examples\rtest.nsi
  File ${NSIS_F}\Examples\gfx.nsi
  File ${NSIS_F}\Examples\one-section.nsi
  File ${NSIS_F}\Examples\languages.nsi
  File ${NSIS_F}\Examples\Library.nsi
  File ${NSIS_F}\Examples\VersionInfo.nsi
  File ${NSIS_F}\Examples\UserVars.nsi
  File ${NSIS_F}\Examples\LogicLib.nsi
  File ${NSIS_F}\Examples\silent.nsi
  File ${NSIS_F}\Examples\StrFunc.nsi
  File ${NSIS_F}\Examples\FileFunc.nsi
  File ${NSIS_F}\Examples\FileFunc.ini
  File ${NSIS_F}\Examples\FileFuncTest.nsi
  File ${NSIS_F}\Examples\TextFunc.nsi
  File ${NSIS_F}\Examples\TextFunc.ini
  File ${NSIS_F}\Examples\TextFuncTest.nsi
  File ${NSIS_F}\Examples\WordFunc.nsi
  File ${NSIS_F}\Examples\WordFunc.ini
  File ${NSIS_F}\Examples\WordFuncTest.nsi
  File ${NSIS_F}\Examples\Memento.nsi
  File ${NSIS_F}\Examples\unicode.nsi

  SetOutPath $INSTDIR\Examples\Plugin
  File ${NSIS_F}\Examples\Plugin\exdll.c
  File ${NSIS_F}\Examples\Plugin\exdll.dpr
  File ${NSIS_F}\Examples\Plugin\exdll.dsp
  File ${NSIS_F}\Examples\Plugin\exdll.dsw
  File ${NSIS_F}\Examples\Plugin\exdll_with_unit.dpr
  File ${NSIS_F}\Examples\Plugin\exdll-vs2008.sln
  File ${NSIS_F}\Examples\Plugin\exdll-vs2008.vcproj
  File ${NSIS_F}\Examples\Plugin\extdll.inc
  File ${NSIS_F}\Examples\Plugin\nsis.pas

  SetOutPath $INSTDIR\Examples\Plugin\nsis
  File ${NSIS_F}\Examples\Plugin\nsis\pluginapi.h
  File /nonfatal ${NSIS_F}\Examples\Plugin\nsis\pluginapi*.lib
  File ${NSIS_F}\Examples\Plugin\nsis\api.h
  File ${NSIS_F}\Examples\Plugin\nsis\nsis_tchar.h

${MementoSectionEnd}

!ifndef NO_STARTMENUSHORTCUTS
${MementoSection} "Start Menu and Desktop Shortcuts" SecShortcuts

  SetDetailsPrint textonly
  DetailPrint "Installing Start Menu and Desktop Shortcuts..."
  SetDetailsPrint listonly

!else
${MementoSection} "Desktop Shortcut" SecShortcuts

  SetDetailsPrint textonly
  DetailPrint "Installing Desktop Shortcut..."
  SetDetailsPrint listonly

!endif
  SectionIn 1 2
  SetOutPath $INSTDIR
!ifndef NO_STARTMENUSHORTCUTS
  CreateShortCut "$SMPROGRAMS\NSIS.lnk" "$INSTDIR\NSIS.exe"
!endif

  CreateShortCut "$DESKTOP\NSIS.lnk" "$INSTDIR\NSIS.exe"

${MementoSectionEnd}

SectionGroup "User Interfaces" SecInterfaces

${MementoSection} "Modern User Interface" SecInterfacesModernUI

  SetDetailsPrint textonly
  DetailPrint "Installing User Interfaces | Modern User Interface..."
  SetDetailsPrint listonly

  SectionIn 1 2

  SetOutPath "$INSTDIR\Examples\Modern UI"
  File "${NSIS_F}\Examples\Modern UI\Basic.nsi"
  File "${NSIS_F}\Examples\Modern UI\HeaderBitmap.nsi"
  File "${NSIS_F}\Examples\Modern UI\MultiLanguage.nsi"
  File "${NSIS_F}\Examples\Modern UI\StartMenu.nsi"
  File "${NSIS_F}\Examples\Modern UI\WelcomeFinish.nsi"

  SetOutPath "$INSTDIR\Contrib\Modern UI"
  File "${NSIS_F}\Contrib\Modern UI\System.nsh"
  File "${NSIS_F}\Contrib\Modern UI\ioSpecial.ini"

  SetOutPath "$INSTDIR\Docs\Modern UI"
  File "${NSIS_F}\Docs\Modern UI\Readme.html"
  File "${NSIS_F}\Docs\Modern UI\Changelog.txt"
  File "${NSIS_F}\Docs\Modern UI\License.txt"

  SetOutPath "$INSTDIR\Docs\Modern UI\images"
  File "${NSIS_F}\Docs\Modern UI\images\header.gif"
  File "${NSIS_F}\Docs\Modern UI\images\screen1.png"
  File "${NSIS_F}\Docs\Modern UI\images\screen2.png"
  File "${NSIS_F}\Docs\Modern UI\images\open.gif"
  File "${NSIS_F}\Docs\Modern UI\images\closed.gif"

  SetOutPath $INSTDIR\Contrib\UIs
  File "${NSIS_F}\Contrib\UIs\modern.exe"
  File "${NSIS_F}\Contrib\UIs\modern_headerbmp.exe"
  File "${NSIS_F}\Contrib\UIs\modern_headerbmpr.exe"
  File "${NSIS_F}\Contrib\UIs\modern_nodesc.exe"
  File "${NSIS_F}\Contrib\UIs\modern_smalldesc.exe"

  SetOutPath $INSTDIR\Include
  File "${NSIS_F}\Include\MUI.nsh"

  SetOutPath "$INSTDIR\Contrib\Modern UI 2"
  File "${NSIS_F}\Contrib\Modern UI 2\Deprecated.nsh"
  File "${NSIS_F}\Contrib\Modern UI 2\Interface.nsh"
  File "${NSIS_F}\Contrib\Modern UI 2\Localization.nsh"
  File "${NSIS_F}\Contrib\Modern UI 2\MUI2.nsh"
  File "${NSIS_F}\Contrib\Modern UI 2\Pages.nsh"

  SetOutPath "$INSTDIR\Contrib\Modern UI 2\Pages"
  File "${NSIS_F}\Contrib\Modern UI 2\Pages\Components.nsh"
  File "${NSIS_F}\Contrib\Modern UI 2\Pages\Directory.nsh"
  File "${NSIS_F}\Contrib\Modern UI 2\Pages\Finish.nsh"
  File "${NSIS_F}\Contrib\Modern UI 2\Pages\InstallFiles.nsh"
  File "${NSIS_F}\Contrib\Modern UI 2\Pages\License.nsh"
  File "${NSIS_F}\Contrib\Modern UI 2\Pages\StartMenu.nsh"
  File "${NSIS_F}\Contrib\Modern UI 2\Pages\UninstallConfirm.nsh"
  File "${NSIS_F}\Contrib\Modern UI 2\Pages\Welcome.nsh"

  SetOutPath "$INSTDIR\Docs\Modern UI 2"
  File "${NSIS_F}\Docs\Modern UI 2\Readme.html"
  File "${NSIS_F}\Docs\Modern UI 2\License.txt"

  SetOutPath "$INSTDIR\Docs\Modern UI 2\images"
  File "${NSIS_F}\Docs\Modern UI 2\images\header.gif"
  File "${NSIS_F}\Docs\Modern UI 2\images\screen1.png"
  File "${NSIS_F}\Docs\Modern UI 2\images\screen2.png"
  File "${NSIS_F}\Docs\Modern UI 2\images\open.gif"
  File "${NSIS_F}\Docs\Modern UI 2\images\closed.gif"

  SetOutPath $INSTDIR\Include
  File "${NSIS_F}\Include\MUI2.nsh"

${MementoSectionEnd}

${MementoSection} "Default User Interface" SecInterfacesDefaultUI

  SetDetailsPrint textonly
  DetailPrint "Installing User Interfaces | Default User Interface..."
  SetDetailsPrint listonly

  SectionIn 1

  SetOutPath "$INSTDIR\Contrib\UIs"
  File "${NSIS_F}\Contrib\UIs\default.exe"

${MementoSectionEnd}

${MementoSection} "Tiny User Interface" SecInterfacesTinyUI

  SetDetailsPrint textonly
  DetailPrint "Installing User Interfaces | Tiny User Interface..."
  SetDetailsPrint listonly

  SectionIn 1

  SetOutPath "$INSTDIR\Contrib\UIs"
  File "${NSIS_F}\Contrib\UIs\sdbarker_tiny.exe"

${MementoSectionEnd}

SectionGroupEnd

${MementoSection} "Graphics" SecGraphics

  SetDetailsPrint textonly
  DetailPrint "Installing Graphics..."
  SetDetailsPrint listonly

  SectionIn 1

  Delete $INSTDIR\Contrib\Icons\*.ico
  Delete $INSTDIR\Contrib\Icons\*.bmp
  RMDir $INSTDIR\Contrib\Icons
  SetOutPath $INSTDIR\Contrib\Graphics
  File /r "${NSIS_F}\Contrib\Graphics\*.ico"
  File /r "${NSIS_F}\Contrib\Graphics\*.bmp"
${MementoSectionEnd}

${MementoSection} "Language Files" SecLangFiles

  SetDetailsPrint textonly
  DetailPrint "Installing Language Files..."
  SetDetailsPrint listonly

  SectionIn 1

  SetOutPath "$INSTDIR\Contrib\Language files"
  File "${NSIS_F}\Contrib\Language files\*.nlf"

  SetOutPath $INSTDIR\Bin
  File ${NSIS_F}\Bin\MakeLangID.exe

  !insertmacro SectionFlagIsSet ${SecInterfacesModernUI} ${SF_SELECTED} mui nomui
  mui:
    SetOutPath "$INSTDIR\Contrib\Language files"
    File "${NSIS_F}\Contrib\Language files\*.nsh"
  nomui:

${MementoSectionEnd}

SectionGroup "Tools" SecTools

${MementoSection} "Zip2Exe" SecToolsZ2E

  SetDetailsPrint textonly
  DetailPrint "Installing Tools | Zip2Exe..."
  SetDetailsPrint listonly

  SectionIn 1

  SetOutPath $INSTDIR\Bin
  File ${NSIS_F}\Bin\zip2exe.exe
  SetOutPath $INSTDIR\Contrib\zip2exe
  File ${NSIS_F}\Contrib\zip2exe\Base.nsh
  File ${NSIS_F}\Contrib\zip2exe\Modern.nsh
  File ${NSIS_F}\Contrib\zip2exe\Classic.nsh

${MementoSectionEnd}

SectionGroupEnd

SectionGroup "Plug-ins" SecPluginsPlugins

${MementoSection} "Banner" SecPluginsBanner

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | Banner..."
  SetDetailsPrint listonly

  SectionIn 1

  !insertmacro InstallPlugin Banner
  SetOutPath $INSTDIR\Docs\Banner
  File ${NSIS_F}\Docs\Banner\Readme.txt
  SetOutPath $INSTDIR\Examples\Banner
  File ${NSIS_F}\Examples\Banner\Example.nsi
${MementoSectionEnd}

${MementoSection} "Language DLL" SecPluginsLangDLL

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | Language DLL..."
  SetDetailsPrint listonly

  SectionIn 1
  !insertmacro InstallPlugin LangDLL
${MementoSectionEnd}

${MementoSection} "nsExec" SecPluginsnsExec

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | nsExec..."
  SetDetailsPrint listonly

  SectionIn 1

  !insertmacro InstallPlugin nsExec
  SetOutPath $INSTDIR\Docs\nsExec
  File ${NSIS_F}\Docs\nsExec\nsExec.txt
  SetOutPath $INSTDIR\Examples\nsExec
  File ${NSIS_F}\Examples\nsExec\test.nsi
${MementoSectionEnd}

${MementoSection} "Splash" SecPluginsSplash

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | Splash..."
  SetDetailsPrint listonly

  SectionIn 1

  !insertmacro InstallPlugin splash
  SetOutPath $INSTDIR\Docs\Splash
  File ${NSIS_F}\Docs\Splash\splash.txt
  SetOutPath $INSTDIR\Examples\Splash
  File ${NSIS_F}\Examples\Splash\Example.nsi
${MementoSectionEnd}

${MementoSection} "AdvSplash" SecPluginsSplashT

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | AdvSplash..."
  SetDetailsPrint listonly

  SectionIn 1

  !insertmacro InstallPlugin advsplash
  SetOutPath $INSTDIR\Docs\AdvSplash
  File ${NSIS_F}\Docs\AdvSplash\advsplash.txt
  SetOutPath $INSTDIR\Examples\AdvSplash
  File ${NSIS_F}\Examples\AdvSplash\Example.nsi
${MementoSectionEnd}

${MementoSection} "BgImage" SecPluginsBgImage

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | BgImage..."
  SetDetailsPrint listonly

  SectionIn 1

  !insertmacro InstallPlugin BgImage
  SetOutPath $INSTDIR\Docs\BgImage
  File ${NSIS_F}\Docs\BgImage\BgImage.txt
  SetOutPath $INSTDIR\Examples\BgImage
  File ${NSIS_F}\Examples\BgImage\Example.nsi
${MementoSectionEnd}

${MementoSection} "InstallOptions" SecPluginsIO

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | InstallOptions..."
  SetDetailsPrint listonly

  SectionIn 1

  !insertmacro InstallPlugin InstallOptions
  SetOutPath $INSTDIR\Docs\InstallOptions
  File ${NSIS_F}\Docs\InstallOptions\Readme.html
  File ${NSIS_F}\Docs\InstallOptions\Changelog.txt
  SetOutPath $INSTDIR\Examples\InstallOptions
  File ${NSIS_F}\Examples\InstallOptions\test.ini
  File ${NSIS_F}\Examples\InstallOptions\test.nsi
  File ${NSIS_F}\Examples\InstallOptions\testimgs.ini
  File ${NSIS_F}\Examples\InstallOptions\testimgs.nsi
  File ${NSIS_F}\Examples\InstallOptions\testlink.ini
  File ${NSIS_F}\Examples\InstallOptions\testlink.nsi
  File ${NSIS_F}\Examples\InstallOptions\testnotify.ini
  File ${NSIS_F}\Examples\InstallOptions\testnotify.nsi
${MementoSectionEnd}

${MementoSection} "nsDialogs" SecPluginsDialogs

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | nsDialogs..."
  SetDetailsPrint listonly

  SectionIn 1

  !insertmacro InstallPlugin nsDialogs
  SetOutPath $INSTDIR\Examples\nsDialogs
  File ${NSIS_F}\Examples\nsDialogs\example.nsi
  File ${NSIS_F}\Examples\nsDialogs\InstallOptions.nsi
  File ${NSIS_F}\Examples\nsDialogs\timer.nsi
  File ${NSIS_F}\Examples\nsDialogs\welcome.nsi
  SetOutPath $INSTDIR\Include
  File ${NSIS_F}\Include\nsDialogs.nsh
  SetOutPath $INSTDIR\Docs\nsDialogs
  File ${NSIS_F}\Docs\nsDialogs\Readme.html
${MementoSectionEnd}

${MementoSection} "Math" SecPluginsMath

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | Math..."
  SetDetailsPrint listonly

  SectionIn 1

  !insertmacro InstallPlugin Math
  SetOutPath $INSTDIR\Docs\Math
  File ${NSIS_F}\Docs\Math\Math.txt
  SetOutPath $INSTDIR\Examples\Math
  File ${NSIS_F}\Examples\Math\math.nsi
  File ${NSIS_F}\Examples\Math\mathtest.txt
  File ${NSIS_F}\Examples\Math\mathtest.nsi
  File ${NSIS_F}\Examples\Math\mathtest.ini

${MementoSectionEnd}

${MementoSection} "NSISdl" SecPluginsNSISDL

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | NSISdl..."
  SetDetailsPrint listonly

  SectionIn 1

  !insertmacro InstallPlugin nsisdl
  SetOutPath $INSTDIR\Docs\NSISdl
  File ${NSIS_F}\Docs\NSISdl\ReadMe.txt
  File ${NSIS_F}\Docs\NSISdl\License.txt
${MementoSectionEnd}

${MementoSection} "System" SecPluginsSystem

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | System..."
  SetDetailsPrint listonly

  SectionIn 1

  !insertmacro InstallPlugin System
  SetOutPath $INSTDIR\Docs\System
  File ${NSIS_F}\Docs\System\System.html
  File ${NSIS_F}\Docs\System\WhatsNew.txt
  SetOutPath $INSTDIR\Examples\System
  File ${NSIS_F}\Examples\System\Resource.dll
  File ${NSIS_F}\Examples\System\SysFunc.nsh
  File ${NSIS_F}\Examples\System\System.nsh
  File ${NSIS_F}\Examples\System\System.nsi
${MementoSectionEnd}

${MementoSection} "StartMenu" SecPluginsStartMenu

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | StartMenu..."
  SetDetailsPrint listonly

  SectionIn 1

  !insertmacro InstallPlugin StartMenu
  SetOutPath $INSTDIR\Docs\StartMenu
  File ${NSIS_F}\Docs\StartMenu\Readme.txt
  SetOutPath $INSTDIR\Examples\StartMenu
  File ${NSIS_F}\Examples\StartMenu\Example.nsi
${MementoSectionEnd}

${MementoSection} "UserInfo" SecPluginsUserInfo

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | UserInfo..."
  SetDetailsPrint listonly

  SectionIn 1

  !insertmacro InstallPlugin UserInfo
  SetOutPath $INSTDIR\Examples\UserInfo
  File ${NSIS_F}\Examples\UserInfo\UserInfo.nsi
${MementoSectionEnd}

${MementoSection} "Dialer" SecPluginsDialer

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | Dialer..."
  SetDetailsPrint listonly

  SectionIn 1

  !insertmacro InstallPlugin Dialer
  SetOutPath $INSTDIR\Docs\Dialer
  File ${NSIS_F}\Docs\Dialer\Dialer.txt
${MementoSectionEnd}

${MementoSection} "VPatch" SecPluginsVPatch

  SetDetailsPrint textonly
  DetailPrint "Installing Plug-ins | VPatch..."
  SetDetailsPrint listonly

  SectionIn 1

  !insertmacro InstallPlugin VPatch
  SetOutPath $INSTDIR\Examples\VPatch
  File ${NSIS_F}\Examples\VPatch\example.nsi
  File ${NSIS_F}\Examples\VPatch\oldfile.txt
  File ${NSIS_F}\Examples\VPatch\newfile.txt
  File ${NSIS_F}\Examples\VPatch\patch.pat
  SetOutPath $INSTDIR\Docs\VPatch
  File ${NSIS_F}\Docs\VPatch\Readme.html
  SetOutPath $INSTDIR\Bin
  File ${NSIS_F}\Bin\GenPat.exe
  SetOutPath $INSTDIR\Include
  File ${NSIS_F}\Include\VPatchLib.nsh
${MementoSectionEnd}

${MementoSectionDone}

SectionGroupEnd

Section -post

  ; When Modern UI is installed:
  ; * Always install the English language file
  ; * Always install default icons / bitmaps

  !insertmacro SectionFlagIsSet ${SecInterfacesModernUI} ${SF_SELECTED} mui nomui

    mui:

    SetDetailsPrint textonly
    DetailPrint "Configuring Modern UI..."
    SetDetailsPrint listonly

    !insertmacro SectionFlagIsSet ${SecLangFiles} ${SF_SELECTED} langfiles nolangfiles

      nolangfiles:

      SetOutPath "$INSTDIR\Contrib\Language files"
      File "${NSIS_F}\Contrib\Language files\English.nlf"
      SetOutPath "$INSTDIR\Contrib\Language files"
      File "${NSIS_F}\Contrib\Language files\English.nsh"

    langfiles:

    !insertmacro SectionFlagIsSet ${SecGraphics} ${SF_SELECTED} graphics nographics

      nographics:

      SetOutPath $INSTDIR\Contrib\Graphics
      SetOutPath $INSTDIR\Contrib\Graphics\Checks
      File "${NSIS_F}\Contrib\Graphics\Checks\modern.bmp"
      SetOutPath $INSTDIR\Contrib\Graphics\Icons
      File "${NSIS_F}\Contrib\Graphics\Icons\modern-install.ico"
      File "${NSIS_F}\Contrib\Graphics\Icons\modern-uninstall.ico"
      SetOutPath $INSTDIR\Contrib\Graphics\Header
      File "${NSIS_F}\Contrib\Graphics\Header\nsis.bmp"
      SetOutPath $INSTDIR\Contrib\Graphics\Wizard
      File "${NSIS_F}\Contrib\Graphics\Wizard\win.bmp"

    graphics:

  nomui:

  SetDetailsPrint textonly
  DetailPrint "Creating Registry Keys..."
  SetDetailsPrint listonly

  SetOutPath $INSTDIR

  WriteRegStr HKLM "Software\NSIS" "" $INSTDIR
!ifdef VER_MAJOR & VER_MINOR & VER_REVISION & VER_BUILD
  WriteRegDword HKLM "Software\NSIS" "VersionMajor" "${VER_MAJOR}"
  WriteRegDword HKLM "Software\NSIS" "VersionMinor" "${VER_MINOR}"
  WriteRegDword HKLM "Software\NSIS" "VersionRevision" "${VER_REVISION}"
  WriteRegDword HKLM "Software\NSIS" "VersionBuild" "${VER_BUILD}"
!endif

  WriteRegExpandStr HKLM "${MEMENTO_REGISTRY_KEY}" "UninstallString" '"$INSTDIR\uninst-nsis.exe"'
  WriteRegExpandStr HKLM "${MEMENTO_REGISTRY_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "${MEMENTO_REGISTRY_KEY}" "DisplayName" "Nullsoft Install System"
  WriteRegStr HKLM "${MEMENTO_REGISTRY_KEY}" "DisplayIcon" "$INSTDIR\NSIS.exe,0"
  WriteRegStr HKLM "${MEMENTO_REGISTRY_KEY}" "DisplayVersion" "${VERSION}"
!ifdef VER_MAJOR & VER_MINOR & VER_REVISION & VER_BUILD
  WriteRegDWORD HKLM "${MEMENTO_REGISTRY_KEY}" "VersionMajor" "${VER_MAJOR}"
  WriteRegDWORD HKLM "${MEMENTO_REGISTRY_KEY}" "VersionMinor" "${VER_MINOR}"
!endif
  WriteRegStr HKLM "${MEMENTO_REGISTRY_KEY}" "URLInfoAbout" "http://nsis.sourceforge.net/"
  WriteRegStr HKLM "${MEMENTO_REGISTRY_KEY}" "HelpLink" "http://nsis.sourceforge.net/Support"
  WriteRegDWORD HKLM "${MEMENTO_REGISTRY_KEY}" "NoModify" "1"
  WriteRegDWORD HKLM "${MEMENTO_REGISTRY_KEY}" "NoRepair" "1"

  WriteUninstaller $INSTDIR\uninst-nsis.exe

  ${MementoSectionSave}

  SetDetailsPrint both

SectionEnd

;--------------------------------
;Descriptions

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} "The core files required to use NSIS (compiler etc.)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecExample} "Example installation scripts that show you how to use NSIS"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecShortcuts} "Adds icons to your start menu and your desktop for easy access"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecInterfaces} "User interface designs that can be used to change the installer look and feel"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecInterfacesModernUI} "A modern user interface like the wizards of recent Windows versions"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecInterfacesDefaultUI} "The default NSIS user interface which you can customize to make your own UI"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecInterfacesTinyUI} "A tiny version of the default user interface"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecTools} "Tools that help you with NSIS development"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecToolsZ2E} "A utility that converts a ZIP file to a NSIS installer"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecGraphics} "Icons, checkbox images and other graphics"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecLangFiles} "Language files used to support multiple languages in an installer"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsPlugins} "Useful plugins that extend NSIS's functionality"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsBanner} "Plugin that lets you show a banner before installation starts"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsLangDLL} "Plugin that lets you add a language select dialog to your installer"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsnsExec} "Plugin that executes console programs and prints its output in the NSIS log window or hides it"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsSplash} "Splash screen add-on that lets you add a splash screen to an installer"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsSplashT} "Splash screen add-on with transparency support that lets you add a splash screen to an installer"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsSystem} "Plugin that lets you call Win32 API or external DLLs"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsMath} "Plugin that lets you evaluate complicated mathematical expressions"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsDialer} "Plugin that provides internet connection functions"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsIO} "Plugin that lets you add custom pages to an installer"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsDialogs} "Plugin that lets you add custom pages to an installer"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsStartMenu} "Plugin that lets the user select the start menu folder"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsBgImage} "Plugin that lets you show a persistent background image plugin and play sounds"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsUserInfo} "Plugin that that gives you the user name and the user account type"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsNSISDL} "Plugin that lets you create a web based installer"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPluginsVPatch} "Plugin that lets you create patches to upgrade older files"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Installer Functions

Function .onInit

  ${MementoSectionRestore}

FunctionEnd

!ifdef VER_MAJOR & VER_MINOR & VER_REVISION & VER_BUILD

Var ReinstallPageCheck

Function PageReinstall

  ReadRegStr $R0 HKLM "Software\NSIS" ""
  ReadRegStr $R1 HKLM "${MEMENTO_REGISTRY_KEY}" "UninstallString"
  ${IfThen} "$R0$R1" == "" ${|} Abort ${|}

  StrCpy $R4 "older"
  ReadRegDWORD $R0 HKLM "Software\NSIS" "VersionMajor"
  ReadRegDWORD $R1 HKLM "Software\NSIS" "VersionMinor"
  ReadRegDWORD $R2 HKLM "Software\NSIS" "VersionRevision"
  ReadRegDWORD $R3 HKLM "Software\NSIS" "VersionBuild"
  ${IfThen} $R0 = 0 ${|} StrCpy $R4 "unknown" ${|} ; Anonymous builds have no version number
  StrCpy $R0 $R0.$R1.$R2.$R3

  ${VersionCompare} ${VER_MAJOR}.${VER_MINOR}.${VER_REVISION}.${VER_BUILD} $R0 $R0
  ${If} $R0 == 0
    StrCpy $R1 "NSIS ${VERSION} is already installed. Select the operation you want to perform and click Next to continue."
    StrCpy $R2 "Add/Reinstall components"
    StrCpy $R3 "Uninstall NSIS"
    !insertmacro MUI_HEADER_TEXT "Already Installed" "Choose the maintenance option to perform."
    StrCpy $R0 "2"
  ${ElseIf} $R0 == 1
    StrCpy $R1 "An $R4 version of NSIS is installed on your system. It's recommended that you uninstall the current version before installing. Select the operation you want to perform and click Next to continue."
    StrCpy $R2 "Uninstall before installing"
    StrCpy $R3 "Do not uninstall"
    !insertmacro MUI_HEADER_TEXT "Already Installed" "Choose how you want to install NSIS."
    StrCpy $R0 "1"
  ${ElseIf} $R0 == 2
    StrCpy $R1 "A newer version of NSIS is already installed! It is not recommended that you install an older version. If you really want to install this older version, it's better to uninstall the current version first. Select the operation you want to perform and click Next to continue."
    StrCpy $R2 "Uninstall before installing"
    StrCpy $R3 "Do not uninstall"
    !insertmacro MUI_HEADER_TEXT "Already Installed" "Choose how you want to install NSIS."
    StrCpy $R0 "1"
  ${Else}
    Abort
  ${EndIf}

  nsDialogs::Create 1018
  Pop $R4

  ${NSD_CreateLabel} 0 0 100% 24u $R1
  Pop $R1

  ${NSD_CreateRadioButton} 30u 50u -30u 8u $R2
  Pop $R2
  ${NSD_OnClick} $R2 PageReinstallUpdateSelection

  ${NSD_CreateRadioButton} 30u 70u -30u 8u $R3
  Pop $R3
  ${NSD_OnClick} $R3 PageReinstallUpdateSelection

  ${If} $ReinstallPageCheck != 2
    SendMessage $R2 ${BM_SETCHECK} ${BST_CHECKED} 0
  ${Else}
    SendMessage $R3 ${BM_SETCHECK} ${BST_CHECKED} 0
  ${EndIf}

  ${NSD_SetFocus} $R2

  nsDialogs::Show

FunctionEnd

Function PageReinstallUpdateSelection

  Pop $R1

  ${NSD_GetState} $R2 $R1

  ${If} $R1 == ${BST_CHECKED}
    StrCpy $ReinstallPageCheck 1
  ${Else}
    StrCpy $ReinstallPageCheck 2
  ${EndIf}

FunctionEnd

Function PageLeaveReinstall

  ${NSD_GetState} $R2 $R1

  StrCmp $R0 "1" 0 +2
    StrCmp $R1 "1" reinst_uninstall reinst_done

  StrCmp $R0 "2" 0 reinst_done
    StrCmp $R1 "1" reinst_done reinst_uninstall

  reinst_uninstall:
  ReadRegStr $R1 HKLM "${MEMENTO_REGISTRY_KEY}" "UninstallString"

  ;Run uninstaller
    HideWindow

    ClearErrors
    ExecWait '$R1 _?=$INSTDIR'

    BringToFront

    IfErrors no_remove_uninstaller
    IfFileExists "$INSTDIR\Bin\makensis.exe" no_remove_uninstaller

      Delete $R1
      RMDir $INSTDIR
      StrCpy $R1 ""

    no_remove_uninstaller:

    StrCmp "" $R1 0 +3
      MessageBox MB_ICONEXCLAMATION "Unable to uninstall!"
      Abort

  StrCmp $R0 "2" 0 +2
    Quit

  reinst_done:

FunctionEnd

!endif # VER_MAJOR & VER_MINOR & VER_REVISION & VER_BUILD

Function ShowReleaseNotes
  ${If} ${FileExists} $WINDIR\hh.exe
    StrCpy $0 $WINDIR\hh.exe
    Exec '"$0" mk:@MSITStore:$INSTDIR\NSIS.chm::/SectionF.1.html'
  ${Else}
    SearchPath $0 hh.exe
    ${If} ${FileExists} $0
      Exec '"$0" mk:@MSITStore:$INSTDIR\NSIS.chm::/SectionF.1.html'
    ${Else}
      ExecShell "open" "http://nsis.sourceforge.net/Docs/AppendixF.html#F.1"
    ${EndIf}
  ${EndIf}
FunctionEnd

;--------------------------------
;Uninstaller Section

Section Uninstall

  SetDetailsPrint textonly
  DetailPrint "Uninstalling NSI Development Shell Extensions..."
  SetDetailsPrint listonly

  IfFileExists $INSTDIR\Bin\makensis.exe nsis_installed
    MessageBox MB_YESNO "It does not appear that NSIS is installed in the directory '$INSTDIR'.$\r$\nContinue anyway (not recommended)?" IDYES nsis_installed
    Abort "Uninstall aborted by user"
  nsis_installed:

  SetDetailsPrint textonly
  DetailPrint "Deleting Registry Keys..."
  SetDetailsPrint listonly

  ReadRegStr $R0 HKCR ".nsi" ""
  StrCmp $R0 "NSIS.Script" 0 +2
    DeleteRegKey HKCR ".nsi"

  ReadRegStr $R0 HKCR ".nsh" ""
  StrCmp $R0 "NSIS.Header" 0 +2
    DeleteRegKey HKCR ".nsh"

  DeleteRegKey HKCR "NSIS.Script"
  DeleteRegKey HKCR "NSIS.Header"

  System::Call 'Shell32::SHChangeNotify(i ${SHCNE_ASSOCCHANGED}, i ${SHCNF_IDLIST}, i 0, i 0)'

  DeleteRegKey HKLM "${MEMENTO_REGISTRY_KEY}"
  DeleteRegKey HKLM "Software\NSIS"

  SetDetailsPrint textonly
  DetailPrint "Deleting Files..."
  SetDetailsPrint listonly

  Delete $SMPROGRAMS\NSIS.lnk
  Delete $DESKTOP\NSIS.lnk
  Delete $INSTDIR\makensis.exe
  Delete $INSTDIR\makensisw.exe
  Delete $INSTDIR\NSIS.exe
  Delete $INSTDIR\NSIS.exe.manifest
  Delete $INSTDIR\license.txt
  Delete $INSTDIR\COPYING
  Delete $INSTDIR\uninst-nsis.exe
  Delete $INSTDIR\nsisconf.nsi
  Delete $INSTDIR\nsisconf.nsh
  Delete $INSTDIR\NSIS.chm
  RMDir /r $INSTDIR\Bin
  RMDir /r $INSTDIR\Contrib
  RMDir /r $INSTDIR\Docs
  RMDir /r $INSTDIR\Examples
  RMDir /r $INSTDIR\Include
  RMDir /r $INSTDIR\Menu
  RMDir /r $INSTDIR\Plugins
  RMDir /r $INSTDIR\Stubs
  RMDir $INSTDIR

  SetDetailsPrint both

SectionEnd
