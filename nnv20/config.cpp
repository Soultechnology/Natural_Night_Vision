#include "\x\cba\addons\main\script_macros_common.hpp"

class CfgPatches {
	class ADDON {
		name = "Natural Night Vision";
		author = "SoulTechnology";
		url = "";
		requiredVersion = 1.0; 
		requiredAddons[] = {"cba_main", "cba_settings"};
		units[] = {};
		weapons[] = {};
	};
};

class CfgFunctions {
    class NNV {
        class functions {
			file = "NNV\functions";
            class naturalNightvision{};
			class cbaSettings{};
        };
    };
};

class Extended_PreInit_EventHandlers {
    class my_preInit {
        init = "call compile preprocessFileLineNumbers 'NNV\functions\fn_cbaSettings.sqf'";
    };
};