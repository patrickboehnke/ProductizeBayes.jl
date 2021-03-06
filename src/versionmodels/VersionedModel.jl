import Base: show
using SHA
using StanSample
using Parquet
using DataFrames
using VersionedFile

mutable struct VersionedModel
    name::String
    # Stan Model
    stan_model::SampleModel

    # Versioning Detail Fields
    hash::String
    # Storage Information
    versionfile::VersionedFile
    version::Int
end

function VersionedModel(name::AbstractString, model::AbstractString, version_store_file::AbstractString)
    stan_model = SampleModel(name, model)
    hash = bytes2hex(sha3_512(lowercase(strip(model))))
    version = 1


    if isfile(version_store_file)
        versionstoredf = DataFrame(read_parquet(version_store_file))
        modelfromfile = filter(:name => modelnames -> modelnames == name, versionstoredf)
        if length(modelfromfile) == 0
            df = DataFrame(Name = [name], Model=[model], Version=[version_number], Hash=[hash])
            append!(versionstoredf, df)
        else
            duplicatemodelfromfile = filter(:hash => modelhash -> modelhash == hash, modelfromfile)
            if length(duplicatemodelfromfile) > 0
                version_number = duplicatemodelfromfile[:hash, 1]
            else
                version_number = max(duplicatemodelfromfile[:Version]) + 1
                df = DataFrame(Name = [name], Model=[model], Version=[version_number], Hash=[hash])
                append!(versionstoredf, df)
            end
        end
    else
        versionstoredf = DataFrame(Name = [name], Model=[model], Version=[version_number], Hash=[hash])
    end
    VersionedModel(stan_model, hash, version_number)
end