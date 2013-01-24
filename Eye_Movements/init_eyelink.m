function Exp = init_eyelink (Exp)


% Initialization of the connection with the Eyelink Gazetracker.
% exit program if this fails.
initializedummy=0;
if initializedummy~=1
    if Eyelink('initialize') ~= 0
        fprintf('error in connecting to the eye tracker');
        return;
    end
else
    Eyelink('initializedummy');
end


% Provide Eyelink with details about the graphics environment
% and perform some initializations. The information is returned
% in a structure that also contains useful defaults
% and control codes (e.g. tracker state bit and Eyelink key values).
Exp.eyelink = EyelinkInitDefaults(Exp.Cfg.win);
% Make the calibration background the custom screen colour.
Exp.eyelink.backgroundcolour = Exp.Cfg.Color.inc;

[ ~, vs] = Eyelink('GetTrackerVersion');
fprintf('Running experiment on a ''%s'' tracker.\n', vs );

% open file to record data to
i = Eyelink('openfile', Exp.Gral.SubjectName);
if i ~= 0
    printf('Cannot create EDF file ''%s'' ', Exp.Gral.SubjectName);
    Eyelink( 'Shutdown');
    return;
end


% Calibrate the eye tracker
EyelinkDoTrackerSetup(Exp.eyelink);

% Do a final check of calibration using driftcorrection
EyelinkDoDriftCorrection(Exp.eyelink);


% SET UP TRACKER CONFIGURATION

Eyelink('command', 'add_file_preamble_text ''Stadium Crowds Experiment''');

% Setting the proper recording resolution, proper calibration type,
% as well as the data file content;
Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', Exp.Cfg.windowRect(1),...
    Exp.Cfg.windowRect(2), Exp.Cfg.windowRect(3)-1, Exp.Cfg.windowRect(4)-1);
Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld',  Exp.Cfg.windowRect(1),...
    Exp.Cfg.windowRect(2), Exp.Cfg.windowRect(3)-1, Exp.Cfg.windowRect(4)-1);

% set calibration type.
Eyelink('command', 'calibration_type = HV9');
% Eyelink('command', 'calibration_area_proportion 0.72 0.95');% 0.72265625 0.963541667'; (737*730)
% Eyelink('command', 'validation_area_proportion 0.72 0.95');% 0.72265625 0.963541667'; (737*730)


% THE PARAMETERS BELOW ARE PRESENTED IN WHICH THEY APPEAR ON THE EYELINK
% PROGRAMER'S GUIDE. THE VALUES CAN BE CHECKED THERE FOR OTHER EXPERIMENTS

% SET PARSER (conservative saccade thresholds)
% '0' for cognitive and '1' for psychophysical configurations. SEE MANUAL
Eyelink('command', 'select_parser_configuration = 0') 

% Set EDF file contents
Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,GAZERES,HTARGET,AREA,STATUS');
Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE');

% Set link data 
Eyelink('command', 'link_sample_data  = GAZE,GAZERES,AREA,STATUS');
Eyelink('command', 'link_event_data  = GAZE,GAZERES,AREA,VELOCITY');
Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,FIXUPDATE,SACCADE,BLINK,MESSAGE');


WaitSecs(0.1);

Eyelink('StartRecording', 1, 1, 1, 1); %1 1 1 1 if online samples are needed


Exp.eyelink.eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
if Exp.eyelink.eye_used == 0
    Exp.eyelink.eye_used = 1; % to avoid the initialization problem
else
    Exp.eyelink.eye_used = 2;
end

WaitSecs(0.2);
Eyelink('Message', 'SYNCTIME');

