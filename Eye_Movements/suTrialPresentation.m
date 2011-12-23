function [flipOnset eyeX eyeY] = suTrialPresentation(params,condition,trial,el)

% el: eyelink structure

fixation(params,condition.end,condition.colEnd,condition);
fixation(params,condition.start,condition.colStart,condition);

waitframes = 1;
vbl = Screen('Flip',params.wPtr);
buttons=[0 0 0];
keyIsDown=0;
keyCode = 66;
while (buttons(2)==0 && keyIsDown==0) % wait for mouse keyPress
    [x y buttons] = GetMouse( params.wPtr );
    waitSecs(0.002);
    [keyIsDown, stop, keyCode] = KbCheck;
    waitSecs(0.002);    
end

keyPressed=KbName(keyCode);
switch params.eyeTrack
    case {1}
        if keyPressed == 'a'
            EyeLinkDoDriftCorrect(el, params.rect(3)/2, params.rect(4)/2, 1, 1);
            fixation(params,condition.end,condition.colEnd);
            fixation(params,condition.start,condition.colStart);
            Screen('Flip',params.wPtr);
            buttons=[0 0 0];
            while (buttons(2)==0) % wait for mouse keyPress
                [x y buttons] = GetMouse( params.wPtr );
            end
        end
end


% eye Tracking
switch params.eyeTrack
    case {1}
        error=0;
        if EYELINK('CheckRecording');
            error=EYELINK('StartRecording');
        end
        WaitSecs(params.monitorFlipInterval*4);
    case {0}
        eyeX = 0;
        eyeY = 0;
        
end
% eye Tracking

% Check which eye is being recorded
if params.eyeTrack == 1
    if Eyelink('EyeAvailable') ~= -1
        eyeAvailable = Eyelink('EyeAvailable') + 1;
    else
        EyeLinkDoDriftCorrect(el, params.rect(3)/2, params.rect(4)/2, 1, 1);
    end
end
switch params.eyeTrack
    case {1}
        EYELINK('message',['TRIALID ',num2str(trial),'_startTrial_']);
end


tempFlag1 = 1;
tempFlag2 = 1;
tempArrow = 1;
for t = 1:params.trialDuration % loop through 1.65 seconds
    
    if ( t >= condition.timeStimuli1(1) && t < condition.timeStimuli1(2))
        stimuli1Flag = 1;
    else
        stimuli1Flag = 0;
    end
    
    if ( t >= condition.timeStimuli2 && t < ( condition.timeStimuli2 + ceil(0.05/params.monitorFlipInterval) ))
        stimuli2Flag = 1;
    else
        stimuli2Flag = 0;
    end
    
    if ( t >= 1 && t < ( ceil(0.5/params.monitorFlipInterval) ))
        arrowFlag = 1;
    else
        arrowFlag = 0;
    end
    
    switch stimuli1Flag            
        case {1}
            Screen('DrawDots',params.wPtr,[condition.x1;condition.y1],params.dotSize,[255 255 255],params.dotCenter,2);            
            switch params.eyeTrack
                case {1}
                    if tempFlag1 == 1
                        EYELINK('message',['TRIALID ',num2str(trial),'_stimuli1_']);
                    end
            end
            tempFlag1 = 0;
    end
    
    switch stimuli2Flag
        case {1}        
            Screen('DrawDots',params.wPtr,[condition.x2;condition.y2],params.dotSize,[255 255 255],params.dotCenter,2);
            switch params.eyeTrack
                case {1}
                    if tempFlag2 == 1
                        EYELINK('message',['TRIALID ',num2str(trial),'_stimuli2_']);
                    end
            end
            tempFlag2 = 0;
    end
    
    switch arrowFlag
        case {1}        
            Screen('DrawText',params.wPtr,condition.arrow,params.rect(3)/2,params.rect(4)/2,[180 180 180]);
            switch params.eyeTrack
                case {1}
                    if tempArrow == 1
                        EYELINK('message',['TRIALID ',num2str(trial),'_arrow_']);
                    end
            end
            tempArrow = 0;
    end
       
    switch t        
        case {condition.timeShiftFixation} % fixation shift
            switch params.saccade
                case {1}
                    condition.colEnd = params.colStart;
                    condition.colStart = params.colEnd;
                    switch params.eyeTrack
                        case {1}
                            EYELINK('message',['TRIALID ',num2str(trial),'_reqSaccade_']);
                    end
            end                
    end

	% Retrieve the latest valid position sample of the eye
    switch params.eyeTrack
        case {1}
            eyeEvent = EYELINK('NewestFloatSample'); 
            eyeX(t) = eyeEvent.gx(eyeAvailable);
            eyeY(t) = eyeEvent.gy(eyeAvailable);

    end
        
    fixation(params,condition.end,condition.colEnd,condition);
    fixation(params,condition.start,condition.colStart,condition);
    flipOnset(t) = Screen('Flip',params.wPtr, vbl+(waitframes-0.5)*params.monitorFlipInterval );
    vbl = flipOnset(t);

end

% eye tracking
switch params.eyeTrack
    case {1}
        EYELINK('message',['TRIALID ',num2str(trial),'_endTrial_']);
        WaitSecs(params.monitorFlipInterval*4);
        EYELINK('stoprecording');
end
% eye tracking

