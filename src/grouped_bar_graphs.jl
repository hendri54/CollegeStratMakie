grouped_bar_defaults() = Dict([
    :strokewidth => 0,
]);

grouped_bar_keys() = (:color, :strokewidth, :xticks);


"""
	$(SIGNATURES)

Grouped bar graph. Rows of `dataM` are groups.

# Example

```julia
grouped_bar_graph(["1", "2"], rand(2, 3); pos = (1,2), yerror = rand(2, 3))
```
"""
function grouped_bar_graph(
    xStrV, dataM :: AbstractMatrix{F}; 
    fig = Figure(), pos = (1,1), forSubPlot = false,
    yerror = nothing,  
    kwargs...) where F

    ng = length(xStrV);
    @assert size(xStrV, 1) == size(dataM, 1)  "Size mismatch: $(size(xStrV)), $(size(dataM))";
    ax, dUnused = make_axis(fig, pos; forSubPlot,
        xticks = (1 : ng, xStrV), kwargs...);

    grouped_bar_graph!(ax, dataM; yerror = yerror, dUnused...);
    return fig, ax
end


"""
	$(SIGNATURES)

Grouped bar graph for a given axis.
"""
function grouped_bar_graph!(ax :: Axis, dataM :: AbstractMatrix{F};
    yerror = nothing, kwargs...) where F

    if !isnothing(yerror)
        @assert size(yerror) == size(dataM)  "Size mismatch yerror";
    end
    args, dUnused = make_args(grouped_bar_defaults(), grouped_bar_keys(); kwargs...);
    nr, nc = size(dataM);
    xV = repeat(1 : nr; outer = (nc,));
    grps = groups_from_rows(nr, nc);
    bars = bars_from_columns(nr, nc);
    barplot!(ax, xV, vec(dataM); 
        dodge = grps, color = get_colors(bars, nc),
        # color = bars, colorrange = (1, nc), 
        args...);

    add_grouped_errorbars!(xV, dataM, yerror, grps);
end


# should be improved and be more robust +++
function add_grouped_errorbars!(xV, dataM, yerror, grps)
    crossbar!(xV, vec(dataM), vec(dataM) .- vec(yerror), vec(dataM) .+ vec(yerror); 
        dodge = grps, color = (:gray50, 0.35));
end

add_grouped_errorbars!(xV, dataM, yerror :: Nothing, grps) = nothing;

groups_from_rows(nr, nc) = repeat(1 : nc; inner = (nr,));
bars_from_columns(nr, nc) = repeat(1 : nc; inner = (nr,));



"""
	$(SIGNATURES)

Places a legend into a figure position `pos`. Uses the same colors as for grouped bar graph.
Useful not just for grouped bar graphs, but also for any kind of subplot.

For horizontal legends: `tellheight = true` prevents vertical spacing issues.

# Arguments
- `pos`: Figure position, such as `fig[2,1]`. Cannot be an `Axis`.
- `title`: cannot be "". That throws an error. 

# Example
```julia
fig, ax = grouped_bar_graph(["1", "2"], rand(2, 3));
legPos, legArgs = legend_args(1, 1, :outerbottom);
grouped_bar_legend(fig[2, 1], colLabelV; legArgs...);
```
"""
function grouped_bar_legend(pos, labelV :: AbstractVector{String}; 
        title = nothing, forSubPlot = false,
        orientation = :vertical, tellheight = (orientation == :horizontal), kwargs...)
    n = length(labelV);
    elements = [PolyElement(color = get_colors(i, n)) for i in 1:n];
    # @show elements
    Legend(pos, elements, labelV, title; orientation, tellheight, kwargs...);
end


# -------------