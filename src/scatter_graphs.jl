scatter_defaults() = Dict([
    :strokewidth => 0,
    :color => main_color()
]);

scatter_keys() = (:color, :strokewidth);


"""
	$(SIGNATURES)

Line graph. Simple wrapper around `lines`.
"""
function scatter_plot(xV, yV :: AbstractVector{F};
    fig = blank_plot(), pos = (1,1), kwargs ...) where F

    ax, dUnused = make_axis(fig, pos; kwargs...);
    args, dUnused = make_args(scatter_defaults(), scatter_keys(); dUnused...);
    scatter!(ax, xV, yV; args...);
    warn_unused_kwargs(dUnused);
    return fig, ax
end

function scatter_plot(yV :: AbstractVector{F}; kwargs ...) where F
    return scatter_plot(1 : length(yV), yV; kwargs...);
end

function scatter_plot(xV, yM :: AbstractMatrix{F};
    fig = blank_plot(), pos = (1,1), kwargs...) where F
    nr, nc = size(yM);
    @assert nr == length(xV);
    ax, dUnused = make_axis(fig, pos; kwargs...);
    for j = 1 : nc
        add_scatter!(ax, xV, yM[:, j];  
            color = get_colors(j, nc), dUnused...);
    end
    return fig, ax
end


"""
	$(SIGNATURES)

Add line to a plot.
"""
function add_scatter!(ax :: Axis, x, y; kwargs...)
    args, dUnused = make_args(scatter_defaults(), scatter_keys(); kwargs...);
    scatter!(ax, x, y; args...);
    return dUnused
end

add_scatter!(p :: Makie.FigureAxisPlot, x, y; kwargs...) = 
    add_scatter!(p.axis, x, y; kwargs...);

# -----------