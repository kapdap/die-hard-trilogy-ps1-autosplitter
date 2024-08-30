// SPDX-FileCopyrightText: 2024 Kapdap <kapdap@pm.me>
//
// SPDX-License-Identifier: MIT
/*  Die Hard Trilogy (PS1) Auto Splitter
 *  https://github.com/kapdap/die-hard-trilogy-ps1-autosplitter
 *
 *  Copyright 2024 Kapdap <kapdap@pm.me>
 *
 *  Use of this source code is governed by an MIT-style
 *  license that can be found in the LICENSE file or at
 *  https://opensource.org/licenses/MIT.
 */
state("LiveSplit") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/emu-help-v2")).CreateInstance("PS1");
    
    vars.Helper.Load = (Func<dynamic, bool>)(emu => 
    {
        emu.Make<uint>("GameMain", 0x8001B34C);

        emu.Make<int>("DH2GameState", 0x800B6AA0);
        emu.Make<int>("DH2GameTime", 0x800B6D08);
        emu.Make<int>("DH2LevelTime", 0x800B6CC8);
        emu.Make<int>("DH2Level", 0x800B7220);

        return true;
    });

    settings.Add("dh2", true, "Die Hard 2");
    settings.Add("dh2levels", true, "Level Splits", "dh2");
    settings.SetToolTip("dh2levels", "Splits at the start of a new level.");
    settings.Add("dh2endgame", false, "Ending Split", "dh2");
    settings.SetToolTip("dh2endgame", "Splits when the screen fades to black after the plane intercept level.");

    settings.Add("infogroup", false, "Info");
    settings.Add("infogroup1", false, "Die Hard Trilogy (PS1) Auto Splitter by Kapdap", "infogroup");
    settings.Add("infogroup2", false, "Website: https://github.com/kapdap/die-hard-trilogy-ps1-autosplitter", "infogroup");
}

init
{
    vars.DH2StartTime = 0;
    vars.DH2GameEnded = false;
}

start
{
    if (current.GameMain == 0x80078EE0) {
        // LevelTime starts when the level has finished loading.
        if (current.DH2GameState == 3 && current.DH2LevelTime >= 0 && current.DH2Level == 0) {
            // GameTime will tick while the first level is reloading.
            vars.DH2StartTime = current.DH2GameTime;
            return true;
        }
    }

    return false;
}

update
{
}

split
{
    if (current.GameMain == 0x80078EE0)
    {
        if (settings["dh2endgame"] && !vars.DH2GameEnded &&
            current.DH2Level == 7 && current.DH2GameState == 2)
            return vars.DH2GameEnded = true;

        if (settings["dh2levels"])
            return current.DH2Level != old.DH2Level;
    }

    return false;
}

gameTime
{
    int time = 0;

    if (current.GameMain == 0x80078EE0)
        time = current.DH2GameTime - vars.DH2StartTime;

    return TimeSpan.FromSeconds(time / 60.0);
}

onReset
{
    vars.DH2StartTime = 0;
    vars.DH2GameEnded = false;
}