pkg_test_dir() = normpath(joinpath(@__DIR__, "..", "test_files"));


"""
	$(SIGNATURES)

Blank plot with options.
"""
blank_plot(; kwargs...) = Figure(; kwargs...);


"""
	$(SIGNATURES)

Split provided `kwargs` into those that are valid according to `validKeys` and those that are not.
"""
function split_args(validKeys; kwargs...)
	dValid = Dict{Symbol, Any}();
	dOther = Dict{Symbol, Any}();
	for (k, v) in kwargs
		if k in validKeys
			dValid[k] = v;
		else
			dOther[k] = v;
		end
	end
	return dValid, dOther
end


"""
	$(SIGNATURES)

Make `kwargs` from a `Dict` with defaults and a set of valid keys.

# Output:
- `dOut`: `Dict` with valid keys that occur either in `defaultDict` or in `kwargs`.
- `dUnused`: `Dict` with `kwargs` that are not used by `make_axis`.
"""
function make_args(defaultDict, validKeys; kwargs...)
	dValid, dUnused = split_args(validKeys; kwargs...);
	dOut = merge(defaultDict, dValid);
	# dOut = Dict{Symbol, Any}();
	# axKeys = validKeys;
	# for (k,v) in dIn
	# 	if k ∈ axKeys
	# 		dOut[k] = v;
	# 	# else
	# 	# 	@warn "Unknown plot argument $k";
	# 	end
	# end
	return dOut, dUnused
end


function warn_unused_kwargs(d :: Dict{Symbol, T}) where T
	if !isempty(d)
		keyStr = join(["$k"  for k in keys(d)], " / ");
		@warn "Unused kwargs: " * keyStr;
	end
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