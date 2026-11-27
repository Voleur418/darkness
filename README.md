# Darkness

Screen tone overlay for Windower

**Version 26.11.4** · by **Voleur**

Darken or lighten your game screen with a single hotkey. Three levels of
darkness for night play, plus one subtle brightness level.

| Tone   | Effect                                      |
|--------|---------------------------------------------|
| Normal | No change                                   |
| Dark 1 | Light black layer                           |
| Dark 2 | Medium black layer                          |
| Dark 3 | Heavy black layer                           |
| Bright | Light white layer, slightly lighter screen  |

Default hotkey: **Alt+F12**. Each press cycles
Normal → Dark 1 → Dark 2 → Dark 3 → Bright → Normal.

---

## Install

1. Create the folder `Windower\addons\darkness\`.
2. Put `darkness.lua` in it.
3. In game: `//lua load darkness`
4. To load it automatically, add this line to `Windower\scripts\init.txt`:
   ```
   lua load darkness
   ```

---

## Commands

Use `//dark` or `//darkness`.

| Command            | What it does                          |
|--------------------|---------------------------------------|
| `//dark cycle`     | Next tone (same as the hotkey)        |
| `//dark normal`    | Normal screen, no overlay             |
| `//dark <1-3>`     | Jump to a dark level                  |
| `//dark bright`    | Bright tone                           |
| `//dark key <key>` | Change the hotkey for this session    |
| `//dark status`    | Show version, tone, levels and hotkey |

The current tone is saved in `addons\darkness\data\settings.xml`.

---

## Configuration

Open `darkness.lua`. The **USER CONFIG** block is at the top:

```lua
local HOTKEY       = '!f12'
local DARK_LEVELS  = { 40, 70, 100 }
local BRIGHT_LEVEL = 20
```

Levels go from 0 to 255 (0 = no effect). You can add or remove entries in
`DARK_LEVELS`; the cycle adapts. Save, then reload with `//lua r darkness`.

Hotkey modifiers (Windower bind syntax):

| Symbol | Key   |
|--------|-------|
| `!`    | Alt   |
| `^`    | Ctrl  |
| `~`    | Shift |

Examples: `'f12'` = F12, `'^f11'` = Ctrl+F11, `'~!b'` = Shift+Alt+B.

---

## Notes

- Windower addons can't change the real gamma, so Darkness draws a
  see-through layer over the screen. Bright can look a little hazy; keep
  `BRIGHT_LEVEL` low.
- The layer also covers menus and chat.

---

*Darkness v26.11.4 · by Voleur*
