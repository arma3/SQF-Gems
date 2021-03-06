# SQF-Aspects
* Author: xetra11
* Credits: Arma3 Discord #scripting Community
## Description
This function will add script logic around an existing function. The added logic can be appended before
and after the original function.
## Parameters
```
 0: _beforeAspect <STRING | CODE> - before aspect code as string
 1: _afterAspect <STRING | CODE> - after aspect code as string
 2: _functionTargets <ARRAY> - [<enrichmentMode> (, <functionName> | <tagPrefix> )]
```
## Usage
Add logic around all functions defined by a tag `myTag`. So all functions starting with
`myTag_fnc_` will be 'enriched'.
```arma.sqf
[{ diag_log ">> __FUNC_NAME__"},
{diag_log "<< __FUNC_NAME__"},
[0,"myTag"]] call gem_fnc_addFunctionAspects;
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
[1,"myTag_fnc_myFooFunc"]] call gem_fnc_addFunctionAspects;
```
## Known Issues
* Has not been tested in a non `allowRecompile` environment
* Has not been tested on dedicated servers
