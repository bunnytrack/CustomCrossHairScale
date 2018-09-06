class CHS_HUD_Notify expands SpawnNotify;

simulated function PreBeginPlay()
{
	if(ROLE < ROLE_Authority)
		//log("CH_Scale::CHS_CHS/HUD_Notify::PreBeginPlay");
	bAlwaysRelevant = True;
}

simulated function PostNetBeginPlay()
{
	local ChallengeHUD PlayerHUD;

	foreach AllActors(Class'ChallengeHUD',PlayerHUD)
		SpawnNotification(PlayerHUD);
}

simulated event Actor SpawnNotification(actor Actor)
{
	local CH_Render tmpHUD;

	//log("CHS/HUD_Notify: SpawnNotification(1)");
	if (Actor != None)
	{
		if (Actor.IsA('HUD') && (HUD(Actor).HUDMutator == None || !HUD(Actor).HUDMutator.IsA('CH_Render')))
		{
			//log("CHS/HUD_Notify: SpawnNotification(2)");
			tmpHUD = spawn(class'CH_Render', Actor);

			if (tmpHUD != None)
			{
				tmpHUD.PlayerOwner = PlayerPawn(Actor.Owner);
				tmpHUD.myHUD = ChallengeHUD(Actor);
				tmpHUD.bHUDMutator = True;

				//log("CHS/HUD_Notify: SpawnNotification(3)");
				if (HUD(Actor).HUDMutator == None)
				{
					//log("CHS/HUD_Notify: SpawnNotification(4)");
					HUD(Actor).HUDMutator = tmpHUD;
				}
				else
				{
					//log("CHS/HUD_Notify: SpawnNotification(5)");
					tmpHUD.NextHUDMutator = HUD(Actor).HUDMutator;
					HUD(Actor).HUDMutator = tmpHUD;
				}
			}
		}
	}

	return Actor;
}

