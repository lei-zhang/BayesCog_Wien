data {
  int<lower=0> w;
  int<lower=0> N;
}

parameters {
  real<lower=0,upper=1> theta;
}

model {
  //p ~ uniform(0,1);
  w ~ binomial(N, theta);
}
