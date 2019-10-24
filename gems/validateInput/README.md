# Validate Input
- Author: Heyoxe (https://github.com/Heyoxe/)

Checks if the given input is valid. Can replace automatically the input if in a Control or return an input with only allowed characters.

To add the input validation on the control, add the "onKeyDown" and "onKeyUp" eventHandler to the control.

## Arguments:
```MD
0 - _textOrControl: <STRING or CONTROL> Text or Control to check.
1 - _allowedCharacters: <ARRAY> Array of allowed Characters.
  0: <STRING> String of allowed characters, use predefined (A-Z, a-z or 0-9) or use custom.
  n: [...]
2 - _maxChar: <SCALAR> Maximum number of characters allowed.
3 - _allowEmpty <BOOLEAN> Allows the value to be equal to "".
4 - _fallbackValue: <STRING> Strings wich is set if empty input value is detected.
5 - _replace: <BOOLEAN> If _textOrControl is a <STRING>, it will return the string with only the valid characters, if it is a <CONTROL>, it will replace the text inside the control with the valid text.

```

## Return Value:
```MD
<BOOLEAN>: text is valid or not or <STRING>: if controlOrText is a <STRING> and replace i set to true, returns validated String.
```

## Example:
### In Script:
```SQF
['My Super Text!', ['A-Z', 'a-z', '0-9'], -1, '...', true] call Gems_fnc_validateInput; 
// Returns: "MySuperText"
// Alows an unlimited number of alpha-numerical characters to be inputed.

['My Super Text!', ['A-Z', 'a-z', '0-9', ' '], -1, '...', true] call Gems_fnc_validateInput; 
// Returns: "My Super Text"
// Alows an unlimited number of alpha-numerical + [spaces] characters to be inputed.

['My Super Text!', ['A-Z', 'a-z', '0-9', ' '], 2, '...', true] call Gems_fnc_validateInput; 
// Returns: "My"
// Alows 2 alpha-numerical + [spaces] characters to be inputed.

['My Super Text!', ['_'], -1, '...', true] call Gems_fnc_validateInput; 
// Returns: "..."
// Only allow '_' to be inputed but you can add as many as you want. If text is not good, will return '...'.

['My Super Text!', ['_'], -1, '...', false] call Gems_fnc_validateInput; 
// Returns: false
// Only allow '_' to be inputed but you can add as many as you want. If text is not good, will return false, else, it will return true.
```

### In Configs:
This code will only allow numbers up to 6 digits and positive to be inputed. If the user types anything else, it will remove that from the input or if nothing is set, it wil fallback to 1.
```CPP
class MySuperDialog {
	idd = -1;
	class Controls {
		class MyInput: RscEdit {
			idc = -1;
			x = 0;
			y = 0;
			w = safeZoneW;
			h = safeZoneH;
			text = "1";
			onKeyDown = "[(_this#0), ['0-9'], 6, false, '1', true] call Gems_fnc_validateInput";
			onKeyUp = "[(_this#0), ['0-9'], 6, false, '1', true] call Gems_fnc_validateInput";
		};  
	};
};
```