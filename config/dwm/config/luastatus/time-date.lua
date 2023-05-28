package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/dwm/themes/?.lua"
local theme = require("theme")

widget = {
    plugin = 'timer',
    cb = function()
        return {
            string.format(os.date(theme.sep .. theme.time_ic_fg .. theme.time_ic_bg .. "  " .. theme.time_fg .. theme.time_bg .. " %I:%M %p ")), -- time
						string.format(os.date(theme.sep .. theme.date_ic_fg .. theme.date_ic_bg .. "  " .. theme.date_fg .. theme.date_bg .. " %a, %d %b ")), --date
        }
    end,
}
