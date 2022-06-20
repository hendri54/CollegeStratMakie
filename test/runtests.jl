using CollegeStratBase, CollegeStratMakie
using CairoMakie, Test

csp = CollegeStratMakie;

function fig_test_setup(figName; forSubPlot = false)
    suffix = forSubPlot  ?  "_subplot"  :  "";
    fPath = joinpath(csp.pkg_test_dir(), figName * suffix * ".pdf");
    notesPath = csp.fig_notes_path(fPath);
    isfile(fPath)  &&  rm(fPath);
    isfile(notesPath)  &&  rm(notesPath);

    plot_defaults();
    return fPath, notesPath
end


function axis_test(forSubPlot)
    @testset "Axis" begin

        ax, dUnused = make_axis(blank_plot(), (1,1); forSubPlot,
            xticklabelsize = 12);
        @test ax isa Axis;

        xTickSize = 10;
        d, dUnused = csp.axis_args(; forSubPlot, xticklabelsize = xTickSize, 
            notValid = 99);
        @test d[:xticklabelsize] == xTickSize;
        @test check_axis_args(d);
    end
end


function subplot_layout_test()
    @testset "Subplot layout" begin
        for nPlots = 2 : 10
            nr, nc = subplot_layout(nPlots);
            isValid = true;
            for j = 1 : nPlots
                ir, ic = subplot_pos(j, nr, nc);
                isValid = isValid  && (1 <= ic <= nc)  && (1 <= ir <= nr);
            end
            @test isValid
        end
    end
end


function fig_save_test()
    @testset "Save figure" begin
        fPath, notesPath = fig_test_setup("fig_save");
        p, _ = csp.test_bar_graph();

        fNotes = ["This is a test figure.", "With figure notes"];
        figsave(p, fPath; figNotes = fNotes);
        @test isfile(fPath)
        @test isfile(notesPath)
    end
end


function bar_graph_test(forSubPlot)
    @testset "Bar graph" begin
        fPath, notesPath = fig_test_setup("bar_graph"; forSubPlot);
        fig, ax = csp.test_bar_graph(; forSubPlot);
        figsave(fig, fPath);
        @test isfile(fPath);
    end
end


function grouped_bar_test()
    @testset "Grouped bar graph" begin
        fPath, notesPath = fig_test_setup("grouped_bar");
        # 4 groups of 6 bars each
        nr = 4; nc = 6;
        # Bar labels (one for each column)
        grpLabelV = ["Grp $j" for j = 1 : nr];
        labelV = ["Lbl $j" for j = 1 : nc];
        dataM = (10 .*(1:nr)) .+ (1 : nc)';
        yerrorM = 0.1 .* dataM;
        fig, _ = grouped_bar_graph(grpLabelV, dataM; 
            yerror = yerrorM,
            legendPos = (1,2), xlabel = "x", ylabel = "y");
        # Cannot create fig[1,2] first
        # not having a title may not work either
        grouped_bar_legend(fig[1,2], labelV; title = "Bars");
        figsave(fig, fPath; figNotes = ["Notes"]);
        @test isfile(fPath)
        @test isfile(notesPath)
    end
end


function histogram_test(forSubPlot)
    @testset "Histogram" begin
        p, _ = histogram_plot(log.(LinRange(1.0, 2.0, 100)); 
            forSubPlot, xlabel = "x");
        fPath, notesPath = fig_test_setup("histogram"; forSubPlot);
        figsave(p, fPath);
        @test isfile(fPath);
    end
end

function contour_test(forSubPlot)
    @testset "Contour" begin
        xV = LinRange(1.0, 4.0, 10);
        yV = LinRange(2.0, 3.0, 8);
        zM = sin.(xV) .+ sin.(yV)';
        p, _ = contour_plot(xV, yV, zM; forSubPlot, xlabel = "x", ylabel = "y");
        fPath, notesPath = fig_test_setup("contour"; forSubPlot);
        figsave(p, fPath);
        @test isfile(fPath);
    end
end


function line_plot_test(forSubPlot)
    @testset "Line plot" begin
        p, ax = csp.test_line_plot(; forSubPlot);
        fPath, notesPath = fig_test_setup("line_plot"; forSubPlot);
        figsave(p, fPath);
        @test isfile(fPath);
    end
end

function add_line_test()
    @testset "Add line" begin
        nx = 7;
        xV = LinRange(-2.0, 1.5, nx);
        yV = xV .+ 0.5;
        p, ax = line_plot(xV, yV; 
            ylabel = "y", color = get_colors(1, 2),
            ylims = (0, nothing));
        add_line!(ax, xV, yV .+ 1.0; color = get_colors(2, 2));
        fPath2, _ = fig_test_setup("add_line");
        figsave(p, fPath2);
        @test isfile(fPath2);
    end
end

function line_error_bands_test()
    @testset "Line error bands" begin
        nx = 7;
        ny = 4;
        xV = LinRange(-2.0, 1.5, nx);
        yM = LinRange(0.3, 0.5, nx) .+ LinRange(1.0, 0.5, ny)';
        p, ax = line_plot(xV, yM; xlabel = "x", 
            labelV = ["Lbl $j" for j = 1 : ny], legPos = :below);
        for iy = 1 : ny
            add_error_band!(ax, xV, yM[:,iy], LinRange(0.05, 0.1, nx);
                color = (get_colors(iy, ny), 0.2));
        end
        fPath3, _ = fig_test_setup("line_error");
        figsave(p, fPath3);
        @test isfile(fPath3);
    end
end

function scatter_plot_test(forSubPlot)
    @testset "Scatter plot" begin
        nx = 7;
        xV = LinRange(-2.0, 1.5, nx);
        yM = LinRange(0.3, 0.5, nx) .+ LinRange(1.0, 0.5, 4)';
        p, _ = scatter_plot(xV, yM; forSubPlot, xlabel = "x");
        fPath, notesPath = fig_test_setup("scatter_plot"; forSubPlot);
        figsave(p, fPath);
        @test isfile(fPath);
    end
end

function add_scatter_test()
    @testset "Add scatter" begin
        nx = 7;
        xV = LinRange(-2.0, 1.5, nx);
        yV = xV .+ 0.5;
        p, ax = scatter_plot(xV, yV; ylabel = "y");
        add_scatter!(ax, xV, yV .+ 1.0; color = get_colors(2, 2));
        fPath2, _ = fig_test_setup("add_scatter");
        figsave(p, fPath2);
        @test isfile(fPath2);
    end
end

@testset "All" begin
    subplot_layout_test();
    fig_save_test();

    for forSubPlot in (true, false)
        axis_test(forSubPlot);
        bar_graph_test(forSubPlot);
        line_plot_test(forSubPlot);
        scatter_plot_test(forSubPlot);
        contour_test(forSubPlot);
        histogram_test(forSubPlot);
    end

    line_error_bands_test();
    add_line_test();
    add_scatter_test();

    grouped_bar_test();
    include("subplot_test.jl");
    include("regression_test.jl");
    include("xyz_test.jl");
end

# ------------------