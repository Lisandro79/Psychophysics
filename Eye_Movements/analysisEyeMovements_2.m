function out = analysisEyeMovements_2 (filename,triggers, eye_used)

% input:
%     filename: ascii eyelink output
%     triggers: cell array with the first two strings: start & end trial triggers
%               further triggers are added subsequently;
%     eye_used: string containing 'L', 'R' or 'B' (this is still experimental)
% output:
%     structure 'out' with fields:
%           dataFrame: trials x events x event information x event type (1 fixation, 2 saccade)
%           triggers: trials x triggers onset times
%           triggersName: trials x trigger name excluding start and end triggers
%
% EXAMPLE CALL:
% filename = '11.asc';
% triggers = [{'startTrial'} {'endTrial'} {'reqSaccade'} {'line'}];
% out = analysisEyeMovements_2(filename,triggers);

% HISTORY

% 28/12/2011 LK

% Main changes with respect to the previous script
% - Renamed variables from saccade to events
% - Now the function collects saccades and fixations
% - Added the parameter to select what eye to analyze (still missing
% binocular).

% Todo
% Code the position of the eye recorded, ampitude, etc for the special
% triggers

try
    
    startTrialLine = triggers{1};
    endTrialLine = triggers{2};
    nExtraTriggers = length(triggers) - 2;
    
    fid = fopen(filename);
    trialID = 1;
    flagEvent = 0;
    line = 0;
    tr_line = 1;
    timing = zeros(500*60*50, 5); % preallocate ~50 minutes of recording
    
    while 1
        
        tline = fgetl(fid);
        line = line + 1;
        if ~ischar(tline),
            break;
        end
        nEvents = 0;
        
        % BEGINNING OF TRIAL
        if ~isempty(strfind(tline, [startTrialLine ' ' num2str(trialID)] ) )
            
            sprintf('Trial :  %3.0f', trialID)
            
            string = textscan(tline, '%s %n %s %n %n %s');
            triggersStartTrial(trialID, 1) = string{2};
            triggersTrialNumber(trialID, 1) = string{4};
            
            tr_event = {};
            tr_ev_counter = 1;
            
            % SEARCH UNTIL WE REACH THE TRIGGER THAT ENDS THE TRIAL
            while (1)
                
                tline = fgetl(fid);
                line = line + 1;
                
                % Collect eye position of every samples that is not an eyelink event
                if isempty(strfind(tline, ['EFIX ' eye_used])) && isempty(strfind(tline, ['SFIX ' eye_used])) && ...
                        isempty(strfind(tline, ['ESACC ' eye_used])) && isempty(strfind(tline, ['SSACC ' eye_used])) && ...
                        isempty(strfind(tline, ['EBLINK ' eye_used])) && isempty(strfind(tline, ['SBLINK ' eye_used])) && ...
                        isempty(strfind(tline, 'endTrial')) && ...
                        isempty(strfind(tline, ['EFIX ' 'R'])) && isempty(strfind(tline, ['SFIX ' 'R'])) && ...
                        isempty(strfind(tline, ['ESACC ' 'R'])) && isempty(strfind(tline, ['SSACC ' 'R'])) && ...
                        isempty(strfind(tline, ['EBLINK ' 'R'])) && isempty(strfind(tline, ['SBLINK ' 'R'])) && ...
                        isempty(strfind(tline, 'endTrial'))
                    
                    string = textscan(tline, '%n %n %n %n %n %n %n');
                    
                    % Trial, Time, X pos, Y pos, Pupil Size:
                    timing (tr_line, 1) = trialID;
                    timing (tr_line, 2) = string{1} - triggersStartTrial(trialID, 1);
                    
                    % Check when the eye is missing and pad with zeros
                    if isempty(string{2}) && isempty(string{3}) || isempty(string{5}) && isempty(string{6})
                        timing (tr_line, 3) = 0;
                        timing (tr_line, 4) = 0;
                        timing (tr_line, 5) = 0;
                    else
                        timing (tr_line, 3) = string{2};
                        timing (tr_line, 4) = string{3};
                        timing (tr_line, 5) = string{7};
                    end
                    
                    tr_line = tr_line + 1;
                end
                
                               
                % COLLECT FIXATIONS
                if ~isempty(strfind(tline, ['EFIX ' eye_used]))
                    
                    flagEvent = 1;
                    string = textscan(tline,'%s %s %n %n %n %n %n %n');
                    nEvents = nEvents + 1;
                    
                    %                COLLECT DATA: [ onset time, offset time, duration -ms-, average x position,
                    %                average y position, average pupil size]
                    if ~isempty(string{3})
                        dataFrame(trialID, nEvents, 1) = string{3}; %#ok<*AGROW> onset time
                    else
                        dataFrame(trialID, nEvents, 1) = 0; % onset time
                    end
                    
                    if ~isempty(string{4})
                        dataFrame(trialID, nEvents, 2) = string{4}; % offset time
                    else
                        dataFrame(trialID, nEvents, 2) = 0; % offset time
                    end
                    
                    if ~isempty(string{5}); % duration
                        
                        % Check that the fixation hasn't started before the
                        % image appeared on the screen. Correct the duration
                        % if so
                        if dataFrame(trialID, nEvents, 1) ~= 0 && ...
                                dataFrame(trialID, nEvents, 1) < triggersStartTrial(trialID, 1)
                            % we calculate only the duration from the beginning
                            % of the trial for the first fixation
                            dataFrame(trialID, nEvents, 3) = string{4} - triggersStartTrial(trialID, 1);
                        else
                            dataFrame(trialID, nEvents, 3) = string{5}; % duration -ms-
                        end
                        
                    else
                        dataFrame(trialID, nEvents, 3) = 0; % duration
                    end
                    
                    if ~isempty(string{6})
                        dataFrame(trialID, nEvents, 4) = string{6}; % average x position
                    else
                        dataFrame(trialID, nEvents, 4) = 0; % average x position
                    end
                    
                    if ~isempty(string{7})
                        dataFrame(trialID, nEvents, 5) = string{7}; % average y position
                    else
                        dataFrame(trialID, nEvents, 5) = 0; % average y position
                    end
                    
                    if ~isempty(string{8})
                        dataFrame(trialID, nEvents, 6) = string{8}; % average pupil size
                    else
                        dataFrame(trialID, nEvents, 6) = 0; % average pupil size
                    end
                    
                end
                
                
                % COLLECT EXTRA TRIGGER ONSETS AND TRIGGER NAMES
                for x = 1:nExtraTriggers
                    triggersCounter = x + 2;
                    if ~isempty(strfind(tline,triggers{triggersCounter}))
                        string = textscan(tline,'%s %n %s %n %s');
                        triggersOnset(trialID,x) = string{2};
                        triggersName(trialID,x) = string{5};
                    end
                end
                
                
                
                 % Collect the sequence of events 
                 if ~isempty(strfind(tline, ['EFIX ' eye_used])) || ~isempty(strfind(tline, ['SFIX ' eye_used])) || ...
                         ~isempty(strfind(tline, ['ESACC ' eye_used])) || ~isempty(strfind(tline, ['SSACC ' eye_used])) || ...
                         ~isempty(strfind(tline, ['EBLINK ' eye_used])) || ~isempty(strfind(tline, ['SBLINK ' eye_used]))  || ...
                         ~isempty(strfind(tline, endTrialLine))
                    
                    string = textscan(tline,'%s');
                    tr_event{tr_ev_counter} = string{1};
                    tr_ev_counter = tr_ev_counter + 1;
                    
