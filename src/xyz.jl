"""
	$(SIGNATURES)

Stacked bar graphs for a matrix by (x,y,z).
Dimension `subPlotIdx` is used for subplots. Dimension `groupIdx` is used to group bars. The remaining dimension makes the bars in each group.

# Arguments
- `xyzM`: 3D data array.
- `xyzlabelV`: Vector of labels for x, y, z groups.
Optional:
- `legendPos`: legend position; may be `:none`.

# Example
```julia
grouped_bar_xyz(xyzM, [["x1" "x2"], ["y1", "y2"], ["z1", "z2", z3"]];
    yLabel = "y label", groupIdx = 2, subplotIdx = 3);
```
"""
function grouped_bar_xyz(xyzM :: AbstractArray{F1, 3}, xyzLabelV;
    yLabel :: AbstractString, legendPos = :best, linkAxes = true,
    groupIdx :: Integer = 2, subPlotIdx :: Integer = 3) where F1 <: Number

    nSub = size(xyzM, subPlotIdx);
    legendIdx = legend_index(groupIdx, subPlotIdx);
    subLabelV = xyzLabelV[subPlotIdx];
    
    fig = blank_plot();
    nRows, nCols = subplot_layout(nSub);
    axV = Vector{Axis}(undef, nSub);
    for iSub = 1 : nSub
        dataM = selectdim(xyzM, subPlotIdx, iSub);
        if legendIdx < groupIdx
            # Group index must be rows
            dataM = dataM';
        end
        # Legend only for first panel
        if iSub == 1
            subLegPos = legendPos;
        else
            subLegPos = :none;
        end
        pos = subplot_pos(iSub, nRows, nCols);
        _, axV[iSub] = grouped_bar_graph(xyzLabelV[groupIdx], dataM;
            xlabel = subLabelV[iSub], ylabel = yLabel,
            fig, pos, forSubPlot = true);
    end

    linkAxes  &&  link_axes(axV);

    if legendPos != :none
        legPos, legArgs = legend_args(nRows, nCols, legendPos);
        grouped_bar_legend(fig[legPos...], xyzLabelV[legendIdx];  legArgs...);
    end
    return fig, axV
end

function legend_index(groupIdx, subPlotIdx)
    @assert groupIdx != subPlotIdx
    availV = trues(3);
    availV[groupIdx] = false;
    availV[subPlotIdx] = false;
    legIdx = findfirst(availV);
    return legIdx
end

function group_indices(subPlotIdx)
    if subPlotIdx == 3
        groupIdx = 2;
        legendIdx = 1;
    else
        groupIdx = 3;
        if subPlotIdx == 2
            legendIdx = 1;
        else
            legendIdx = 2;
        end
    end
    @assert sort([subPlotIdx, groupIdx, legendIdx]) == [1,2,3]
    return groupIdx, legendIdx
end

# -----------------