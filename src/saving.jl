"""
    $(SIGNATURES)

Save a figure to a pdf file.

# Arguments

- p: Figure.
- io: If provided, display a short version of the file path there.
- `dataM`: If provided, write the data to a text file. A simple method of preserving underlying data. 
"""
function figsave(p, filePath :: String; 
    figNotes = nothing, io :: Union{Nothing, IO} = nothing,
    dataM = nothing)

    @assert !(p isa Tuple)  "Tuple input $p. Expecting a Figure";
    if !isempty(filePath)
		newPath = change_extension(filePath, FigExtension);
        fDir, fName = splitdir(newPath);
        if !isdir(fDir)
            mkpath(fDir);
        end
        # This prevents trouble with corrupt files
        isfile(newPath)  &&  rm(newPath);
        save(newPath, p);
        if !isnothing(io)
            pathStr = fpath_to_show(filePath);
            println(io, "Saved figure:  $pathStr");
        end
        
        save_fig_notes(figNotes, filePath; io);
        save_fig_data(dataM, filePath; io);
	end
end

figsave(p, fDir :: String, fName :: String; figNotes = nothing) =
    figsave(p, joinpath(fDir, fName); figNotes = figNotes);


## --------  These are indpendent of the plotting package

save_fig_notes(figNotes :: AbstractVector, fPath :: AbstractString; io = nothing) =
    save_text_file(fig_notes_path(fPath), figNotes; io);
save_fig_notes(figNotes :: AbstractString, fPath :: AbstractString; io = nothing) = 
    save_fig_notes([figNotes], fPath);
function save_fig_notes(figNotes :: Nothing, fPath; io) end

function fig_notes_path(fPath :: AbstractString)
    newDir = fig_data_dir(fPath);
    fDir, fName = splitdir(fPath);
    newPath = joinpath(newDir, change_extension(fName, ".txt"));
    return newPath
end


"""
	$(SIGNATURES)

Saves the data in text format. DataFrames are also written to CSV.
"""
function save_fig_data(dataM, filePath :: AbstractString; io = nothing)
    if !isnothing(dataM)
        newPath = fig_data_path(filePath);
        make_dir(newPath);
        if dataM isa DataFrame
            write_df_to_csv(dataM, newPath);
        end

        open(newPath, "w") do ioWrite
            println(ioWrite, dataM);
        end
    end
end

function write_df_to_csv(dataM :: AbstractDataFrame, fPath :: AbstractString)
    csvPath = change_extension(fPath, ".csv");
    if nrow(dataM) > 1_000
        @warn """
            DataFrame for $csvPath too large
            $(nrow(dataM)) rows
            """;
    else
        CSV.write(csvPath, dataM);
    end
end


function fig_data_path(fPath :: AbstractString)
    newDir = fig_data_dir(fPath);
    fDir, fName = splitdir(fPath);
    newPath = joinpath(newDir, change_extension("data_" * fName, ".txt"));
    return newPath
end

function fig_data_dir(fPath :: AbstractString)
    fDir, fName = splitdir(fPath);
    newDir = joinpath(fDir, "plot_data");
    isdir(newDir)  ||  mkpath(newDir);
    return newDir
end

# -----------