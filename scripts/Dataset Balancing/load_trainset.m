% retrieves the images from the training set and stores them in an
% ImageDatastore, associating the right label to each of them

function imds = load_trainset()

    train_info = readtable("annot\train_balanced_info.csv");
    train_info.Properties.VariableNames = {'image_name', 'label'};
    train_info = sortrows(train_info);
    
    labels = uint8(table2array(train_info(:,2)));

    imds = imageDatastore("train\train_set\", ...
        "IncludeSubfolders", false, ...
        "labels", labels);

end