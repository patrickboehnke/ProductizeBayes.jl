using Test
using ProductizeBayes


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
@test sm.hash == "5dce4091b38059e657f64ee7222f2b74778d852c051ad33bf0d646d1f0f66a05237510dd556214a343f5da8981faa5aef866a3cb109897f6074adbd38c8835bd"

if success(rc)
  sdf = read_summary(sm.stan_model)
  @test sdf[sdf.parameters .== :theta, :mean][1] ≈ 0.33 rtol=0.05

  (samples, parameters) = read_samples(sm.stan_model, :array;
    return_parameters=true)
  @test size(samples) == (1000, 1, 2)
  @test length(parameters) == 1

  (samples, parameters) = read_samples(sm.stan_model, :array;
    return_parameters=true, include_internals=true)
  @test size(samples) == (1000, 8, 2)
  @test length(parameters) == 8

  samples = read_samples(sm.stan_model, :array;
    include_internals=true)
  @test size(samples) == (1000, 8, 2)

  samples = read_samples(sm.stan_model, :array)
  @test size(samples) == (1000, 1, 2)
end