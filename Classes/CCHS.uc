class CCHS extends Mutator;

var CHS_Setup list[32];

var bool preInit;
var config bool bOn;
var config float Scale;

function PreBeginPlay()
{
	if(preInit)	
		return;
		
	preInit = True;
	
	if(!bOn)
	{
		Self.Destroy();
		Log(">>CustomCrossHairScale DISABLED");
		return;
	}
	
	Log(">>CustomCrossHairScale started");
	
	Level.Spawn(class'CHS_HUD_Notify');
	Level.Game.RegisterMessageMutator(Self);
}

function ModifyPlayer(Pawn Other)
{
	if ( NextMutator != None )
		NextMutator.ModifyPlayer(Other);
		
	if(!Other.PlayerReplicationInfo.bIsABot && NotInitialized(Other))
		NewPlayer(Other);
	
}

function bool NotInitialized(Pawn p)
{
	local int i;
	
	for(i = 0;i<ArrayCount(list);i++)
	{
		if(list[i] != None && list[i].owner == p)
			return False;
	}
	
	return True;
}

function NewPlayer(Pawn p)
{
	local int i, e;
	local string ipAddress; 
	local PlayerPawn pp; 

	e = -1;
	for(i = 0;i<32;i++)
	{
		if(list[i] == None)
		{
			if(e == -1)
				e = i;
		}
		else if(list[i].owner == p)
			return;
	}
	
	list[e] = Level.Spawn(class'CHS_Setup', p);

	pp = PlayerPawn(p);
	ipAddress = pp.getPlayerNetworkAddress();
	ipAddress = left(ipAddress, instr(ipAddress, ":"));

	Log("New CHS_Setup for "$ p.PlayerReplicationInfo.PlayerName $ " with IP address " $ ipAddress);
}

function Mutate(string MutateString, PlayerPawn Sender)
{
	local int index;
	local float x;
	
	if ( NextMutator != None )
		NextMutator.Mutate(MutateString, Sender);
		
	if(MutateString ~= "dontscale")
	{
		index = FindIndex(Sender);
		if(index != -1)
		{
			Sender.ClientMessage("Normal crosshair drawing now.");
			list[index].DisableScaling();
		}
		else 
			Log("ERROR 1");
	}
	else if(Left(MutateString, 9) ~= "ch_scale ")
	{
		x = Float(Mid(MutateString, 9));
		if(x <= 0)
			Sender.ClientMessage("Invalid scaling of " $ x);
		else
		{
			index = FindIndex(Sender);
			if(index != -1)
			{
				Sender.ClientMessage("Scale your crosshair by " $ x $ " now.");
				list[index].SetScaleClient(x);
			}
			else
				Log("ERROR 2");
		}
	}
}


function int FindIndex(Pawn owner)
{
	local int i;
	
	for(i = 0;i<32;i++)
	{
		if(list[i] != None && list[i].owner == owner)
			return i;
	}
	
	return -1;
}

defaultproperties
{
    bOn=True
    Scale=1.000000
}
