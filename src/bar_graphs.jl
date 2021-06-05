"""
	$(SIGNATURES)

Bar graph. Simple wrapper for `barplot` that applies default settings.

# Arguments

- yerror: errorbars around `dataV`.
"""
function bar_graph(groupLabelV, dataV; 
    fig = Figure(), pos = (1,1), yerror = nothing, kwargs...)
    
    @assert size(dataV) == size(groupLabelV);
    args = merge(bar_defaults(), kwargs);
    n = length(groupLabelV);
    ax = make_axis(fig, pos; xticks = (1:n, string.(groupLabelV)), args...);
    barplot!(ax, dataV; args...);
    add_errorbars!(dataV, yerror);
    return fig, ax
end

"""
	$(SIGNATURES)

Plots bar graph into existing axis or FigurePosition.
"""
function bar_graph!(ax :: Axis, dataV; yerror = nothing, kwargs...)
    args = merge(bar_defaults(), kwargs);
    barplot!(ax, dataV;  args...);
    add_errorbars!(dataV, yerror);
end

add_errorbars!(dataV, yerror) = 
    errorbars!(1 : length(dataV), dataV, yerror; whiskerwidth = 10);
add_errorbars!(dataV, yerror :: Nothing) = nothing;

bar_defaults() = Dict([
    :strokewidth => 0,
    :color => main_color()
]);


function test_bar_graph()
    n = 10;
    dataV = LinRange(4, 5, n);
    groupLabelV = ["G$j" for j = 1 : n];
    fig, ax = bar_graph(groupLabelV, dataV; 
        xlabel = "x label", ylabel = "y label", 
        xticks = (1:n, groupLabelV));
    return fig, ax
end


# ------------