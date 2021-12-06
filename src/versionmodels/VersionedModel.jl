import Base: show
using SHA
using StanSample
using HDF5
using DataFrames


mutable struct VersionedModel
    # Stan Model
    stan_model::SampleModel

    # Versioning Detail Fields
    hash::AbstractString
    version_number::Int

    # Storage Information
    version_store_file::AbstractString
end

function VersionedModel(name::AbstractString, model::AbstractString, version_store_file::AbstractString)
    stan_model = SampleModel(name, model)
    hash = bytes2hex(sha3_512(lowercase(strip(model))))

    fid = h5open(version_store_file, "cw")
    if name in keys(fid)
        versioned_model_data = fid[name]
    else
        versioned_model_data = create_group(fid, name)
    end
    for cnm in DataFrames._names(df)
        g["$cnm"] = convert(Array, df[cnm])
    end
    VersionedModel(stan_model, hash)

end