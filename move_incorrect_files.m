clc
t = readtable("annot\train_incorrect.csv", ...
    "Delimiter", ",", ...
    "ReadVariableNames", false);
file_names = table2array(t);

if ~isfolder("train\train_set_incorrect\")
    mkdir train\train_set_incorrect\
end

for ii=1:size(file_names)
    file = strcat("train\train_set\", file_names(ii));
    if isfile(file)
        movefile(file, "train\train_set_incorrect\")
    end
end