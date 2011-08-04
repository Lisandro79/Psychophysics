function printPsychtoolboxScreen (win, name)

outDir= '/home/lisandro/Desktop/';
% name= 'BlankScreen';

A=Screen('GetImage' , win);
fig= figure();
set(fig, 'PaperPositionMode', 'auto', 'Visible', 'on')
set(fig, 'InvertHardcopy', 'off')
imshow(A);
print(fig,'-dpng','-loose', [outDir name])
close(fig)
WaitSecs(1)