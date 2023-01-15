function Base.ImmutableDict(KV::Core.Pair{K, V}, KVs::Core.Pair{K, V}...) where {K, V}
    d = Base.ImmutableDict(KV)
    for p in KVs
        d = Base.ImmutableDict(d, p)
    end
    return d
end
