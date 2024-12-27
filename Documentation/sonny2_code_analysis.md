This is me documenting the control flow of the game as it progresses from the first frame, noting what scripts play and what data is loaded.
This describes scripts found in ./game/data/ported/original_scripts which are labeled based on their frame and script number (ex 41.1.language_data.as is below as Frame 41.). Not all frames are saved in that directory as the actual code is redundant (like the first few frames)

### Frame 1:
Load some language data (define it)
Display the english and dutch flags as language select.

### Frame 4:
Tries to load and play an ad
Displays text "Loading"

### Frame 5:
Displays text "Click to play"

### Frame 6:
Check for original domain and goto sitelock() if we aren't on armorgames

### Frame 21:
gotoAndStop("soundExport");
presumably that frame is somewhere later and gets jumped to now. Unclear.
That is going to be frame 40 where nothing happens, but the next frame is "resethere" which loads more data.

### Frame 41 "resethere":
1 - Loads a metric fuckton of strings into memory all at once... including some that already exist? hollup....
These files are... exactly the same, with the exclusion of this bit:
```actionscript
KLangChoosen = "ENGLISH";
Stage.showMenu = false();
fscommand("showMenu",false);
Stage.scaleMode = "exactFit";
stop();
var today_date = new Date();
dayNow = today_date.getDate();
```
This stuff probably shouldn't run? If it _must_ have a language selection screen before loading, it should load only what it needs. Really all that data should be IN the language selection screen code becuase it's so minimal then the game can load the rest of the language strings from the file for whatever lang you chose.

Anyway, this is the game's strings that other shit are going to reference constantly.

2 - loads the game's classes and sets a bunch of global values... of all sorts.

### Frame 42:
This frame contains like 21 scripts, generally function definitions and stuff. I'll go through them.
1 - Defines function "addSound()" is defined and sounds are attached to some dog entities
2 - Defines function "expWorkOut" which determines how much experience the player gets after combat based on the experience of the enemies (I think?)
3 - Defines function "krinChangeColor" and creates a bunch of shaders and effects using the flash player api
  - like flash.filters. and flash.geom.
4 - Defines functions krinAddMove, krinMelee, krinBoltMake, and sets several global variables. These appear to control attacking behavior for all game characters as their only movesets involve bolts and melee.
5 - This sets some variable related to how enemies' attributes are chosen when randomly generated. I think? It's unclear.
6 - Defines function "addNewMove" and defines the abilities of the game
7 - Defines "KrinNumberShow" which appears to control the damage popups when characters are hit
8 - Defines "executeMove", "perScript" and "lifeBarUpdate" which appear to be used in combat to decide damage and more
9 - Defines "AImoveAdder" which appears to decide what ability the AI should use next and filter based on many conditions. Also defines "LowerCD" which is self-explanatory. Not sure why it's here in particlular.
10 - Defines functions to add and apply buffs, then appears to define specific buffs and/or attach them to existing moves (hackMove()) but that's unclear without looking further.
11 - Appears to handle the menu to choose an ability during combat via "addMoveForPlayer". Also defines "checkBuffsOnUnit" which checks how many buffs are on that unit against some value passed in. Probably used for AI behavior.
12 - Defines AI behavior mode names and a set of 5 values to go with each mode. The values may be used to check against some other set of values to decide what the AI should do.
   - Upon further inspection the values corrospond to the following
   - _root["playerKrin" + _parent.pN].(see below)
     - agMode = pN;
     - Aggression = _root.agModeAr1[pN];
     - LifeBoundary1 = _root.agModeAr2[pN];
     - LifeBoundary2 = _root.agModeAr3[pN];
     - FocusAggression = _root.agModeAr4[pN];
     - FocusRegenLimit = _root.agModeAr5[pN];
   - "pN" is the ID in our AI behavior array "agModeNames" containing phalanx, defensive, neutral, aggressive and relentless. Each of the 5 arrays is the setting for the above listed trait for that mode. (agModeAr1-5)
13 - Defines "createNewUnitKrin" which is a template for information about every game actor wether friend or foe (or bunny rabbit), then proceeds to call that function with custom data to create the game's characters.
14 - Appears to set up the zones and their attributes (the battles they contain, custom loot, etc). Requires further inspection. Defines functions "createNewBattle", "krinAddNewUnit" and "getPNum". The format in which this file is set up is rather odd.
15 - Defines "getStat", "givePoints" and "assignPointsStart" which appear to be used throughout the game to calculate stats. One of the things that will be translated to lua and otherwise left alone probably.
16 - Defines "respecValue" which handles how many points to give the player when they respec.
   - Also defines the template for ingame items and proceeds to define the rest of the items in the game.
   - I think the weird formatting of functions like these is the result of certain variables being shared. They are set, read from when the item is created, then cleared and filled with new data for the next item. It's an odd way of doing things and looks like endless lines of code with no structure. It will take time to clean up.
17 - Defines data for all friendly party characters: "Sonny", "Veradux", "Roald", "Felicity", "Teco", "Catelin". The last 2 are not familiar. Perhaps unused content or something I missed while playing?
18 - Empty...? Huh. Weird. Deleted empty file in original scripts directory....
19 - Defines function "krinSetShop" which takes the ID of the current stage and returns a list of item IDs for that shop. This really should be stored with the stage itself. Man I'm going to have to restructure. Fun fun! I chose this.
20 - Defines function "checkIfAllStar" which checks if you've completed the game on difficulty 2 with each class of character.
   - Defines function "krinHandleData" which appears to save/load data from a slot (used in arena mode as well as regular)
   - Defines functions "loadPvPCode" and "exportPvPCode" which are probably used in arena but idk.
   - Defines function "krinNavTutSpeech"
21 - Sets data for "Krin.progressSpeech" which is used by the function "krinNavTutSpeech" which seems involved in deciding what to do after combat and displaying something? It isn't used much.

### Frame 43:
Loads in all the sprites for weapons, armor and effects. Also defines the structure for skeletons or "Dolls" as they put it

### Frame 46 ("mainmenu"):
1 - Shows a back button, stops any boss music that might be playing and sets winCondition to -1 for some reason
2 - Defines function "awardAch" to give achievements / display a toast if you get one
3 - Displays several text buttons on the main menu:
    - "Start!"
    - "Play MORE Games!"
    - "Game Manual"
    - "Play the Original Sonny"
    - "Credits"
Other behavior is handled by the buttons themselves.

### Frame 56 ("subMenu"):
Display second main menu buttons
 - "New Game"
 - "Load Game"
 - "PvP Arena"
Other behavior is handled by the buttons themselves.

### Frames with minimal scripting but several buttons which run small scripts:
64 - Name Menu
84 - Class Menu
93 - Options Menu
104 - Game-Over Menu
116 - End Menu
124 - Design Menu (manual?)
134 - Credit Menu

### Frames 165 and 180:
Appear to set a few variables before combat starts

### Frame 181 ("Navigation"):
Handles behavior of the zone-select screen including hovering zones to see their descriptions and only allowing the proper zones to be interacted with
  - It looks like the user might get sent to this frame after combat because there's a little script that handles _root.winCondition == 1 and sends us to the "win" scene.

### Frame 200 ("arenaNav")
Defines function "refreshArenaUI"

### Frame 201 ("loadBattleScene"):
Sets up the combat arena. Large script.
Note: "playerKrin" refers to ai controlled actors on the player's team (I think)
This defines function "updateStat_Player" which sets the stats and stuff for the player characer, changing bits if the player is in the arena.

### Frame 217 ("KrinBattleScene"):
Handles in-combat stuff like the turn timer, audio, and effects. Contains many scripts
1 - TODO