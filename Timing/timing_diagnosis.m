function timing_diagnosis(expinfo, Cfg)

%TRIAL BY TRIAL COMPARISON OF REQUESTED AND ELAPSED TIMES FOR EACH PAGE
nTrials = length(expinfo);

for i = 1:nTrials

    ti = expinfo(i).timing(1:end, :);  %.timing(1:end-1, :); 
%     req = ti(1:end-1, 1);  %ti(1:end-1, 1);
%     perf = diff(ti(:, 2))*Cfg.FrameRate; %
    
     pageDurationPerformed_ms = diff(ti(:, 2)-ti(1, 2)) *1000 ; %
     pageDurationRequested_ms = ti(1:end-1, 1)*Cfg.MonitorFlipInterval*1000;

     %THIS IS EITHER A BUG IN LOGGING OR IN THE EXPERIMENT, CHECK IT!
     %pageDurationPerformed_ms(end) = pageDurationPerformed_ms(end) + pageDurationRequested_ms(end-1); %DON'T KNOW WHY, LOGGING SEEMS TO FORGET THE STIMULUS DURATION

     deltams = pageDurationPerformed_ms - pageDurationRequested_ms;

     deltamat(i, 1:length(deltams)) = deltams(:)'; %#ok
%      x = [pageDurationRequested_ms(:), pageDurationPerformed_ms(:), pageDurationPerformed_ms(:) - pageDurationRequested_ms(:), deltams];
%     deltaframes = (req - perf);%/expinfo.cfg.FrameRate*1000;
%     deltams = (req - perf)/Cfg.FrameRate*1000;
%     deltamat(i, 1:length(deltams)) = deltams(:)';
%  
%     x = [req, perf, deltaframes, deltams];

end

figure
surf(deltamat)
shading interp
xlabel('Page Number')
ylabel('Trial Number')
zlabel('Deviation [ms]')
title('Timing Accuracy of Experiment')


