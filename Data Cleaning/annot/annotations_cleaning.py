import pandas as pd
import numpy as np


train_df = pd.read_csv("train_info.csv", header=None)
incorrect_df = pd.read_csv("train_incorrect.csv", header=None)

incorrect_list = incorrect_df[0]
train_clean_df = train_df[~train_df[0].isin(incorrect_list)]

### --- len check --- ###

print("Old train-set len: ", len(train_df))

incorrect_len = len(np.unique(np.array((incorrect_df)))) # only uniques: there are 2 duplicates
print("Incorrect len: ", incorrect_len)

print("Expected new len: ", (len(train_df)-incorrect_len))
print("New train-set len: ", len(train_clean_df))

### --- writing data --- ###

train_clean_df.to_csv("train_clean_info.csv", index=False, header=False)