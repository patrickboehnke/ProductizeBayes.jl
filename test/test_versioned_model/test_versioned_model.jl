using Test
using ProductizeBayes, StanModel


bernoulli_model = "
data {
  int<lower=1> N;
  int<lower=0,upper=1> y[N];
}
parameters {
  real<lower=0,upper=1> theta;
}
model {
  theta ~ beta(1,1);
  y ~ bernoulli(theta);
}
";

data = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])

sm = VersionedModel("bernoulli", bernoulli_model)
rc = stan_sample(sm.stan_model; data, num_chains=2, seed=-1)
println(sm.hash)
@test sm.hash == "test"