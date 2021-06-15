using Test

function regression_test(interceptAsText :: Bool)
    @testset "Regression $interceptAsText" begin
        nRegr = 5;
        coeffNameV = ["beta$j" for j = 1 : nRegr];
        coeffV = LinRange(0.9, 0.2, nRegr);
        seV = 0.1 .* coeffV;
        p, _ = plot_regression(coeffNameV, "y label", coeffV, seV;
            interceptAsText = interceptAsText, interceptName = "beta2",
            figTitle = "Figure title");

        fName = "plot_regression";
        if interceptAsText
            fName = fName * "_interceptAsTest";
        end
        fPath, notesPath = fig_test_setup("$fName.pdf");
        figsave(p, fPath);
        @test isfile(fPath)
	end

end

function regressions_test(onePlot :: Bool, interceptAsText :: Bool)
    # rng = MersenneTwister(123);
    @testset "Regressions $onePlot" begin
        nr = 4;
        nRegr = 3;
        coeffM = LinRange(0.5, 0.4, nr) .+ LinRange(0.1, 0.2, nRegr)';
        #  randn(rng, nr, nRegr) .* 10.0;
        seM = 0.1 .* coeffM;
        coeffNameV = ["beta$j"  for j = 1 : nr];
        regrNameV = ["Regr$j" for j = 1 : nRegr];
        p = plot_regressions(coeffNameV, regrNameV, 
            coeffM, seM; 
            onePlot = onePlot, 
            interceptAsText = interceptAsText, interceptName = "beta2",
            figTitle = "Figure title");
        # p = plot_regressions(Symbol.(coeffNameV), Symbol.(regrNameV), 
        #     coeffM, seM; onePlot = onePlot, figTitle = "Figure title");
        # add_title!(p, "Figure title"; color = :red);

        fName = "plot_regressions";
        if onePlot
            fName = fName * "_oneplot";
        end
        if interceptAsText
            fName = fName * "_interceptAsText";
        end
        fPath, notesPath = fig_test_setup("$fName.pdf");
        figsave(p, fPath);
        @test isfile(fPath)
	end
end


@testset "Regression plots" begin
    for interceptAsText in (true, false)
        regression_test(interceptAsText);
    end
    for onePlot in (true, false)
        for interceptAsText in (true, false)
            regressions_test(onePlot, interceptAsText);
        end
    end
end

# -------------