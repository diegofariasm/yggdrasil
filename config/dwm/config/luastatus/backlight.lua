-- Note that this widget only shows backlight level when it changes.
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/dwm/themes/?.lua"
local theme = require("theme")

widget = luastatus.require_plugin('backlight-linux').widget{
    cb = function(level)
        if level ~= nil then
            return string.format(theme.sep .. theme.brgn_ic_fg .. theme.brgn_ic_bg .. '  ' .. theme.brgn_fg .. theme.brgn_bg .. ' %3.0f%% ', level * 100)
        end
    end,
}
