function subDataset =dataSubset (Data, groupVariables, groupVariablesConditions)

%% Input the Dataset (rows by nCols)

%% give a vector with the group variables (cell array of nominal arrays) of the dataset (cols) and a
%% vector with the conditions to pick up from those variables (cell array with cell arrays of strings)

%% loop the input vector and check which fields are empty. If empty take
%% all the conditions of the variable using grp2idx.

%% extract the subdataset from the main dataset array

%% return the subset for later statistical processing


%% Example call: 
%% subset = dataSubset (Data, {adapt subjs responses}, {  {'CCMA'} {} {}  })


if length(groupVariables) ~= length(groupVariablesConditions)
    disp('Error: Input Cell arrays must have the same lenght')
    return
end

nVariables= length(groupVariables);
subset = zeros(length(Data),nVariables);
for m=1:nVariables
    if isempty(groupVariablesConditions{m})
        %Take all trials for this condition
        [G,GN] = grp2idx(groupVariables{m});
        subset(:,m) = ismember(groupVariables{m}, GN);
    else
        %Take the spedified conditions for the variable        
        subset(:,m) = ismember(groupVariables{m}, groupVariablesConditions{m});    
    end
end   

%Only consider the data that accomplish the 3 conditions
finalSubset = sum(subset,2);
idxFinalSubset= find(finalSubset == nVariables);
% finalSubset(finalSubset ~= nVariables) = 0;
% finalSubset(finalSubset == nVariables) = 1;

subDataset= Data(idxFinalSubset,:);


