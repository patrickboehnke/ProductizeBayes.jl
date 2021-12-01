# ProductizeBayes.jl
A Julia package for productizing bayesian models, particularly those in Stan. The goal of this package is four-fold:
1. Speed up model development
2. Managing priors and posteriors to allow the same model structure to fit multiple applications
3. Automate model fit evaluation & cut-off/threshold tuning
4. Speed up & simplify model predictions to let models be used as a service

This work was inspired by my blog post [here](https://patrickboehnke.github.io/StanJuliaThoughts/)