data {
    int<lower=1> nTrials;
    int<lower=1,upper=2> choice[nTrials];
    int<lower=-1,upper=1> reward[nTrials];
} 

parameters {
    real<lower=0,upper=1> alpha; // learning rate
    real<lower=0,upper=20>tau; // softmax inv.temp.
}

model {
    real pe;
    vector[2] v;
    vector[2] p;
    
    for (t in 1:nTrials) {
        p = softmax( tau * v); // action prob. computed via softmax
        choice[t] ~ categorical(p);
        
        pe = reward[t] - v[choice[t]]; // compute pe for chosen value only
        v[choice[t]] = v[choice[t]] + alpha * pe; // update chosen V
    }
    
}
