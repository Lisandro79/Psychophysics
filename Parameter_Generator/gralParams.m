function Experiment= gralParams (inFileName)

%% Main plug-ins: insert here your creative portions of code
% To avoid these parameters just leave them as empty strings
% textureGenerator= 'TextureGenerator_motionCFS'; % for offline rendering the textures go always first
% trialGenerator= 'TrialGenerator_stereoAM';
% showTrials= 'showTrialsStereoAM';

Exp.funcs = {'[Exp,indexes]= TrialGenerator_QuartetAM (Exp,inFileName)'};
Exp.postExpFuncs = {};

%% Additional parameters for the experiment, especially parameters in the 
%% array format.
% Target stimuli Parameters
Exp.addParams.frequencyInHz= {'10Hz' '10Hz' '20Hz' '25Hz'};
Exp.addParams.frequency={[5 5 5 5] [5 5 5 30] [5 5 5 30] [ 5 5 5 5]}; % IN FRAMES, CHECK ALWAYS WITH THE REFRESH
Exp.addParams.nRepetitions= [5 5 6 6]; %number of repetitions for each frequency cycle
Exp.addParams.frequencyTags={'Horizontal Bidirectional' 'Horizontal Right' ...
    'Horizontal Left' 'Vertical'}; % Code for the txt file.

% Mask parameters
Exp.addParams.maskContrastValues= {[0.8 1] [0.2 0.4]};
% Inter trial Intervals
Exp.addParams.ITI= [30 60 90]; %in FRAMES

% Grid Parameters
% Exp.addParams.AdaptGrid={[]};
Exp.addParams.TestGrid.topMostCoord= 1;
Exp.addParams.TestGrid.leftMostCoord= 1;
Exp.addParams.TestGrid.dotsX= 2;
Exp.addParams.TestGrid.dotsY= 2;
Exp.addParams.TestGrid.distX= 0.2;
Exp.addParams.TestGrid.distY= 0.2;

% Fixation dot parameters
Exp.addParams.fixDotSize= 5;
Exp.addParams.fixDotContrast= 0.5;
Exp.addParams.fixDotType= 2;

%% Call Leonidas
Experiment= Leonidas (inFileName, Exp);







