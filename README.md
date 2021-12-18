# ProductizeBayes.jl
A Julia package for productizing bayesian models, particularly those in Stan. The goal of this package is four-fold:
1. Speed up model development
2. Managing priors and posteriors to allow the same model structure to fit multiple applications
3. Automate model fit evaluation & cut-off/threshold tuning
4. Speed up & simplify model predictions to let models be used as a service

# What exists today
So far it can store information about the model (e.g., name, model text) in a parquet file. It also gets a version of the model so that you can keep track of changes.

The background for this work can be found [here](https://patrickboehnke.github.io/StanJuliaThoughts/)