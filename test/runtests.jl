using CollegeStratBase, CollegeStratMakie
using Test

csp = CollegeStratMakie;

function fig_test_setup(figName)
    fPath = joinpath(csp.pkg_test_dir(), figName);
    notesPath = csp.fig_notes_path(fPath);
    isfile(fPath)  &&  rm(fPath);
    isfile(notesPath)  &&  rm(notesPath);

    plot_defaults();
    return fPath, notesPath
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
        fPath, notesPath = fig_test_setup("fig_save_test.pdf");
        p, _ = csp.test_bar_graph();

        fNotes = ["This is a test figure.", "With figure notes"];
        figsave(p, fPath; figNotes = fNotes);
        @test isfile(fPath)
        @test isfile(notesPath)
    end
end


function bar_graph_test()
    @testset "Bar graph" begin
        fPath, notesPath = fig_test_setup("bar_graph_test.pdf");
        n = 5;
        groupLabelV = ["G$j"  for j = 1 : n];
        p, _ = bar_graph(groupLabelV, LinRange(2, 3, n); 
            xlabel = "x", ylabel = "y", yerror = LinRange(0.2, 0.3, n));
        figsave(p, fPath);
        @test isfile(fPath);
    end
end


function grouped_bar_test()
    @testset "Grouped bar graph" begin
        fPath, notesPath = fig_test_setup("grouped_bar_test.pdf");
        # 4 groups of 6 bars each
        nr = 4; nc = 6;
        # Bar labels (one for each column)
        grpLabelV = ["Grp $j" for j = 1 : nr];
        labelV = ["Lbl $j" for j = 1 : nc];
        dataM = (10 .*(1:nr)) .+ (1 : nc)';
        yerrorM = 0.1 .* dataM;
        # fig = blank_plot();
        # ax = make_axis(fig; xlabel = "x", ylabel = "y"); 
            # xticks = (1:nr, ));
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


function histogram_test()
    @testset "Histogram" begin
        fPath, notesPath = fig_test_setup("histogram_test.pdf");
        p, _ = histogram_plot(log.(LinRange(1.0, 2.0, 100)); xlabel = "x")
        figsave(p, fPath);
        @test isfile(fPath);
    end
end

function contour_test()
    @testset "Contour" begin
        fPath, notesPath = fig_test_setup("contour_test.pdf");
        xV = LinRange(1.0, 4.0, 10);
        yV = LinRange(2.0, 3.0, 8);
        zM = sin.(xV) .+ sin.(yV)';
        p, _ = contour_plot(xV, yV, zM; xlabel = "x", ylabel = "y");
        figsave(p, fPath);
        @test isfile(fPath);
    end
end


function line_plot_test()
    @testset "Line plot" begin
        fPath, notesPath = fig_test_setup("line_plot_test.pdf");
        nx = 7;
        xV = LinRange(-2.0, 1.5, nx);
        yM = LinRange(0.3, 0.5, nx) .+ LinRange(1.0, 0.5, 4)';
        p, ax = line_plot(xV, yM; xlabel = "x", 
            labelV = ["Lbl $j" for j = 1 : 4], legPos = :below);
        figsave(p, fPath);
        @test isfile(fPath);

        fPath2, _ = fig_test_setup("add_line_test.pdf");
        yV = xV .+ 0.5;
        p, ax = line_plot(xV, yV; ylabel = "y");
        add_line!(ax, xV, yV .+ 1.0);
        figsave(p, fPath2);
        @test isfile(fPath2);
    end
end

function scatter_plot_test()
    @testset "Line plot" begin
        fPath, notesPath = fig_test_setup("scatter_plot_test.pdf");
        nx = 7;
        xV = LinRange(-2.0, 1.5, nx);
        yM = LinRange(0.3, 0.5, nx) .+ LinRange(1.0, 0.5, 4)';
        p, _ = scatter_plot(xV, yM; xlabel = "x");
        figsave(p, fPath);
        @test isfile(fPath);

        fPath2, _ = fig_test_setup("add_scatter_test.pdf");
        yV = xV .+ 0.5;
        p, ax = scatter_plot(xV, yV; ylabel = "y");
        add_scatter!(ax, xV, yV .+ 1.0);
        figsave(p, fPath2);
        @test isfile(fPath2);
    end
end

@testset "All" begin
    subplot_layout_test();
    fig_save_test();
    grouped_bar_test();
    bar_graph_test();
    line_plot_test();
    scatter_plot_test();
    contour_test();
    histogram_test();
    include("subplot_test.jl");
    include("regression_test.jl");
    include("xyz_test.jl");
end

# ------------------