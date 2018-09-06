class CH_Render extends Mutator;

var CHS_Setup ownerSetup;
var int count;

var PlayerPawn PlayerOwner;
var ChallengeHUD myHUD;
var Texture T;

simulated function bool FindOwnerSetup()
{
	local int i;

	foreach AllActors(class'CHS_Setup', ownerSetup)
	{
		if(ownerSetup.owner == PlayerOwner) //pass Canvas.Viewport.Actor?
			return True;
	}

	return False;
}

simulated function PostRender( canvas Canvas )
{

	local float XL, YL, dx, dy;
	local int i;

	local SniperRifle sr;
	local WarheadLauncher wl;
	local UT_Eightball eb;

	if(nextHUDMutator != none)
		nextHUDMutator.PostRender(Canvas);


	if(++count < 25)
		return;

	if(ownerSetup == None)
	{
		if(!FindOwnerSetup())
			return;

		//Log(ownerSetup.bOn $ " / " $ ownerSetup.scale);
	}

	if(PlayerOwner.Weapon != None)
	{

		//g("got weapon "$ownerSetup.bOn);
		eb = UT_Eightball(PlayerOwner.Weapon);
		if(eb == None)
		{
			wl = WarheadLauncher(PlayerOwner.Weapon);

			if(wl == None)
				sr = SniperRifle(PlayerOwner.Weapon);
		}

		//we draw the crosshair!
		PlayerOwner.Weapon.bOwnsCrossHair = True;

		//Log(PlayerOwner.Weapon $ " /  " $ownerSetup.bOn
			//$ " / " $ ownerSetup.scale);

		if((eb != None && eb.bLockedOn) ||
		(wl != None && (wl.bGuiding || wl.bShowStatic)) ||
		(sr != None && PlayerOwner.DesiredFOV != PlayerOwner.DefaultFOV))
		{
			//let the weapons draw their special things

		}
		else
			DrawScaledCH(Canvas);//draw with desired scale

	}
	//else
		//Log("can't see weapon");

}


simulated function DrawScaledCH(Canvas canvas)
{
	local float XScale, PickDiff;
	local float XLength;
	//local texture T;
	local int i;

 	if (myHUD.Crosshair >= myHUD.CrosshairCount) Return;


	if(ownerSetup.bOn)
		XScale = ownerSetup.scale;
	else
	{
		if ( Canvas.ClipX < 512 )
			XScale = 0.5;
		else
			XScale = FMax(1, int(0.1 + Canvas.ClipX / 640.0));
	}


	PickDiff = Level.TimeSeconds - myHUD.PickupTime;
	if ( PickDiff < 0.4 )
	{
		if ( PickDiff < 0.2 )
			XScale *= (1 + 5 * PickDiff);
		else
			XScale *= (3 - 5 * PickDiff);
	}
	XLength = XScale * 64.0;

	Canvas.bNoSmooth = False;
	if ( PlayerOwner.Handedness == -1 )
		Canvas.SetPos(0.503 * (Canvas.ClipX - XLength), 0.504 * (Canvas.ClipY - XLength));
	else if ( PlayerOwner.Handedness == 1 )
		Canvas.SetPos(0.497 * (Canvas.ClipX - XLength), 0.496 * (Canvas.ClipY - XLength));
	else
		Canvas.SetPos(0.5 * (Canvas.ClipX - XLength), 0.5 * (Canvas.ClipY - XLength));
	Canvas.Style = ERenderStyle.STY_Translucent;
	Canvas.DrawColor = 15 * myHUD.CrosshairColor;

	if( T == None || T != myHUD.CrossHairTextures[myHUD.CrossHair])
	{
		if(myHUD.CrossHairTextures[myHUD.CrossHair] == None)
		{
			T = Texture(DynamicLoadObject(myHUD.Default.CrossHairs[myHUD.CrossHair], class'Texture'));
			myHUD.CrossHairTextures[myHUD.CrossHair] = T;
		}
		else
			T = myHUD.CrossHairTextures[myHUD.CrossHair];

		if(T == None)
		{
			Log(myHUD.Default.CrossHairs[myHUD.CrossHair] $ " no tex " $ myHUD.CrossHair);
			return;
		}
	}


	Canvas.DrawTile(T, XLength, XLength, 0, 0, 64, 64);
	Canvas.bNoSmooth = True;
	Canvas.Style = Style;
}

simulated function Destroyed()
{
	local Mutator M;
	local HUD H;

	Log("CH_Render destroyed");

	if ( Level.Game != None ) {
		if ( Level.Game.BaseMutator == Self )
			Level.Game.BaseMutator = NextMutator;
    }
    ForEach AllActors(Class'Engine.HUD', H)
        if ( H.HUDMutator == Self )
            H.HUDMutator = NextHUDMutator;
    ForEach AllActors(Class'Engine.Mutator', M) {
        if ( M.NextMutator == Self )
            M.NextMutator = NextMutator;
        if ( M.NextHUDMutator == Self )
            M.NextHUDMutator = NextHUDMutator;
    }
}
