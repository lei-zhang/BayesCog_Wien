data {
  int<lower=1> nTrials;               
  int<lower=1,upper=2> choice[nTrials];     
  real<lower=-1, upper=1> reward[nTrials]; 
}

transformed data {
  vector[2] initV;  // initial values for V
  initV = rep_vector(0.0, 2);
}

parameters {
  real<lower=0,upper=1> lr;
  real<lower=0,upper=3> tau;  
}

model {
  vector[2] v[nTrials+1]; // value
  real pe[nTrials];       // prediction error
  
  //vector[2] p[nTrials];

  v[1] = initV;

  for (t in 1:nTrials) {        
    // compute action probabilities
    choice[t] ~ categorical_logit( tau * v[t] );
    
    //p[t] = softmax(tau * v[t]);
    //choice[t] ~ categorical(p[t]);
    //
    
    //print("helping messages", v);

    // prediction error 
    pe[t] = reward[t] - v[t,choice[t]];

    // value updating (learning) 
    v[t+1] = v[t]; 
    v[t+1, choice[t]] = v[t, choice[t]] + lr * pe[t]; 
  }  
}
