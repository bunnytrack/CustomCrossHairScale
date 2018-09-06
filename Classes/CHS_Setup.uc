class CHS_Setup extends Info config(CCHS3);

var config bool bOn;
var config float scale;

var PlayerPawn myOwner;

replication {
	reliable if(Role == ROLE_Authority)
		SetInitialScale, SetScaleClient, DisableScaling;
}

function Tick(float DeltaTime)
{
	if(owner == None)
		Destroy();
}

// Run when player joins server to scale xhair unless they disabled it before
simulated function SetInitialScale(float newScale) {
	if (bOn) {
		SetScaleClient(newScale);
	}
}

simulated function SetScaleClient(float newScale)
{
	bOn = True;
	scale = newScale;
	if(ROLE < ROLE_Authority)
		SaveConfig();
}

simulated function DisableScaling()
{
	bOn = False;
	if(ROLE < ROLE_Authority)
		SaveConfig();
}

defaultproperties
{
    bOn=True
    Scale=1.000000
}
