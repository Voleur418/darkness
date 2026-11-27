# Brightness CC 2026

**Version 27.3.0.142 (Build 0x7F3A) "Twilight Dunes"**
by **Voleur**
Screen tone overlay addon for Windower 4 (FFXI).

Switch the game screen between three tones with one hotkey:

| Tone   | Effect                                 |
|--------|----------------------------------------|
| Normal | No change                              |
| Dark   | Black see-through layer, darker screen |
| Bright | White see-through layer, lighter screen |

Default hotkey: **Alt+F12**. Each press cycles: Normal → Dark → Bright → Normal.

---

## Install

1. Create the folder `Windower\addons\brightness\`.
2. Put `brightness.lua` in it.
3. In game: `//lua load brightness`
4. To load it automatically, add this line to `Windower\scripts\init.txt`:
   ```
   lua load brightness
   ```

---

## Commands

You can use `//bright` or `//brightness`.

| Command                 | What it does                                  |
|-------------------------|-----------------------------------------------|
| `//bright cycle`        | Next tone (same as the hotkey)                |
| `//bright normal`       | Normal tone (no overlay)                      |
| `//bright dark`         | Dark tone                                     |
| `//bright bright`       | Bright tone                                   |
| `//bright up`           | Stronger effect for the current tone (+10)    |
| `//bright down`         | Weaker effect for the current tone (-10)      |
| `//bright level <0-255>`| Set the strength of the current tone directly |
| `//bright key <key>`    | Change the hotkey for this session only       |
| `//bright status`       | Show version, tone, levels and hotkey         |

Dark and Bright each remember their own strength. The current tone and both
levels are saved in `addons\brightness\data\settings.xml`.

Default levels: Bright 30, Dark 80. Suggested ranges: Bright 20–40, Dark 60–120.

---

## Changing the hotkey

Open `brightness.lua`. The **USER CONFIG** block is at the top of the file:

```lua
local HOTKEY = '!f12'
```

Change it, save, then reload with `//lua r brightness`.

Key modifiers (Windower bind syntax):

| Symbol | Key   |
|--------|-------|
| `!`    | Alt   |
| `^`    | Ctrl  |
| `~`    | Shift |

Examples: `'f12'` = F12, `'^f11'` = Ctrl+F11, `'~!b'` = Shift+Alt+B.

To try a key without editing the file, use `//bright key ^f11`. That lasts
until the addon is reloaded.

---

## Notes

- Windower 4 addons can't change the real gamma, so this addon draws a
  see-through layer over the screen instead. Bright mode can look a little
  hazy. For real brightening, use Windower's gamma setting. Dark mode does
  something gamma can't.
- The layer also covers the in-game menus and chat.
- If the addon was loaded before version 27.3.0.142, delete
  `addons\brightness\data\settings.xml` for a clean start.

---

*Brightness CC 2026, v27.3.0.142, Build 0x7F3A "Twilight Dunes" · by Voleur*
