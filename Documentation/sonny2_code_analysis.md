This is me documenting the control flow of the game as it progresses from the first frame, noting what scripts play and what data is loaded.
This describes scripts found in ./game/data/ported/original_scripts which are labeled based on their frame and script number (ex 41.1.language_data.as is below as Frame 41.). Not all frames are saved in that directory as the actual code is redundant (like the first few frames)

# Frame Scripts
## Frame 1:
1. Load some language data (define it)
   
## Frame 4:
1. Tries to load and play an ad
2. Displays text "Loading"
## Frame 5:
1. Displays text "Click to play"
## Frame 6:
Check for original domain and goto `sitelock()` if we aren't on armorgames
## Frame 21:
`gotoAndStop("soundExport");`
presumably that frame is somewhere later and gets jumped to now. Unclear.
That is going to be frame 40 where nothing happens, but the next frame is "resethere" which loads more data.
## Frame 41 "resethere":
1. Loads a metric fuckton of strings into memory all at once... including some that already exist? hollup....
These files are... exactly the same, with the exclusion of this bit:
```javascript
KLangChoosen = "ENGLISH";
Stage.showMenu = false();
fscommand("showMenu",false);
Stage.scaleMode = "exactFit";
stop();
var today_date = new Date();
dayNow = today_date.getDate();
```
This stuff probably shouldn't run? If it _must_ have a language selection screen before loading, it should load only what it needs. Really all that data should be IN the language selection screen code because it's so minimal then the game can load the rest of the language strings from the file for whatever lang you chose.
Anyway, this is the game's strings that other shit are going to reference constantly.
2. loads the game's classes and sets a bunch of global values... of all sorts.
## Frame 42:
This frame contains like 21 scripts, generally function definitions and stuff. I'll go through them.
1. Defines function "addSound()" is defined and sounds are attached to some dog entities
2. Defines function "expWorkOut" which determines how much experience the player gets after combat based on the experience of the enemies (I think?)
3. Defines function "krinChangeColor" and creates a bunch of shaders and effects using the flash player api like flash.filters. and flash.geom.
4. Defines functions krinAddMove, krinMelee, krinBoltMake, and sets several global variables. These appear to control attacking behavior for all game characters as their only movesets involve bolts and melee.
5. This sets some variable related to how enemies' attributes are chosen when randomly generated. I think? It's unclear.
6. Defines function "addNewMove" and defines the abilities of the game
7. Defines "KrinNumberShow" which appears to control the damage popups when characters are hit
8. Defines "executeMove", "perScript" and "lifeBarUpdate" which appear to be used in combat to decide damage and more
9. Defines "AImoveAdder" which appears to decide what ability the AI should use next and filter based on many conditions. Also defines "LowerCD" which is self-explanatory. Not sure why it's here in particlular.
   EDIT: That is exactly what it does, using values from unit definitions and rebranding several "aggression values" to things like `FocusRegenLimit`
10. Defines functions to add and apply buffs, then appears to define specific buffs and/or attach them to existing moves (hackMove()) but that's unclear without looking further.
   Defines `changeForm()` function which uses `dressChar()` to set the armors for characters in combat
11. Appears to handle the menu to choose an ability during combat via "addMoveForPlayer". Also defines "checkBuffsOnUnit" which checks how many buffs are on that unit against some value passed in. Probably used for AI behavior.
12. Defines AI behavior mode names and a set of 5 values to go with each mode. The values may be used to check against some other set of values to decide what the AI should do. Upon further inspection the values corrospond to the following:
    ```javascript
	_root["playerKrin" + _parent.pN].see_below
	     agMode = pN;
	     Aggression = _root.agModeAr1[pN];
	     LifeBoundary1 = _root.agModeAr2[pN];
	     LifeBoundary2 = _root.agModeAr3[pN];
	     FocusAggression = _root.agModeAr4[pN];
	     FocusRegenLimit = _root.agModeAr5[pN];
	``` 
	"pN" is the ID in our AI behavior array "agModeNames" containing phalanx, defensive, neutral, aggressive and relentless. Each of the 5 arrays is the setting for the above listed trait for that mode. (agModeAr1-5)

