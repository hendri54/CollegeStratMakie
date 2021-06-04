"""
	$(SIGNATURES)

Line graph. Simple wrapper around `lines`.
"""
function scatter_plot(xV, yV :: AbstractVector{F};
    fig = blank_plot(), pos = (1,1), kwargs ...) where F

    args = merge(bar_defaults(), kwargs);
    ax = fig[pos...] = Axis(fig; args...);
    scatter!(ax, xV, yV; kwargs...);
    return fig, ax
end

function scatter_plot(yV :: AbstractVector{F}; kwargs ...) where F
    return scatter_plot(1 : length(yV), yV; kwargs...);
end

function scatter_plot(xV, yM :: AbstractMatrix{F}; kwargs...) where F
    nr, nc = size(yM);
    @assert nr == length(xV);
    fig, ax = scatter_plot(xV, yM[:,1]; kwargs...);
    if nc > 1
        for j = 2 : nc
            add_scatter!(ax, xV, yM[:, j]);
        end
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