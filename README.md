# initial-value-search
A grid search code for initial values in non-linear estimations

## Introduction
1.	When estimating a non-linear model, it is suggested to provide initial values for the parameters as it either helps the system to converge or shortens the iteration process. However, how can we determine the initials? Moreover, assuming more than one parameter, which combinations of initials should we try? This code answers this question.
2.	Among all possible combinations of initial values defined for the parameters, this code chooses a combination of initial values that provides the smallest sum squared residuals (SSR), and then estimates the model using these initials.
3.	I have benefited from the discussion in the Stata forum https://www.stata.com/statalist/archive/2005-07/msg00485.html
4.	I have written this code using Stata 13 on 6/12/2017.

## Estimation framework

