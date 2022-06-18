module CollegeStratMakie

using DocStringExtensions, FileIO, StatsBase
using CairoMakie, ColorSchemes
using FilesLH
using CollegeStratBase

# Helpers
export blank_plot, make_axis, make_legend, add_title!
# Settings
export default_theme, plot_defaults, get_colors
# Saving
export figsave
# Axis
export make_axis, axis_defaults, axis_args, check_axis_args;
# Bar graphs
export bar_graph, bar_graph!
# Grouped bar graphs
export grouped_bar_graph, grouped_bar_graph!, grouped_bar_legend,
    grouped_bar_xyz
# Line graphs
export line_plot, add_line!, add_error_band!
# Scatter plots
export scatter_plot, add_scatter!
# Other graphs
export histogram_plot, contour_plot
export plot_regressions, plot_regression
# Subplots
export subplot_layout, subplot_pos, link_axes, make_axes!, subplots

include("helpers.jl");
include("settings.jl");
include("axis.jl");
include("saving.jl");
include("bar_graphs.jl");
include("grouped_bar_graphs.jl");
include("line_graphs.jl");
include("scatter_graphs.jl");
include("subplots.jl");
include("regressions.jl");
include("xyz.jl");
include("other_plots.jl");


end # module