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
make_legend(v) = string.(vec(v));
make_legend(::Nothing) = nothing;


"""
	$(SIGNATURES)

Return legend position and kwargs needed to format the legend.

# Example
```julia
legPos, legArgs = legend_args(4, 3, :outerbottom);
grouped_bar_legend(fig[legPos...], labelV; legArgs...);
```
"""
function legend_args(nRows, nCols, legendPos; forSubPlot = false)
    if legendPos == :outerbottom
        legPos = (nRows + 1, 1 : nCols);
        orientation = :horizontal;
    else  # if legendPos == :outerright
        legPos = (1 : nRows, nCols + 1);
        orientation = :vertical;
    end
	tellheight = (orientation == :horizontal);
	d = Dict([
		:orientation => orientation, 
		:tellheight => tellheight,
		:labelsize => plot_text_size(forSubPlot)
		]);
	return legPos, d
end


# Retrieve an element from a vector; or return nothing.
# Useful for passing `label` from a vector, for example.
get_idx(v, j) = v[j];
get_idx(v :: Nothing, j) = nothing;

# ----------