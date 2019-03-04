data {
    int<lower = 1> N;
    real y1[N];
    real y2[N];
    real mu_y;
    real sd_y ;
}
transformed data {
    real unifLo ;
    real unifHi ;
    real normalSigma ;
    real expLambda ;
    unifLo = sd_y/1000 ;
    unifHi = sd_y*1000 ;
    normalSigma = sd_y*100 ;
    expLambda = 1/29.0 ;
}
parameters {
    real<lower=0> nuMinusOne ; 
    real mu[2] ;               // 2 groups
    real<lower=0> sigma[2] ;   // 2 groups
}
transformed parameters {
    real<lower=0> nu ;         // actually lower=1
    nu = nuMinusOne + 1 ;
}
model {
    sigma ~ uniform( unifLo , unifHi ) ; // vectorized
    mu ~ normal( mu_y , normalSigma ) ; // vectorized
    nuMinusOne ~ exponential( expLambda );
    
    y1 ~ student_t( nu , mu[1] , sigma[1]) ;
    y2 ~ student_t( nu , mu[2] , sigma[2]) ;
}

generated quantities {
    real mu_diff;
    mu_diff = mu[1] - mu[2];
}



