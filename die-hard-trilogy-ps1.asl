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
        emu.MakeString("US", 11, 0x800094B4); // SLUS_001.19
        emu.MakeString("EU", 11, 0x8000949C); // SLES_004.45
        emu.MakeString("JP", 11, 0x800094CC); // SLPS_005.85

        emu.Make<short>("Game", 0x80012800); // 0:Loader, 1:Menu, 2:DH1, 3:DH2, 4:DH3

        // NTSC-U - Die Hard 1
        emu.Make<short>("US_DH1GameState",  0x801CB094); // 2:Menu, 3:Menu, 4:Demo, 5:Game
        emu.Make<short>("US_DH1GameEnded",  0x800A346C); // 4:Level Completion, 5:Game Completion
        emu.Make<short>("US_DH1Level",      0x800A33F4); // 23:Last Level
        emu.Make<int>  ("US_DH1LevelTime",  0x800A33DC);

        // NTSC-U - Die Hard 2
        emu.Make<short>("US_DH2GameState",  0x800B6AA0); // 2:Menu, 3:Game, 5:Demo
        emu.Make<short>("US_DH2Level",      0x800B7220); // 7:Last Level
        emu.Make<int>  ("US_DH2GameTime",   0x800B6D08);
        emu.Make<int>  ("US_DH2LevelTime",  0x800B6CC8);

        // NTSC-U - Die Hard 3
        emu.Make<short>("US_DH3GameState",  0x800B5D0C); // 2:Menu, 3:Game, 5:Demo, 8:Scores
        emu.Make<short>("US_DH3Level",      0x800B64B4); // 15:Last Level
        emu.Make<int>  ("US_DH3LevelTime",  0x800B56A4);
        emu.Make<int>  ("US_DH3LevelTimeB", 0x801DA704);

        // PAL - Die Hard 1
        emu.Make<short>("EU_DH1GameState",  0x801CE928);
        emu.Make<short>("EU_DH1GameEnded",  0x800A6D7C);
        emu.Make<short>("EU_DH1Level",      0x800A6D3C);
        emu.Make<int>  ("EU_DH1LevelTime",  0x800A6D30);

        // PAL - Die Hard 2
        emu.Make<short>("EU_DH2GameState",  0x800B9398);
        emu.Make<short>("EU_DH2Level",      0x800B9B20);
        emu.Make<int>  ("EU_DH2GameTime",   0x800B9608);
        emu.Make<int>  ("EU_DH2LevelTime",  0x800B8C7C);

        // PAL - Die Hard 3
        emu.Make<short>("EU_DH3GameState",  0x800B7F0C);
        emu.Make<short>("EU_DH3Level",      0x800B86BC);
        emu.Make<int>  ("EU_DH3LevelTime",  0x800B7888);
        emu.Make<int>  ("EU_DH3LevelTimeB", 0x801DC914);

        // NTSC-J - Die Hard 1
        emu.Make<short>("JP_DH1GameState",  0x801CC8B8);
        emu.Make<short>("JP_DH1GameEnded",  0x800A4D0C);
        emu.Make<short>("JP_DH1Level",      0x800A4CCC);
        emu.Make<int>  ("JP_DH1LevelTime",  0x800A4CC0);

        // NTSC-J - Die Hard 2
        emu.Make<short>("JP_DH2GameState",  0x800B6B8C);
        emu.Make<short>("JP_DH2Level",      0x800B730C);
        emu.Make<int>  ("JP_DH2GameTime",   0x800B6E04);
        emu.Make<int>  ("JP_DH2LevelTime",  0x800B6DC4);

        // NTSC-J - Die Hard 3
        emu.Make<short>("JP_DH3GameState",  0x800B8900);
        emu.Make<short>("JP_DH3Level",      0x800B90B0);
        emu.Make<int>  ("JP_DH3LevelTime",  0x800B8B90);
        emu.Make<int>  ("JP_DH3LevelTimeB", 0x801DD308);

        return true;
    });

    settings.Add("dh1", true, "Die Hard 1");
    settings.Add("dh1start", true, "Auto Start", "dh1");
    settings.SetToolTip("dh1start", "Automatically starts the timer when a new game has started.");
    settings.Add("dh1levels", true, "Level Splits", "dh1");
    settings.SetToolTip("dh1levels", "Splits at the start of each level.");
    settings.Add("dh1endgame", false, "Ending Split", "dh1");
    settings.SetToolTip("dh1endgame", "Splits when the screen fades to black after the final level.");

    settings.Add("dh2", true, "Die Hard 2");
    settings.Add("dh2start", true, "Auto Start", "dh2");
    settings.SetToolTip("dh2start", "Automatically starts the timer when a new game has started.");
    settings.Add("dh2levels", true, "Level Splits", "dh2");
    settings.SetToolTip("dh2levels", "Splits at the start of each level.");
    settings.Add("dh2endgame", false, "Ending Split", "dh2");
    settings.SetToolTip("dh2endgame", "Splits when the screen fades to black after the final level.");

    settings.Add("dh3", true, "Die Hard 3");
    settings.Add("dh3start", true, "Auto Start", "dh3");
    settings.SetToolTip("dh3start", "Automatically starts the timer when a new game has started.");
    settings.Add("dh3levels", true, "Level Splits", "dh3");
    settings.SetToolTip("dh3levels", "Splits at the start of each level.");
    settings.Add("dh3endgame", false, "Ending Split", "dh3");
    settings.SetToolTip("dh3endgame", "Splits when the screen fades to black after the final level.");

    settings.Add("infogroup", false, "Info");
    settings.Add("infogroup1", false, "Die Hard Trilogy (PS1) Auto Splitter by Kapdap", "infogroup");
    settings.Add("infogroup2", false, "Website: https://github.com/kapdap/die-hard-trilogy-ps1-autosplitter", "infogroup");
}

