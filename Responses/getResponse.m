function [responseTime, ActualResponse]= getResponse(rtStartTime)

%GET RESPONSE
        while (1) 
            [keyIsDown, T, keyCode ] = KbCheck;            
            if  (keyIsDown)
                time= GetSecs; %Actual time of the response
                ActualResponse= KbName(keyCode);
                responseTime= time - rtStartTime;
                
                putvalue(dio,data);
                WaitSecs(0.002);
                putvalue(dio,0);
                break;                
            end
            %wait 4ms among each KbCheck to avoid 'overheating'
            WaitSecs(0.005); 
        end
        
        
        
%% the old code inside the main function

%          waitTime=0; % interval of time to check for a response inside each flip
%             while (waitTime < (Exp.Cfg.MonitorFlipInterval-0.005) && RTflag==0)
%                 [keyIsDown, T, keyCode ] = KbCheck;
%                 if  (keyIsDown)
%                     time3= GetSecs; %Actual time of the response
%                     Exp.Trial(m).ActualResponse= KbName(keyCode);
%                     Exp.Trial(m).RT= time3 - time2;
%                     RTflag=1;
%                     %ADD TRIGGERS HERE IF NECESARY
%                     break;
%                 end
%                 %wait 2ms in between each KbCheck to avoid 'overheating'
%                 WaitSecs(0.002);
%                 leavingTime= GetSecs;
%                 waitTime= leavingTime - VBLTimestamp;
%             end
%         
