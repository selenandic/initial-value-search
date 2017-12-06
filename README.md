# initial-value-search
A grid search code for initial values in non-linear estimations

## Introduction
1.	When estimating a non-linear model, it is suggested to provide initial values for the parameters as it either helps the model to converge or shortens the iteration process. However, how can we determine the initials? Moreover, assuming more than one parameter, which combinations of initials should we try? This code answers this question.
2.	Among all possible combinations of initial values defined for the parameters, this code chooses a combination of initial values that provides the smallest sum squared residuals (SSR), and then estimates the model using these initials.
3.	I have benefited from the discussion in the Stata forum https://www.stata.com/statalist/archive/2005-07/msg00485.html
4.	I have written this code using Stata 13 on 6/12/2017.

## Estimation Framework
1.	The estimated model is a non-linear constant elasticity of substitution (CES) production function, which defines the productivity of inputs as a Box-Cox transformation as in Leon-Ledesma et al. (2009):
![alt text]( https://github.com/selenandic/initial-value-search/blob/master/Equation_CES.PNG)
2.	Variables of the model:
 Y=Real output
 L=Labor (employment)
 K=Capital services index
 Y_bar=geometric mean of Y
L_bar=geometric mean of L
 K_bar=geometric mean of K
 t_var=average of t (time) 
3.	Parameters of the model;
σ= elasticity of substitution between labor L and K
π= share of capital in national income
ɣ<sub>L</sub>= productivity growth of L
ɣ<sub>K</sub>= productivity growth of K
λ<sub>K</sub>= curvature of the productivity level of K
A= normalization constant
## The code
1.	The program for the above model is called “nlmynlmodel”. I defined two locals; one for labor part and one for capital part in the CES function, and I labeled their sum as “term2”.
2.	As the CES is non-linear “nl” command is used for estimation.
3.	Next, I determined the vectors of possible initial values for parameters For instance, for σ I used a range from 0.5 to 1.2, including 7 different values. 
4.	The code tries all possible combinations of initials and computes the SSR of the model. It chooses a combination of initials that gives the lowest SSR. Finally, it estimates the model using those initials.
5.	The last part of the code is a hypothesis test for σ=1, i.e., whether the function is significantly different form the Cobb-Douglas or not.







