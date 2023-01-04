% retrieves the images from the test set and stores them in an
% ImageDatastore, associating the right label to each of them

function imds = load_testset()

    train_info = readtable("..\annot\val_info.csv");
    train_info.Properties.VariableNames = {'image_name', 'label'};
    train_info = sortrows(train_info);
    
    labels = categorical(uint8(table2array(train_info(:,2))));

    imds = imageDatastore("..\val\val_set\", ...
        "IncludeSubfolders", false, ...
        "labels", labels);

end