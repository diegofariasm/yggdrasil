package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/dwm/themes/?.lua"
local theme = require("theme")

widget = luastatus.require_plugin('battery-linux').widget{
    period = 2,
    cb = function(t)
        local symbol = ({
            Charging    = '',
            Discharging = '',
        })[t.status] or ''
        local rem_seg
        if t.rem_time then
            local h = math.floor(t.rem_time)
            local m = math.floor(60 * (t.rem_time - h))
            rem_seg = string.format('%2dh %02dm', h, m)
        end
        return {
            string.format(theme.sep .. theme.btt_ic_fg .. theme.btt_ic_bg .. ' %s ' .. theme.btt_fg .. theme.btt_bg .. ' %3d%% ', symbol, t.capacity),
            rem_seg,
        }
    end,
}
