function displayFiles(files)

%% Displays all the files names contained in the structure. Useful to check the files that are being loaded

for m=1:length(files)
   disp( files(m).name)
end
