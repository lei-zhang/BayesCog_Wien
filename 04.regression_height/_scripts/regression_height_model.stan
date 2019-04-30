data {
  int<lower=0> N;
  vector<lower=0>[N] height;
  vector<lower=0>[N] weight;
}

parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}

model {
  alpha ~ normal(170, 100);
  beta  ~ normal(0, 20);
  sigma ~ cauchy(0, 20);

  height ~ normal(alpha + beta * weight, sigma);
}



/*model {
  vector[N] mu;
  for (i in 1:N) {
    mu[i] = alpha + beta * weight[i];
    height[i] ~ normal(mu[i], sigma);
  }
}

model {
  vector[N] mu;
  mu = alpha + beta * weight;
  height ~ normal(mu, sigma);
}

model {
  height ~ normal(alpha + beta * weight, sigma);
}*/


