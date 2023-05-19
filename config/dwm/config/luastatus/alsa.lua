package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/dwm/themes/?.lua"
local theme = require("theme")

widget = {
    plugin = 'alsa',
		opts = {
				timeout = 5,
		},
    cb = function(t)
				if t == nil then
						return nil
				end
        if t.mute then
            return theme.sep .. theme.vol_ic_fg .. theme.vol_ic_bg .. '  '
        else
            local percent = (t.vol.cur - t.vol.min) / (t.vol.max - t.vol.min) * 100
            return string.format(theme.sep .. theme.vol_ic_fg .. theme.vol_ic_bg .. '  ' .. theme.vol_fg .. theme.vol_bg .. ' %3d%% ', math.floor(0.5 + percent))
        end
    end,
}
