/*
* Code by B3none -> http://steamcommunity.com/profiles/76561198028510846
*/

#include <sourcemod>
#include <sdktools>
#include <basecomm>
#pragma semicolon 1
#pragma newdecls required

#define TAG_MESSAGE "[\x04RoundMute\x01]"

bool b_IsNew[MAXPLAYERS+1];
int RoundCount = 0;

public Plugin myinfo =
{
	name = 			"Round Muting",
	author = 		"B3none",
	description = 	"The player is muted for the initial round of connection.",
	version = 		"0.1",
	url = 			""
};


public void OnPluginStart()
{
	HookEvent("round_end", OnRoundEnd);
	HookEvent("round_start", OnRoundStart);
}

public void OnClientPutInServer(int client) 
{
	b_IsNew[client] = true;
	if(b_IsNew[client])
	{
		BaseComm_SetClientMute(client, true);
		if(RoundCount >= 1)
		{
			PrintToChat(client, "%s You have been muted for the first round.", TAG_MESSAGE);
		}
	}
}

public Action OnRoundEnd(Handle event, const char[] name, bool dontBroadcast)
{
	for(int i = 1; i<=MAXPLAYERS+1; i++)
	{
		if(b_IsNew[i])
		{
			b_IsNew[i] = false;
			BaseComm_SetClientMute(i, false);
			PrintToChat(i, "%s You have been unmuted, welcome to the server!", TAG_MESSAGE);
		}
		
		else
		{
			return Plugin_Handled;
		}
	}
	RoundCount++;
	
	return Plugin_Handled;
} 

public Action OnRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	for(int i = 1; i<=MAXPLAYERS+1; i++)
	{
		if(RoundCount == 0)
		{
			BaseComm_SetClientMute(i, false);
		}
	}
}

public void OnClientDisconnect(int client)
{
	b_IsNew[client] = true;
}
