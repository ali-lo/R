# import the library 
import pandas as pd # standard shortcut 
import numpy as np # numeric analysis module that is the underlying framework 

# series are a cross between a dict and list 
# they are one-dimensional, ordered collections with indices (keys)

# create a series by calling pd.Series()
# create a series from a list 
number_series = pd.Series([1, 2, 3, 3, 5, 8])
print(number_series)

# create a series from a dict
# when created from a dict, they are ordered by key,
# which is not always the same order as the OG
age_series = pd.Series({"sarah":42, "amit":35, "zhang":13})
print(age_series)

# basic operations are matched up pair-wise with the same index label 
# unmateched elements are given NaN
s1 = pd.Series([3, 1, 4, 1, 5])
s2 = pd.Series([1, 6, 1, 8, 0])
# add the series 
# s3 is a series of integers 
s3 = s1+ s2 # 4, 7, 5, 9, 5
# compare the series 
# s4 is a series of booleans 
s4 = s1 > s2 # True, False, True, False, True 

# broadcasting - apply one operand (scalar) across the series 
sample = pd.Series ([3, 1, 4, 1, 5])
result = sample + 4 # add 4 to each element 
print(result) # 7, 5, 8, 5, 9

# can call series-specific methods 
# can use index property to find index values 
age_series.index # .index is a property = no ()
# it tends to be most helpful to conver it into a list
list(age_series.index) # list of keys/ indices

# can call aggragate functions on series
# .max() calls the max of the values 
age_series.max() # 42
# .idxmax() gives the index of the max value
age_series.idxmax() # "sarah"
# tell me if all the values are True
s4.all() # False 
# .describe() look at the descriptive stats 
# since it returns a series, you need to then access the values
description_results = age_series.describe() 
list(description_results.index) # see the index/ key labels 

# accessing series - elements in a series can be accessed via bracket notation 
# access the value at i=1  of number_series 
number_series[1] #2
# access the value at i="sarah" of age_series
age_series["amit"] #35

# get the 0th element from age_series 
# Since sereies are ordered, it can be accessed positonally 
age_series[0]

# we can specify sequences of elements to access multiple elements at once
# this returns a new series
index_list = ["sarah", "zhang"]
print(age_series[index_list]) # 42 13

# using an anonymous variable for the index list 
# Notice the brackets!! 
# the brackets access the series 
# the inner brackets create a list of what to access
print(age_series[["sarah", "zhang"]])

# Boolean indexing - we can use a sequence of boolean values
vowels = pd.Series[("a", "e", "i", "o", "u")]
# list of elements to extract
filter_indices = [True, False, False, True, True]
# extract every element corresponding to True 
list(vowels[filter_indices]) # "a" "o" "i"

# when combined with relational operators, 
# we can use this approach to filter series elements by criteria
shoe_sizes = pd.Series([5.5, 11, 7, 8, 4])
small_sizes = shoe_sizes < 6 # True, False, False, False, True 

small_shoes = shoe_sizes[small_sizes] # has values 5.5, 4

# as one line: "shoe sizes, where shoe size is less than 6"
small_shoes = shoe_sizes[shoe_sizes < 6]