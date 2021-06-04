function subplot_test(grouped :: Bool)
    @testset "Subplots" begin
        nPlots = 4;
        fig = blank_plot();
        nr, nc = subplot_layout(nPlots);
        # axV = make_axes!(fig, nPlots);
        nx = 6;
        ny = 3;
        xTickLbls = ["x$j"  for j = 1 : nx];
        if grouped
            dataM = (1:nx) .+ (1 : ny)';
            suffix = "_grouped";
            plot_fct = grouped_bar_graph;
        else
            dataM = collect(1 : nx);
            suffix = "";
            plot_fct = bar_graph;
        end
        for ip = 1 : nPlots
            pos = subplot_pos(ip, nr, nc);
            # ylabel is ignored, if plotting into existing axis
            # But when plotting into Figure, it all works out.
            plot_fct(xTickLbls, ip .+ dataM; fig = fig, pos = pos, 
                forSubPlot = true,
                ylabel = "y lbl",
                xticks = (2 : 2 : nx, xTickLbls[2 : 2 : nx]));
        end
        fPath, notesPath = fig_test_setup("subplots_test$suffix.pdf");
        figsave(fig, fPath);
        @test isfile(fPath)
    end
end

function subplot2_test()
    @testset "Subplots" begin
        nPlots = 5;
        fig = blank_plot();
        nr, nc = subplot_layout(nPlots);
        nx = 10;
        xV = 1 : nx;
        xTickLbls = ["x$j"  for j = 1 : nx];
        for ir = 1 : nr
            for ic = 1 : nc
                if (ir-1) * nc + ic <= nPlots
                    ax = make_axis(fig; ir = ir, ic = ic,
                        forSubPlot = true,
                        ylabel = "y label",
                        xticks = (2 : 2 : nx, xTickLbls[2 : 2 : nx]));
                    bar_graph!(ax, ir .+ xV);
                end
            end
        end
        fPath, notesPath = fig_test_setup("subplots2_test.pdf");
        figsave(fig, fPath);
        @test isfile(fPath)
    end
end

function plot_fct(fig, pos; kwargs...)
    ax = make_axis(fig, pos; kwargs...);
    add_line!(ax, 1:10, 1:10; kwargs...);
    return ax
end

function subplot_fct_test()
    @testset "Subplot function" begin
        nPlots = 5;
        plotFctV = [(x,y; kwargs...) -> plot_fct(x,y; xlabel = "x$j", kwargs...)  
            for j = 1 : nPlots];
        fig, axV = subplots(plotFctV; figTitle = "Title");
        fPath, notesPath = fig_test_setup("subplot_fct_test.pdf");
        figsave(fig, fPath);
        @test isfile(fPath)
    end
end


@testset "Subplots" begin
    for grouped in (true, false)
        subplot_test(grouped);
    end
    subplot2_test();
    subplot_fct_test();
end

# -------------