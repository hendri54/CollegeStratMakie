"""
	$(SIGNATURES)

Histogram.
"""
function histogram_plot(dataV; 
        fig = blank_plot(), pos = (1,1), forSubPlot = false, kwargs...)
    ax, dUnused = make_axis(fig, pos; forSubPlot, kwargs...);
    args, dUnused = make_args(histogram_defaults(), histogram_keys(); dUnused...);
    hist!(ax, dataV; args...); 
    warn_unused_kwargs(dUnused);
    return fig, ax
end

histogram_defaults() = Dict([
    :strokewidth => 0,
    :color => main_color()
]);

histogram_keys() = (:color, :strokewidth);


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