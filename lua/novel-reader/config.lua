local M = {
    file_states = {}
}
local state = require('novel-reader.state')
local regex = require('novel-reader.regex')
local safe_unpack = unpack or table.unpack

function M.setup()
    M.load_from_file()
end

function M.get_config_path()
    local data_dir = vim.fn.stdpath('data')
    local plugin_dir = data_dir .. '/novel-reader'
    local config_file = plugin_dir .. '/config.json'
    return config_file, plugin_dir
end

function M.ensure_dir_exists()
    local config_file, plugin_dir = M.get_config_path()

    if vim.fn.isdirectory(plugin_dir) == 0 then
        vim.fn.mkdir(plugin_dir, 'p')
    end

    return config_file
end

function M.get_file_state()
    local buf = vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(buf)

    if not M.file_states[filepath] then
        M.file_states[filepath] = {
            chapter_pattern = regex.chapter_pattern,
            current_chapter = 1,
            cached_locations = {},
            current_row = 1,
            current_col = 0
        }
    end

    return M.file_states[filepath]
end

function M.update_file_state(new_state)
    local buf = vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(buf)
    M.file_states[filepath] = vim.tbl_deep_extend("keep", new_state, M.get_file_state())
end

function M.load_to_state()
    local file_state = M.get_file_state()

    if next(file_state) ~= nil then
        regex.set_chapter_pattern(file_state.chapter_pattern)
        state.set_chapter(file_state.current_chapter)
        -- state.update_cache(file_state.cached_locations)
        vim.api.nvim_win_set_cursor(0, {file_state.current_row, file_state.current_col})
    end
end

function M.save_from_state()
    local file_state = M.get_file_state()

    file_state.chapter_pattern = regex.chapter_pattern

    local row, col = safe_unpack(vim.api.nvim_win_get_cursor(0))
    file_state.current_row = row
    file_state.current_col = col
    file_state.current_chapter = state.get_current_chapter_by_row(row)
    -- file_state.cached_locations = state.chapter_locations

    M.update_file_state(file_state)
end

function M.save_to_file()
    if not state.chapter_locations then
        return
    end

    local data_file = M.ensure_dir_exists()
    local ok, data = pcall(vim.fn.readfile, data_file)

    local states = {}
    if ok and #data > 0 then
        states = vim.json.decode(table.concat(data, '\n')) or {}
    end

    for path, st in pairs(M.file_states) do
        if vim.fn.filereadable(path) == 1 then
            states[path] = st
        end
    end

    vim.fn.writefile({ vim.json.encode(states) }, data_file)
end

function M.load_from_file()
    local data_file = M.ensure_dir_exists()
    local ok, data = pcall(vim.fn.readfile, data_file)

    if ok and #data > 0 then
        local states = vim.json.decode(table.concat(data, '\n')) or {}
        for path, st in pairs(states) do
            if vim.fn.filereadable(path) == 1 then
                M.file_states[path] = st
            end
        end
    end
end

return M
