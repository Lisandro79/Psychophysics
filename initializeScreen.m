function Exp = initializeScreen (Exp)


%% DEFINE ALL THE DEFAULTS
% Exp.Gral.randomize= [];
if ~isfield(Exp.Cfg, 'SkipSyncTest'), Exp.Cfg.SkipSyncTest = 0; else end;
if ~isfield(Exp.Cfg, 'AuxBuffers'), Exp.Cfg.AuxBuffers = 1; else end;
if ~isfield(Exp.Cfg, 'WinSize'), Exp.Cfg.WinSize = []; else end; % full screen
if ~isfield(Exp.Cfg, 'WinColor'), Exp.Cfg.WinColor = []; else end; % gray background 
% STEREOMODE
% 0 == No stereo mode, just a single window
% 6-9 == Different modes of anaglyph stereo for color filter glasses:
% 6 == Red-Green
% 7 == Green-Red
% 8 == Red-Blue
% 9 == Blue-Red
if ~isfield(Exp.Cfg, 'stereoMode'), Exp.Cfg.stereoMode= 0; else end; % no stereomode
if ~isfield(Exp.Cfg, 'adjustColorGains'), Exp.Cfg.adjustColorGains = 0; else end; % no adjust
if ~isfield(Exp.Cfg, 'xDimCm'), Exp.Cfg.xDimCm=30; else end; %Length in cm of the screen in X
if ~isfield(Exp.Cfg, 'yDimCm'), Exp.Cfg.yDimCm=20; else end; %Length in cm of the screen in Y
if ~isfield(Exp.Cfg, 'distanceCm'), Exp.Cfg.distanceCm=60; else end; %Viewing distance


%% GENERAL PARAMETERS FOR SCREEN
%=============================
% Get the list of screens and choose the one with the highest screen number.
% Screen 0 is, by definition, the display with the menu bar. Often when
% two monitors are connected the one without the menu bar is used as
% the stimulus display.  Chosing the display with the highest dislay number is
% a best guess about where you want the stimulus displayed.
Exp.Cfg.screens=Screen('Screens');
Exp.Cfg.screenNumber=max(Exp.Cfg.screens);
% Find the color values which correspond to white and black.  Though on OS
% X we currently only support true color and thus, for scalar color
% arguments, black is always 0 and white 255, this rule is not necessarily
% true on other platforms and will not remain true after we add other color depth modes.
Exp.Cfg.Color.white=WhiteIndex(Exp.Cfg.screenNumber);
Exp.Cfg.Color.black=BlackIndex(Exp.Cfg.screenNumber);
Exp.Cfg.Color.gray= round((Exp.Cfg.Color.white + Exp.Cfg.Color.black)/2);
if round(Exp.Cfg.Color.gray)==Exp.Cfg.Color.white
    Exp.Cfg.Color.gray=Exp.Cfg.Color.black;
end
Exp.Cfg.Color.inc= Exp.Cfg.Color.white - Exp.Cfg.Color.gray;

if isempty(Exp.Cfg.WinColor)
    Exp.Cfg.WinColor= Exp.Cfg.Color.gray;
