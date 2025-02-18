As data scientists on the team, we aim to assess the residential property value in Cook County in a fair and accurate way. We tried five different models, which are Lasso Regression, Gradient-Boosting Decision Tree, Random Forest, Neural Network and Brulee Multilayer Perceptron Neural Network.

All of them have advantages and downsides. Both Random Forecast and Neural Network are time-consuming. Furthermore, Neural Network is not capable of handling categorical features, while this capability is extremely important as many property variables are categorical. Brulee Multilayer Perceptron Neural Network fixes the issue of processing categorical variables, but the result shows overfitting, which generates a huge MSE. Lasso produces the smallest mean squared error (MSE) but it cannot deal with properties with missing variable values. Gradient-Boosting Decision Tree fixes the above problem that Lasso Regression faces but it produces a slightly larger MSE.
 
In general, the strategy we choose is combining Lasso Regression and Gradient-Boosting Decision Tree. Properties with completed feature values are processed with Lasso Regression and properties that have missing values of any variables are assessed by Gradient-Boosting Decision Tree.

Methodology

Variable Selection

The historical property data set that we gained has 62 variables that may affect a home’s sale price. Suggested by the analysis of features highlighted by Cook County Assessor’s Office’s data scientist Dan Snow, we choose 28 variables that have strong predictive powers as shown in the table (APPENDIX A) to predict house prices.

Data Processing

After variable selection, the dataset contains 50,000 properties, 28 independent variables and 1 dependent variable (sale price), of which 49,816 properties have independent variables without missing values. We divided these 49,816 properties randomly into 2 primary datasets, one for training (70%) and one for testing (30%). Training data includes 34,871 properties and testing data contains 14,945 properties.

Model Selection

Before dropping properties with missing variable values, we tried five models: Lasso Regression, Gradient- Boosting Decision Tree, Random Forest, Neural Network and Brulee Multilayer Perceptron Neural Network. While Lasso Regression produces the least cross-validated MSE, it automatically excludes homes with variables that carry missing values. Gradient-Boosting Decision Tree works well with all variables, but it generates a slightly higher MSE than Lasso Regression. Random Forecast is quite time-consuming. Neural Network is not only time-consuming but also incapable of handling categorical variables, which account for a large portion of our dataset. Brulee Multilayer Perceptron Neural Network fixes the issue of processing categorical data, but it has two problems. Firstly, Brulee Multilayer Perceptron Neural Network cannot deal with Boolean variables with missing values. Second, the result shows overfitting, which generates a large MSE.

To make the estimate more accurate, we used training data and testing data to retest these five models after omitting homes that lack values for selected variables. The minimum cross-validated MSE is produced by Lasso Regression (MSE: 14170826107) compared with Gradient-Boosting Decision Tree (MSE: 15802833177) and Brulee Multilayer Perceptron Neural Network (MSE: 83705853026). Random Forecast and Neural Network still have the same problems as above.

According to the testing procedures mentioned above and the principle of choosing minimum MSE, we decided to combine Lasso Regression and Gradient-Boosting Decision Tree. For properties with completed feature values, we use Lasso Regression to assess, while for properties that lack variable values, Gradient-Boosting Decision Tree is the model adopted. This combined strategy allows us to obtain more accurate valuation results.

Conclusion

To apply the strategy that combines Lasso Regression and Gradient-Boosting Decision Tree to the dataset for prediction, we divided the properties in the predicted dataset (10,000) into two subsets: one containing missing values (2) and one without missing values (9998). Through Gradient-Boosting Decision Tree prediction, the assessed values of two properties with missing feature values are $1,900,671 and $2,343,844, respectively. Combining the property values predicted by Lasso Regression and the above two values assessed by Gradient- Boosting Decision Tree, we summarized the distribution of these 10,000 properties’ values. Considering the nature of the real estate price in the real world, we reset 91 negative assessed property values to 0. After the conversion, the minimum and the maximum assessed values are $0 and $6,207,284, respectively. The mean value is $322,037. The 1st quantile is $150,704, the 2nd quantile is $241,951, and the 3rd quantile is $377,302
