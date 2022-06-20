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

Make an axis in a given figure position.

Various text elements are smaller when this is in a subplot.
"""
function make_axis(fig; ir :: Integer = 1, ic :: Integer = 1,
	    forSubPlot :: Bool = false, xlims = nothing, ylims = nothing, 
        kwargs...)
    args, dUnused = axis_args(; forSubPlot, kwargs...);
    ax = fig[ir, ic] = Axis(fig; args...);
    isnothing(xlims)  ||  xlims!(ax, xlims);
    isnothing(ylims)  ||  ylims!(ax, ylims);
    # remove those keys from dUnused +++++
    return ax, dUnused
end



"""
	$(SIGNATURES)

Given a set of keyword arguments, return a `Dict` with valid arguments for creating an axis, including defaults from `axis_defaults`.
"""
function axis_args(; forSubPlot :: Bool = false, kwargs...)
	dOut, dUnused = make_args(axis_defaults(; forSubPlot), axis_keys(); kwargs...);
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
	return dOut, dUnused
end


"""
	$(SIGNATURES)

Check that all axis kwargs (provided as `Dict`) are valid.
"""
function check_axis_args(d)
    isValid = true;
    for (k, v) in d
        if !(k in axis_keys())
            @warn "Invalid axis key $k";
            isValid = false;
        end
    end
    return isValid;
end


"""
	$(SIGNATURES)

Permitted kwargs when creating an `Axis`.

Notes:
- `xlims` have to be set with `xlims!` or `limits!`.
"""
axis_keys() = (
    :xlabel, :ylabel, 
    :xlabelsize, :ylabelsize,
    :xticks, :yticks,
    :xticklabelsize, :yticklabelsize);


function axis_defaults(; forSubPlot :: Bool = false)
    if forSubPlot
        d = subplot_defaults();
    else
        d = oneplot_defaults();
    end
    return d
end

oneplot_defaults() = Dict{Symbol, Any}([
        :xlabel => ""
    ]);


function subplot_defaults()
    textSize = 8;
    return Dict{Symbol, Any}([
        :xticklabelsize => textSize,
        :yticklabelsize => textSize,
        :xlabelsize => textSize,
        :ylabelsize => textSize
    ])
end

# subplot_keys() = ();


# --------------