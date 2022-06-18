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
- `interceptAsText`: don't show a bar for intercept; show it as text in the graph (to avoid vastly different scales).
"""
function plot_regressions(coeffNameV, regrLabelV, 
    coeffM :: AbstractMatrix{F1}, 
    seM :: AbstractMatrix{F1};
    onePlot :: Bool = false,
    interceptAsText = interceptAsText, interceptName = "cons",
    figTitle = nothing) where F1 <: AbstractFloat

    n, nRegr = size(coeffM);
    @assert length(coeffNameV) == n
    @assert length(regrLabelV) == nRegr

    p = blank_plot();
    if onePlot
        plot_regressions_together(coeffNameV, regrLabelV, coeffM, seM;
            interceptAsText = interceptAsText, interceptName = interceptName,
            fig = p, pos = (1,1), figTitle = figTitle);
    else
        # One plot per regressor
        nr, nc = subplot_layout(n);
        for iReg = 1 : n
            pos = subplot_pos(iReg, nr, nc);
            # No point having intercept as text here. It gets its own plot.
            plot_regression(string.(regrLabelV), coeffNameV[iReg], 
                coeffM[iReg,:], seM[iReg,:]; 
                fig = p, pos,  forSubPlot = true);
        end
        add_title!(p, figTitle);
    end
    return p
end

function plot_regression(xStrV, yStr, 
    coeffV :: AbstractVector{F1},  seV :: AbstractVector{F1}; 
    fig = blank_plot(), pos = (1,1), forSubPlot = false,
    interceptAsText :: Bool = false,
    interceptName = :cons,
    kwargs...) where F1 <: AbstractFloat

    n = length(xStrV);
    @assert n == length(coeffV) == length(seV)  "Size mismatch"

    if interceptAsText
        idxV, constIdx = idx_drop_regressor(xStrV, interceptName);
    else
        idxV = 1 : length(xStrV);
        constIdx = nothing;
    end
    if !isnothing(seV)
        seV = seV[idxV];
    end

    _, ax = bar_graph(xStrV[idxV], coeffV[idxV]; 
        fig, pos, forSubPlot, 
        ylabel = string(yStr), yerror = seV, kwargs...);

    if interceptAsText  &&  !isnothing(constIdx)
        show_intercept_text(ax, coeffV, seV, constIdx);
    end
    return fig, ax
end

# Drop a regressor by name. Return remaining indices and matching index.
function idx_drop_regressor(xStrV, regrName)
    idxV = findall(x -> !isequal(x, regrName), xStrV);
    matchIdx = findfirst(x -> isequal(x, regrName), xStrV);
    return idxV, matchIdx
end

function show_intercept_text(ax, coeffV :: AbstractVector{F1}, seV, constIdx) where F1
    xPos = 1.0;
    idxV = [j  for j = 1 : length(coeffV)  if j != constIdx];
    yPos = maximum(coeffV[idxV]) + 0.1;
    intercept = round(coeffV[constIdx], digits = 2);
    se = round(seV[constIdx], digits = 2);
    interStr = "Intercept: $intercept ($se)";
    text!(ax, interStr; position = (xPos, yPos));
end

# Plot regressions in one plot. Each group of bars is a regressor.
function plot_regressions_together(coeffNameV, regrLabelV, coeffM, seM;
    fig = blank_plot(), pos = (1,1),
    interceptAsText :: Bool = false,
    interceptName = :cons,
    figTitle = nothing, kwargs...)

    if interceptAsText
        idxV, constIdx = idx_drop_regressor(coeffNameV, interceptName);
    else
        idxV = 1 : length(coeffNameV);
        constIdx = nothing;
    end
    if !isnothing(seM)
        seM = seM[idxV, :];
    end

    _, ax = grouped_bar_graph(string.(coeffNameV[idxV]), coeffM[idxV, :];
        fig = fig, pos = pos, yerror = seM, kwargs...);
    isnothing(figTitle)  ||  (ax.title = figTitle);
    if interceptAsText  &&  !isnothing(constIdx)
        show_intercept_text(ax, coeffM, seM, constIdx);
    end
    return fig, ax
end


# Rows are coefficients.
function show_intercept_text(ax, coeffM :: AbstractMatrix{F1}, seM, constIdx) where F1
    nCoeff, nRegr = size(coeffM);
    if isnothing(seM)
        seV = nothing;
    else
        seV = seM[constIdx, :];
    end
    idxV = [j  for j = 1 : nCoeff  if j != constIdx];
    yPos = maximum(coeffM[idxV, :]) + 0.1;
    text!(ax, make_intercept_text(coeffM[constIdx,:], seV); position = (1.0, yPos));
end

function make_intercept_text(interceptV, seV)
    nRegr = length(interceptV);
    interStr = "Intercepts: ";
    for j = 1 : nRegr
        sepStr = (j == nRegr)  ?  ""  :  ", ";
        if isnothing(seV)  
            seStr = "";
        else
            se = round(seV[j], digits = 2);
            seStr = " ($se)";
        end
        inter = round(interceptV[j], digits = 2);
        interStr = interStr * " $inter" * seStr * sepStr;
    end
    return interStr
end


# -----------------