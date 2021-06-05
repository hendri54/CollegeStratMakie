scatter_defaults() = Dict([
    :strokewidth => 0,
    :color => main_color()
]);


"""
	$(SIGNATURES)

Line graph. Simple wrapper around `lines`.
"""
function scatter_plot(xV, yV :: AbstractVector{F};
    fig = blank_plot(), pos = (1,1), kwargs ...) where F

    args = merge(scatter_defaults(), kwargs);
    ax = fig[pos...] = Axis(fig; args...);
    scatter!(ax, xV, yV; args...);
    return fig, ax
end

function scatter_plot(yV :: AbstractVector{F}; kwargs ...) where F
    return scatter_plot(1 : length(yV), yV; kwargs...);
end

function scatter_plot(xV, yM :: AbstractMatrix{F};
    fig = blank_plot(), pos = (1,1), kwargs...) where F
    nr, nc = size(yM);
    @assert nr == length(xV);
    args = merge(scatter_defaults(), kwargs);
    ax = make_axis(fig, pos; args...);
    for j = 1 : nc
        add_scatter!(ax, xV, yM[:, j]; args..., color = get_colors(j, nc));
    end
    return fig, ax
end


"""
	$(SIGNATURES)

Add line to a plot.
"""
function add_scatter!(ax :: Axis, x, y; kwargs...)
    scatter!(ax, x, y; kwargs...);
end

add_scatter!(p :: Makie.FigureAxisPlot, x, y; kwargs...) = 
    add_scatter!(p.axis, x, y; kwargs...);

# -----------