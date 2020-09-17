#include <.\idp\idp.iss>

#define SickChillInstallerVersion "v0.5.8"

#define AppId "{{B0D7EA3E-CC34-4BE6-95D5-3C3D31E9E1B2}"
#define AppName "SickChill"
#define AppVersion "master"
#define AppPublisher "SickChill"
#define AppURL "http://sickchill.github.io/"
#define AppServiceName AppName
#define AppServiceDescription "Automatic Video Library Manager for TV Shows"
#define ServiceStartIcon "{group}\Start " + AppName + " Service"
#define ServiceStopIcon "{group}\Stop " + AppName + " Service"

#define DefaultPort 8081

#define InstallerVersion 10009
#define InstallerSeedUrl "https://raw.githubusercontent.com/SickChill/windows-sickchill/master/seed.ini"
#define AppRepoUrl "https://github.com/SickChill/SickChill.git"

[Setup]
AppId={#AppId}
AppName={#AppName}
AppCopyright=Copyright (C) 2016 SickChill
AppVersion={#AppVersion}
AppVerName={#AppName} ({#AppVersion})
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
DefaultDirName={sd}\{#AppName}
DefaultGroupName={#AppName}
AllowNoIcons=yes
DisableWelcomePage=no
DisableDirPage=no
DisableProgramGroupPage=no
ArchitecturesInstallIn64BitMode=x64
OutputBaseFilename={#AppName}Installer
SolidCompression=yes
UninstallDisplayIcon={app}\Installer\sickchill.ico
UninstallFilesDir={app}\Installer
ExtraDiskSpaceRequired=524288000
SetupIconFile=assets\sickchill.ico
WizardImageFile=assets\Wizard.bmp
WizardSmallImageFile=assets\WizardSmall.bmp

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "assets\sickchill.ico"; DestDir: "{app}\Installer"
Source: "assets\github.ico"; DestDir: "{app}\Installer"
Source: "utils\nssm32.exe"; DestDir: "{app}\Installer"; DestName: "nssm.exe"; Check: not Is64BitInstallMode
Source: "utils\nssm64.exe"; DestDir: "{app}\Installer"; DestName: "nssm.exe"; Check: Is64BitInstallMode

[Dirs]
Name: "{app}\Data"

[Icons]
Name: "{group}\{#AppName}"; Filename: "http://localhost:{code:GetWebPort}/"; IconFilename: "{app}\Installer\sickchill.ico"
Name: "{commondesktop}\{#AppName}"; Filename: "http://localhost:{code:GetWebPort}/"; IconFilename: "{app}\Installer\sickchill.ico"; Tasks: desktopicon
Name: "{group}\{cm:ProgramOnTheWeb,{#AppName}}"; Filename: "{#AppURL}"; IconFilename: "{app}\Installer\sickchill.ico"; Flags: excludefromshowinnewinstall
Name: "{group}\{#AppName} on GitHub"; Filename: "{#AppRepoUrl}"; IconFilename: "{app}\Installer\github.ico"; Flags: excludefromshowinnewinstall
Name: "{#ServiceStartIcon}"; Filename: "{app}\Installer\nssm.exe"; Parameters: "start ""{#AppServiceName}"""; Flags: excludefromshowinnewinstall
Name: "{#ServiceStopIcon}"; Filename: "{app}\Installer\nssm.exe"; Parameters: "stop ""{#AppServiceName}"""; Flags: excludefromshowinnewinstall
Name: "{group}\Edit {#AppName} Service"; Filename: "{app}\Installer\nssm.exe"; Parameters: "edit ""{#AppServiceName}"""; AfterInstall: ModifyServiceLinks; Flags: excludefromshowinnewinstall

[Run]
;SickChill
Filename: "{app}\Git\cmd\git.exe"; Parameters: "clone {#AppRepoUrl} ""{app}\{#AppName}"""; StatusMsg: "Installing {#AppName}..."
;Filename: "xcopy.exe"; Parameters: """C:\SRinstaller\SickChill"" ""{app}\{#AppName}"" /E /I /H /Y"; Flags: runminimized; StatusMsg: "Installing {#AppName}..."
;Service
Filename: "{app}\Installer\nssm.exe"; Parameters: "start ""{#AppServiceName}"""; Flags: runhidden; BeforeInstall: CreateService; StatusMsg: "Starting {#AppName} service..."
;Firewall
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""{#AppServiceName} In"" program=""{app}\Python3\python.exe"" dir=in action=allow enable=yes"; Flags: runhidden;
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""{#AppServiceName} Out"" program=""{app}\Python3\python.exe"" dir=out action=allow enable=yes"; Flags: runhidden;
;Open
Filename: "http://localhost:{code:GetWebPort}/"; Flags: postinstall shellexec; Description: "Open {#AppName} in browser"

[UninstallRun]
;Service
Filename: "{app}\Installer\nssm.exe"; Parameters: "remove ""{#AppServiceName}"" confirm"; Flags: runhidden
;Firewall
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""{#AppServiceName} In"""; Flags: runhidden;
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""{#AppServiceName} Out"""; Flags: runhidden;

[UninstallDelete]
Type: filesandordirs; Name: "{app}\Python3"
Type: filesandordirs; Name: "{app}\Python"
Type: filesandordirs; Name: "{app}\Git"
Type: filesandordirs; Name: "{app}\{#AppName}"
Type: dirifempty; Name: "{app}"

[Messages]
WelcomeLabel2=This will install [name/ver] on your computer.%n%nYou will need Internet connectivity in order to download the required packages.%n%nNOTE: This installer intentionally ignores any existing installations of Git or Python you might already have installed on your system. If you would prefer to use those versions, we recommend installing [name] manually.
AboutSetupNote=SickChillInstaller {#SickChillInstallerVersion}
BeveledLabel=SickChillInstaller {#SickChillInstallerVersion}

[Code]
type
  TDependency = record
    Name:     String;
    URL:      String;
    Filename: String;
    Size:     Integer;
    SHA1:     String;
  end;

  IShellLinkW = interface(IUnknown)
    '{000214F9-0000-0000-C000-000000000046}'
    procedure Dummy;
    procedure Dummy2;
    procedure Dummy3;
    function GetDescription(pszName: String; cchMaxName: Integer): HResult;
    function SetDescription(pszName: String): HResult;
    function GetWorkingDirectory(pszDir: String; cchMaxPath: Integer): HResult;
    function SetWorkingDirectory(pszDir: String): HResult;
    function GetArguments(pszArgs: String; cchMaxPath: Integer): HResult;
    function SetArguments(pszArgs: String): HResult;
    function GetHotkey(var pwHotkey: Word): HResult;
    function SetHotkey(wHotkey: Word): HResult;
    function GetShowCmd(out piShowCmd: Integer): HResult;
    function SetShowCmd(iShowCmd: Integer): HResult;
    function GetIconLocation(pszIconPath: String; cchIconPath: Integer;
      out piIcon: Integer): HResult;
    function SetIconLocation(pszIconPath: String; iIcon: Integer): HResult;
    function SetRelativePath(pszPathRel: String; dwReserved: DWORD): HResult;
    function Resolve(Wnd: HWND; fFlags: DWORD): HResult;
    function SetPath(pszFile: String): HResult;
  end;

  IPersist = interface(IUnknown)
    '{0000010C-0000-0000-C000-000000000046}'
    function GetClassID(var classID: TGUID): HResult;
  end;

  IPersistFile = interface(IPersist)
    '{0000010B-0000-0000-C000-000000000046}'
    function IsDirty: HResult;
    function Load(pszFileName: String; dwMode: Longint): HResult;
    function Save(pszFileName: String; fRemember: BOOL): HResult;
    function SaveCompleted(pszFileName: String): HResult;
    function GetCurFile(out pszFileName: String): HResult;
  end;

  IShellLinkDataList = interface(IUnknown)
    '{45E2B4AE-B1C3-11D0-B92F-00A0C90312E1}'
    procedure Dummy;
    procedure Dummy2;
    procedure Dummy3;
    function GetFlags(out dwFlags: DWORD): HResult;
    function SetFlags(dwFlags: DWORD): HResult;
  end;

const
  MinPort = 1;
  MaxPort = 65535;
  WM_CLOSE             = $0010;
  GENERIC_WRITE        = $40000000;
  GENERIC_READ         = $80000000;
  OPEN_EXISTING        = 3;
  INVALID_HANDLE_VALUE = $FFFFFFFF;
  SLDF_RUNAS_USER      = $00002000;
  CLSID_ShellLink = '{00021401-0000-0000-C000-000000000046}';
  SHCONTCH_NOPROGRESSBOX = 4;
  SHCONTCH_RESPONDYESTOALL = 16;

var
  // This lets AbortInstallation() terminate setup without prompting the user
  CancelWithoutPrompt: Boolean;
  ErrorMessage, LocalFilesDir: String;
  SeedDownloadPageId, DependencyDownloadPageId: Integer;
  PythonDep, GitDep: TDependency;
  InstallDepPage: TOutputProgressWizardPage;
  OptionsPage: TInputQueryWizardPage;
  // Uninstall variables
  UninstallRemoveData: Boolean;

// Import some Win32 functions
function CreateFile(
  lpFileName: String;
  dwDesiredAccess: LongWord;
  dwSharedMode: LongWord;
  lpSecurityAttributes: LongWord;
  dwCreationDisposition: LongWord;
  dwFlagsAndAttributes: LongWord;
  hTemplateFile: LongWord): LongWord;
external 'CreateFileW@kernel32.dll stdcall';

function CloseHandle(hObject: LongWord): Boolean;
external 'CloseHandle@kernel32.dll stdcall';

procedure AbortInstallation(ErrorMessage: String);
begin
  MsgBox(ErrorMessage + #13#10#13#10 'Setup will now terminate.', mbError, 0)
  CancelWithoutPrompt := True
  PostMessage(WizardForm.Handle, WM_CLOSE, 0, 0);
end;

procedure CheckInstallerVersion(SeedFile: String);
var
  InstallerVersion, CurrentVersion: Integer;
  DownloadUrl: String;
begin
  InstallerVersion := StrToInt(ExpandConstant('{#InstallerVersion}'))

  CurrentVersion := GetIniInt('Installer', 'Version', 0, 0, MaxInt, SeedFile)

  if CurrentVersion = 0 then begin
    AbortInstallation('Unable to parse configuration.')
  end;

  if CurrentVersion > InstallerVersion then begin
    DownloadUrl := GetIniString('Installer', 'DownloadUrl', ExpandConstant('{#AppURL}'), SeedFile)
    AbortInstallation(ExpandConstant('This is an old version of the {#AppName} installer. Please get the latest version at:') + #13#10#13#10 + DownloadUrl)
  end;
end;

procedure ParseDependency(var Dependency: TDependency; Name, SeedFile: String);
var
  LocalFile: String;
begin
  Dependency.Name     := Name;
  Dependency.URL      := GetIniString(Name, 'url', '', SeedFile)
  Dependency.Filename := Dependency.URL
  Dependency.Size     := GetIniInt(Name, 'size', 0, 0, MaxInt, SeedFile)
  Dependency.SHA1     := GetIniString(Name, 'sha1', '', SeedFile)

  if (Dependency.URL = '') or (Dependency.Size = 0) or (Dependency.SHA1 = '') then begin
    AbortInstallation('Error parsing dependency information for ' + Name + '.')
  end;

  while Pos('/', Dependency.Filename) <> 0 do begin
    Delete(Dependency.Filename, 1, Pos('/', Dependency.Filename))
  end;

  if LocalFilesDir <> '' then begin
    LocalFile := LocalFilesDir + '\' + Dependency.Filename
  end;
  if (LocalFile <> '') and (FileExists(LocalFile)) then begin
    FileCopy(LocalFile, ExpandConstant('{tmp}\') + Dependency.Filename, True)
  end else begin
    idpAddFileSize(Dependency.URL, ExpandConstant('{tmp}\') + Dependency.Filename, Dependency.Size)
  end
end;

procedure ParseSeedFile();
var
  SeedFile: String;
  Arch: String;
  DownloadPage: TWizardPage;
begin
  SeedFile := ExpandConstant('{tmp}\installer.ini')

  // Make sure we're running the latest version of the installer
  CheckInstallerVersion(SeedFile)

  if Is64BitInstallMode then
    Arch := 'x64'
  else
    Arch := 'x86';

  ParseDependency(PythonDep,    'Python.'    + Arch, SeedFile)
  ParseDependency(GitDep,       'Git.'       + Arch, SeedFile)

  DependencyDownloadPageId := idpCreateDownloadForm(wpPreparing)
  DownloadPage := PageFromID(DependencyDownloadPageId)
  DownloadPage.Caption := 'Downloading Dependencies'
  DownloadPage.Description := ExpandConstant('Setup is downloading {#AppName} dependencies...')

  idpSetOption('DetailedMode', '1')
  idpSetOption('DetailsButton', '0')

  idpConnectControls()
end;

procedure InitializeSeedDownload();
var
  DownloadPage: TWizardPage;
  Seed: String;
  IsRemote: Boolean;
begin
  IsRemote := True

  Seed := ExpandConstant('{param:SEED}')
  if (Lowercase(Copy(Seed, 1, 7)) <> 'http://') and (Lowercase(Copy(Seed, 1, 8)) <> 'https://') then begin
    if Seed = '' then begin
      Seed := ExpandConstant('{#InstallerSeedUrl}')
    end else begin
      if FileExists(Seed) then begin
        IsRemote := False
      end else begin
        MsgBox('Invalid SEED specified: ' + Seed, mbError, 0)
        Seed := ExpandConstant('{#InstallerSeedUrl}')
      end;
    end;
  end;

  if not IsRemote then begin
    FileCopy(Seed, ExpandConstant('{tmp}\installer.ini'), False)
    ParseSeedFile()
  end else begin
    // Download the installer seed INI file
    // I'm adding a dummy size here otherwise the installer crashes (divide by 0)
    // when runnning in silent mode, a bug in IDP maybe?
    idpAddFileSize(Seed, ExpandConstant('{tmp}\installer.ini'), 1024)

    SeedDownloadPageId := idpCreateDownloadForm(wpWelcome)
    DownloadPage := PageFromID(SeedDownloadPageId)
    DownloadPage.Caption := 'Downloading Installer Configuration'
    DownloadPage.Description := 'Setup is downloading its configuration file...'

    idpConnectControls()
  end;
end;

function CheckFileInUse(Filename: String): Boolean;
var
  FileHandle: LongWord;
begin
  if not FileExists(Filename) then begin
    Result := False
    exit
  end;

  FileHandle := CreateFile(Filename, GENERIC_READ or GENERIC_WRITE, 0, 0, OPEN_EXISTING, 0, 0)
  if (FileHandle <> 0) and (FileHandle <> INVALID_HANDLE_VALUE) then begin
    CloseHandle(FileHandle)
    Result := False
  end else begin
    Result := True
  end;
end;

function GetWebPort(Param: String): String;
begin
  Result := OptionsPage.Values[0]
end;

procedure CreateService();
var
  Nssm: String;
  ResultCode: Integer;
  OldProgressString: String;
  WindowsVersion: TWindowsVersion;
begin
  Nssm := ExpandConstant('{app}\Installer\nssm.exe')
  GetWindowsVersionEx(WindowsVersion);

  OldProgressString := WizardForm.StatusLabel.Caption;
  WizardForm.StatusLabel.Caption := ExpandConstant('Installing {#AppName} service...')

  Exec(Nssm, ExpandConstant('install "{#AppServiceName}" "{app}\Python3\python.exe" """{app}\{#AppName}\SickChill.py""" --nolaunch --port='+GetWebPort('')+' --datadir="""{app}\Data"""'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
  Exec(Nssm, ExpandConstant('set "{#AppServiceName}" AppDirectory "{app}\Data"'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
  Exec(Nssm, ExpandConstant('set "{#AppServiceName}" Description "{#AppServiceDescription}"'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
  Exec(Nssm, ExpandConstant('set "{#AppServiceName}" AppStopMethodSkip 6'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
  Exec(Nssm, ExpandConstant('set "{#AppServiceName}" AppStopMethodConsole 20000'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
  Exec(Nssm, ExpandConstant('set "{#AppServiceName}" AppEnvironmentExtra "PATH={app}\Git\cmd;%PATH%"'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)

  if WindowsVersion.NTPlatform and (WindowsVersion.Major = 10) and (WindowsVersion.Minor = 0) and (WindowsVersion.Build > 14393) then begin
    Exec(Nssm, ExpandConstant('set "{#AppServiceName}" AppNoConsole 1'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
  end;

  WizardForm.StatusLabel.Caption := OldProgressString;
end;

procedure StopService();
var
  Nssm: String;
  ResultCode: Integer;
  Retries: Integer;
  OldProgressString: String;
begin
  Retries := 30

  OldProgressString := UninstallProgressForm.StatusLabel.Caption;
  UninstallProgressForm.StatusLabel.Caption := ExpandConstant('Stopping {#AppName} service...')

  Nssm := ExpandConstant('{app}\Installer\nssm.exe')
  Exec(Nssm, ExpandConstant('stop "{#AppServiceName}"'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)

  while (Retries > 0) and (CheckFileInUse(Nssm)) do begin
    UninstallProgressForm.StatusLabel.Caption := ExpandConstant('Waiting for {#AppName} service to stop (') + IntToStr(Retries) + ')...'
    Sleep(1000)
    Retries := Retries - 1
  end;

  UninstallProgressForm.StatusLabel.Caption := OldProgressString;
end;

procedure CleanPython();
var
  PythonPath: String;
begin
  PythonPath := ExpandConstant('{app}\Python3')

  DelTree(PythonPath + '\*.msi',        False, True, False)
  DelTree(PythonPath + '\Doc',          True,  True, True)
  DelTree(PythonPath + '\Lib\test\*.*', False, True, True)
  DelTree(PythonPath + '\Scripts',      True,  True, True)
  DelTree(PythonPath + '\tcl',          True,  True, True)
  DelTree(PythonPath + '\Tools',        True,  True, True)
end;

procedure InstallPython();
begin
  InstallDepPage.SetText('Installing Python...', '');
  Shell := CreateOleObject('Shell.Application');
  ZipFile := Shell.NameSpace(ExpandConstantEx('{tmp}\{filename}', 'filename', PythonDep.Filename));
  TargetFolder := Shell.NameSpace(ExpandConstant('{app}\Python3'));
  TargetFolder.CopyHere(ZipFile.Items, SHCONTCH_NOPROGRESSBOX or SHCONTCH_RESPONDYESTOALL);
  CleanPython()
  InstallDepPage.SetProgress(InstallDepPage.ProgressBar.Position+1, InstallDepPage.ProgressBar.Max)
end;

procedure InstallGit();
var
  ResultCode: Integer;
begin
  InstallDepPage.SetText('Installing Git...', '')
  Exec(ExpandConstantEx('{tmp}\{filename}', 'filename', GitDep.Filename), ExpandConstant('-InstallPath="{app}\Git" -y -gm2'), '', SW_SHOW, ewWaitUntilTerminated, ResultCode)
  InstallDepPage.SetProgress(InstallDepPage.ProgressBar.Position+1, InstallDepPage.ProgressBar.Max)
end;

function VerifyDependency(Dependency: TDependency): Boolean;
begin
  Result := True

  InstallDepPage.SetText('Verifying dependency files...', Dependency.Filename)
  if GetSHA1OfFile(ExpandConstant('{tmp}\') + Dependency.Filename) <> Dependency.SHA1 then begin
    MsgBox('SHA1 hash of ' + Dependency.Filename + ' does not match.', mbError, 0)
    Result := False
  end;
  InstallDepPage.SetProgress(InstallDepPage.ProgressBar.Position+1, InstallDepPage.ProgressBar.Max)
end;

function VerifyDependencies(): Boolean;
begin
  Result := True

  Result := Result and VerifyDependency(PythonDep)
  Result := Result and VerifyDependency(GitDep)
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
begin
  if ErrorMessage <> '' then begin
    Result := ErrorMessage
  end;
end;

procedure InstallDependencies();
begin
  try
    InstallDepPage.Show
    InstallDepPage.SetProgress(0, 6)
    if VerifyDependencies() then begin
      InstallPython()
      InstallGit()
    end else begin
      ErrorMessage := 'There was an error installing the required dependencies.'
    end;
  finally
    InstallDepPage.Hide
  end;
end;

procedure InitializeWizard();
begin
  InitializeSeedDownload()

  idpInitMessages()

  InstallDepPage := CreateOutputProgressPage('Installing Dependencies', ExpandConstant('Setup is installing {#AppName} dependencies...'));

  OptionsPage := CreateInputQueryPage(wpSelectProgramGroup, 'Additional Options', ExpandConstant('Additional {#AppName} configuration options'), '');
  OptionsPage.Add(ExpandConstant('{#AppName} Web Server Port:'), False)
  OptionsPage.Values[0] := ExpandConstant('{#DefaultPort}')
end;

function ShellLinkRunAsAdmin(LinkFilename: String): Boolean;
var
  Obj: IUnknown;
  SL: IShellLinkW;
  PF: IPersistFile;
  DL: IShellLinkDataList;
  Flags: DWORD;
begin
  try
    Obj := CreateComObject(StringToGuid(CLSID_ShellLink));

    SL := IShellLinkW(Obj);
    PF := IPersistFile(Obj);

    // Load the ShellLink
    OleCheck(PF.Load(LinkFilename, 0));

    // Set the SLDF_RUNAS_USER flag
    DL := IShellLinkDataList(Obj);
    OleCheck(DL.GetFlags(Flags))
    OleCheck(DL.SetFlags(Flags or SLDF_RUNAS_USER))

    // Save the ShellLink
    OleCheck(PF.Save(LinkFilename, True));

    Result := True
  except
    Result := False
  end;
end;

procedure ModifyServiceLinks();
begin
  ShellLinkRunAsAdmin(ExpandConstant('{#ServiceStartIcon}.lnk'))
  ShellLinkRunAsAdmin(ExpandConstant('{#ServiceStopIcon}.lnk'))
end;

function InitializeSetup(): Boolean;
begin
  CancelWithoutPrompt := False

  LocalFilesDir := ExpandConstant('{param:LOCALFILES}')
  if (LocalFilesDir <> '') and (not DirExists(LocalFilesDir)) then begin
    MsgBox('Invalid LOCALFILES specified: ' + LocalFilesDir, mbError, 0)
    LocalFilesDir := ''
  end;

  // Don't allow installations over top
  if RegKeyExists(HKEY_LOCAL_MACHINE, ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#AppId}_is1')) then begin
    MsgBox(ExpandConstant('{#AppName} is already installed. If you''re reinstalling or upgrading, please uninstall the current version first.'), mbError, 0)
    Result := False
  end else begin
    Result := True
  end;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  Port: Integer;
begin
  Result := True

  if CurPageID = SeedDownloadPageId then begin
    ParseSeedFile()
  end else if CurPageId = OptionsPage.ID then begin
    // Make sure valid port is specified
    Port := StrToIntDef(OptionsPage.Values[0], 0)
    if (Port = 0) or (Port < MinPort) or (Port > MaxPort) then begin
      MsgBox(FmtMessage('Please specify a valid port between %1 and %2.', [IntToStr(MinPort), IntToStr(MaxPort)]), mbError, 0)
      Result := False;
    end;
  end;
end;

function UninstallShouldRemoveData(): Boolean;
begin
  Result := MsgBox(ExpandConstant('Do you want to remove your {#AppName} database and configuration?' #13#10#13#10 'Select No if you plan on reinstalling {#AppName}.'), mbConfirmation, MB_YESNO or MB_DEFBUTTON2) = IDYES;
end;

procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
  Confirm := not CancelWithoutPrompt;
end;

procedure InitializeUninstallProgressForm();
begin
  UninstallRemoveData := UninstallShouldRemoveData()
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then begin
    // Stop service
    StopService()

    // Remove data if requested
    if UninstallRemoveData then begin
      DelTree(ExpandConstant('{app}\Data'), True, True, True)
    end;
  end;
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo,
  MemoTypeInfo, MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
begin
  Result := MemoDirInfo + NewLine + NewLine + \
            MemoGroupInfo + NewLine + NewLine + \
            'Download and install dependencies:' + NewLine + \
            Space + 'Git' + NewLine + \
            Space + 'Python' + NewLine + NewLine + \
            'Web server port:' + NewLine + Space + GetWebPort('')

  if MemoTasksInfo <> '' then begin
    Result := Result + NewLine + NewLine + MemoTasksInfo
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then begin
    InstallDependencies()
  end;
end;
