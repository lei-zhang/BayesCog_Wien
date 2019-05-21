data {
  int<lower=1> nSubjects;
  int<lower=1> nTrials;
  int<lower=1,upper=2> choice[nSubjects, nTrials];     
  real<lower=-1, upper=1> reward[nSubjects, nTrials]; 
}

transformed data {
  vector[2] initV;  // initial values for V
  initV = rep_vector(0.0, 2);
}

parameters {
  // group-level parameters
  real lr_mu_raw; 
  real tau_mu_raw;
  real<lower=0> lr_sd_raw;
  real<lower=0> tau_sd_raw;
  
  // subject-level raw parameters
  vector[nSubjects] lr_raw;
  vector[nSubjects] tau_raw;
}

transformed parameters {
  vector<lower=0,upper=1>[nSubjects] lr;
  vector<lower=0,upper=3>[nSubjects] tau;
  
  for (s in 1:nSubjects) {
    lr[s]  = Phi_approx( lr_mu_raw  + lr_sd_raw * lr_raw[s] );
    tau[s] = Phi_approx( tau_mu_raw + tau_sd_raw * tau_raw[s] ) * 3;
  }
}


model {
  lr_mu_raw  ~ normal(0,1);
  tau_mu_raw ~ normal(0,1);
  lr_sd_raw  ~ cauchy(0,3);
  tau_sd_raw ~ cauchy(0,3);
  
  lr_raw  ~ normal(0,1);
  tau_raw ~ normal(0,1);
  
  for (s in 1:nSubjects) {
    vector[2] v; 
    real pe;    
    v = initV;

    for (t in 1:nTrials) {        
      choice[s,t] ~ categorical_logit( tau[s] * v );
            
      pe = reward[s,t] - v[choice[s,t]];      
      v[choice[s,t]] = v[choice[s,t]] + lr[s] * pe; 
    }
  }    
}

generated quantities {
  real<lower=0,upper=1> lr_mu; 
  real<lower=0,upper=3> tau_mu;
  real log_lik[nSubjects, nTrials];
  int y_pred[nSubjects, nTrials];
  
  lr_mu  = Phi_approx(lr_mu_raw);
  tau_mu = Phi_approx(tau_mu_raw) * 3;
  y_pred = rep_array(-999,nSubjects ,nTrials);

  { // local section, this saves time and space
    for (s in 1:nSubjects) {
      vector[2] v; 
      real pe;    
      v = initV;

      for (t in 1:nTrials) {    
        log_lik[s,t] = categorical_logit_lpmf(choice[s,t] | tau[s] * v);    
        y_pred[s,t] = categorical_logit_rng( tau[s] * v ); 
              
        pe = reward[s,t] - v[choice[s,t]];      
        v[choice[s,t]] = v[choice[s,t]] + lr[s] * pe; 
      }
    }    
  }
}
