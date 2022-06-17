pkg_test_dir() = normpath(joinpath(@__DIR__, "..", "test_files"));


"""
	$(SIGNATURES)

Blank plot with options.
"""
blank_plot(; kwargs...) = Figure(; kwargs...);

"""
	$(SIGNATURES)

Make an axis in a given figure position.

Various text elements are smaller when this is in a subplot.
"""
function make_axis(fig; ir :: Integer = 1, ic :: Integer = 1,
	forSubPlot :: Bool = false, kwargs...)
	if forSubPlot
		args = merge(subplot_defaults(), kwargs);
	else
		args = axis_args(; kwargs...);
	end
    ax = fig[ir, ic] = Axis(fig; args...);
    return ax
end

"""
	$(SIGNATURES)

Make an axis in a given position `pos`.

# Example
```julia
make_axis(fig, (2,1); title = "Axis title");
```
"""
function make_axis(fig, pos :: Tuple{I1, I1}; kwargs...) where I1 <: Integer 
    return make_axis(fig; ir = pos[1], ic = pos[2], kwargs...);
end


"""
	$(SIGNATURES)

Given a set of keyword arguments, return a `Dict` with valid arguments for creating an axis, including defaults from `axis_defaults`.

test this +++++
"""
function axis_args(; kwargs...)
	dOut = make_args(axis_defaults(), axis_keys(); kwargs...);
	# dIn = merge(axis_defaults(), kwargs);
	# # dArgs = Dict(kwargs...);
	# # dDefaults = axis_defaults();
	# dOut = Dict{Symbol, Any}();
	# axKeys = axis_keys();
	# for (k,v) in dIn
	# 	if k ∈ axKeys
	# 		dOut[k] = v;
	# 	end
	# end
	return dOut
end

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

axis_defaults() = Dict{Symbol, Any}([
    :xlabel => ""
    ]);

axis_keys() = (:xlabel, :ylabel, :xlims, :ylims);


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