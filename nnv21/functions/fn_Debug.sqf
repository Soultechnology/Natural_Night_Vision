0 spawn { 	
	///* Debug Loop If Enabled. *///	
	if (NNV_Debug) then {
		(uiNamespace getVariable ["NNV_CurrentDebug",-1]) call CBA_fnc_removePerFrameHandler;
		_debugVar = [{
			hintSilent format ["targMin= %1, targMax= %2, currApp= %3, reffApp= %4, cheat= %5, range= %6", NNV_targetMin, NNV_targetMax, (apertureParams select 0), (apertureParams select 2), NNV_cheatValue, NNV_myRange];
		}, 0] call CBA_fnc_addPerFrameHandler;
		(uiNamespace setVariable ["NNV_CurrentDebug",_debugVar]);
	} else {
		(uiNamespace getVariable ["NNV_CurrentDebug",-1]) call CBA_fnc_removePerFrameHandler;
		hintSilent "";
	};	
};

