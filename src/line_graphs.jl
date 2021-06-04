line_defaults() = Dict{Symbol, Any}([
    :labelV => nothing
    ]);

"""
	$(SIGNATURES)

Line graph. Simple wrapper around `lines`.
"""
function line_plot(xV, yV :: AbstractVector{F};
    fig = blank_plot(), pos = (1,1), kwargs ...) where F

    args = merge(line_defaults(), kwargs);
    ax = make_axis(fig, pos; args...);
    lines!(ax, xV, yV; args...);
    return fig, ax
end

function line_plot(yV :: AbstractVector{F}; 
    fig = blank_plot(), pos = (1,1), kwargs ...) where F
    return line_plot(1 : length(yV), yV; fig = fig, pos = pos, kwargs...);
end


"""
	$(SIGNATURES)

Multi-line plot from data matrix. Columns are series.

# Arguments

- legPos: `:below` places a legend below the graph (in a new frame).
"""
function line_plot(xV, yM :: AbstractMatrix{F}; 
    fig = blank_plot(), pos = (1,1),
    legPos = :none,
    kwargs...) where F

    args = merge(line_defaults(), kwargs);
    ax = make_axis(fig, pos; args...);
    nr, nc = size(yM);
    @assert nr == length(xV);
    for j = 1 : nc
        add_line!(ax, xV, yM[:, j]; label = get_idx(args[:labelV], j), args...);
    end
    if !isnothing(args[:labelV])  &&  (legPos == :below)
        legPos = (pos[1] + 1, pos[2]);
        fig[legPos...] = Legend(fig, ax; 
            orientation = :horizontal, 
            tellwidth = false, tellheight = true);
    end
    return fig, ax
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

Add error band
"""
add_error_band!(ax :: Axis, x, y, errorV; kwargs...) = 
    band!(ax, x, y .- errorV, y .+ errorV; kwargs...)

add_error_band!(ax :: Axis, x, y, errorV :: Nothing; kwargs...) = nothing;

# -----------