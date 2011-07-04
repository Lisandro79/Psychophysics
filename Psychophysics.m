function Exp = Psychophysics (inFileName, Exp) %#ok inFileName is Used with eval


% Explain the main purpose of Leonidas: Flexibility and fast building of
% experiments

% Explain the use of the plugIns and the decision on the showTrial function


try 

    %% INITIALYZE SCREEN
    Exp = InitializeScreen (Exp);      
    
    %% Call the plug Ins to generate the trial structure, the textures and to present instructions    
    for m=1:length(Exp.plugIns)
        eval(Exp.plugIns{m});
    end     

    %% PRESENT TRIALS
    %% To avoid the delay of the first loop and the delay in the
    %% preallocation of the functions just present 1 trial for each condition at
    %% the begining of the experiment -and we can later discard these data
    %% from the analysis to allow calibration of the data recording
    HideCursor;
%     ListenChar(0);
    Priority(1); %Set Maximun Priority to Window win
    
    % FIRST vbl= PRESENT BLANK SCREEN and collect time 
    if Exp.Cfg.stereoMode == 0
        Screen('FillRect', Exp.Cfg.win,  Exp.Cfg.Color.gray);
        vbl= Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
    else
        Screen('SelectStereoDrawBuffer', Exp.Cfg.win, 1);  
        Screen('FillRect', Exp.Cfg.win,  Exp.Cfg.Color.gray);
        Screen('SelectStereoDrawBuffer', Exp.Cfg.win, 0);         
        Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.gray);
        Screen('DrawingFinished', Exp.Cfg.win);
        vbl= Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
    end    
    
    % SHOW TRIAL FUNCTIONS
    for m=1:length(Exp.Trial)
        %READ WHAT FUNCTION TO USE FOR EACH TRIAL
        ShowTrials= str2func(Exp.Trial(m).showTrials);
        %PRESENT THE TRIAL: call the respective function for each trial and
        %present the stimuli
        [vbl, Exp]= ShowTrials(Exp,m, vbl);
        %TO ABORT THE PROGRAM PRESS 'Q'
        if (strcmp(Exp.Trial(m).ActualResponse, Exp.addParams.exitKey)),break; end;
    end
    %% SAVE RESULTS
    endTime = GetSecs;
    Exp.ExpTotalDuration = endTime - Exp.Cfg.ExperimentStart;
    disp(Exp.ExpTotalDuration)
    save(Exp.Gral.SubjectName,'Exp');     
    
    %% RUN POST EXPERIMENT CODE (TIMING PLOTS, ANALYZE SOME RESULTS, ETC)
    if ~isempty(Exp.endProgram)
        for m=1:length(Exp.endProgram)
            eval(Exp.endProgram{m});
        end
    end
    
    %% PLot TIME Accuracy
    %     timing_diagnosis(Exp.Synch.Trials, Exp.Cfg)
    %     % Plot the time accuracy results using GetSecs
    %     % This is the time elapsed since the onset of the stimuli at
    %     % the begining of each trial and the onset of the test stimuli
    %     figure;
    %     plot (Exp.Synch.time,'--rs','LineWidth',2,...
    %         'MarkerEdgeColor','k',...
    %         'MarkerFaceColor','g',...
    %         'MarkerSize',10)
    %     xlabel('Trial Number')
    %     ylabel('Duration [Secs]')
    %     title('Timing Accuracy of Stimuli')


    %% Shut down     
    Priority(0);
    Screen('CloseAll');
    sca
    ShowCursor; 
    endTime = GetSecs;
    Exp.ExpTotalDuration = endTime - Exp.Cfg.ExperimentStart;
    disp(Exp.ExpTotalDuration)
%     ListenChar('1');

catch ME1 
    sca;
    rethrow(ME1);
%     rethrow(psychlasterror);
end


%%
%% THE END
%%

%% Todo:

% There is a huge discrepancy between vbl and getsecs. Try a minimal piece
% of code to try to see what's going on there.

%% History

% 01/01/2010. Added the 'when' parameter to the flip inside showTrial. Mario says it helps
% psychtoolbox to control for timing accuracies.

% 09/06/2010. Added the default values inside initializeScreen




%% Examples

% Implement the function for the moving dots
% Implement apparent motion: Vertical and horizontal movements.OK
% Implement the rainy dots here
% Implement the spiral


% Stereo mode: ImagingStereoDemo.m, SetAnaglyphStereoParameters.m,
% StereoMode.txt, PsychColorCorrection()

% Alpha Blending: AlphaDemo, TestAlphaBlending, PsychAlphaBlending,
% DriftingMaskedGrating, AlphaImageDemo

% Monitor Calibration: Psychcal


