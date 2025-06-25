local M = {}
local regex = require("novel-reader.regex")

function M.build(buf, pattern)
    if not pattern then return {} end

    local locations = {}
    local line_count = vim.api.nvim_buf_line_count(buf)

    for i = 0, line_count - 1 do
        local line = vim.api.nvim_buf_get_lines(buf, i, i + 1, false)[1]
        if line and regex.compile():match_str(line) then
            table.insert(locations, i + 1)
        end
    end

    return locations
end

return M
