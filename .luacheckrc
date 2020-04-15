
include_files = {
    "*.lua",
    "./lib/**/**.lua",
    "./services/**/**.lua",
    "./theme/**/**.lua",
}

exclude_files = {
    "./lain/**"
}

-- The default config may set global variables
files["rc.lua"].allow_defined_top = true

-- Global objects defined by the C code
read_globals = {
    "awesome",
    "button",
    "dbus",
    "drawable",
    "drawin",
    "key",
    "keygrabber",
    "mousegrabber",
    "selection",
    "tag",
    "window",
    "table.unpack",
    "math.atan2",
}

globals = {
    "screen",
    "mouse",
    "root",
    "client"
}

files["services/usage/*.lua"] = {
    read_globals = {
        "cpu_now",
        "mem_now",
    },
}

files["services/volume/alsa.lua"] = {
    read_globals = {
        "volume_now",
    },
}

files["services/*.lua"] = {
    read_globals = {
        "net_now",
    },
}
