capture set more on
set more off
capture drop lnlsh
capture drop lnksh
capture drop lnyy0
generate lnyy0=ln(y/y0)
capture program drop mynlmodel


//This system has a meaningful solution.TIME starts from 1991.
//write your -nl- program (here: 3 parameters to be estimated) 
program mynlmodel
version 13
nl (lnyy0= (ln({a}))+({sigma}/({sigma}-1))*(ln(({pi})*((k/k0)*(exp({gammak}*t0/{lambdak}*((time/t0)^{lambdak}-1))))^(({sigma}-1)/{sigma})+ ///
	(1-{pi})*(((l/l0)*(exp(({gammal}*t0*(ln(time/t0))))))^(({sigma}-1)/{sigma})))))
end

//define grid of starting vsigmalues: a vector for each parameter
matrix vpi=(0.25,0.3,0.35)
matrix vsigma=(0.7,0.6,.8)
matrix vgammal=(0.01, 0.015)
matrix va=(1)
matrix vgammak=(0.01,0.001,-0.01)
matrix vlambdak=(-1, 0.001,1)



//get SSR for all 3^3=27 combinations
//and remember those starting vsigmalues that led to the lowest SSR
local minssr=.
forv x= 1/3 {
local spi`x'=vpi[1,`x']
		forv i=1/3 {
		local ssigma`i'=vsigma[1,`i']
			forv j=1/2 {
			local sgammal`j'=vgammal[1,`j']
				forv k=1/1 {
				local sa`k'=va[1,`k']
					forv m=1/3 {
					local sgammak`m'=vgammak[1,`m']
					forv n=1/3 {
					local slambdak`n'=vlambdak[1,`n']
								capture nl (lnyy0= (ln({a}))+(exp(ln({sigma}))/(exp(ln({sigma}))-1))*(ln(({pi})*((k/k0)*(exp({gammak}*t0/{lambdak}*((time/t0)^{lambdak}-1))))^((exp(ln({sigma}))-1)/exp(ln({sigma})))+ ///
								(1-{pi})*(((l/l0)*(exp(({gammal}*t0*(ln(time/t0))))))^((exp(ln({sigma}))-1)/exp(ln({sigma}))))))) ///
										, initial(pi `spi`x'' sigma `ssigma`i'' gammal `sgammal`j'' a `sa`k'' gammak `sgammak`m'' lambdak `slambdak`n'')  vce(r) iterate(1)
							
								if e(rss)<`minssr' {
								display "The lowest SSR is currently" e(rss)
								local bestpi = `spi`x''
								local bestsigma = `ssigma`i''
								local bestgammal = `sgammal`j''
								local besta = `sa`k''
								local bestgammak = `sgammak`m''
								local bestlambdak = `slambdak`n''
								local minssr=e(rss)	
								
						}
						}
					}
				}
			}
		}
	}
* estimate nl-program for chosen set of starting vsigmalues*/
display "Chosen starting vsigmalues: pi=`bestpi', sigma=`bestsigma', gammal=`bestgammal', a=`besta', gammak=`bestgammak', lambdak=`bestlambdak'" 
nl (lnyy0= (ln({a}))+({sigma}/({sigma}-1))*(ln(({pi})*((k/k0)*(exp({gammak}*t0/{lambdak}*((time/t0)^{lambdak}-1))))^(({sigma}-1)/{sigma})+ ///
								(1-{pi})*(((l/l0)*(exp(({gammal}*t0*(ln(time/t0))))))^(({sigma}-1)/{sigma}))))), ///
	initial(pi `bestpi' sigma `bestsigma' gammal `bestgammal' a `besta' gammak `bestgammak'  lambdak `bestlambdak')  vce(r)

