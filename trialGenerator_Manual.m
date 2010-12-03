function [Exp] = trialGenerator_Manual(inFileName)


%This function is intended to create a .txt file with the data for an
%experiment. All the flexibility can be obtained by combinig matlab
%experimental design functions with a structure txt file.
%Be creative...

% Changes to be made:
% We feed the function with a .txt
% First row: variables names. We read the names of variables and create those variables inside Exp.Trial using the 'eval' function.
% READ THE PARAMETERS OF THE EXPERIMENT THAT ARE CHANGING FROM TRIAL TO TRIAL AND PREALLOCATE THEM IN MEMORY 
% Get line by line of text file
% firstline = fgetl(fid);
% cellArrayOfFirstLine = textscan(tline, '%s %s %s %f %d %f %f %f %f %s'); %The delimiter by default is 'white space'.

% eval(['Exp.Trial('Trials').'  cellArrayOfFirstLine{i}  '=' '[]' ';']);

% Second row: variable types (s, d, f, etc). We read the variable types of
% each variable. The format
% secondLine = fgetl(fid);


% Third: we just read the data for each variable for each trial

%--------------------------------------------------------------------------

% It should ask for:
% Number of Trials (rows)
% Number of Fields (columns)
% Posible values inside each field (factors for columns)
% Values that might adopt the field
% It should receive a matrix as parameter with all trial definitions:
% Trial Factors (FullFact).
% The user should define a priori all the fields inside each trial and then
% fill it with the appropriate parameters.


%--------------------------------------------------------------------------
%=================
% SOME PARAMETERS:
%=================
%Param.NumberofTrials

%TIME PARAMETERS:
%Param.StimuliDuration (the duration of the BR condition in frames, in multiples of 100?)
%Param.ITIDuration
%Param.BlankScreenDuration
%Param.FixationCrossDuration

%STIMULI PARAMETERS
%Param.StimuliSize (in pixels or in degrees?)
%Param.StimuliLocation (in pixels or in degrees from central fixation?)
%CHECK JENS FUNCTION TO CONVERT FROM ONE TO ANOTHER.

%RESPONSE PARAMETERS AND PORT WRITING: USE DATA AQCUISITION TOOLBOX
%Param.PortCodeToWrite
%Param.CorrectResponse
%Param.ActualResponse

% The function should return a .txt file with all Trial definitions and a
% structure with all these values to be used in the Main experiment code.

%--------------------------------------------------------------------------

%=========================================
%CREATE THE EXPERIMENT STRUCTURE
%=========================================

%ASK FOR SUBJECT'S NAME:
SubjectName= input('Please enter subject name:\t"\n', 's');

% CALCULATE THE TOTAL NUMBER OF TRIALS OF THE EXPERIMENT
Trials= 0;
fid=fopen(inFileName);
while 1
    tline = fgetl(fid);
    if ~ischar(tline), sprintf('Total number of Trials: %3d', Trials), break, end;
    Trials= Trials + 1;
end
fclose(fid);


%PARAMETERS FOR THE STRUCTURE THAT DO NOT CHANGE FROM TRIAL TO TRIAL
Exp.Trial(Trials).Name = 'motionCFS';
Exp.Trial(Trials).Date = datestr(now);
Exp.Trial(Trials).SubjectName=  SubjectName;
Exp.Trial(Trials).TrialCode= [];
Exp.Trial(Trials).Type= []; %target absent or target present
Exp.Trial(Trials).Class= []; %Animal or Tool
Exp.Trial(Trials).StimuliName= [];
Exp.Trial(Trials).ITI= []; %One value out of a range of values
% Exp.Trial(Trials).Textures= [];
% Exp.Trial(Trials).TexturesPointers= [];
Exp.Trial(Trials).TexturesDuration= []; %In frames at 75HZ
%38Tics 507ms =cross, 75tics 1000ms = target, 75tics 1000ms = BlankResponse, 38tics 506ms =Blank
Exp.Trial(Trials).PortValue=[];
Exp.Trial(Trials).imdata= [];
Exp.Trial(Trials).CorrectResponse= []; % Y o N
Exp.Trial(Trials).ActualResponse= [];
Exp.Trial(Trials).RT= [];
Exp.Trial(Trials).DiscActualResponse= [];
Exp.Trial(Trials).DiscRT= [];
Exp.Trial(Trials).ContrastUsed= [];

%Inter trial Intervals
ITI= []; %One value out of a range of values. In FRAMES
%---------------------------
%START READING THE .txt FILE
%---------------------------
fid = fopen(inFileName);
for i=1:Trials

    %Get line by line of text file
    tline = fgetl(fid);
    C = textscan(tline, '%s %s %s %f %d %f %f %f %f %s'); %The delimiter by default is 'white space'.

    %GENERAL PARAMETERS
    Exp.Trial(i).Name = 'CFS';
    Exp.Trial(i).Date = datestr(now);
    Exp.Trial(i).SubjectName=  SubjectName;

    %STIMULI PARAMETERS
    %Define type of Trial: Target Absent or Target Present
    Exp.Trial(i).Type= char(C{1});
    %Class: Tools or Animal
    Exp.Trial(i).Class= char(C{2});
    %Store name of the Trial Stimuli
    Exp.Trial(i).StimuliName= char(C{3});
    %Store code of trial for later identifying epochs
    Exp.Trial(i).TrialCode= C{9};
    
    %TIMING PARAMETERS
    %Randomly choose one of the ITIs
    random= randperm(length(ITI));       
    Exp.Trial(i).ITI= ITI(random(1));
    Exp.Trial(i).TexturesDuration= C{4}; %In Frames.
    Exp.Trial(i).PortValue= C{5};
    Exp.Trial(i).imdata= uint8(zeros(150,150,3));
    %RESPONSE PARAMETERS
    Exp.Trial(i).CorrectResponse= char(C{end});
    % 'j' is used for 'empty' Trials
    % 'k' is used for Stimuli trials
    Exp.Trial(i).ContrastUsed= [C{6}, C{7}, C{8}];    
    

end


%Close file pointer
fclose('all')





%%


%HOW TO READ A TXT FILE
%======================
% fid = fopen('Test.txt')
% tline = fgetl(fid)
% C = textscan(tline, '%s %s') %The delimiter by default is white space.
% fclose('all')





