function printPsychtoolboxScreen (win, name, outDir)

% Take a snapshot of the actual psychtoolbox scren and save on disk

% win: pointer to onscreen psychtoolbox
% name: choose a name to save the file
% outDir: path where the image is saved

%outDir= '/home/lisandro/Desktop/';

A=Screen('GetImage' , win);
fig= figure();
set(fig, 'PaperPositionMode', 'auto', 'Visible', 'on')
set(fig, 'InvertHardcopy', 'off')
imshow(A);
Screen('Close', win)
print(fig,'-dpng','-loose', [outDir name])
WaitSecs(0.5)

% close(fig)

>>>>>>> 260bf164dc22ff69495efa4c2590e88571e9c90b
