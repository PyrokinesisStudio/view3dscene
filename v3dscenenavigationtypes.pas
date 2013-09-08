{
  Copyright 2003-2013 Michalis Kamburelis.

  This file is part of "view3dscene".

  "view3dscene" is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  "view3dscene" is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with "view3dscene"; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

  ----------------------------------------------------------------------------
}

{ Manage camera navigation types. }
unit V3DSceneNavigationTypes;

interface

uses SysUtils, CastleUtils, CastleWindow, CastleCameras, CastleVectors,
  GL, GLU, CastleGLUtils, CastleSceneManager, Classes, CastleUIControls,
  CastleControls, CastleControlsImages;

{ Call this once on created SceneManager.
  This will take care of using proper SceneManager.Camera. }
procedure InitCameras(SceneManager: TCastleSceneManager);

const
  CameraNames: array [TCameraNavigationType] of string =
  ('Examine', 'Architecture (Work in Progress)', 'Walk', 'Fly', 'None');
  StableNavigationType = [Low(TCameraNavigationType)..High(TCameraNavigationType)]
    -[ntArchitecture];

var
  CameraRadios: array [TCameraNavigationType] of TMenuItemRadio;
  CameraButtons: array [TCameraNavigationType] of TCastleButton;

procedure UpdateCameraNavigationTypeUI;

{ Interpret and remove from ParStr(1) ... ParStr(ParCount)
  some params specific for this unit.
  Those params are documented in CamerasOptionsHelp.

  Call this @italic(before) InitCameras. }
procedure CamerasParseParameters;

var
  { When loading scene, check InitialNavigationType, and if non-empty:
    use it, and reset to empty. }
  InitialNavigationType: string;

var
  { Same as your SceneManager.Camera after InitCameras. }
  Camera: TUniversalCamera;

type
  TNavigationTypeButton = class(TCastleButton)
  public
    NavigationType: TCameraNavigationType;
    constructor Create(AOwner: TComponent;
      const ANavigationType: TCameraNavigationType); reintroduce;
    function TooltipStyle: TUIControlDrawStyle; override;
    procedure DrawTooltip; override;
    procedure GLContextOpen; override;
    procedure GLContextClose; override;
  end;

implementation

uses CastleParameters, CastleClassUtils, CastleImages, CastleGLImages,
  V3DSceneImages, CastleRectangles;

var
  ImageExamine_TooltipGL: TGLImage;
  ImageWalk_Fly_TooltipGL: TGLImage;
  ImageTooltipArrow: TGLImage;

procedure UpdateCameraNavigationTypeUI;
var
  NT: TCameraNavigationType;
begin
  if CameraRadios[Camera.NavigationType] <> nil then
    CameraRadios[Camera.NavigationType].Checked := true;
  for NT := Low(NT) to High(NT) do
    { check <> nil, since for ntNone and not StableNavigationType
      we don't show buttons }
    if CameraButtons[NT] <> nil then
      CameraButtons[NT].Pressed := NT = Camera.NavigationType;
end;

procedure InitCameras(SceneManager: TCastleSceneManager);
begin
  { init SceneManager.Camera }
  SceneManager.Camera := Camera;
  UpdateCameraNavigationTypeUI;
end;

  procedure OptionProc(OptionNum: Integer; HasArgument: boolean;
    const Argument: string; const SeparateArgs: TSeparateArgs; Data: Pointer);
  begin
    Assert(OptionNum = 0);
    InitialNavigationType := Argument;
  end;

procedure CamerasParseParameters;
const
  Options: array[0..0]of TOption =
  ((Short:#0; Long:'navigation'; Argument: oaRequired));
begin
  Parameters.Parse(Options, @OptionProc, nil, true);
end;

{ TNavigationTypeButton ------------------------------------------------------ }

constructor TNavigationTypeButton.Create(AOwner: TComponent;
  const ANavigationType: TCameraNavigationType);
begin
  inherited Create(AOwner);
  NavigationType := ANavigationType;
end;

function TNavigationTypeButton.TooltipStyle: TUIControlDrawStyle;
begin
  if NavigationType in [ntExamine, ntWalk, ntFly] then
    Result := ds2D else
    Result := dsNone;
end;

{ By using image instead of drawing the text we avoid some lacks
  of our text output:
  - it would be unhandy to print both normal and bold fonts
  - it would be unhandy to use non-monospace fonts and still
    make columns (key names) matching
  - GIMP makes fonts antialiased, our bitmap fonts are not antialiased.
    Besides making things look better, this allows us to use smaller fonts,
    which is important (we have a lot of text that we have to fit within
    window).
  - Also we can draw a nice circle instead of "*" inside walk_fly list.

  Of course, it also causes some problems. Things are no longer configurable
  at runtime:
  - fonts
  - text contents (e.g. we cannot allow view3dscene keys config,
    although this wasn't planned anyway, as it would make problems
    with KeySensor, StringSensor)
  - we cannot wrap text to window width. We just have to assume
    we'll fit inside.
}

procedure TNavigationTypeButton.DrawTooltip;

  procedure DoDraw(GLImage: TGLImage);
  const
    WindowBorderMargin = 8;
    ButtonBottomMargin = 16;
    ImageMargin = 8;
  var
    R: TRectangle;
  begin
    R := Rectangle(
      WindowBorderMargin,
      Bottom - ButtonBottomMargin - (GLImage.Height + 2 * ImageMargin),
      GLImage.Width  + 2 * ImageMargin,
      GLImage.Height + 2 * ImageMargin);

    Theme.Draw(R, tiTooltip);
    GLImage.Draw(R.Left + ImageMargin, R.Bottom + ImageMargin);
    { we decrease R.Top to overdraw the tooltip image border }
    ImageTooltipArrow.Draw(Left + (Width - ImageTooltipArrow.Width) div 2, R.Top - 1);
  end;

begin
  if NavigationType = ntExamine then
    DoDraw(ImageExamine_TooltipGL) else
    DoDraw(ImageWalk_Fly_TooltipGL);
end;

procedure TNavigationTypeButton.GLContextOpen;
begin
  inherited;

  { Just use GLContextOpen/Close for ntExamine to initialize global unit
    variables . }
  if NavigationType = ntExamine then
  begin
    if ImageExamine_TooltipGL = nil then
      ImageExamine_TooltipGL := TGLImage.Create(Examine_Tooltip);
    if ImageWalk_Fly_TooltipGL = nil then
      ImageWalk_Fly_TooltipGL := TGLImage.Create(Walk_Fly_Tooltip);
    if ImageTooltipArrow = nil then
      ImageTooltipArrow := TGLImage.Create(TooltipArrow);
  end;
end;

procedure TNavigationTypeButton.GLContextClose;
begin
  if NavigationType = ntExamine then
  begin
    FreeAndNil(ImageExamine_TooltipGL);
    FreeAndNil(ImageWalk_Fly_TooltipGL);
    FreeAndNil(ImageTooltipArrow);
  end;
  inherited;
end;

initialization
  Theme.Images[tiTooltip] := TooltipRounded;
  Theme.Corners[tiTooltip] := Vector4Integer(9, 9, 9, 9);
  Camera := TUniversalCamera.Create(nil);
finalization
  FreeAndNil(Camera);
end.
