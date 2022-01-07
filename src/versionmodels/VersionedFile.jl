import Base: show

using Parquet
using DataFrames

mutable struct VersionedFile
    # Versioned Model Data
    versionstoredf::DataFrame

    # Versioning Detail Fields
    # Storage Information
    version_store_file::AbstractString
end

function VersionedFile(version_store_file::AbstractString)
    if isfile(version_store_file)
        versionstoredf = DataFrame(read_parquet(version_store_file))
    else
        versionstoredf = DataFrame(Name = Any[], Model=Any[], Version=Int[], Hash=Any[])
    end
    VersionedFile(versionstoredf, version_store_file)
end

function saveFile(versionfile::VersionedFile)
    # Function to write the data to the file
    write_parquet(versionfile.version_store_file, versionfile.versionstoredf)
end

function addModelVersion()
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
end