%                     tr_event_data{tr_ev_counter} = [];                 
%                     % collect the info for the end of saccade
%                     if isempty(strfind(tline, ['ESACC ' eye_used])) 
%                         string = textscan(tline,'%s %s %n %n %n %n %n %n %n %n %n');
%                         tr_event_data{tr_ev_counter} = string;
%                     end
                    
                end
                
                % END OF TRIAL: COLLECT LAST FIXATION (only for the experiment
                % here)
                if ~isempty(strfind(tline, endTrialLine))
                    
                   if length(tr_event) >= 2 % Check that there are enough events
                        if strcmp( 'SFIX', tr_event{end-1}{1}) % and that the last event before ending the trial was an ongoing fixation
                            
                            nEvents = nEvents + 1;
                            dataFrame(trialID, nEvents, 1) = str2double(tr_event{end-2}{4}); %#ok<*AGROW> onset time
                            dataFrame(trialID, nEvents, 2) = str2double(tr_event{end}{2}); % offset time
                            dataFrame(trialID, nEvents, 3) = dataFrame(trialID, nEvents, 2) - dataFrame(trialID, nEvents, 1);
                            %  x position -when the saccade ended, not the
                            %  average as before-
                            dataFrame(trialID, nEvents, 4) = str2double(tr_event{end-2}{8}); 
                            dataFrame(trialID, nEvents, 5) = str2double(tr_event{end-2}{9}); 
                            dataFrame(trialID, nEvents, 6) = nan; % there is no info for pupil size
                        end
                    end
                    
                    break; % go to next trial
                end
                
            end
            
            
            % Sort triggers by onset time
            if nExtraTriggers > 0
                [~, idxs]= sort ( triggersOnset(triggersOnset(trialID,:) > 0) );
                triggersName(trialID, 1:length(idxs))= triggersName(trialID,idxs) ;
                
            end
            
            string = textscan(tline,'%s %n %s %n %n %s');
            triggersEndTrial(trialID,1) = string{2};
            
            % In case no events are recorder during the trial,
            % then pad the trial matrix with zeros;
            if flagEvent == 0
                dataFrame(trialID,:,:) = 0;
            end
            
            output(trialID,1) = trialID; %trialCounter
            output(trialID,2) = nEvents; % nEvents performed after requested signal
            
            trialID = trialID + 1;
            
            flagEvent = 0;
        end
        
    end
    
    
    fclose(fid);
    
    out.dataFrame = dataFrame;
    if nExtraTriggers > 0
        triggersOnset = cat(2,triggersStartTrial,triggersEndTrial,triggersTrialNumber,triggersOnset);
        out.triggersName = triggersName;
    else
        triggersOnset = cat(2,triggersStartTrial,triggersEndTrial,triggersTrialNumber);
    end
    out.triggers = triggersOnset;
    
    % return only the valid data in timing
    timing = timing(timing(:,1) > 0, :);
    out.timing = timing;
    
