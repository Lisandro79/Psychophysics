function Exp= runStaircase(Exp, m, accuracy, actualContrast)


% If subject was accurate 
if accuracy
    % Increase the number of correct trials
    Exp.addParams.nAccurateTrials= Exp.addParams.nAccurateTrials+1;    
    if Exp.addParams.nAccurateTrials >=  Exp.addParams.nBeforeReversal
        % Decrease contrast if we reached the number of trials required before changing contrast 
        nextContrast=actualContrast-Exp.addParams.stairCaseDecrements;       
    else  % Otherwise keep contrast constant       
        nextContrast=actualContrast;       
    end
    
% If the subject responded wrongly
else
    % Set correct trials to '0'
    Exp.addParams.nAccurateTrials= 0;    
    % Increase contrast
    nextContrast=actualContrast+Exp.addParams.stairCaseDecrements;    
end

% Assign the return contrast value for the next trial
Exp.addParams.StaircaseContrast(m)=nextContrast;
disp(nextContrast);

% Adjust the contrast after certain threshold. This is done to speed up the
% threshold detection.
if Exp.addParams.StaircaseContrast(m) > 0.085
    % 2% of contrast variation until getting to 8% of contrast
    Exp.addParams.stairCaseDecrements= 0.02;
elseif Exp.addParams.StaircaseContrast(m) <= 0.085
    % from 8% variate in stepts of 0.5% contrast
    Exp.addParams.stairCaseDecrements= 0.005;
elseif Exp.addParams.StaircaseContrast(m) <= 0.052
    % from 5 % variate in steps of 0.2% contrast
    Exp.addParams.stairCaseDecrements= 0.0025;
end

% Count the reversals and code them inside isReversal vector
Exp.addParams.accuracies(m)= accuracy;
if m==1
    % Do nothing on the first trial. Just assign the first accuracy
    % It's not a reversal (the first trials cannot be a reversal even if
    % wrong)
    Exp.addParams.isReversal(m) = 0;
else
    % Check whether there is a reversal or not
    if Exp.addParams.accuracies(m)== Exp.addParams.accuracies(m-1)
        %It's not a reversal
        Exp.addParams.isReversal(m) = 0;
    else
        % It's a reversal
        Exp.addParams.isReversal(m) = 1;
    end
end 
 

%% Exit the program if the threshold is estimated
if sum(Exp.addParams.isReversal) > Exp.addParams.nReversals
    Exp.Trial(m).ActualResponse= Exp.addParams.exitKey; %exit the staircase
    Exp.finalContrast= actualContrast;
    disp(['Final contrast value is:  ' num2str(actualContrast)]);
    disp(['Number of trials employed:   ' num2str(m)]);
end


% Exp.addParams.nAccurateTrials = [Exp.addParams.nAccurateTrials 0];
% Exp.addParams.isReversal = Exp.addParams.isReversal + 1;
% nextContrast = actualContrast;
% Exp.addParams.nAccurateTrials=[Exp.addParams.nAccurateTrials Exp.addParams.nAccurateTrials(m)+1];


