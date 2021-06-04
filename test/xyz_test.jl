# Code to be factored into a plotting package

## ------------  Setup

function make_matrix_xyz(nx, ny, nz)
    m = zeros(nx, ny, nz);
    for ix = 1 : nx
        m[ix,:,:] .+= 0.1 * ix;
    end
    for iy = 1 : ny
        m[:,iy,:] .+= 0.2 * iy;
    end
    for iz = 1 : nz
        m[:,:,iz] .+= 0.3 * iz;
    end
    return m
end

function make_test_labels(nx, ny, nz)
    xyzLabelV = [make_test_labels("x", nx), make_test_labels("y", ny), make_test_labels("z", nz)];
    return xyzLabelV
end

make_test_labels(lStr :: AbstractString, n :: Integer) = 
    ["$lStr$j" for j = 1 : n];


## ---------------  Tests

function grouped_bar_xyz_test()
    @testset "Grouped bar xyz" begin
        nx = 5; ny = 4; nz = 3;
        m = make_matrix_xyz(nx, ny, nz);
        xyzLabelV = make_test_labels(nx, ny, nz);
        yStr = "y values";

        for subPlotIdx = 1 : 3
            for groupIdx = 1 : 3
                if groupIdx != subPlotIdx
                    p, _ = grouped_bar_xyz(m, xyzLabelV;
                        yLabel = yStr, legendPos = :outerright, 
                        groupIdx = groupIdx, subPlotIdx = subPlotIdx);
                    fName = "plot_by_xyz_$groupIdx$subPlotIdx.pdf";
                    fPath, notesPath = fig_test_setup(fName);
                    figsave(p,  fPath);
                    @test isfile(fPath)
                end
            end
        end
    end
end

@testset "Plot (x,y,z)" begin
    grouped_bar_xyz_test()
end


# ------------