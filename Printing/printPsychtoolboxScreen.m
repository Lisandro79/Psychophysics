function printPsychtoolboxScreen (win, name)

outDir= '/home/lisandro/Desktop/';
% name= 'BlankScreen';

A=Screen('GetImage' , win);
fig= figure();
set(fig, 'PaperPositionMode', 'auto', 'Visible', 'on')
set(fig, 'InvertHardcopy', 'off')
imshow(A);
Screen('Close', win)
print(fig,'-dpng','-loose', [outDir name])
WaitSecs(0.5)
% return

% close(fig)
% WaitSecs(0.5)
