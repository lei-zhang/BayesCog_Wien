data {
  int<lower=0> N;
  vector<lower=0>[N] height;
  vector<lower=0>[N] weight;
  vector<lower=0>[N] weight_sq;
}

parameters {
  real alpha;
  real beta1;
  real beta2;
  real<lower=0> sigma;
}

model {
  alpha ~ normal(170, 100);
  beta1 ~ normal(0, 20);
  beta2 ~ normal(0, 20);
  sigma ~ cauchy(0, 20);

  
}

generated quantities {
  vector[N] height_bar;
  for (n in 1:N) {
      
  }
}
