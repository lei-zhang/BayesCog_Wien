data {
    int<lower=1> nSubjects;
    int<lower=1> nTrials;
    int<lower=1, upper=nTrials> Tsubj[nSubjects];
    real<lower=0> delay_later[nSubjects,nTrials];
    real<lower=0> amount_later[nSubjects,nTrials];
    real<lower=0> delay_sooner[nSubjects,nTrials];
    real<lower=0> amount_sooner[nSubjects,nTrials];
    int<lower=0,upper=1> Choice[nSubjects, nTrials]; # 0 for instant reward, 1 for delayed reward
}

parameters {
  # Hyper(group)-parameters  
  real mu_k_raw;
  real mu_beta_raw;
  real sd_k_raw;
  real sd_beta_raw;
    
  # Subject-level raw parameters
  vector[nSubjects] k_raw;
  vector[nSubjects] beta_raw;    
}

transformed parameters {
  # Transform subject-level raw parameters 
  vector<lower=0,upper=1>[nSubjects] k;
  vector<lower=0,upper=5>[nSubjects] beta;
        
  k[s]    = Phi_approx( mu_k_raw + sd_k_raw * k_raw[s] )
  beta[s] = Phi_approx( mu_beta_raw + sd_beta_raw * beta_raw[s] ) * 5;
}

model {
  # Hyperparameters
  sd_k_raw    ~ cauchy(0, 3);
  sd_beta_raw ~ cauchy(0, 3);

  # individual parameters
  k_raw    ~ normal(0, 1);
  beta_raw ~ normal(0, 1);
    
  for (s in 1:nSubjects) {
    # Define values
    real ev_later;
    real ev_sooner
      
    for (t in 1:(Tsubj[s])) {
      ev_later   = amount_later[s,t]  / ( 1 + k[s] * delay_later[s,t] );
      ev_sooner  = amount_sooner[s,t] / ( 1 + k[s] * delay_sooner[s,t] );
      choice[s,t] ~ bernoulli_logit( beta[ns] * (ev_later - ev_sooner) );
    }
  }
}

generated quantities {
  real<lower=0,upper=1> mu_k;
  real<lower=0,upper=5> mu_beta;
  real log_lik[nSubjects];

  mu_k    = Phi_approx(mu_k_raw);
  mu_beta = Phi_approx(mu_beta_raw) * 5;
  
  { # local section, this saves time and space
    for (s in 1:nSubjects) {
      real ev_later;
      real ev_sooner;

      for (t in 1:(Tsubj[s])) {
        ev_later   = amount_later[s,t]  / ( 1 + k[s] * delay_later[s,t] );
        ev_sooner  = amount_sooner[s,t] / ( 1 + k[s] * delay_sooner[s,t] );
        log_lik[s] += bernoulli_logit_lpmf( choice[s,t] | beta[s] * (ev_later - ev_sooner) );
      }
    }
  }
}