13. Defines `createNewUnitKrin` which is a template for information about every game actor whether friend or foe (or bunny rabbit), then proceeds to call that function with custom data to create the game's characters.
    Note: MODEL6 is this ape:
    ![[gorilla]]
    And ***its sprite contains all of its animations***. I should be able to pull those out into a sprite sheet
1. Appears to set up the zones and their attributes (the battles they contain, custom loot, etc). Requires further inspection. Defines functions "createNewBattle", `krinAddNewUnit` and `getPNum`. The format in which this file is set up is rather odd.
2. Defines `getStat`, `givePoints` and `assignPointsStart` which appear to be used throughout the game to calculate stats. One of the things that will be translated to lua and otherwise left alone probably.
3. Defines "respecValue" which handles how many points to give the player when they respec.
   - Also defines the template for ingame items and proceeds to define the rest of the items in the game.
   - I think the weird formatting of functions like these is the result of certain variables being shared. They are set, read from when the item is created, then cleared and filled with new data for the next item. It's an odd way of doing things and looks like endless lines of code with no structure. It will take time to clean up.
4. Defines data for all friendly party characters: `{"Sonny", "Veradux", "Roald", "Felicity", "Teco", "Catelin"}`. The last 2 are not familiar. Perhaps unused content or something I missed while playing?
5. Empty...? Huh. Weird. Deleted empty file in original scripts directory....
6. Defines function `krinSetShop` which takes the ID of the current stage and returns a list of item IDs for that shop. This really should be stored with the stage itself. Man I'm going to have to restructure. Fun fun! I chose this.
7.  Defines function `checkIfAllStar` which checks if you've completed the game on difficulty 2 with each class of character.
   - Defines function `krinHandleData` which appears to save/load data from a slot (used in arena mode as well as regular)
   - Defines functions `loadPvPCode` and `exportPvPCode` which are probably used in arena but idk.
   - Defines function `krinNavTutSpeech`
8.  Sets data for `Krin.progressSpeech` which is used by the function `krinNavTutSpeech` which seems involved in deciding what to do after combat and displaying something? It isn't used much.

## Frame 43:
Loads in all the sprites for weapons, armor and effects. Also defines the structure for skeletons or "Dolls" as they put it

## Frame 46 ("mainmenu"):
1. Shows a back button, stops any boss music that might be playing and sets winCondition to -1 for some reason
2. Defines function `awardAch` to give achievements / display a toast if you get one
3. Displays several text buttons on the main menu:
    - "Start!"
    - "Play MORE Games!"
    - "Game Manual"
    - "Play the Original Sonny"
    - "Credits"
Other behavior is handled by the buttons themselves.
## Frame 56 ("subMenu"):
1. Display second main menu buttons
	 - "New Game"
	 - "Load Game"
	 - "PvP Arena"
Other behavior is handled by the buttons themselves.
## Frames with minimal scripting but several buttons which run small scripts:
```lua
{
	{64, "Name Menu"},
	{84, "Class Menu"},
	{93, "Options Menu"},
	{104, "Game-Over Menu"},
	{116, "End Menu"},
	{124, "Design Menu"},
	{134, "Credit Menu"}
}
-- I didn't need to make this lua I just felt like it.
```
## Frames 165 and 180:
1. Appear to set a few variables before combat starts
## Frame 181 ("Navigation"):
1. Handles behavior of the zone-select screen including hovering zones to see their descriptions and only allowing the proper zones to be interacted with
	  - It looks like the user might get sent to this frame after combat because there's a little script that handles _root.winCondition == 1 and sends us to the "win" scene.
## Frame 200 ("arenaNav")
1. Defines function "refreshArenaUI"
## Frame 201 ("loadBattleScene"):
1. Sets up the combat arena. Large script.
   Note: "playerKrin" refers to ai controlled actors on the player's team (I think)
   This defines function "updateStat_Player" which sets the stats and stuff for the player characer, changing bits if the player is in the arena.
