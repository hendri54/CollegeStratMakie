
"""
	$(SIGNATURES)

Make a plot that contains several subplots.

# Arguments
- `plotFctV`:  Vector of functions that generate each plot.
    Function signature: `ax = plotFct(fig, pos; color)`.
    If `plotFct` does not return an `Axis`, `axV` remains `missing`.
- `figTitle`: Title for entire figure. `nothing` is ignored.
"""
function subplots(plotFctV; figTitle = nothing, kwargs...)
    # args = merge(subplot_defaults(), kwargs);
    fig = blank_plot();  # ; args...);
    nPlots = length(plotFctV);
    nRows, nCols = subplot_layout(nPlots);
    axV = Vector{Union{Axis, Missing}}(undef, nPlots);
    for (j, plotFct) in enumerate(plotFctV)
        pos = subplot_pos(j, nRows, nCols);
        ax = plotFct(fig, pos; color = main_color());
        if ax isa Axis
            axV[j] = ax;
        else
            axV[j] = missing;
        end
    end
    add_title!(fig, figTitle);
    return fig, axV
end


"""
	$(SIGNATURES)

Makes Axis objects so that subplots can be written into Figure fig.

It is generally better to make axes one by one.
"""
function make_axes!(fig, nPlots :: Integer; kwargs...)
    # args = make_args(subplot_defaults(), subplot_keys(); kwargs...);
    nr, nc = subplot_layout(nPlots);
    axV = Vector{Any}(undef, nPlots);
    for ir = 1 : nr
        for ic = 1 : nc
            if (ir * ic) <= nPlots
                j = (ir-1) * nc + ic;
                axV[j], _ = make_axis(fig, (ir, ic); forSubPlot = true, kwargs...);
            end
        end
    end
    return axV
end


"""
	$(SIGNATURES)

Make layout for subplots of `nPlots` equally sized plots.

Return number of rows and columns.

# Example

```julia
fig = blank_plot();
nPlots = 5;
nRows, nCols = subplot_layout(nPlots);
for iPlot = 1 : nPlots
    pos = subplot_pos(iPlot, nRows, nCols);
    line_plot(1:5, 1:5; fig = fig, pos = pos);
end
```
"""
function subplot_layout(nPlots)
    if nPlots <= 3
        nRows = 1;
        nCols = nPlots;
    elseif nPlots == 4
        nRows = 2;
        nCols = 2;
    else
        nCols = 3;
        nRows = ceil(Int, nPlots / nCols);
        @assert (nPlots <= (nRows * nCols)) "$nPlots too high: $nRows, $nCols"
    # else
    #     error("Not implemented for $nPlots");
    end
    return nRows, nCols
end


"""
	$(SIGNATURES)

Row and column position of a linear plot index. Goes together with [`subplot_layout`](@ref).
"""
function subplot_pos(j, nr, nc)
    # Columns first so that we go row by row.
    cIdx = CartesianIndices((nc, nr))[j];
    ir = cIdx[2];
    ic = cIdx[1];
    return ir, ic
end


"""
	$(SIGNATURES)

Link the given axes. First argument is a `Vector{Axis}`. Elements that are not `Axis` are ignored.
"""
function link_axes(axV :: AbstractVector{T}) where T 
    ax2V = filter(ax -> isa(ax, Axis), axV);
    if length(ax2V) > 1
        linkaxes!(ax2V...);
    end
end

link_axes(args...) = link_axes([args...]);


"""
	$(SIGNATURES)

Add a title to an entire figure with subplots. This shifts all existing layouts down.

Possible bug: This narrows the figure to the width of the title, unless there are multiple figure columns. Don't use for a single plot. There one should use an axis title.
"""
function add_title!(fig, titleStr; kwargs...)
    fig[0, :] = Label(fig, titleStr; kwargs...);
end

add_title!(fig, titleStr :: Nothing; kwargs...) = nothing;


# ---------------