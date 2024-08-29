// If mods enabled, wer enot in 3den, and were a player. Start up the mod. Otherwise make sure the mod is dead
0 spawn { 
	sleep 1;
	if (NNV_modEnabled && !(is3DEN) && hasInterface) then {
		NNV_ModStarted = true;
		// systemChat "Enabling NNV";
		[] call NNV_fnc_AntiCheeze; sleep 0.1;
		[] call NNV_fnc_LargeLoop; sleep 0.1;
		[] call NNV_fnc_SmallLoop; sleep 0.1;
		[] call NNV_fnc_Debug;
		// systemChat "NNV Enabled";
	} else {
		NNV_ModStarted = false;
		// systemChat "Disabling NNV";
		(uiNamespace getVariable ["NNV_CurrentCheck",-1]) call CBA_fnc_removePerFrameHandler;
		(uiNamespace getVariable ["NNV_CurrentLoop",-1]) call CBA_fnc_removePerFrameHandler;
		ppEffectDestroy (uiNamespace getVariable ["NNV_PostProcess",-1]);
		ppEffectDestroy (uiNamespace getVariable ["NNV_PostProcessAddition",-1]);
		(findDisplay 46) displayRemoveEventHandler ["keyDown", (uiNamespace getVariable ["NNV_CheatChecker",-2])];
		(uiNamespace getVariable ["NNV_CurrentDebug",-1]) call CBA_fnc_removePerFrameHandler;
		setApertureNew [-1];
	};
	NNV_SettingsInit = true;
};