## Frame 217 ("KrinBattleScene"):
Handles in-combat stuff like the turn timer, audio, and effects. Contains many scripts
1. Sets a listener to display some angry text if you try to move at the beginning of the game before text and stuff has finished displaying.
   Also sets several global variables for combat (I think) like a battle time limit...? 
2. Defines several functions like `dressChar`, `TeamSelect`, `TeamSpeedAdder` and `AIGoERSwitch`.
   Respectively these seem to control dressing all the character dolls in this combat, setting teams, deciding the order in which teams should go, and ... maybe setting the ai to active? I'm not sure.
3. Looks like it sets some initial variables before combat
4. Applies passive buffs to all characters in the combat which have them.
### Frame 219
1. Handles several things at the end of  battle, specifically whether achievement progress should be awarded, setting the variables if it decides you beat a boss, and deciding which scene you go to afterward (boss kills send you to Navigation)
### Frame 230
1. Looks like you just died. It'll set the game over state to true, disable boss music and set the save slot that resethere will load for you.

# Out of Order Notes
## Skeleton Stuff
Ok so I think I found the base character model in the swf file as a sprite labeled `MODEL1` which uses a ninja outfit by default. I'm pretty sure it gets swapped out. when it needs to be displayed. Contains the base animations for all humanoid characters (since they all use the same set). I should be able to clip those into sprite sheets to use for animations.
It's a damn shame this developr, Krin, ended up using flash.
### Draw Order:
Okay, so flash uses its own z-coordinate system which invalidates the draw order entirely, but I'll recreate it here

```lua
-- Assume the character is facing right for comments
draw_order = {
	"drop_shadow",
	"arm2", -- Upper left arm
	"hand2", -- Lower left arm
	"weapon2", -- Left hand weapon
	"foot2", -- Left foot
	"leg2", -- Left _upper_ leg
	"leg4", -- Left _lower_ leg (these are backward but it doesn't end up mattering at all I guess)
	"foot1", -- Right 
	"leg1",
	"leg3",
	"chest",
	"head",
	"arm1",
	"shoulder", -- Only 1 shoulder ever faces the camera because the sprite gets flipped on its y axis instead
	"weapon1",
	"hand1"
}
```

### Figuring out how abilities are defined
Sooooooo in Original script `42.8` it defines `ExecuteMove` which appears to handle all of the logic for taking an ability and using the clusterfuck of values therein.
Here's the function signature:
```javascript
function executeMove(IDKM, IDKM2, IDKC, IDKT)
```
IDKM I think is "ID Krin Move" and it maps to KRINABILITY#
IDKM maps to KRINABILITYB#

I can tell because of how these sorts of strings corrospond with each other between the definitions and executeMove script:
```javascript
if(IDKM[14] == "Full Damage")
...
"KRINABILITY2":["Auto Swing",2,0,1,0,0,0,0,8,1,"Melee","0xFF0000","Attack","BOOM_SLASH2","Full Damage",1,0,"Integrity","sfx_hit4"]
```
... ok so here's something curious, executeMove is only used _twice_ in the entire game under a couple of conditions. Here's the code:

```javascript
               if(!mAry2[20]) // If this returns false the attack hits all enemies
               {
                  _root.executeMove(mAry1,mAry2,mCaster,mTarget);
               }
               else
               {
                  owegwe = 0;
                  while(owegwe < 3)
                  {
                     if(_root["playerKrin" + (7 - (mCaster.teamSide + owegwe * 2))].active)
                     {
                        _root.executeMove(mAry1,mAry2,mCaster,_root["playerKrin" + (7 - (mCaster.teamSide + owegwe * 2))]);
                     }
                     owegwe++;
                  }
               }
```
As you can see the signature is more like `executeMove(mAry1,mAry2,mCaster,mTarget)` where it passes in the move arrays, the caster and the target.
