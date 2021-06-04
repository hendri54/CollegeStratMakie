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

function line_plot(xV, yM :: AbstractMatrix{F}; 
    fig = blank_plot(), pos = (1,1),
    kwargs...) where F

    args = merge(line_defaults(), kwargs);
    ax = make_axis(fig, pos; args...);
    nr, nc = size(yM);
    @assert nr == length(xV);
    for j = 1 : nc
        add_line!(ax, xV, yM[:, j]; label = get_idx(labelV, j), args...);
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