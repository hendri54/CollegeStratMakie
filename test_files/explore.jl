using CairoMakie, ColorSchemes;

function explore1()
    # set_theme!(theme_ggplot2());
    set_theme!(theme_minimal());
    f = Figure()
    labelV = ["lbl $j" for j = 1 : 3];
    n = length(labelV);
    elements = [PolyElement(color = ColorSchemes.corkO[16 * i]) for i in 1:n];
    # To verify that RGB values differ across entries
    @show elements
    Legend(f[1,1], elements, labelV);
    f

    fPath = "/Users/lutz/Documents/projects/p2019/college_stratification/CollegeStratMakie/test_files/explore1.pdf";
    save(fPath, f);
end

function explore2()

end

f = Figure();
ax = f[1,1] = Axis(f);
labelV = ["l1", "l2"];
colorV = [:red, :blue];
n = length(colorV);
elements = [PolyElement(color = colorV[j])  for j = 1 : n];
Legend(f[1,2], elements, labelV, nothing; labelsize = 24);
fPath = "/Users/lutz/Documents/projects/p2019/college_stratification/CollegeStratMakie/test_files/explore2.pdf";
save(fPath, f);


# --------------
