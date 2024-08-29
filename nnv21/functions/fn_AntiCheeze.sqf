0 spawn { 

	///* Sanity Check our settings and run some conversions.*///
	NNV_SettingCheeze = (NNV_set_SettingCheeze*0.01);
	NNV_ShadowCheeze = (NNV_set_ShadowCheeze*0.01);

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
		NNV_cheatValue = 0;
		(findDisplay 46) displayRemoveEventHandler ["keyDown", (uiNamespace getVariable ["NNV_CheatChecker",-2])];
	};
};

