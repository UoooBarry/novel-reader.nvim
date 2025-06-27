local M = {
    current_chapter = 1,
    chapter_locations = {},
    current_index = 1,
}

function M.set_chapter(num)
    if type(num) == "number" and num > 0 then
        M.current_chapter = math.floor(num)
        M.current_index = math.min(num, #M.chapter_locations)
    end
end

function M.update_cache(locations)
    M.chapter_locations = locations or {}
    M.current_index = math.min(M.current_index, #locations)
end

function M.get_location()
    return M.chapter_locations[M.current_index]
end

function M.get_current_chapter()
    return M.current_chapter
end

function M.get_current_chapter_by_row(row)
    local locations = M.chapter_locations
    if #locations == 0 then return 0 end

    if row < locations[1] then return 0 end
    if row >= locations[#locations] then return #locations end

    local left, right = 1, #locations
    while left <= right do
        local mid = math.floor((left + right) / 2)
        if locations[mid] == row then
            return mid
        elseif locations[mid] < row then
            left = mid + 1
        else
            right = mid - 1
        end
    end

    return right
end

return M
