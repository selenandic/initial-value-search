capture set more on
set more off
capture drop lnyy0
capture drop l_l0
capture drop k_k0
capture drop time_t0
generate lnyy0=ln(y/y0)
generate l_l0=l/l0
generate k_k0=k/k0
generate time_t0=time/t0
capture program drop nlmynlmodel


//write your -nl- program (here: 6 parameters to be estimated) 
program nlmynlmodel, rclass
version 13
local capterm "({pi})*((k_k0)*(exp({gammak}*t0/{lambdak}*((time_t0)^{lambdak}-1))))^((exp(ln({sigma}))-1)/exp(ln({sigma})))"
local labterm "(1-{pi})*(((l_l0)*(exp(({gammal}*t0*(ln(time_t0))))))^((exp(ln({sigma}))-1)/exp(ln({sigma}))))"
local term2 "(exp(ln({sigma}))/(exp(ln({sigma}))-1))*ln(`capterm'+`labterm')"
return local eq "lnyy0 = ln({a})+`term2'"
end


//define grid of starting values: a vector for each parameter
matrix vpi=(0.25,0.3,0.35)
matrix vsigma=(0.5,0.6,0.7,0.8,0.9,1.1,1.2)
matrix vgammal=(0.01,0.015,0.02)
matrix va=(1)
matrix vgammak=(-0.001,0.0001,0.001)
matrix vlambdak=(-1, 0.001,1)


//get SSR for all combinations and remember those starting values that led to the lowest SSR
local minssr=.
forv x= 1/3 {
local spi`x'=vpi[1,`x']
		forv i=1/7 {
		local ssigma`i'=vsigma[1,`i']
			forv j=1/3 {
			local sgammal`j'=vgammal[1,`j']
				forv k=1/1 {
				local sa`k'=va[1,`k']
					forv m=1/3 {
					local sgammak`m'=vgammak[1,`m']
						forv n=1/3 {
						local slambdak`n'=vlambdak[1,`n']
							capture nl mynlmodel:lnyy0 l_l0 k_k0 time_t0 t0 ///
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
	

//estimate nl-program for chosen set of starting values
display "Chosen starting vsigmalues: pi=`bestpi', sigma=`bestsigma', gammal=`bestgammal', a=`besta', gammak=`bestgammak', lambdak=`bestlambdak'" 
nl mynlmodel: lnyy0 l_l0 k_k0 time_t0 t0 ///
	,initial(pi `bestpi' sigma `bestsigma' gammal `bestgammal' a `besta' gammak `bestgammak'  lambdak `bestlambdak')  vce(r)

	
//test if sigma is significantly different from 1
test (_b[sigma:_cons]=1)