init
{
    vars.StartTime = 0;
    vars.AccumulatedTime = 0;
    vars.GameStart = false;
    vars.GameEnded = false;
    vars.GameRegion = string.Empty;
    vars.UpdateRegion = (Action) (() =>
    {
        if (current.US == "SLUS_001.19")
            vars.GameRegion = "US";
        else if (current.EU == "SLES_004.45")
            vars.GameRegion = "EU";
        else if (current.JP == "SLPS_005.85")
            vars.GameRegion = "JP";
        else
            vars.GameRegion = string.Empty;
    });

    vars.Read = (Func<string, dynamic>)(name => vars.Helper[vars.GameRegion + "_" + name]);
}

start
{
    vars.UpdateRegion();

    if (vars.GameRegion == string.Empty)
        return false;

    if (current.Game == 2)
    {
        return vars.GameStart = settings["dh1start"] &&
               vars.Read("DH1GameState").Current == 5 &&
               vars.Read("DH1LevelTime").Current >= 0 &&
               vars.Read("DH1LevelTime").Current <= 15 &&
               vars.Read("DH1Level").Current == 0;
    }
    else if (current.Game == 3)
    {
        if (settings["dh2start"] &&
            vars.Read("DH2GameState").Current == 3 &&
            vars.Read("DH2LevelTime").Current >= 0 &&
            vars.Read("DH2LevelTime").Current <= 15 &&
            vars.Read("DH2Level").Current == 0)
        {
            vars.StartTime = vars.Read("DH2GameTime").Current;
            return vars.GameStart = true;
        }
    }
    else if (current.Game == 4)
    {
        return vars.GameStart = settings["dh3start"] &&
               vars.Read("DH3GameState").Current == 3 &&
               vars.Read("DH3LevelTime").Current >= 0 &&
               vars.Read("DH3LevelTime").Current <= 15 &&
               vars.Read("DH3LevelTimeB").Current != -1 &&
               vars.Read("DH3Level").Current == 0;
    }

    return false;
}

update
{
    vars.UpdateRegion();

    if (vars.GameRegion == string.Empty)
        return false;

    int time = 0;

    if (current.Game == 3)
        time = vars.Read("DH2GameTime").Current - vars.StartTime;
    else if (current.Game == 2 || current.Game == 4)
    {
        int tcur = vars.Read("DH1LevelTime").Current;
        int told = vars.Read("DH1LevelTime").Old;

        if (current.Game == 4)
        {
            tcur = vars.Read("DH3LevelTime").Current;
            told = vars.Read("DH3LevelTime").Old;
        }

        if (tcur < told && vars.GameStart)
            vars.AccumulatedTime += told;

        time = vars.AccumulatedTime + tcur;
    }

    current.GameTime = TimeSpan.FromSeconds(time / (vars.GameRegion == "EU" ? 50.0 : 60.0));
}

split
{
    if (current.Game == 2)
    {
        if (settings["dh1levels"] &&
            vars.Read("DH1Level").Current !=
            vars.Read("DH1Level").Old)
            return true;

        if (settings["dh1endgame"] && !vars.GameEnded &&
            vars.Read("DH1GameState").Current == 5 &&
            vars.Read("DH1GameEnded").Current == 5 &&
            vars.Read("DH1Level").Current == 23)
            return vars.GameEnded = true;
    }
    else if (current.Game == 3)
    {
        if (settings["dh2levels"] &&
            vars.Read("DH2Level").Current !=
            vars.Read("DH2Level").Old)
            return true;

        if (settings["dh2endgame"] && !vars.GameEnded &&
            vars.Read("DH2GameState").Current == 2 &&
            vars.Read("DH2Level").Current == 7)
            return vars.GameEnded = true;
    }
    else if (current.Game == 4)
    {
        if (settings["dh3levels"] &&
            vars.Read("DH3Level").Current !=
            vars.Read("DH3Level").Old)
            return true;

        if (settings["dh3endgame"] && !vars.GameEnded &&
            vars.Read("DH3GameState").Current == 2 &&
            vars.Read("DH3Level").Current == 15)
            return vars.GameEnded = true;
    }

    return false;
}

gameTime
{
    return current.GameTime;
}

isLoading
{
    return true;
}

onReset
{
    vars.AccumulatedTime = 0;
    vars.StartTime = 0;
    vars.GameStart = false;
    vars.GameEnded = false;
}