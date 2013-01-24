function runExp


% Main function to run the experiment

try

    
    %% GENERAL PARAMETERS OF THE EXPERIMENT
    
%     Exp.Gral.SubjectName= input('Please enter subject ID:\n', 's');
%     Exp.Gral.SubjectNumber= input('Please enter subject number:\n');
%     Exp.Gral.SubjectBlock= input('Please enter block number:\n');
%     Exp.Gral.BlockName= input('Block name:\n','s');
%     Exp.Gral.Triggers.option= input('Do you want to send Triggers?:\n');
    
    Exp.Gral.SubjectName = 'test5';
    Exp.Gral.SubjectNumber = 4;

   
%     PsychJavaTrouble; % Check there are no problems with Java
    Exp.Cfg.SkipSyncTest = 0; %This should be '0' on a properly working NVIDIA video card. '1' skips the SyncTest.
    Exp.Cfg.AuxBuffers= 1; % '0' if no Auxiliary Buffers available, otherwise put it into '1'.
    % Check for OpenGL compatibility
    AssertOpenGL;
    Screen('Preference','SkipSyncTests', Exp.Cfg.SkipSyncTest);
    
    Exp.Cfg.WinSize= [];  %Empty means whole screen
    Exp.Cfg.WinColor= []; % empty for the middle gray of the screen.
    
    Exp.Cfg.xDimCm = 40; %Length in cm of the screen in X
    Exp.Cfg.yDimCm = 30; %Length in cm of the screen in Y
    Exp.Cfg.distanceCm = 75; %Viewing distance
    
    Exp.addParams.witheye = 0;
    
    %% INITIALYZE SCREEN
    Exp = initializeScreen (Exp);
    
     %% INITIALIZE EYELINK
    if Exp.addParams.witheye
        Exp = init_eyelink (Exp); 
    end
    
    %% SHOW TRIALS
    for tr = 1 : length(Exp.Trial)
        Exp = show_trials(Exp); 
    end    

     %% End of experiment
    Screen('FillRect',  Exp.Cfg.win, Exp.Cfg.Color.inc);
    text = sprintf('End of Experiment. Thanks for participating' );
    Screen('DrawText', Exp.Cfg.win, text, Exp.Cfg.centerX - 200, Exp.Cfg.centerY, [0 0 255]);
    Screen('Flip', Exp.Cfg.win,  [], Exp.Cfg.AuxBuffers);
    WaitSecs(2);
    
    
    %% SAVE RESULTS
    endTime = GetSecs;
    Exp.ExpTotalDuration = endTime - Exp.Cfg.ExperimentStart;
    sprintf('The experiment lasted:  %5.0f', Exp.ExpTotalDuration)
    % save the results in the current directory
    save(Exp.Gral.SubjectName,'Exp');

  
    %% CLOSE EYELINK CONNECTION
    if Exp.addParams.witheye
        close_eyelink (Exp)
    end 
    
       
    %% CLOSE EVERYTHING
    Priority(0);
    Screen('CloseAll');
    ShowCursor;
    
    
catch ME1
    rethrow(ME1)
end


