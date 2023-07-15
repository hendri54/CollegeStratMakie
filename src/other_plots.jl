"""
	$(SIGNATURES)

Histogram. Optional weights.
"""
function histogram_plot(dataV; 
        fig = blank_plot(), pos = (1,1), 
        forSubPlot = false, weights = nothing, kwargs...)
    ax, dUnused = make_axis(fig, pos; forSubPlot, kwargs...);
    args, dUnused = make_args(histogram_defaults(), histogram_keys(); dUnused...);
    if isnothing(weights)
        hist!(ax, dataV; args...); 
    # hist1 = data((x = dataV, )) * mapping(:x) * visual(Hist, strokewidth = 2);
    # draw!(ax, hist1);
    else
        hist!(ax, dataV; weights, args...);
    end
    warn_unused_kwargs(dUnused);
    return fig, ax
end

histogram_defaults() = Dict([
    :strokewidth => 0,
    :color => main_color()
]);

histogram_keys() = (:color, :strokewidth, :normalization);


"""
	$(SIGNATURES)

Contour plot.
"""
function contour_plot(x, y, z;
        fig = blank_plot(), pos = (1,1), forSubPlot = false, kwargs...)
    ax, dUnused = make_axis(fig, pos; forSubPlot, kwargs...);
    args, dUnused = make_args(contour_defaults(), contour_keys(); dUnused...);
    contour!(ax, x, y, z; args...);
    warn_unused_kwargs(dUnused);
    return fig, ax
end

contour_defaults() = Dict([
    :linewidth => 3,
]);

contour_keys() = (:color, :linewidth);


# ----------------