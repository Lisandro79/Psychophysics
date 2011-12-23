function startSaccadeFlip = speedCheck(eyeX,condition,params)

% Calculate the speed and amplitude of the saccades to assess whether a saccade has just been performed.
% startSaccadeFlip: index of flip when the saccade started


% speed criterion
vel = abs(diff(eyeX( condition.timeShiftFixation : condition.timeShiftFixation+ceil(0.6/params.monitorFlipInterval) )));
vel = vel(vel<300);
startIndx = ( vel*( (1/params.pixperdeg) / params.monitorFlipInterval ) > 80 );
startSaccadeFlip =  find( startIndx > 0 );

% amplitude criterion
M = max(eyeX ( condition.timeShiftFixation : condition.timeShiftFixation+ceil(0.6/params.monitorFlipInterval) ) );
m = min(eyeX ( condition.timeShiftFixation : condition.timeShiftFixation+ceil(0.6/params.monitorFlipInterval) ) );
amp = (M-m)/params.pixperdeg;

% one startSaccadeFlip for static trials and one startSaccadeFlip for moving trials (viewingCondition)
switch params.viewingCondition
    case {1}
        if (~isempty( startSaccadeFlip ) && amp > 5 &&  startSaccadeFlip(1)>5)
            startSaccadeFlip = startSaccadeFlip(1); % return the flip corresponding to the sacc onset time
        else
            startSaccadeFlip = 0; % negative feedback
        end
    case {2}
        if amp < 5
            startSaccadeFlip = 1; %positive feedback
        else
            startSaccadeFlip = 0; % negative feedback
        end
end


