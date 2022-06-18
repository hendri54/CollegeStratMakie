pkg_test_dir() = normpath(joinpath(@__DIR__, "..", "test_files"));


"""
	$(SIGNATURES)

Blank plot with options.
"""
blank_plot(; kwargs...) = Figure(; kwargs...);


"""
	$(SIGNATURES)

Make `kwargs` from a `Dict` with defaults and a set of valid keys.

# Output:
`Dict` with valid keys that occur either in `defaultDict` or in `kwargs`.
"""
function make_args(defaultDict, validKeys; kwargs...)
	dIn = merge(defaultDict, kwargs);
	dOut = Dict{Symbol, Any}();
	axKeys = validKeys;
	for (k,v) in dIn
		if k ∈ axKeys
			dOut[k] = v;
		end
	end
	return dOut
end


"""
	$(SIGNATURES)

Legends are string vectors. `nothing` is passed through.
"""
make_legend(v) = string.(v);
make_legend(::Nothing) = nothing;


# Retrieve an element from a vector; or return nothing.
# Useful for passing `label` from a vector, for example.
get_idx(v, j) = v[j];
get_idx(v :: Nothing, j) = nothing;

# ----------