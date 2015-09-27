{ -*- buffer-read-only: t -*- }

{ Unit automatically generated by image2pascal tool,
  to embed images in Pascal source code.
  @exclude (Exclude this unit from PasDoc documentation.) }
unit V3DSceneImages;

interface

uses CastleImages;

var
  Warning_icon: TRGBAlphaImage;

var
  Examine: TGrayscaleAlphaImage;

var
  Walk: TGrayscaleAlphaImage;

var
  Fly: TGrayscaleAlphaImage;

var
  Open: TRGBAlphaImage;

var
  Screenshot: TGrayscaleAlphaImage;

var
  TooltipArrow: TRGBAlphaImage;

var
  Examine_tooltip: TRGBImage;

var
  Walk_fly_tooltip: TRGBImage;

implementation

uses SysUtils;

{ Actual image data is included from another file, with a deliberately
  non-Pascal file extension ".image_data". This way online code analysis
  tools will NOT consider this source code as an uncommented Pascal code
  (which would be unfair --- the image data file is autogenerated
  and never supposed to be processed by a human). }
{$I v3dsceneimages.image_data}

initialization
  Warning_icon := TRGBAlphaImage.Create(Warning_iconWidth, Warning_iconHeight, Warning_iconDepth);
  Move(Warning_iconPixels, Warning_icon.RawPixels^, SizeOf(Warning_iconPixels));
  Warning_icon.URL := 'embedded-image:/Warning_icon';
  Examine := TGrayscaleAlphaImage.Create(ExamineWidth, ExamineHeight, ExamineDepth);
  Move(ExaminePixels, Examine.RawPixels^, SizeOf(ExaminePixels));
  Examine.URL := 'embedded-image:/Examine';
  Walk := TGrayscaleAlphaImage.Create(WalkWidth, WalkHeight, WalkDepth);
  Move(WalkPixels, Walk.RawPixels^, SizeOf(WalkPixels));
  Walk.URL := 'embedded-image:/Walk';
  Fly := TGrayscaleAlphaImage.Create(FlyWidth, FlyHeight, FlyDepth);
  Move(FlyPixels, Fly.RawPixels^, SizeOf(FlyPixels));
  Fly.URL := 'embedded-image:/Fly';
  Open := TRGBAlphaImage.Create(OpenWidth, OpenHeight, OpenDepth);
  Move(OpenPixels, Open.RawPixels^, SizeOf(OpenPixels));
  Open.URL := 'embedded-image:/Open';
  Screenshot := TGrayscaleAlphaImage.Create(ScreenshotWidth, ScreenshotHeight, ScreenshotDepth);
  Move(ScreenshotPixels, Screenshot.RawPixels^, SizeOf(ScreenshotPixels));
  Screenshot.URL := 'embedded-image:/Screenshot';
  TooltipArrow := TRGBAlphaImage.Create(TooltipArrowWidth, TooltipArrowHeight, TooltipArrowDepth);
  Move(TooltipArrowPixels, TooltipArrow.RawPixels^, SizeOf(TooltipArrowPixels));
  TooltipArrow.URL := 'embedded-image:/TooltipArrow';
  Examine_tooltip := TRGBImage.Create(Examine_tooltipWidth, Examine_tooltipHeight, Examine_tooltipDepth);
  Move(Examine_tooltipPixels, Examine_tooltip.RawPixels^, SizeOf(Examine_tooltipPixels));
  Examine_tooltip.URL := 'embedded-image:/Examine_tooltip';
  Walk_fly_tooltip := TRGBImage.Create(Walk_fly_tooltipWidth, Walk_fly_tooltipHeight, Walk_fly_tooltipDepth);
  Move(Walk_fly_tooltipPixels, Walk_fly_tooltip.RawPixels^, SizeOf(Walk_fly_tooltipPixels));
  Walk_fly_tooltip.URL := 'embedded-image:/Walk_fly_tooltip';
finalization
  FreeAndNil(Warning_icon);
  FreeAndNil(Examine);
  FreeAndNil(Walk);
  FreeAndNil(Fly);
  FreeAndNil(Open);
  FreeAndNil(Screenshot);
  FreeAndNil(TooltipArrow);
  FreeAndNil(Examine_tooltip);
  FreeAndNil(Walk_fly_tooltip);
end.