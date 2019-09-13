#include "script_component.hpp"
/*
 * Author: xetra11
 *
 * This function will enrich existing functions with aspects before and after the function call.
 * This way it will remove boilerplate code mostly used for debugging purpose.
 * Aspects add this functionality while making it more difficult to maintain the code base.
 * Only use if really needed!
 *
 * Arguments:
 * 0: _beforeAspect <STRING | CODE> - before aspect code as string
 * 1: _afterAspect <STRING | CODE> - after aspect code as string
 * 2: _functionTargets <ARRAY> - [<enrichmentMode> (, <functionName> | <tagPrefix> )]

 * enrichmentMode : 0 = all functions that start with <tagPrefix>
 * enrichmentMode : 1 = only one function as <functionName>
 *
 * Return Value:
 *
 * Example:
 *
 *     [{ diag_log ">> __FUNC_NAME__"},
 *      {diag_log "<< __FUNC_NAME__"},
 *      [0,"myTag"]] call coopr_fnc_addFunctionAspects;
 *
 *     [{ diag_log "before func"},
 *      {diag_log "after func"},
 *      [1,"myTag_fnc_myFooFunc"]] call coopr_fnc_addFunctionAspects;
 *
 * Public: No
 *
 * Scope: Global
 */

#define FUNCS_BY_TAG 0
#define FUNC_NAME 1

params [["_beforeAspect", {}],
        ["_afterAspect", {}],
        ["_enrichmentMode", [], [[0, ""]]]];

if (isNil "GEM_ignoreFunctions") then {
    GEM_ignoreFunctions = [];
};

if (_beforeAspect isEqualTo {}) exitWith { diag_log "_beforeAspect was not defined" };
if (_afterAspect isEqualTo {}) exitWith { diag_log "_afterAspect was not defined" };
if (_enrichmentMode isEqualTo []) exitWith { diag_log "_enrichmentMode was not defined" };

if (typeName _afterAspect isEqualTo "STRING") then { _beforeAspect = compile _afterAspect };
if !(typeName _afterAspect isEqualTo "CODE") exitWith { diag_log "_afterAspect is not code" };
if (typeName _beforeAspect isEqualTo "STRING") then { _beforeAspect = compile _beforeAspect };
if !(typeName _beforeAspect isEqualTo "CODE") exitWith { diag_log "_beforeAspect is not code" };

private _mode = _enrichmentMode select 0;
private _functionNameOrTags = _enrichmentMode select 1;

private _enrichFunction = {
    params ["_functionSignature"];
    if (_functionSignature in GEM_ignoreFunctions) then {
        diag_log format["ignore function enrichment for %1", _functionSignature];
    } else {
        // preprocess special keywords
        // replace __FUNC_NAME__ with function name
        _processedBeforeAspect = [str _beforeAspect, "__FUNC_NAME__", _functionSignature] call coopr_fnc_stringReplace;
        _processedAfterAspect = [str _afterAspect, "__FUNC_NAME__", _functionSignature] call coopr_fnc_stringReplace;

        private _function = missionNamespace getVariable _functionSignature;
        diag_log format["enriching function: %1", _functionSignature];

        if !(isNil "_function") then {
            private _enrichedFunction = format ["
                call %1;
                private _returnValue = [nil] apply {_this call %2} param [0, false];
                call %3;
                _returnValue;
            ", _processedBeforeAspect, _function, _processedAfterAspect];
            missionNamespace setVariable [_functionSignature, compile _enrichedFunction];
            GEM_ignoreFunctions pushBackUnique _functionSignature;
        };
    }
};

if (_mode isEqualTo FUNCS_BY_TAG) then {
    private _tag = _functionNameOrTags;
    private _fullPrefix = _tag + "_fnc_";

    private _funcCategories = ("true" configClasses(configFile >> "CfgFunctions" >> _tag)) apply { configName _x };
    {
        private _category = _x;
        private _classNames = ("true" configClasses(configFile >> "CfgFunctions" >> _tag >> _category)) apply { configName _x };
        GEM_ignoreFunctions append (_classNames select { ([(configFile >> "CfgFunctions" >> _tag >> _category >> _x), "ignoreAspect", 0] call BIS_fnc_returnConfigEntry) > 0 });
    } forEach _funcCategories;
    GEM_ignoreFunctions = GEM_ignoreFunctions apply { toLower (_fullPrefix + _x) };
    DEBUG2("aspects won't be applied to following functions: %1", GEM_ignoreFunctions);

    DEBUG2("enriching functions for tag: %1", (toUpper _tag));
    private _taggedFunctionSignatures = allVariables missionNamespace select {[_fullPrefix, _x] call BIS_fnc_inString };
    { _x call _enrichFunction; } forEach _taggedFunctionSignatures;
};

if (_mode isEqualTo FUNC_NAME) then {
    private _funcName = _functionNameOrTags;
    _funcName call _enrichFunction;
};

