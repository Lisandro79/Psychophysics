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
% Screen('Close', win)

print(fig,'-djpeg', [outDir name])
close(fig)
WaitSecs(0.5)

% close(fig)

