# CustomCrossHairScale

Scale your Unreal Tournament crosshair.

Original author unknown. Modified by Dizzy.

## Limitations

Works only with weapons which don't use a modified crosshair. For example, it won't work correctly with the sniper rifle. Designed primarily for InstaGib.

## Installation

### Online (Servers)

1. Copy `.u` file to `UT/System/`
2. In `UnrealTournament.ini`, add:  

   `ServerPackages=CCHS4`  
   `ServerActors=CCHS4.CCHS`

### Offline (Single Player)

1. Copy `.u` and `.int` files to `UT/System/`
2. Add the "Custom Crosshair Scale" mutator when starting your game

## Usage in-game:
1. Open console or press Tab
2. `mutate ch_scale 1`
