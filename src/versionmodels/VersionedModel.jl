import Base: show
using SHA
using StanSample
using HDF5


mutable struct VersionedModel
    # Stan Model
    stan_model::SampleModel

    # Versioning Detail Fields
    hash::AbstractString
    version_number::Int;

    # Storage Information
    version_store_file::AbstractString
end

function VersionedModel(name::AbstractString, model::AbstractString)
    stan_model = SampleModel(name, model)
    hash = bytes2hex(sha3_512(lowercase(strip(model))))

    VersionedModel(stan_model, hash)

end