catch ME1
    rethrow(ME1)
end




%%
%             % SACCADES
%             if ~isempty(strfind(tline, ['ESACC ' eye_used]))
%
%                 flagEvent = 1;
%                 string = textscan(tline,'%s %s %n %n %n %n %n %n %n %n %n');
%                 nEvents = nEvents + 1;
%
%                 % COLLECT DATA
%                 if ~isempty(string{10})
%                     dataFrame(trialID,nEvents,1) = string{10}; %#ok<*AGROW> % amplitude
%                 else
%                     dataFrame(trialID,nEvents,1) = 0;% amplitude
%                 end
%                 if ~isempty(string{5}); % duration
%                     dataFrame(trialID,nEvents,2) = string{5}; % duration
%                 else
%                     dataFrame(trialID,nEvents,2) = 0; % duration
%                 end
%                 if ~isempty(string{11})
%                     dataFrame(trialID,nEvents,3) = string{11};% peak velocity
%                 else
%                     dataFrame(trialID,nEvents,3) = 0;% peak velocity
%                 end
%                 if ~isempty(string{3})
%                     dataFrame(trialID,nEvents,4) = string{3}; % onset time
%                 else
%                     dataFrame(trialID,nEvents,4) = 0; % onset time
%                 end
%                 if ~isempty(string{4})
%                     dataFrame(trialID,nEvents,5) = string{4}; % offset time
%                 else
%                     dataFrame(trialID,nEvents,5) = 0; % offset time
%                 end
%                 if ~isempty(string{8})
%                     dataFrame(trialID,nEvents,6) = string{8}; % esacc end x position
%                 else
%                     dataFrame(trialID,nEvents,6) = 0; % esacc end x position
%                 end
%                 if ~isempty(string{9})
%                     dataFrame(trialID,nEvents,7) = string{9}; % esacc end y position
%                 else
%                     dataFrame(trialID,nEvents,7) = 0; % esacc end y position
%                 end
%                 if ~isempty(string{6})
%                     dataFrame(trialID,nEvents,8) = string{6}; % esacc start x position
%                 else
%                     dataFrame(trialID,nEvents,8) = 0; % esacc start x position
%                 end
%                 if ~isempty(string{7})
%                     dataFrame(trialID,nEvents,9) = string{7}; % esacc start y position
%                 else
%                     dataFrame(trialID,nEvents,9) = 0; % esacc start y position
%                 end
%
%             end
