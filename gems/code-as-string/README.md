# SQF-Aspects
* Author: X39
* Credits: Arma3 Discord #scripting Community
## Description
will remove the { & } from the code string (which are applied when using str for example)
## Parameters
```
 0: _codeToConvert <STRING | CODE> - code to be converted (if string then function will simply return the string again)
```
## Usage
Add logic around all functions defined by a tag `myTag`. So all functions starting with
`myTag_fnc_` will be 'enriched'.
```arma.sqf
 { diag_log "I am code"; } call gem_fnc_codeAsString;
```
