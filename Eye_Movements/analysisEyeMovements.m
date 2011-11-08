function out = analysisEyeMovements(filename,triggers)

% input: 
%     filename: ascii eyelink output
%     triggers: cell array with the first two strings: start & end trial triggers
%               further triggers are added subsequently;
% output:
%     structure 'out' with fields:
%           saccadeDataFrame: trials x saccades x saccades information  
%           triggers: trials x triggers onset times
%           triggersName: trials x trigger name excluding start and end triggers
% EXAMPLE CALL:
% filename = '11.asc';
% triggers = [{'startTrial'} {'endTrial'} {'reqSaccade'} {'line'}];
% out = analysisEyeMovements(filename,triggers);


startTrialLine = triggers{1};
endTrialLine = triggers{2};
nExtraTriggers = length(triggers)-2;

fid = fopen(filename);
trialID = 1;
flagSaccade = 0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break
    end
    nSaccades = 0;
    %     if trialID <= size(startTimeCorrect,2)
    if ~isempty(strfind(tline,startTrialLine))
        string = textscan(tline,'%s %n %s %n %n %s');
        triggersStartTrial(trialID,1) = string{2}; 
        while isempty(strfind(tline,endTrialLine))
            tline = fgetl(fid);
            if ~isempty(strfind(tline,'ESACC'))
                flagSaccade = 1;
                string = textscan(tline,'%s %s %n %n %n %n %n %n %n %n %n');
                nSaccades = nSaccades + 1;
                
                % COLLECT DATA
                if ~isempty(string{10})
                    saccadeDataFrame(trialID,nSaccades,1) = string{10};%#ok<*AGROW> % amplitude
                else
                    saccadeDataFrame(trialID,nSaccades,1) = 0;% amplitude
                end
                if ~isempty(string{5}); % duration
                    saccadeDataFrame(trialID,nSaccades,2) = string{5}; % duration
                else
                    saccadeDataFrame(trialID,nSaccades,2) = 0; % duration
                end
                if ~isempty(string{11})
                    saccadeDataFrame(trialID,nSaccades,3) = string{11};% peak velocity
                else
                    saccadeDataFrame(trialID,nSaccades,3) = 0;% peak velocity
                end
                if ~isempty(string{3})
                    saccadeDataFrame(trialID,nSaccades,4) = string{3}; % onset time
                else
                    saccadeDataFrame(trialID,nSaccades,4) = 0; % onset time
                end
                if ~isempty(string{4})
                    saccadeDataFrame(trialID,nSaccades,5) = string{4}; % offset time
                else
                    saccadeDataFrame(trialID,nSaccades,5) = 0; % offset time
                end
                if ~isempty(string{8})
                    saccadeDataFrame(trialID,nSaccades,6) = string{8}; % esacc end x position
                else
                    saccadeDataFrame(trialID,nSaccades,6) = 0; % esacc end x position
                end
                if ~isempty(string{9})
                    saccadeDataFrame(trialID,nSaccades,7) = string{9}; % esacc end y position
                else
                    saccadeDataFrame(trialID,nSaccades,7) = 0; % esacc end y position
                end
                if ~isempty(string{6})
                    saccadeDataFrame(trialID,nSaccades,8) = string{6}; % esacc start x position
                else
                    saccadeDataFrame(trialID,nSaccades,8) = 0; % esacc start x position
                end
                if ~isempty(string{7})
                    saccadeDataFrame(trialID,nSaccades,9) = string{7}; % esacc start y position
                else
                    saccadeDataFrame(trialID,nSaccades,9) = 0; % esacc start y position
                end
            end
            
            % COLLECT TRIGGER ONSETS AND TRIGGER NAMES
            for x = 1:nExtraTriggers
                triggersCounter = x+2;
                if ~isempty(strfind(tline,triggers{triggersCounter}))
                    string = textscan(tline,'%s %n %s %n %s');
                    triggersOnset(trialID,x) = string{2};
                    triggersName(trialID,x) = string{5};                    
                end
            end
%             triggersCounter = 0;
        end
        
          
        % Sort triggers by onset time
        [~, idxs]= sort ( triggersOnset(triggersOnset(trialID,:) > 0) );
        triggersName(trialID, 1:length(idxs))= triggersName(trialID,idxs) ;
        
        
        string = textscan(tline,'%s %n %s %n %n %s');
        triggersEndTrial(trialID,1) = string{2}; 
        % In case no saccades are pefrormed during the trial, 
        % then pad the trial matrix qith zeroes;
        if flagSaccade == 0 
            saccadeDataFrame(trialID,:,:) = 0;
        end
        output(trialID,1) = trialID; %trialCounter
        output(trialID,2) = nSaccades; % nSaccades performed after request saccade signal
        trialID = trialID + 1;
        flagSaccade = 0;
    end
   
end
fclose(fid);

out.saccadeDataFrame = saccadeDataFrame;
if nExtraTriggers > 0
    triggersOnset = cat(2,triggersStartTrial,triggersEndTrial,triggersOnset);
else
    triggersOnset = cat(2,triggersStartTrial,triggersEndTrial);
end
out.triggers = triggersOnset;
out.triggersName = triggersName;

