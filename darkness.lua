--[[
    ============================================================
     Darkness
     Version 26.11.4  (format: YY.MM.release)
     Screen darkness overlay for FFXIERA (FFXI)
    ------------------------------------------------------------
     Author : Voleur
     Tones  : Normal / Dark 1 / Dark 2 / Dark 3, cycled with a hotkey
    ============================================================
]]

-- ============================================================
--  USER CONFIG: edit these, save, then //lua r darkness
-- ============================================================

-- Hotkey. Windower bind syntax:
--    !  = Alt        ^  = Ctrl        ~  = Shift
--  Examples:
--    '!f12'  -> Alt+F12   (default)
--    'f12'   -> F12
--    '^f11'  -> Ctrl+F11
--    '~!b'   -> Shift+Alt+B
local HOTKEY = '!f12'

-- Darkness levels, from lightest to darkest.
-- Values are 0-255 (0 = no effect, 255 = black screen).
-- You can add or remove entries; the cycle adapts automatically.
local DARK_LEVELS = { 40, 70, 100 }

-- Brightness level (white overlay), 0-255. Last step of the cycle.
local BRIGHT_LEVEL = 20

-- ============================================================

_addon.name = 'Darkness'
_addon.author = 'Voleur'
_addon.version = '26.11.4'
_addon.commands = {'darkness', 'dark'}

-- Lua addons cannot touch the real gamma ramp, so this addon darkens
-- the screen with a full-screen translucent black overlay.
-- Level 0 = normal (no overlay), levels 1..N = entries of DARK_LEVELS.

local config = require('config')

-- Only the current level is saved; strengths live in DARK_LEVELS above,
-- so editing them always takes effect after a reload.
local defaults = {
    level = 0,
}

local settings = config.load(defaults)
local PRIM = 'darkness_overlay'
local bound_key = nil -- key currently bound this session

local function msg(text)
    windower.add_to_chat(207, '[Darkness] ' .. text)
end

local function clamp(v)
    return math.max(0, math.min(255, v))
end

-- Sanitize a level loaded from an older or edited settings file
settings.level = tonumber(settings.level) or 0
local BRIGHT_INDEX = #DARK_LEVELS + 1
if settings.level < 0 or settings.level > BRIGHT_INDEX then
    settings.level = 0
end

-- Bind the cycle command to a key, releasing the previous one
local function bind_key(key)
    if bound_key then
        windower.send_command('unbind ' .. bound_key)
    end
    windower.send_command('bind ' .. key .. ' darkness cycle')
    bound_key = key
end

-- Redraw the overlay from the current level
local function apply()
    local s = windower.get_windower_settings()
    -- Oversize to cover both window and UI resolution; extra size is harmless
    local w = math.max(s.x_res or 0, s.ui_x_res or 0) + 100
    local h = math.max(s.y_res or 0, s.ui_y_res or 0) + 100

    windower.prim.set_position(PRIM, 0, 0)
    windower.prim.set_size(PRIM, w, h)

    if settings.level > 0 then
        if settings.level == BRIGHT_INDEX then
            windower.prim.set_color(PRIM, clamp(BRIGHT_LEVEL), 255, 255, 255)
        else
            windower.prim.set_color(PRIM, clamp(DARK_LEVELS[settings.level]), 0, 0, 0)
        end
    end

    windower.prim.set_visibility(PRIM, settings.level > 0)
end

local function level_label()
    if settings.level == 0 then
        return 'NORMAL'
    end
    if settings.level == BRIGHT_INDEX then
        return ('BRIGHT (%d)'):format(BRIGHT_LEVEL)
    end
    return ('DARK %d of %d (%d)'):format(
        settings.level, #DARK_LEVELS, DARK_LEVELS[settings.level])
end

local function status()
    msg(('v%s | %s | dark: %s | bright: %d | key: %s'):format(
        _addon.version, level_label(),
        table.concat(DARK_LEVELS, ' / '), BRIGHT_LEVEL, bound_key or 'none'))
end

windower.register_event('load', function()
    windower.prim.create(PRIM)
    apply()
    bind_key(HOTKEY)
end)

windower.register_event('unload', function()
    if bound_key then
        windower.send_command('unbind ' .. bound_key)
    end
    windower.prim.delete(PRIM)
end)

windower.register_event('addon command', function(cmd, ...)
    cmd = cmd and cmd:lower() or 'cycle'
    local args = {...}

    if cmd == 'cycle' or cmd == 'toggle' then
        -- Normal -> Dark 1 -> ... -> Dark N -> Normal
        settings.level = (settings.level + 1) % (BRIGHT_INDEX + 1)
        msg(level_label())

    elseif cmd == 'normal' or cmd == 'off' then
        settings.level = 0
        msg(level_label())

    elseif cmd == 'bright' then
        settings.level = BRIGHT_INDEX
        msg(level_label())

    elseif cmd == 'dark' or cmd == 'level' or tonumber(cmd) then
        -- Accepts //dark 2 as well as //dark level 2
        local n = tonumber(cmd) or tonumber(args[1]) or 1
        if n < 1 or n > #DARK_LEVELS then
            msg(('Usage: //dark <1-%d>'):format(#DARK_LEVELS))
            return
        end
        settings.level = n
        msg(level_label())

    elseif cmd == 'key' then
        -- Session-only rebind; edit HOTKEY at the top of the file to make it permanent
        local key = args[1] and args[1]:lower()
        if not key then msg('Usage: //dark key <key>   e.g. //dark key ^f11') return end
        bind_key(key)
        msg('Hotkey is now ' .. key .. ' (this session). Edit HOTKEY in darkness.lua to keep it.')
        return

    elseif cmd == 'status' or cmd == 'version' then
        status()
        return

    else
        msg(('Commands: cycle | normal | <1-%d> | bright | key <key> | status'):format(#DARK_LEVELS))
        return
    end

    apply()
    config.save(settings)
end)
