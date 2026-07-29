local ttml2srt = {}

local function checkfile(filepath)
    local f = io.open(filepath, "r")
    if f then
        f:close()
        return 0
    else
        return nil
    end
end

local function convertbr(line)
    return line:gsub("<br/>", "\n")
end

local function stripxml(line)
    local startpos = line:find(">") + 1
    local endpos = line:len() - 4
    return convertbr(line:sub(startpos, endpos))
end

local function gettimes(line)
    return line:sub(line:find("begin=") + 7, line:find("begin=") + 18):gsub("%.", ",") .. " --> " .. line:sub(line:find("end=") + 5, line:find("end=") +16):gsub("%.", ",")
end

function ttml2srt.convert(filepath)
    local datastring = ""
    local srtnumber = 1
    if checkfile(filepath) then
        for line in io.lines(filepath) do
            if line:sub(1, 2) == "<p" then
                datastring = datastring .. srtnumber .. "\n" .. gettimes(line) .. "\n" .. stripxml(line) .. "\n\n"
                srtnumber = srtnumber + 1
            end
        end
        local outfile = io.open(filepath:gsub(".ttml", ".srt"), "w")
        if outfile then
            outfile:write(datastring)
            outfile:close()
        end
    end
end

return ttml2srt