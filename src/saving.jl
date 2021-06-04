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
		newPath = change_extension(filePath, ".pdf");
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
        
        save_fig_notes(figNotes, filePath);
        save_fig_data(dataM, filePath);
	end
end

figsave(p, fDir :: String, fName :: String; figNotes = nothing) =
    figsave(p, joinpath(fDir, fName); figNotes = figNotes);


## --------  These are indpendent of the plotting package

save_fig_notes(figNotes :: AbstractVector, fPath :: AbstractString) =
    save_text_file(fig_notes_path(fPath), figNotes);
save_fig_notes(figNotes :: AbstractString, fPath :: AbstractString) = 
    save_fig_notes([figNotes], fPath);
function save_fig_notes(figNotes :: Nothing, fPath) end

function fig_notes_path(fPath :: AbstractString)
    newDir = fig_data_dir(fPath);
    fDir, fName = splitdir(fPath);
    newPath = joinpath(newDir, change_extension(fName, ".txt"));
    return newPath
end


# Saves the data in text format. 
function save_fig_data(dataM, filePath :: AbstractString)
    newPath = fig_data_path(filePath);
    make_dir(newPath);
    if !isnothing(dataM)
        open(newPath, "w") do io
            println(io, dataM);
        end
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