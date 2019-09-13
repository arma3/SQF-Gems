# SQF-Aspects
* Author: X39
* Credits: Arma3 Discord #scripting Community
## Description
This function will add script logic around an existing function. The added logic can be appended before
and after the original function.
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
### Ignore Functions
If you want to skip some functions when using the *tag-mode* (mentioned above) then you can add an
attribute to a function called `ignoreAspect = 1`.


Example:

_in CfgFunctions.hpp_
```
 class codeAsString {ignoreAspect = 1;};
```
Now this function will be ignored and not 'enriched'.
 
 This will 'enrich' only one explicit function
 ```arma.sqf
[{ diag_log "before func"},
{diag_log "after func"},
[1,"myTag_fnc_myFooFunc"]] call coopr_fnc_addFunctionAspects;
```
## Known Issues
* Has not been tested in a non `allowRecompile` environment
* Has not been tested on dedicated servers
