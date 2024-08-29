NNV_KillTheMod = {
	(uiNamespace getVariable ["NNV_CurrentCheck",-1]) call CBA_fnc_removePerFrameHandler;
	(uiNamespace getVariable ["NNV_CurrentLoop",-1]) call CBA_fnc_removePerFrameHandler;
	setApertureNew [-1];
	ppEffectDestroy (uiNamespace getVariable ["NNV_PostProcess",-1]);
	ppEffectDestroy (uiNamespace getVariable ["NNV_PostProcessAddition",-1]);
	(findDisplay 46) displayRemoveEventHandler ["keyDown", (uiNamespace getVariable ["NNV_CheatChecker",-2])];
	(uiNamespace getVariable ["NNV_CurrentDebug",-1]) call CBA_fnc_removePerFrameHandler;
};
call NNV_KillTheMod;
//  stops the mod. Active here as part of redundancy. 

0 spawn { 

	///* Sanity Check our settings and run some conversions.*///
	NNV_updateFrequency =  NNV_set_updateFrequency*0.1;
	NNV_minApature = NNV_set_minApature*0.1;
	NNV_maxApature = NNV_set_maxApature*0.1;
	if (!(NNV_maxApature >= NNV_minApature)) then {NNV_maxApature = NNV_minApature;};
	NNV_meanApature = NNV_set_meanApature*0.1;
	if (!(NNV_minApature <= NNV_meanApature) && !(NNV_meanApature >= NNV_maxApature)) then {NNV_meanApature = (NNV_minApature + NNV_maxApature)/2;};
	NNV_Range = NNV_set_Range*0.1;
	if (!((NNV_maxApature - NNV_minApature) >= NNV_Range)) then  {NNV_Range = NNV_maxApature - NNV_minApature;};
	NNV_Multiplier = NNV_set_Multiplier;
	if (!((NNV_maxApature - NNV_minApature) >= (NNV_Range*NNV_Multiplier))) then {NNV_Multiplier = (NNV_maxApature - NNV_minApature)/NNV_Range};
	NNV_checkFrequency = NNV_set_checkFrequency*0.1;
	NNV_bwRange = NNV_set_bwRange*0.1;
	NNV_AdditionalIntensity =  NNV_set_AdditionalIntensity * 0.001;
	NNV_SettingCheeze = NNV_set_SettingCheeze*0.01;
	NNV_ShadowCheeze = NNV_set_ShadowCheeze*0.01;
	NNV_brighness = NNV_set_brighness*0.01;


	///* Wait for eveyrthing to load. Reset apature (Helps with 3den first load bug). Give it half a sec to adjust so Apature isnt bottomed out and blinds everyone while it adjusts at mission start. *///
	sleep 0.5;
	setApertureNew [-1]; 
	sleep 0.5;
	if (!(is3DEN) && hasInterface && !(isNull player) && NNV_modEnabled && (isNull findDisplay 128)) then { // way to much checking cuz appernetly is3DEN doesnt always return true even after waiting before loading into 3den. 
		
		///* Calculate the cheat multiplier *///
		NNV_cheatValue = 0;
		if (NNV_NoCheeze) then {
			NNV_cheatValue = ( //  the 4 menu settings that effect brighness most. Some math to give leeway to small adjustments aswell as create a value based on how much each setting effects visability. 
				(((getVideoOptions get "ppBrightness") -1.2) *3)+
				(1/ (1.2+ (getVideoOptions get "ppContrast")))+
				(((getVideoOptions get "gamma") -1.3) *2)+
				(((getVideoOptions get "brightness") -1.3) *5)
			)*NNV_SettingCheeze;
			switch (true) do { // Shadows are a value thats added on using a range. 200m Is old vanilla max and about where terrian textures usually blend into shadows. 
				case ((getVideoOptions get "shadowQualityName") == "Disabled"):{NNV_cheatValue = NNV_cheatValue + (1.65*NNV_ShadowCheeze);};
				case ((getVideoOptions get "shadowVisibility") >= 200):{};
				case (true):{
					NNV_cheatValue = NNV_cheatValue + ((((((getVideoOptions get "shadowVisibility")-200)*1.65)/200)*-1)*NNV_ShadowCheeze);
				};
			};
			if (NNV_cheatValue <= 0) then {NNV_cheatValue = 0;};
			
			
			///* add eventhandler to recalc cheat multipler every time the pause menu is closed and settings could possibly have been changed *///
			(findDisplay 46) displayRemoveEventHandler ["keyDown", (uiNamespace getVariable ["NNV_CheatChecker",-2])];
			private _AnticheatEH = (findDisplay 46) displayAddEventHandler ["keyDown", {
				private _key = _this select 1;
				if (({_x==_key} count (actionKeys "ingamePause")) >= 1) then {
					0 spawn { 
						waitUntil { !isNull findDisplay 49 };
						(findDisplay 49) displayAddEventHandler ["Unload", {
							NNV_cheatValue = ( //  the 4 menu settings that effect brighness most. Some math to give leeway to small adjustments aswell as create a value based on how much each setting effects visability. 
								(((getVideoOptions get "ppBrightness") -1.2) *3)+
								(1/ (1.2+ (getVideoOptions get "ppContrast")))+
								(((getVideoOptions get "gamma") -1.3) *2)+
								(((getVideoOptions get "brightness") -1.3) *5)
							)*NNV_SettingCheeze;
							switch (true) do { // Shadows are a value thats added on using a range. 200m Is old vanilla max and about where terrian textures usually blend into shadows. 
								case ((getVideoOptions get "shadowQualityName") == "Disabled"):{NNV_cheatValue = NNV_cheatValue + (1.65*NNV_ShadowCheeze);};
								case ((getVideoOptions get "shadowVisibility") >= 200):{};
								case (true):{
									NNV_cheatValue = NNV_cheatValue + ((((((getVideoOptions get "shadowVisibility")-200)*1.65)/200)*-1)*NNV_ShadowCheezel);
								};
							};
							if (NNV_cheatValue <= 0) then {NNV_cheatValue = 0;};
						}];
					};
				};
			}];
			uiNamespace setVariable ["NNV_CheatChecker",_AnticheatEH];
		} else {
			(findDisplay 46) displayRemoveEventHandler ["keyDown", (uiNamespace getVariable ["NNV_CheatChecker",-2])];
			NNV_cheatValue = 0;
		};
		
		
		NNV_targetMin = NNV_minApature;
		NNV_targetMax = NNV_maxApature;
		NNV_myRange = NNV_Range; // Made this a public var here to simplify the debug loop.
		private _codeToCheck = {};
		
		///* Create the larger loop code. This one gets the engine desired apature and creates the apature range. Also ensures we dont jump around and slowly change from our current to our target. *///
		if (!(NNV_Multiplier <= 1)) then {
			_codeToCheck = {
				NNV_myRange = ((((apertureParams select 0) - NNV_minApature) * ((NNV_Range * NNV_Multiplier) - NNV_Range)) / (NNV_maxApature - NNV_minApature)) + NNV_Range; // Scale the range to the range with multiplier based on current apature.
				private _NewTarget = (((((apertureParams select 2) - 4) * ((NNV_maxApature - (NNV_myRange*0.5)) - (NNV_minApature + (NNV_myRange*0.5)))) / 116) + (NNV_minApature + (NNV_myRange*0.5))) + NNV_cheatValue;	// Converts Engine apature baed on its aproximate min and max to be our new target using settings min and max.
				switch (true) do {
					case ((_NewTarget + (NNV_myRange*0.5)) <= (apertureParams select 0)): {NNV_targetMax = (apertureParams select 0); NNV_targetMin = (apertureParams select 0) - (NNV_myRange);}; // If our max target apature range is less then current apature, but we want to go down, set our current max to our current apature to make it smoother
					case ((_NewTarget - (NNV_myRange*0.5)) >= (apertureParams select 0)): {NNV_targetMin = (apertureParams select 0); NNV_targetMax = (apertureParams select 0) + (NNV_myRange);}; // same, but for our minimum target range.
					case (true): {NNV_targetMax = _NewTarget + (NNV_myRange*0.5); NNV_targetMin = _NewTarget - (NNV_myRange*0.5);}; // else, either something went weird or our apature is within our range, so just use our target range
				};
			};
		} else {
			_codeToCheck = { // same as above, just simplified if there is effectivly no multiplier. 
				private _NewTarget = ((((apertureParams select 2) - 4) * ((NNV_maxApature - (NNV_Range*0.5)) - (NNV_minApature + (NNV_Range*0.5)))) / 116) + (NNV_minApature + (NNV_Range*0.5));
				
				switch (true) do {
					case ((_NewTarget + (NNV_Range*0.5)) <= (apertureParams select 0)): {NNV_targetMax = (apertureParams select 0); NNV_targetMin = (apertureParams select 0) - NNV_Range;};
					case ((_NewTarget - (NNV_Range*0.5)) >= (apertureParams select 0)): {NNV_targetMin = (apertureParams select 0); NNV_targetMax = (apertureParams select 0) + NNV_Range;};
					case (true): {NNV_targetMax = _NewTarget + (NNV_Range*0.5); NNV_targetMin = _NewTarget - (NNV_Range*0.5);}; 
				};
			};
		};
		
		
		
		private _codeToLoop = {};
		private _ppVar = ppEffectCreate ["ColorCorrections",1264];
		uiNamespace setVariable ["NNV_PostProcess",_ppVar];
		private _ppAddVar = ppEffectCreate ["ChromAberration",1263];	
		uiNamespace setVariable ["NNV_PostProcessAddition",_ppAddVar];


		///* Create the smaller loop code. Check if were in regular vision, not using A3TI. Set the apature based on the larger loop and checks effects if enabled. *///
		if (NNV_enableBW == true) then { 	
			_codeToLoop = {	
				if (((currentVisionMode player) == 0) && ((uiNamespace getVariable ["A3TI_FLIR_VisionMode",0]) == 0)) then { // Current vision mode covers all vanilla visions. the A3ti function returns nil if the mod doesnt exist OR its not being used, otherwise itll return a vlaue with 0 being no thermal vision. (Dpeending on a3ti updates, this method may need ot be changed in the future)
					setApertureNew [NNV_targetMin, NNV_meanApature, NNV_targetMax, NNV_brighness]; // Set apature range
					if (((apertureParams select 0) <= NNV_bwRange) && (isNull findDisplay 60492) && (isNull findDisplay 60000)) then { // Update PostFX (checking were within the postFX setting set range, and were not in spectator or ace spectator)
						if (NNV_addEffects == true) then {
							_NNV_PPeffect = uiNamespace getVariable ["NNV_PostProcess",-1];
							_NNV_PPeffect ppEffectAdjust [1,1,0,[0,0,0,0],[1,1,1,(((apertureParams select 0)-NNV_cheatValue) / NNV_bwRange)],[0.5,0.25,0.25,0]];
							_NNV_PPeffect ppEffectEnable true;
							_NNV_PPeffect ppEffectCommit NNV_updateFrequency;
							
							_NNV_AddPPeffect = uiNamespace getVariable ["NNV_PostProcessAddition",-1];
							_NNV_AddPPeffect ppEffectAdjust [((1 - (((apertureParams select 0)-NNV_cheatValue) /NNV_bwRange))* NNV_AdditionalIntensity), ((1 - ((apertureParams select 0) / NNV_bwRange))* NNV_AdditionalIntensity), true];
							_NNV_AddPPeffect ppEffectEnable true;
							_NNV_AddPPeffect ppEffectCommit NNV_updateFrequency;
						} else {
							_NNV_PPeffect = uiNamespace getVariable ["NNV_PostProcess",-1];
							_NNV_PPeffect ppEffectAdjust [1,1,0,[0,0,0,0],[1,1,1,(((apertureParams select 0)-NNV_cheatValue) / NNV_bwRange)],[0.5,0.25,0.25,0]];
							_NNV_PPeffect ppEffectEnable true;
							_NNV_PPeffect ppEffectCommit NNV_updateFrequency;
						};
					} else { // ensure effects die if were outside the effect range or are in spectator.
						(uiNamespace getVariable ["NNV_PostProcess",-1]) ppEffectEnable false;
						(uiNamespace getVariable ["NNV_PostProcessAddition",-1]) ppEffectEnable false;
					};
				} else { // ensure effects die if were in NVGs or thermals.
					(uiNamespace getVariable ["NNV_PostProcess",-1]) ppEffectEnable false;
					(uiNamespace getVariable ["NNV_PostProcessAddition",-1]) ppEffectEnable false;
				};
			};
		} else { 																
			_codeToLoop = {	
				if (((currentVisionMode player) == 0) && ((uiNamespace getVariable ["A3TI_FLIR_VisionMode",0]) == 0)) then {
					setApertureNew [NNV_targetMin, NNV_meanApature, NNV_targetMax, NNV_brighness];
				};
			};
		};

		
		///* Start up the loops and define them in UI namespace to ensure they can be killed later. *///	
		(uiNamespace getVariable ["NNV_CurrentCheck",-1]) call CBA_fnc_removePerFrameHandler;
		(uiNamespace getVariable ["NNV_CurrentLoop",-1]) call CBA_fnc_removePerFrameHandler;
		_checkVar = [_codeToCheck, NNV_checkFrequency] call CBA_fnc_addPerFrameHandler;
		(uiNamespace setVariable ["NNV_CurrentCheck",_checkVar]);
		_loopVar = [_codeToLoop, NNV_updateFrequency] call CBA_fnc_addPerFrameHandler;
		(uiNamespace setVariable ["NNV_CurrentLoop",_loopVar]);
		
		///* Debug Loop If Enabled. *///	
		if (NNV_Debug && (!(is3DEN) && hasInterface && !(isNull player) && NNV_modEnabled && (isNull findDisplay 128))) then {
			(uiNamespace getVariable ["NNV_CurrentDebug",-1]) call CBA_fnc_removePerFrameHandler;
			_debugVar = [{
				hintSilent format ["targMin= %1, targMax= %2, currApp= %3, reffApp= %4, cheat= %5, range= %6", NNV_targetMin, NNV_targetMax, (apertureParams select 0), (apertureParams select 2), NNV_cheatValue, NNV_myRange];
			}, 0] call CBA_fnc_addPerFrameHandler;
			(uiNamespace setVariable ["NNV_CurrentDebug",_debugVar]);
		};
			
		sleep 2; // wait longer and run yet another redundancy check cuz checking is3den appears to be abit unreliable and i dont want this mod running on accident elsewhere (server, headless, ect).
		if (is3DEN || !(hasInterface) || (isNull player) || !(NNV_modEnabled) || !(isNull findDisplay 128)) then { 
			call NNV_KillTheMod;
		};
	} else {
		call NNV_KillTheMod;
	};
};

