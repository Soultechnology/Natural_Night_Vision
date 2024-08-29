[
    "NNV_modEnabled",
    "CHECKBOX",
    ["Enable Aperture Adjustment","Can be disabled mid game"],
    "Natural Night Vision",
    true,
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 

[
    "NNV_Debug",
    "CHECKBOX",
    ["Enable info hints","Returns current relevant aperture information every frame using hints. May be useful for getting values and changing settings. All aperture setting values are 1-10th actual readout."],
    "Natural Night Vision",
    false,
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 



[
    "NNV_set_updateFrequency",
    "SLIDER",
    ["Update Frequency","How often (in 10ths of a seconds, 0 is per frame) to recheck applied aperture and update post process effects. [Default 0]"],
    ["Natural Night Vision","[1] Main Mod Settings"],
    [0, 420, 0, -1],
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 

[
    "NNV_set_minApature",
    "SLIDER",
    ["Dark Area Brightness","How much should we brighten darker areas at most. Lower is brighter. [Default 8][Vanilla 40]"],
    ["Natural Night Vision","[1] Main Mod Settings"],
	[1, 80, 8, -1],
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 

[
    "NNV_set_maxApature",
    "SLIDER",
    ["Bright Area Darkness","How much should we darken brighter areas at most. Higher is darker. [Default 1000][Vanilla 1200]"],
    ["Natural Night Vision","[1] Main Mod Settings"],
	[1, 3000, 1000, -1],
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 

[
    "NNV_set_meanApature",
    "SLIDER",
    ["Preferred Target","A target/mean aperture. If above this well darken faster, below well brighten faster. [Default 60]"],
    ["Natural Night Vision","[1] Main Mod Settings"],
	[1, 350, 60, -1],
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 

[
    "NNV_set_brighness",
    "SLIDER",
    ["Apature Brighness","Additonal option in-mod for overall brighness adjustments post-apature (in %)[Defualt 100]"],
    ["Natural Night Vision","[1] Main Mod Settings"],
	[1, 3000, 100, -1],
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 



[
    "NNV_set_Range",
    "SLIDER",
    ["Aperture Range","How far can we rapidly adjust to brightness changes, at minimum. Effects overall vision adjustment speed. [Default 2]"],
    ["Natural Night Vision","[2] Range Settings"],
	[0, 3000, 2, -1],
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 

[
    "NNV_set_Multiplier",
    "SLIDER",
    ["Aperture Multiplier","How much can we multiply the 'Aperture range' based on current brightness (EG: allowing better adjustment when its overall brighter) (Effects adjustment speed). [Default 150]"],
    ["Natural Night Vision","[2] Range Settings"],
	[1, 3000, 150, -1],
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 

[
    "NNV_set_checkFrequency",
    "SLIDER",
    ["Check Frequency","How often (in 10ths of a seconds) should we run range related checks (like how bright it is around us and what our range should be). Effects Vision adjustment speed. [Default 15]"],
    ["Natural Night Vision","[2] Range Settings"],
	[0, 999, 15, -1],
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 



[
    "NNV_enableBW",
    "CHECKBOX",
    ["Enable BlackWhite Effect","Mimic color loss in vision when adjusted to darkness. Disabled in spectator."],
    ["Natural Night Vision","[3] Effect Settings"],
    true,
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 

[
    "NNV_set_bwRange",
    "SLIDER",
    ["BW Effect range","At what level of darkness do we start losing color vision? [Default 50]"],
    ["Natural Night Vision","[3] Effect Settings"],
	[1, 350, 50, -1],
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 

[
    "NNV_addEffects",
    "CHECKBOX",
    ["BW Vision Distort","Adds an additional effect layer to make it harder to see clearly at night. Disabled in spectator."],
    ["Natural Night Vision","[3] Effect Settings"],
	true,
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 

[
    "NNV_set_AdditionalIntensity",
    "SLIDER",
    ["Distortion FX Intensity","The Strength of the additional effect layer in % [Default 25]"],
    ["Natural Night Vision","[3] Effect Settings"],
	[1, 100, 25, -1],
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 



[
    "NNV_NoCheeze",
    "CHECKBOX",
    ["Enable Graphical AntiCheat","Attempts to balance the adaptive aperture if it seems someone is abusing brightness and similar settings."],
    ["Natural Night Vision","[4] Anti-Cheeze Settings"],
    false,
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 

[
    "NNV_set_SettingCheeze",
    "SLIDER",
    ["Settings Anticheat Multiplier","Increase or reduce the compensation for changing general settings (in %)[Default 100]"],
    ["Natural Night Vision","[4] Anti-Cheeze Settings"],
	[0, 999, 100, -1],
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 

[
    "NNV_set_ShadowCheeze",
    "SLIDER",
    ["Shadows Anticheat Multiplier","Increase or reduce the compensation for changing shadow settings (In %)(Scaled on shadow distance. Maxed out if quality is off.) [Default 100]"],
	["Natural Night Vision","[4] Anti-Cheeze Settings"],
	[0, 999, 100, -1],
    0,
	{[] call NNV_fnc_naturalNightvision;}
] call cba_settings_fnc_init; 

