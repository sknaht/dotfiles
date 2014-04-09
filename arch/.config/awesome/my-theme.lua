icons_dir = "~/.config/awesome/icons/"

theme = {}

theme.font          = "Terminus 8"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 5
theme.border_normal = "#000000"
theme.border_focus  = "#119933"
theme.border_marked = "#91231c"

theme.wallpaper = "~/.config/awesome/bg2.jpg"

theme.widget_mem       = icons_dir .. "/mem.png"
theme.widget_cpu       = icons_dir .. "/cpu.png"
theme.widget_temp      = icons_dir .. "/temp.png"
theme.widget_hdd       = icons_dir .. "/hdd.png"
theme.widget_music     = icons_dir .. "/note.png"
theme.widget_music_on  = icons_dir .. "/note_on.png"
theme.widget_vol       = icons_dir .. "/vol.png"
theme.widget_vol_low   = icons_dir .. "/vol_low.png"
theme.widget_vol_no    = icons_dir .. "/vol_no.png"
theme.widget_vol_mute  = icons_dir .. "/vol_mute.png"

theme.taglist_squares_sel   = icons_dir .. "/square_sel.png"
theme.taglist_squares_unsel = icons_dir .. "/square_unsel.png"

return theme
