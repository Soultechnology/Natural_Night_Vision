0 spawn { 

	///* Sanity Check our settings and run some conversions.*///
	NNV_minApature = (NNV_set_minApature*0.1);
	NNV_maxApature = (NNV_set_maxApature*0.1);
	NNV_updateFrequency =  (NNV_set_updateFrequency*0.1);
	if (!(NNV_maxApature >= NNV_minApature)) then {NNV_maxApature = NNV_minApature;};
	NNV_meanApature = (NNV_set_meanApature*0.1);
	if (!(NNV_minApature <= NNV_meanApature) && !(NNV_meanApature >= NNV_maxApature)) then {NNV_meanApature = (NNV_minApature + NNV_maxApature)/2;};
	NNV_bwRange = (NNV_set_bwRange*0.1);
	NNV_AdditionalIntensity =  (NNV_set_AdditionalIntensity*0.001);
	NNV_brighness = (NNV_set_brighness*0.01); 
	
	if (!(NNV_cheatValue >= 0)) then {NNV_cheatValue = 0;};
	if (NNV_targetMin <= (NNV_set_minApature*0.1)) then {NNV_targetMin = (NNV_set_minApature*0.1);};
	if (NNV_targetMax >= (NNV_set_maxApature*0.1)) then {NNV_targetMax = (NNV_set_maxApature*0.1);};
	if (NNV_myRange >= ((NNV_set_maxApature*0.1) - (NNV_set_minApature*0.1))) then {NNV_myRange = ((NNV_set_maxApature*0.1) - (NNV_set_minApature*0.1));};
	
	private _codeToLoop = {};
	private _ppVar = ppEffectCreate ["ColorCorrections",1564];
	uiNamespace setVariable ["NNV_PostProcess",_ppVar];
	private _ppAddVar = ppEffectCreate ["ChromAberration",1563];	
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

	(uiNamespace getVariable ["NNV_CurrentLoop",-1]) call CBA_fnc_removePerFrameHandler;
	_loopVar = [_codeToLoop, NNV_updateFrequency] call CBA_fnc_addPerFrameHandler;
	(uiNamespace setVariable ["NNV_CurrentLoop",_loopVar]);
	
};

