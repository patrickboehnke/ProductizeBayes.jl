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
    write_parquet(versionfile.version_store_file, versionfile.versionstoredf)
end