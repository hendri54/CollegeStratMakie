"""
	$(SIGNATURES)

Histogram.
"""
function histogram_plot(dataV; fig = blank_plot(), pos = (1,1), kwargs...)
    args = merge(histogram_defaults(), kwargs);
    ax = fig[pos...] = Axis(fig; args...);
    hist!(ax, dataV; args...); 
    return fig, ax
end

histogram_defaults() = Dict([
    :strokewidth => 0,
    :color => main_color()
]);


"""
	$(SIGNATURES)

Contour plot.
"""
function contour_plot(x, y, z; fig = blank_plot(), pos = (1,1), kwargs...)
    args = merge(contour_defaults(), kwargs);
    ax = make_axis(fig, pos; args...);
    contour!(ax, x, y, z; args...);
    return fig, ax
end

contour_defaults() = Dict([
    :linewidth => 3,
]);



# ----------------