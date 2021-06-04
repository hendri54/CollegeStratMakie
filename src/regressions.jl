"""
	$(SIGNATURES)

Plots a set of regressions as a series of bar graph. Each bar is a regressor so that different scales are not a visual problem.
Standard errors are shown as error bars.

# Arguments

- coeffNameV:  Regressor names. Common across regressions. Symbols or Strings.
- regrLabelV:  Descriptive labels for the regressions. Become x labels under each bar. Symbols or Strings.
- coeffM: Coefficients by [regressor, regression].
- seM: Standard errors in the same format.
- `onePlot`: if `true`, all regressors are plotted in one grouped bar graph. Only works when scales are similar across regressors.
"""
function plot_regressions(coeffNameV, regrLabelV, 
    coeffM :: AbstractMatrix{F1}, 
    seM :: AbstractMatrix{F1};
    onePlot :: Bool = false,
    figTitle = nothing) where F1 <: AbstractFloat

    n, nRegr = size(coeffM);
    @assert length(coeffNameV) == n
    @assert length(regrLabelV) == nRegr

    p = blank_plot();
    if onePlot
        plot_regressions_together(coeffNameV, regrLabelV, coeffM, seM;
            fig = p, pos = (1,1), figTitle = figTitle);
    else
        # One plot per regressor
        nr, nc = subplot_layout(n);
        for iReg = 1 : n
            pos = subplot_pos(iReg, nr, nc);
            plot_regression(string.(regrLabelV), coeffNameV[iReg], 
                coeffM[iReg,:], seM[iReg,:]; fig = p, pos = pos,
                forSubPlot = true);
        end
        add_title!(p, figTitle);
    end
    return p
end

function plot_regression(xStrV, yStr, coeffV :: AbstractVector{F1}, 
    seV :: AbstractVector{F1}; 
    fig = blank_plot(), pos = (1,1), 
    kwargs...) where F1 <: AbstractFloat

    n = length(xStrV);
    @assert n == length(coeffV) == length(seV)  "Size mismatch"

    p, ax = bar_graph(xStrV, coeffV; fig = fig, pos = pos, 
        ylabel = string(yStr), yerror = seV, kwargs...);
    return p, ax
end


# Plot regressions in one plot. Each group of bars is a regressor.
function plot_regressions_together(coeffNameV, regrLabelV, coeffM, seM;
    fig = blank_plot(), pos = (1,1),
    figTitle = nothing, kwargs...)

    p, ax = grouped_bar_graph(string.(coeffNameV), coeffM;
        fig = fig, pos = pos, yerror = seM, kwargs...);
    isnothing(figTitle)  ||  (ax.title = figTitle);
    # p = grouped_bar_xy(coeffM',  string.(coeffNameV);
    #     legendV = regrLabelV, legendPos = :best,
    #     yErrorM = seM');
    return p, ax
end

# -----------------