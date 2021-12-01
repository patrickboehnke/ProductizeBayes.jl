module ProductizeBayes

import SHA
import StanSample

include("versionmodels/VersionedModel.jl")

export VersionedModel,
        stan_sample,
        read_samples,
        read_summary,
        stan_summary,
        stan_generate_quantities,
        read_generated_quantities,
        diagnose
end # module
