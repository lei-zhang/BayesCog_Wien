data{
  int<lower=0> nitem; // No. of Items
  int<lower=0> ns;    // No. of Subj
  int<lower=0> nt;    // No. of Trials 
  int<lower=0> intervals;  // time intervals
  int<lower=0> k[ns,nt];   // No. of remembered items
}

parameters {
  # group-level parameters
  real alpha_mu_raw; 
  real beta_mu_raw;
  real alpha_sd_raw;
  real beta_sd_raw;
  
  # subject-level raw parameters
  vector[ns] alpha_raw;
  vector[ns] beta_raw;
}

transformed parameters {
  vector<lower=0,upper=1>[ns] alpha;
  vector<lower=0,upper=1>[ns] beta;
 
  alpha = Phi_approx( alpha_mu_raw  + alpha_sd_raw * alpha_raw )
  beta  = Phi_approx( beta_mu_raw + beta_sd_raw * beta_raw );
}

model {
  real<lower=0,upper=1> theta[ns,nt];

  // hyper-parameters
  alpha_mu_raw ~ normal(0,1);
  beta_mu_raw  ~ normal(0,1);
  

  
  // individual parameters 
  alpha_raw ~ normal(0,1);
  beta_raw  ~ normal(0,1);

  // Observed Data
  for (s in 1:ns) {
    for (t in 1:nt) {
      theta[s,t] = fmin(1.0, exp(-alpha[ns] * intervals[t]) + beta);
      k ~ binomial(nItem, theta[s,t]);
    }
  }
}

generated quantities{
  int<lower=0,upper=1> alpha_mu; 
  int<lower=0,upper=1> beta_mu;

  alpha_mu = Phi_approx( alpha_mu_raw );
  beta_mu  = Phi_approx( beta_mu_raw );
}
