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
"""
function default_theme()
    thm = theme_ggplot2();
    update_theme!(thm;  
        Lines = (linewidth = 3, ),  
        colormap = :corkO,
        # fontsize = 10,
        whiskerwidth = 8
        );
    return thm
end

default_color_scheme() = ColorSchemes.leonardo;

get_colors(idx) = default_color_scheme()[idx];

function get_colors(idx, nMax :: Integer)
    nColors = length(default_color_scheme());
    idxV = round.(Int, LinRange(1, nColors, nMax));
    return get_colors(idxV[idx])
end


# -----------