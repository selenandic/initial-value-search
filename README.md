## Introduction
1.	When estimating a non-linear model, it is suggested to provide initial values for the parameters as it either helps the model to converge or shortens the iteration process. However, how can we determine the initials? Moreover, assuming more than one parameter, which combinations of initials should we try? This code answers this question.
2.	Among all possible combinations of initial values defined for the parameters, this code chooses a combination of initial values that provides the smallest sum squared residuals (SSR), and then estimates the model using these initials.
3.	I have benefited from the discussion in the Stata forum https://www.stata.com/statalist/archive/2005-07/msg00485.html
4.	I have written this code using Stata 13 on 6/12/2017.
## Estimation Framework
1.	The estimated model is a non-linear constant elasticity of substitution (CES) production function, which defines the productivity of inputs , i.e., g<sub>i</sub>(t) where i=L,K, as a Box-Cox transformation as in Leon-Ledesma et al. (2010):
![alt text]( https://github.com/selenandic/initial-value-search/blob/master/Equation_CES.PNG)
2.	Variables of the model:
 Y=Real output,
 L=Labor (employment),
 K=Capital services index,
 Y_bar=geometric mean of Y,
L_bar=geometric mean of L,
 K_bar=geometric mean of K,
 t_bar=average of t (time) ,
3.	Parameters of the model;
σ= elasticity of substitution between labor L and K,
π= share of capital in national income,
ɣ<sub>L</sub>= productivity growth of L,
ɣ<sub>K</sub>= productivity growth of K,
λ<sub>K</sub>= curvature of the productivity level of K,
A= normalization constant.
## The code
1.	The program for the above model is called “nlmynlmodel”. I defined two locals; one for labor part and one for capital part in the CES function, and I labeled their sum as “term2”.
2.	As the CES is non-linear “nl” command is used for the estimation.
3.	Next, in Part 2, I determined the vectors of possible initial values for parameters. For instance, for σ I used a range from 0.5 to 1.2, including 7 different values. 
4.	In Part 3, the code tries all possible combinations of initials and computes the SSR of the model. I have declared the maximum number of iteration as 1 in this part. If you change this number (or if you completely delete it), the computation will get longer. However, be aware that the selected initials can change depending on the number of iterations. 
5.	In Part 4, the code estimates the model using the selected combination of initials that gives the minimum SSR. Here, I do not indicate any max number for iteration.
6.	The last part of the code is a hypothesis test for σ=1, i.e., whether the function is significantly different form the Cobb-Douglas or not.
## How the code is run
1.	Download the code and data file I have provided in this repo to your computer.
2.	Open the .do file in Stata. Then File>Open> choose the .dta file.
3.	Push the execute (do) button in .do file.
## Outputs after the code is run
1.	The first thing you should notice is the lowest SSR information shown on the screen. Also, you can see the estimation results.
2.	Here, for my imaginary economy, I find that the elasticity is estimated as 0.25 and significantly below unity. So, L and K are complements. The capital’s share in national income is found as 0.43. The long-run growth in labor productivity is close to 1 percent, while that of capital is -0.1 percent. λ<sub>K</sub> is estimated to be negative. Hence, ɣ<sub>K</sub> and λ<sub>K</sub> signal that capital’s productivity decreases at a decreasing rate.
![alt text](https://github.com/selenandic/initial-value-search/blob/master/Estimation%20Results.PNG)
#### References
Leon-Ledesma, M. A, McAdam, P. and A. Willman. 2010. Identifying the elasticity of substitution with biased technical change. American Economic Review Vol.100 (4), 1330-57.

