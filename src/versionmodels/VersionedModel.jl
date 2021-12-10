import Base: show
using SHA
using StanSample
using HDF5
using DataFrames

const DESCRIPTION = "This group stores a versioned Stan model produced by ProductizeBayes.jl"

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

    df = DataFrame(Model=[model], Version=[1], Hash=[hash])

    fid = h5open(version_store_file, "cw")
    if name in keys(fid)
        global versioned_model_data = fid[name]
    else
        global versioned_model_data = create_group(fid, name)
        global version_number = 1
    end
    for cnm in DataFrames._names(df)
        versioned_model_data["$cnm"] = convert(Array, df[cnm])
    end
    attrs(g)["Description"] = DESCRIPTION
    h5write(version_store_file, name, g)

    VersionedModel(stan_model, hash, version_number)

end