end
[x y]=Screen('DisplaySize',Exp.Cfg.screenNumber);
Exp.Cfg.xDimCm=x/10;
Exp.Cfg.yDimCm=y/10;
%% OPEN A WINDOW DEPENDING ON THE STEREO MODE
if Exp.Cfg.stereoMode==0 %No stereo mode, one display only
    [Exp.Cfg.win Exp.Cfg.windowRect]= Screen('OpenWindow', 0 , Exp.Cfg.WinColor, Exp.Cfg.WinSize, [], 2, 0);
    [Exp.Cfg.centerX ,Exp.Cfg.centerY] = RectCenter(Exp.Cfg.windowRect);
    
    % Set up alpha-blending for smooth (anti-aliased) drawing of dots:
    Screen('BlendFunction', Exp.Cfg.win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

else
    % Open double-buffered onscreen window with the requested stereo mode,
    % setup imaging pipeline for additional on-the-fly processing:

    % Prepare pipeline for configuration. This marks the start of a list of
    % requirements/tasks to be met/executed in the pipeline:
    PsychImaging('PrepareConfiguration');

    % ADD STEREOMODE CONFIGURATIONS
    % Ask to restrict stimulus processing to some subarea (ROI) of the
    % display. This will only generate the stimulus in the selected ROI and
    % display the background color in all remaining areas, thereby saving
    % some computation time for pixel processing: We select the center
    % 512x512 pixel area of the screen:
%     PsychImaging('AddTask', 'AllViews', 'RestrictProcessing', CenterRect([0 0 512 512], Screen('Rect', Exp.Cfg.screenNumber)));
%     PsychImaging('AddTask', 'General', 'UseVirtualFramebuffer');
%     PsychImaging('AddTask', 'General', 'UseFastOffscreenWindows');
%     PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
    PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');    
    % Normalize color 
%     PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange');
%     Exp.Cfg.Color.white= Exp.Cfg.Color.white;
%     Exp.Cfg.Color.black= Exp.Cfg.Color.black;
%     Exp.Cfg.Color.gray= Exp.Cfg.Color.gray;
%     Exp.Cfg.Color.inc= Exp.Cfg.Color.inc;
%     Exp.Cfg.WinColor= Exp.Cfg.WinColor;
    
    % Consolidate the list of requirements (error checking etc.), open a
    % suitable onscreen window and configure the imaging pipeline for that
    % window according to our specs. The syntax is the same as for
    % Screen('OpenWindow'):
%     rval = kPsychNeedFastOffscreenWindows; 
    rval = [];
    [Exp.Cfg.win, Exp.Cfg.windowRect]=PsychImaging('OpenWindow', Exp.Cfg.screenNumber, Exp.Cfg.WinColor, Exp.Cfg.WinSize, [], [], Exp.Cfg.stereoMode, [], rval);
    [Exp.Cfg.centerX ,Exp.Cfg.centerY] = RectCenter(Exp.Cfg.windowRect);
    % Apply gamma correction to the open window
    PsychColorCorrection('SetEncodingGamma', Exp.Cfg.win, 1, 'AllViews');

    % SET COLOR GAINS. This depends on the anaglyph mode selected. The
    % values set here as default need to be fine-tuned for any specific
    % combination of display device, color filter glasses and (probably)
    % lighting conditions and subject. The current settings do ok on a
    % MacBookPro flat panel.% Open double-buffered onscreen window with the requested stereo mode,
    % setup imaging pipeline for additional on-the-fly processing:
    if Exp.Cfg.adjustColorGains
        switch Exp.Cfg.stereoMode
            case 6,
                SetAnaglyphStereoParameters('LeftGains', Exp.Cfg.win,  [1.0 0.0 0.0]); % [1.0 0.0 0.0]
                SetAnaglyphStereoParameters('RightGains', Exp.Cfg.win, [0.0 0.6 0.0]); % [0.0 0.6 0.0]
            case 7,
                SetAnaglyphStereoParameters('LeftGains', Exp.Cfg.win,  [0.0 0.6 0.0]);
                SetAnaglyphStereoParameters('RightGains', Exp.Cfg.win, [1.0 0.0 0.0]);
            case 8,
                SetAnaglyphStereoParameters('LeftGains', Exp.Cfg.win, [0.4 0.0 0.0]);
                SetAnaglyphStereoParameters('RightGains', Exp.Cfg.win, [0.0 0.2 0.7]);
            case 9,
                SetAnaglyphStereoParameters('LeftGains', Exp.Cfg.win, [0.0 0.2 0.7]);
                SetAnaglyphStereoParameters('RightGains', Exp.Cfg.win, [0.4 0.0 0.0]);
            otherwise
                error('Unknown Exp.Cfg.stereoMode specified.');
        end
    end

    % Set up alpha-blending for smooth (anti-aliased) drawing of dots:
    % colorMaskNew= [1 1 1 1]; %Check this
    Screen('BlendFunction', Exp.Cfg.win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
end


%% GENERAL PARAMETERS OF CONFIGURATION
Exp.Cfg.Date= datestr(now);
Exp.Cfg.ExperimentStart = GetSecs; %store time when experiment was started
Exp.Cfg.computer = Screen('Computer');
Exp.Cfg.version = Screen('Version');
[Exp.Cfg.width, Exp.Cfg.height]=Screen('WindowSize', Exp.Cfg.win);
Exp.Cfg.FrameRate = Screen('NominalFrameRate', Exp.Cfg.win);
[Exp.Cfg.MonitorFlipInterval, Exp.Cfg.GetFlipInterval.nrValidSamples, Exp.Cfg.GetFlipInterval.stddev ] = Screen('GetFlipInterval', Exp.Cfg.win );


%DEG VISUAL ANGLE FOR SCREEN
Exp.Cfg.visualAngleDegX = atan(Exp.Cfg.xDimCm/(2*Exp.Cfg.distanceCm))/pi*180*2;
Exp.Cfg.visualAngleDegY = atan(Exp.Cfg.yDimCm/(2*Exp.Cfg.distanceCm))/pi*180*2;

%DEG VISUAL ANGLE PER PIXEL
Exp.Cfg.visualAngleDegPerPixelX = Exp.Cfg.visualAngleDegX/Exp.Cfg.width;
Exp.Cfg.visualAngleDegPerPixelY = Exp.Cfg.visualAngleDegY/Exp.Cfg.height;
Exp.Cfg.visualAnglePixelPerDegX = Exp.Cfg.width/Exp.Cfg.visualAngleDegX;
Exp.Cfg.visualAnglePixelPerDegY = Exp.Cfg.height/Exp.Cfg.visualAngleDegY;
Exp.Cfg.pixelsPerDegree= mean([Exp.Cfg.visualAnglePixelPerDegX Exp.Cfg.visualAnglePixelPerDegY]); % Usually the mean is reported in papers

%TEXT SIZE
Screen('TextSize', Exp.Cfg.win , 25);
% Screen(Exp.Cfg.win,'TextFont', 'TimesNewRoman');

% Screen('DrawText', Exp.Cfg.win, '7',Exp.Cfg.centerX-5, Exp.Cfg.centerY-10,1);


