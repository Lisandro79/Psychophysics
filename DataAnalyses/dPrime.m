function [dPrime, TPR, FPR, accuracy]= dPrime (TP, TN, FP, FN)

% Calculates d'Prime and Plots ROC curves (optional).
% The function receives as parameters TP, TN, FP & FN. Also we need to
% specify label of the condition we want to plot. This is 'Condition', for
% example, a contrast value of 0.5

TPR= TP / (TP + FN);
disp(['TPR:  ' num2str(TPR)])
FPR= FP / (FP + TN);
disp(['FPR:  ' num2str(FPR)])
accuracy= (TP + TN) / (TP + FN + TN + FP);
disp(['accuracy:  ' num2str(accuracy)])

% D PRIME CALCULATION
% Neither TPR nor FPR can be 0 or 1 (if so, adjust slightly up or down)
if (TPR==0)
    TPR=0.01;
elseif (TPR==1)
    TPR= 0.99;
end

if (FPR==0)
    FPR=0.01;
elseif (FPR==1)
    FPR= 0.99;
end

%Calculate the d'Prime
dPrime= icdf('Normal', TPR, 0, 1) - icdf('Normal', FPR, 0, 1);
fprintf('d''Prime is %2f \n \n', dPrime);


% figure;
% Contrast = num2str(Condition*100);
% annotation('textbox',[0 0.94 0.98 0.04], 'String',['Receiver Operating Characteristic -ROC-. Contrast: ' Contrast '%' ], ...
%     'FontSize', 12, 'FontWeight', 'Bold','LineStyle','none','HorizontalAlignment', 'center','FitHeightToText','off');
% axis([0 1 0 1]);
% x=(0:0.1:1);
% y= x;
% plot(x,y, 'LineStyle', '--', 'LineWidth', 0.2)
% xlabel('False Alarm Rate', 'fontsize',12,'fontweight','b')
% ylabel('Hit Rate','fontsize',12,'fontweight','b')
% hold on
% plot(FPR,TPR, 'r*', 'MarkerSize', 11)

