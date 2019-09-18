# Code as String
* Author: X39
* Credits: Arma3 Discord #scripting Community
## Description
will remove the { & } from the code string (which are applied when using str for example)
## Parameters
```
 0: _codeToConvert <STRING | CODE> - code to be converted (if string then function will simply return the string again)
```
## Usage
```arma.sqf
 { diag_log "I am code"; } call gem_fnc_codeAsString;
```
