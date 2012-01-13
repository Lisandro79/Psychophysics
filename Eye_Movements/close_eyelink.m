function close_eyelink (Exp)


% End of Experiment; close the file first
% close graphics window, close data file and shut down tracker
Eyelink('Command', 'set_idle_mode');
WaitSecs(0.5);
Eyelink('CloseFile');
% download data file

try
    fprintf('Receiving data file ''%s''\n', Exp.Gral.SubjectName );
    status = Eyelink('ReceiveFile');
    if status > 0
        fprintf('ReceiveFile status %d\n', status);
    end
    if 2 == exist(Exp.Gral.SubjectName, 'file')
        fprintf('Data file ''%s'' can be found in ''%s''\n', Exp.Gral.SubjectName, pwd );
    end
catch ME1
    fprintf('Problem receiving data file ''%s''\n', Exp.Gral.SubjectName );
    
    rethrow(ME1);
end
%close the eye tracker.
Eyelink('ShutDown');

