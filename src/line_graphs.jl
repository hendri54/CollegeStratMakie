line_defaults() = Dict{Symbol, Any}([
    :labelV => nothing
    ]);

line_keys() = (:color, );

"""
	$(SIGNATURES)

Line graph. Simple wrapper around `lines`.
"""
function line_plot(xV, yV :: AbstractVector{F};
    fig = blank_plot(), pos = (1,1), forSubPlot = false, kwargs...) where F

    # args = merge(line_defaults(), kwargs);
    ax, dUnused = make_axis(fig, pos; forSubPlot, kwargs...);
    args, dUnused = make_args(line_defaults(), line_keys(); dUnused...);
    warn_unused_kwargs(dUnused);
    lines!(ax, xV, yV; args...);
    return fig, ax
end

function line_plot(yV :: AbstractVector{F}; 
    fig = blank_plot(), pos = (1,1), kwargs...) where F
    return line_plot(1 : length(yV), yV; fig = fig, pos = pos, kwargs...);
end


"""
	$(SIGNATURES)

Multi-line plot from data matrix. Columns are series.

This is really the same as `Makie.series`.

# Arguments

- legPos: `:below` places a legend below the graph (in a new frame).
- labelV: labels for legend (optional).

# Example
```julia
fig, ax = line_plot(1:4, rand(4,3); labelV = ["Lbl \$j" for j = 1 : 3]);
axislegend()
```
"""
function line_plot(xV, yM :: AbstractMatrix{F}; 
    fig = blank_plot(), pos = (1,1), forSubPlot = false,
    legPos = :none, labelV = nothing,
    kwargs...) where F

    ax, dUnused = make_axis(fig, pos; forSubPlot, kwargs...);
    dUnused = line_plot!(ax, xV, yM; labelV, dUnused...);
    warn_unused_kwargs(dUnused);

    if !isnothing(labelV)  &&  (legPos == :below)
        legPos = (pos[1] + 1, pos[2]);
        legend_horizontal(fig, ax, legPos);
        # fig[legPos...] = Legend(fig, ax; 
        #     orientation = :horizontal, 
        #     tellwidth = false, tellheight = true);
    end
    return fig, ax
end

function legend_horizontal(fig, ax, legPos)
    fig[legPos...] = Legend(fig, ax; 
        orientation = :horizontal, 
        tellwidth = false, tellheight = true);
end

function line_plot!(ax, xV, yM :: AbstractMatrix{F}; 
        labelV = nothing, kwargs...) where F
    args, dUnused = make_args(line_defaults(), line_keys(); kwargs...);
    nr, nc = size(yM);
    @assert nr == length(xV);
    for j = 1 : nc
        sLabel = isnothing(labelV)  ?  (nothing)  :  (labelV[j]);
        add_line!(ax, xV, yM[:, j]; 
            label = sLabel, 
            color = get_colors(j, nc),  # (fill(j, nr), nc),
            # color = fill(j, nr), colorrange = (1, nc),
            args...);
    end
    return dUnused
end


"""
	$(SIGNATURES)

Add line to a plot.
"""
function add_line!(ax :: Axis, x, y; kwargs...)
    lines!(ax, x, y; kwargs...);
end

add_line!(p :: Makie.FigureAxisPlot, x, y; kwargs...) = 
    add_line!(p.axis, x, y; kwargs...);


"""
	$(SIGNATURES)

Add error band. 

How to get these colored is not clear. Adding 
`color = (get_colors(j, n), 0.2)`
achieves transparency, but no color (all grey).
"""
function add_error_band!(ax :: Axis, x, y, errorV; kwargs...)
    @assert all(errorV .>= 0.0)  "Negative errors";
    @assert size(x) == size(y) == size(errorV); # This may be too restrictive +++
    if any(errorV .> 0.0)
        band!(ax, x, y .- errorV, y .+ errorV; kwargs...);
    end
end

add_error_band!(ax :: Axis, x, y, errorV :: Nothing; kwargs...) = nothing;


## ------------  Testing

function test_line_plot(; forSubPlot = false)
    nx = 7;
    xV = LinRange(-2.0, 1.5, nx);
    yM = LinRange(0.3, 0.5, nx) .+ LinRange(1.0, 0.5, 4)';
    p, ax = line_plot(xV, yM; 
        forSubPlot, xlabel = "x", 
        labelV = ["Lbl $j" for j = 1 : 4], legPos = :below);
    return p, ax
end

# -----------