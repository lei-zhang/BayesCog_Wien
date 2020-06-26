data {
  int<lower=1> nSubjects;
  int<lower=1> nTrials;
  int<lower=1,upper=2> choice;
  real<lower=-1, upper=1> reward[nSubjects, nTrials]; 
}

transformed data {
  vector[2] initV;  // initial values for V
  initV = rep_vector(0.0, 2);
}

parameters {
  // group-level parameters
  real lr_mu_rae; 
  real tau_mu_raw;
  real lr_sd_raw;
  real tau_sd_raw;
  
  // subject-level raw parameters
  vector[nSubjects] lr_raw;
  vector[nSubjects] tau_raw;
}

transformed parameters {
  vector<lower=0,upper=1>[nSubjects] lr;
  vector<lower=0,upper=3>[nSubjects] tau;
  
  lr  = Phi_approx( lr_mu_raw  + lr_sd_raw * lr_raw[s] )
  tau = Phi_approx( tau_mu_raw + tau_sd_raw * tau_raw ) * 5;
}


model {
  // group-level prior
  lr_mu_raw  ~ normal(0,1);
  tau_mu_raw ~ normal(0,1);
  
  // individual-level prior
  lr_raw  ~ normal(0,1);
  tau_raw ~ normal(0,1);
  
  for (s in 1:nSubjects) {
    vector[2] v; 
    real pe;    
    v = initV;

    for (t in 1:nTrials) {        
      Choice[s,t] ~ categorical( tau[s] * v );
            
      pe = Reward - v[choice[s,t]];      
      v[choice[s,t]] = v[choice[s,t]] + lr[s] * pe; 
    }
  }    
}

generated quantities {
  real<lower=0,upper=1> lr_mu; 
  real<lower=0,upper=5> tau_mu;
  
  real log_lik[nSubjects];
  
  lr_mu  = Phi_approx(lr_mu_raw);
  tau_mu = Phi_approx(tau_mu_raw) * 5;

  { // local section, this saves time and space
    for (s in 1:nSubjects) {
      vector[2] v; 
      real pe;    

      v = initV;

      for (t in 1:nTrials) {    
        log_lik[s] = log_lik[s] + categorical_logit_lpdf(choice[s,t] | tau[s] * v);    
              
        pe = reward[s,t] - v[choice[s,t]];      
        v[choice[s,t]] = v[choice[s,t]] + lr[s] * pe; 
      }
    }    
  }
}
