using Test

function regression_test(onePlot :: Bool)
    # rng = MersenneTwister(123);
    @testset "" begin
        fName = "plot_regressions";
        if onePlot
            fName = fName * "_oneplot";
        end
        fPath, notesPath = fig_test_setup("$fName.pdf");

        nr = 4;
        nRegr = 3;
        coeffM = LinRange(0.5, 0.4, nr) .+ LinRange(0.1, 0.2, nRegr)';
        #  randn(rng, nr, nRegr) .* 10.0;
        seM = 0.1 .* coeffM;
        coeffNameV = ["beta$j"  for j = 1 : nr];
        regrNameV = ["Regr$j" for j = 1 : nRegr];
        p = plot_regressions(coeffNameV, regrNameV, coeffM, seM; 
            onePlot = onePlot, figTitle = "Figure title");
        p = plot_regressions(Symbol.(coeffNameV), Symbol.(regrNameV), 
            coeffM, seM; onePlot = onePlot, figTitle = "Figure title");
        # add_title!(p, "Figure title"; color = :red);

        figsave(p, fPath);
        @test isfile(fPath)
	end
end


@testset "Regression plots" begin
    regression_test(true);
    regression_test(false);
end

# -------------