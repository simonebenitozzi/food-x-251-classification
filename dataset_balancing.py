import pandas as pd
import os
import shutil
import random
from keras.preprocessing.image import ImageDataGenerator

### --- dataset cleaning --- ###

def clean(train_df, incorrect_df, train_dir):

    print("Cleaning ", len(incorrect_df), " images . . .\n\n")

    train_set_dir = train_dir+"train_set/"

    # create folder for incorrect files
    incorrect_dir = train_dir+"train_set_incorrect/"
    if not os.path.exists(incorrect_dir):
        os.makedirs(incorrect_dir)

    # loop through all incorrect files
    for name in incorrect_df["filepaths"]:
        if os.path.exists(train_set_dir+name):

            # move file to folder
            shutil.move(train_set_dir+name, incorrect_dir+name)

            # remove row from dataframe    
            train_df.drop(train_df[train_df['filepaths'] == name].index, inplace = True)

    return train_df

### --- Oversample --- ###

def oversample(df, n, train_dir, img_size):
    
    train_set_dir = train_dir+"train_set/"
    tmp_df=df.copy()
    tmp_df["filepaths"] = train_set_dir+tmp_df["filepaths"]

    target_dir=train_set_dir  # define where to write the images
    
    # create and store the augmented images  
    total=0
    gen=ImageDataGenerator(rescale=1. / 255, 
                                rotation_range = 50,
                                shear_range=0.2,
                                zoom_range=[0.75,1.25],
                                brightness_range=[0.5, 1.5],
                                width_shift_range=0.1,
                                height_shift_range=0.1,
                                horizontal_flip=True)
    
    groups=tmp_df.groupby('labels') # group by class
    
    for label in tmp_df['labels'].unique():  # for every class               
        
        group=groups.get_group(label)  # a dataframe holding only rows with the specified label 
        sample_count=len(group)   # determine how many samples there are in this class  
        
        if sample_count< n: # if the class has less than target number of images
            
            aug_img_count=0
            delta=n - sample_count  # number of augmented images to create
            
            msg='{0:40s} for class {1:^30s} creating {2:^5s} augmented images\n'.format(' ', str(label), str(delta))

            prefix = 'aug-'+str(label).zfill(3)+"-"
            # augmentation parameters
            aug_gen=gen.flow_from_dataframe(group,  
                                            x_col='filepaths', y_col=None, 
                                            target_size=img_size,
                                            class_mode=None, 
                                            batch_size=1, 
                                            shuffle=False, 
                                            save_to_dir=target_dir, 
                                            save_prefix=prefix, 
                                            color_mode='rgb',
                                            save_format='jpg')
            print(msg, end='')
            
            # new images creation
            while aug_img_count<delta:
                images=next(aug_gen)            
                aug_img_count += len(images)
            total +=aug_img_count

            # dataframe updating
            for file in os.listdir(target_dir):
                if file.startswith(prefix):
                    df.loc[df.index.max()+1] = [file, label]

    print('Total Augmented images created= ', total)
    return df
    
### --- Undersample --- ###

def undersample(df,n,train_dir):

    train_set_dir = train_dir+"train_set/"
    undersampled_dir = train_dir+"undersampled/"

    # create folder for undersampled files
    if not os.path.exists(undersampled_dir):
        os.makedirs(undersampled_dir)

    tmp_df=df.copy()
    path_prefix = train_set_dir
    tmp_df["filepaths"] = path_prefix+tmp_df["filepaths"]

    total=0
    groups=tmp_df.groupby('labels') # group by class
    
    for label in tmp_df['labels'].unique():  # for every class               
        
        group=groups.get_group(label)  # a dataframe holding only rows with the specified label 
        sample_count=len(group)   # determine how many samples there are in this class  

        if sample_count > n: # if the class has more than target number of images
            
            delta = sample_count - n  # number of images to remove
            total = total+delta

            msg='{0:40s} for class {1:^30s} removing {2:^5s} images\n'.format(str(sample_count)+' images found', str(label), str(delta))
            print(msg, end='')

            filepaths_to_remove = random.sample(list(group["filepaths"]), delta)

            for path in filepaths_to_remove:
                
                name = path.replace(path_prefix, "")
                shutil.move(path, undersampled_dir+name)
                df.drop(df[df['filepaths'] == name].index, inplace = True)

    print('Total images removed= ', total)
    return df
   
### --- Script --- ###

treshold=500 #number of samples in each class
img_size=(224,224) # size of augmented images
train_dir = "./train/"
lens=[]

train_df = pd.read_csv("./annot/train_info.csv", header=None)
train_df.columns = ["filepaths", "labels"]

incorrect_df = pd.read_csv("./annot/train_incorrect.csv", header=None)
incorrect_df.columns = ["filepaths"]

lens.append(len(train_df)) # initial len

train_df=clean(train_df, incorrect_df, train_dir)
lens.append(len(train_df)) # after cleaning

train_df=oversample(train_df, treshold, train_dir, img_size)
lens.append(len(train_df)) # after oversampling

train_df=undersample(train_df, treshold, train_dir)
lens.append(len(train_df)) # after undersampling (final)


print("Images before execution: ", lens[0])
print("Images after cleaning: ", lens[1])
print("Images after oversampling: ", lens[2])
print("Final images count: ", lens[3], "\n\t[Expected: ", treshold*251, "]")

train_df.to_csv("./annot/train_balanced_info.csv", index=False, header=None)