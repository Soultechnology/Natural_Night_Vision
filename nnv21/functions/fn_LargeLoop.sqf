0 spawn { 
	///* Sanity Check our settings and run some conversions.*///
	NNV_checkFrequency = (NNV_set_checkFrequency*0.1);
	NNV_minApature = (NNV_set_minApature*0.1);
	NNV_maxApature = (NNV_set_maxApature*0.1);
	if (!(NNV_maxApature >= NNV_minApature)) then {NNV_maxApature = NNV_minApature;};
	NNV_Range = (NNV_set_Range*0.1);
	if (!((NNV_maxApature - NNV_minApature) >= NNV_Range)) then  {NNV_Range = NNV_maxApature - NNV_minApature;};
	NNV_Multiplier = (NNV_set_Multiplier);
	if (!((NNV_maxApature - NNV_minApature) >= (NNV_Range*NNV_Multiplier))) then {NNV_Multiplier = (NNV_maxApature - NNV_minApature)/NNV_Range};
	
	NNV_targetMin = NNV_minApature;
	NNV_targetMax = NNV_maxApature;
	NNV_myRange = NNV_Range;
	if (!(NNV_cheatValue >= 0)) then {NNV_cheatValue = 0;};
	NNV_CheckStage = 1;
	
	private _codeToCheck = {};
	
	///* Create the larger loop code. This one gets the engine desired apature and creates the apature range. Also ensures we dont jump around and slowly change from our current to our target. *///
	if (!(NNV_Multiplier <= 1)) then {
		_codeToCheck = {
			NNV_oldMin = NNV_targetMin;
			NNV_oldMax = NNV_targetMax;
		
			NNV_myRange = ((((apertureParams select 0) - NNV_minApature) * ((NNV_Range * NNV_Multiplier) - NNV_Range)) / (NNV_maxApature - NNV_minApature)) + NNV_Range; // Scale the range to the range with multiplier based on current apature.
			private _NewTarget = (((((apertureParams select 2) - 4) * ((NNV_maxApature - (NNV_myRange*0.5)) - (NNV_minApature + (NNV_myRange*0.5)))) / 116) + (NNV_minApature + (NNV_myRange*0.5))) + NNV_cheatValue;	// Converts Engine apature baed on its aproximate min and max to be our new target using settings min and max.
			switch (true) do {
				Case ( ((_NewTarget + (NNV_myRange*0.25)) >= (apertureParams select 0)) && (NNV_CheckStage == 1) ) : {NNV_targetMin = (apertureParams select 0); NNV_CheckStage = 2;};
				Case ( ((_NewTarget + (NNV_myRange*0.25)) <= (apertureParams select 0)) && (NNV_CheckStage == 1) ) : {NNV_targetMin = (apertureParams select 0) - (NNV_myRange * 0.5); NNV_CheckStage = 2;};
				Case ( ((_NewTarget - (NNV_myRange*0.25)) <= (apertureParams select 0)) && (NNV_CheckStage == 2) ) : {NNV_targetMax = (apertureParams select 0); NNV_CheckStage = 1;};
				Case ( ((_NewTarget - (NNV_myRange*0.25)) >= (apertureParams select 0)) && (NNV_CheckStage == 2) ) : {NNV_targetMax = (apertureParams select 0) + (NNV_myRange * 0.5); NNV_CheckStage = 1;};
				Case (NNV_CheckStage == 1) : {NNV_targetMin = (apertureParams select 0) - (NNV_myRange * 0.5); NNV_CheckStage = 2;};
				Case (NNV_CheckStage == 2) : {NNV_targetMax = (apertureParams select 0) + (NNV_myRange * 0.5); NNV_CheckStage = 1;};
			};
			
			// Sanity n stuck checks
			if (NNV_CheckStage == 2) then {
				If (NNV_targetMin >= NNV_targetMax) then {NNV_targetMin = NNV_targetMax - (NNV_myRange * 0.5);};
				If (!(NNV_targetMin >= NNV_minApature)) then {NNV_targetMin = NNV_minApature;};
				if (NNV_targetMin == NNV_oldMin) then { NNV_targetMin = NNV_targetMin + (NNV_myRange * 0.25); } ;
			} else {
				If (NNV_targetMax <= NNV_targetMin) then {NNV_targetMax = NNV_targetMin + (NNV_myRange * 0.5);};
				If (!(NNV_targetMax <= NNV_maxApature)) then {NNV_targetMax = NNV_maxApature;};
				if (NNV_targetMax == NNV_oldMax) then { NNV_targetMax = NNV_targetMax - (NNV_myRange * 0.25); } ;
			};
		};
	} else {
		_codeToCheck = { // same as above, just simplified if there is effectivly no multiplier. 
			NNV_oldMin = NNV_targetMin;
			NNV_oldMax = NNV_targetMax;
		
			private _NewTarget = ((((apertureParams select 2) - 4) * ((NNV_maxApature - (NNV_Range*0.5)) - (NNV_minApature + (NNV_Range*0.5)))) / 116) + (NNV_minApature + (NNV_Range*0.5));
			switch (true) do {
				Case ( ((_NewTarget + (NNV_Range*0.25)) >= (apertureParams select 0)) && (NNV_CheckStage == 1) ) : {NNV_targetMin = (apertureParams select 0); NNV_CheckStage = 2;};
				Case ( ((_NewTarget + (NNV_Range*0.25)) <= (apertureParams select 0)) && (NNV_CheckStage == 1) ) : {NNV_targetMin = (apertureParams select 0) - (NNV_Range * 0.5); NNV_CheckStage = 2;};
				Case ( ((_NewTarget - (NNV_Range*0.25)) <= (apertureParams select 0)) && (NNV_CheckStage == 2) ) : {NNV_targetMax = (apertureParams select 0); NNV_CheckStage = 1;};
				Case ( ((_NewTarget - (NNV_Range*0.25)) >= (apertureParams select 0)) && (NNV_CheckStage == 2) ) : {NNV_targetMax = (apertureParams select 0) + (NNV_Range * 0.5); NNV_CheckStage = 1;};
				Case (NNV_CheckStage == 1) : {NNV_targetMin = (apertureParams select 0) - (NNV_Range * 0.5); NNV_CheckStage = 2;};
				Case (NNV_CheckStage == 2) : {NNV_targetMax = (apertureParams select 0) + (NNV_Range * 0.5); NNV_CheckStage = 1;};
			};
			
			// Sanity n stuck checks
			if (NNV_CheckStage == 2) then {
				If (NNV_targetMin >= NNV_targetMax) then {NNV_targetMin = NNV_targetMax - (NNV_Range * 0.5);};
				If (!(NNV_targetMin >= NNV_minApature)) then {NNV_targetMin = NNV_minApature;};
				if (NNV_targetMin == NNV_oldMin) then { NNV_targetMin = NNV_targetMin + (NNV_Range * 0.25); } ;
			} else {
				If (NNV_targetMax <= NNV_targetMin) then {NNV_targetMax = NNV_targetMin + (NNV_Range * 0.5);};
				If (!(NNV_targetMax <= NNV_maxApature)) then {NNV_targetMax = NNV_maxApature;};
				if (NNV_targetMax == NNV_oldMax) then { NNV_targetMax = NNV_targetMax - (NNV_Range * 0.25); } ;
			};
		};
	};
	
	(uiNamespace getVariable ["NNV_CurrentCheck",-1]) call CBA_fnc_removePerFrameHandler;
	_checkVar = [_codeToCheck, NNV_checkFrequency] call CBA_fnc_addPerFrameHandler;
	(uiNamespace setVariable ["NNV_CurrentCheck",_checkVar]);
};

