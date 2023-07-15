"""
	$(SIGNATURES)

Set plot defaults.
"""
function plot_defaults()
    set_theme!(default_theme());
end


"""
	$(SIGNATURES)

Default theme. Note that `Makie` also exports `default_theme`.

CairoMakie 0.8: theme ggplot2 does not show legends correctly.
"""
function default_theme()
    # thm = theme_ggplot2();
    # thm = theme_minimal();
    # This effectively sets the default theme (for which no command exists).
    thm = Theme(Lines = (linewidth = 3, ));

    update_theme!(thm;  
        # Lines = (linewidth = 3),  # causes errors
        linewidth = 3,
        colormap = default_color_scheme(),
        # fontsize = 10,
        whiskerwidth = 8
        );
    return thm
end

default_color_scheme() = ColorSchemes.corkO;

"""
	$(SIGNATURES)

Color used for a single color graph.
"""
main_color() = get_colors(2, 6);

get_colors(idx) = default_color_scheme()[idx];

"""
	$(SIGNATURES)

Get color `idx` out of `nMax` along the color range defined by the colormap.
"""
function get_colors(idx, nMax :: Integer)
    # nColors = length(default_color_scheme());
    # idxV = round.(Int, LinRange(1, nColors, nMax));
    idxV = 0.05 .+ (0.95 - 0.05) .* idx ./ nMax;
    return get_colors(idxV);
    # return get_colors(idxV[idx])
end


## ------------  Text settings

plot_text_size(forSubPlot :: Bool) = 
    forSubPlot  ?  subplot_text_size()  :  default_text_size();

default_text_size() = 14;
subplot_text_size() = 12;


# -----------