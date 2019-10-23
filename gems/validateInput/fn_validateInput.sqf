/*
 *	Author: Heyoxe
 *		Check if Input is valid.
 *		To add the input validation on the control, add the "onKeyDown" and "onKeyUp" eventHandler to the control.
 *
 *	Arguments:
 *		0 - _textOrControl: <STRING or CONTROL> Text or Control to check.
 *		1 - _allowedCharacters: <ARRAY> Array of allowed Characters.
 *			0: <STRING> String of allowed characters, use predefined (A-Z, a-z or 0-9) or use custom.
 *			n: [...]
 *		2 - _maxChar: <SCALAR> Maximum number of characters allowed.
 *		3 - _allowEmpty <BOOLEAN> Allows the value to be equal to "".
 *		4 - _fallbackValue: <STRING> Strings wich is set if empty input value is detected.
 *		5 - _replace: <BOOLEAN> If _textOrControl is a <STRING>, it will return the string with only the valid characters, if it is a <CONTROL>, it will replace the text inside the control with the valid text.
 *
 *	Return Value: <BOOLEAN>: text is valid or not or <STRING>: if controlOrText is a <STRING> and replace i set to true, returns validated String.
 *
 *	Example:
 *		[_control, ['0-9'], 6, false, '1', true] call Gems_fnc_validateInput; // Only allow '0123456789' to be inputed and will limit size to 6 and will automaticaly correct the control's input. If nothing set, fallbacks to 1.
 *		['My Super Text', ['_'], -1, '...', true] call Gems_fnc_validateInput; // Only allow '_' to be inputed but you can add as many as you want. If text is not good, will return '...'.
 *		['My Super Text', ['_'], -1, '...', false] call Gems_fnc_validateInput; // Only allow '_' to be inputed but you can add as many as you want. If text is not good, will return false, else, it will return true.
 *
 */

params [
	["_textOrControl", "", ["", controlNull]],
	["_allowedCharacters", ["A-Z", "a-z", "0-9"], [[]]],
	["_maxChar", -1, [0]],
	["_allowEmpty", true, [true]],
	["_fallbackValue", "", [""]],
	["_replace", true, [true]]
];

// Generic exit function but only related to validateInput 
_fnc_exit = {
	params [
		["_textOrControl", "", ["", controlNull]],
		["_validatedText",  [], [[]]],
		["_replace", true, [true]],
		["_success", false, [true]]
	];
	_validatedText = _validatedText joinString "";
	if (_replace) then {
		if ((typeName _textOrControl) isEqualTo "CONTROL") then {
			_textOrControl ctrlSetText _validatedText;
		} else {
			_validatedText
		};
	} else {
		_success
	};
};

// Transform human-friednly authorized input to code-friendly
private _allowedCharactersArray = [];
{
	_allowedCharactersArray pushBackUnique (switch _x do {
		case "A-Z": { "ABCDEFGHIJKLMNOPQRSTUVWXYZ" };
		case "a-z": { "abcdefghijklmnopqrstuvwxyz" };
		case "0-9": { "0123456789" };
		default { _x };
	});
} forEach _allowedCharacters;
_allowedCharactersArray = (_allowedCharactersArray joinString "") splitString "";


// Checks if we test a text or a control
private "_inputText";
if ((typeName _textOrControl) isEqualTo "CONTROL") then {
	_inputText = (ctrlText _textOrControl) splitString "";
} else {
	_inputText = _textOrControl splitString "";
};

// Will only select char that are in the allowedChar Defined above
private _validatedText = _inputText select {_x in _allowedCharactersArray};


// Checks for emptines
if (!_allowEmpty && { (count _validatedText) <= 0 }) exitWith {
	_validatedText = [_fallbackValue];
	hint format ["You must type something!"];
	[_textOrControl, _validatedText, _replace, false] call _fnc_exit
};

// Error printing if invalid char has been inputed
if !((count _inputText) isEqualTo (count _validatedText)) exitWith {
	hint format ["This character is not allowed! List of allowed character: %1.", _allowedCharacters];
	[_textOrControl, _validatedText, _replace, false] call _fnc_exit
};

// Checks if text is longer than the maximum allowed chars
if ((_maxChar != -1) && (count _validatedText) > _maxChar) exitWith {
	_validatedText deleteRange [_maxChar, ((count _validatedText) - 1)];
	hint format ["Cannot type more than %1 characters!", _maxChar];
	[_textOrControl, _validatedText, _replace, false] call _fnc_exit
};


// Everything went correctly
[_textOrControl, _validatedText, _replace, true] call _fnc_exit