unit uWindowsDarkMode;

interface

function DarkModeIsEnabled: Boolean;
procedure SetSpecificThemeMode(const AsDarkMode: Boolean; const DarkModeThemeName, LightModeThemeName: string);
procedure SetAppropiateThemeMode(const DarkModeThemeName, LightModeThemeName: string);


implementation

uses
{$IFDEF MSWINDOWS}
  Winapi.Windows, System.Win.Registry,
{$ENDIF}
  Vcl.Themes;

procedure SetAppropiateThemeMode(const DarkModeThemeName, LightModeThemeName: string);
begin
  SetSpecificThemeMode(DarkModeIsEnabled, DarkModeThemeName, LightModeThemeName);
end;

procedure SetSpecificThemeMode(const AsDarkMode: Boolean; const DarkModeThemeName, LightModeThemeName: string);
var
  ChosenTheme: string;
begin
  if AsDarkMode then
    ChosenTheme := DarkModeThemeName
  else
    ChosenTheme := LightModeThemeName;
  TStyleManager.TrySetStyle(ChosenTheme, False);
end;

function DarkModeIsEnabled: Boolean;
{$IFDEF MSWINDOWS}
const
  TheKey = 'Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\';
  TheValue = 'AppsUseLightTheme';
var
  Reg: TRegistry;
{$ENDIF}
begin
  Result := False;

{$IFNDEF MSWINDOWS}
{$MESSAGE ' WARN '"DarkModesIsEnabled"'will only work on MS Windows targets'}
{$ELSE}

  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.KeyExists(TheKey) then
      if Reg.OpenKey(TheKey, False) then
      try
        Result := Reg.ReadInteger(TheValue) = 0;
      finally
        Reg.CloseKey;
      end;
  finally
    Reg.Free;
  end;
{$ENDIF}
end;

end.

