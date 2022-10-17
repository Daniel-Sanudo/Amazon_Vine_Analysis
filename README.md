# Amazon_Vine_Analysis

This project involves using AWS RDS, PySpark and SQL to extract, transform and load the dataset from amazon vine reviews.

## Overview

By using Amazon's relational databases to host the dataset from one of Amazon's vine reviews along PySpark to Extract, Transform and Load the dataset, we'll try to find if there's a bias in the vine reviews regarding their star rating and if they're part of the vine program.

The script to ETL the chosen dataset can be found [here.](https://github.com/Daniel-Sanudo/Amazon_Vine_Analysis/blob/main/Amazon_Reviews_ETL.ipynb)

PySpark was used to break the dataset into 4 smaller, more manageable tables. These are:

### Review ID table

![review_id_table](/Images/review_id_table.png)

### Products table

![products_table](/Images/products_table.png)

### Customers table

![customers_table](/Images/customers_table.png)

### Vine table

![vine_table](/Images/vine_table.png)

Afterwards, the vine_table was used to analyze the review data to determine if there's a bias or not.

## Results

![vine_analysis](/Images/Vine_Analysis_Results.png)

The chosen dataset belongs to Amazon videogame vine reviews, with a total of 37921 entries. Only 90 of these are part of Amazon's vine program, the remaining 37831 are not part of the vine program.

The sum of the 5 star reviews is 14748. 44 of them are part of the vine program and had a 5 star rating, which is almost 50% of them. The reviews that aren't part of vine had a 39% 5 star rating, which translates to 14704 out of 37831 reviews.

## Summary

Although the vine reviews are much less than those that are not part of the vine program, there's a 10% difference with the 5 star rating percentage.

It could be assumed that there's a bias with these reviews since almost half of them have a 5 star rating while having a small sample size.

The vine table also has information about the purchase status. This can confirm if the star rating comes from a user that does not own the product. By using creating a new table without the users that do not own the product we could find a deeper insight on the possible existence of a bias and the weight of the reviews from users who did not purchase the product.