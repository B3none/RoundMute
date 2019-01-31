#include <sourcemod>
#include <sdktools_voice>

#pragma semicolon 1
#pragma newdecls required

#define MESSAGE_PREFIX "[\x04RoundMute\x01]"

bool b_IsNew[MAXPLAYERS+1];
int RoundCount = 0;

public Plugin myinfo =
{
	name = "Initial Round Mute",
	author = "B3none",
	description = "The player is muted for the initial round of connection.",
	version = "1.0.0",
	url = "https://github.com/b3none"
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
		SetClientListeningFlags(client, VOICE_MUTED);
		if(RoundCount >= 1)
		{
			PrintToChat(client, "%s You have been muted for the first round.", MESSAGE_PREFIX);
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
			SetClientListeningFlags(i, VOICE_NORMAL);
			PrintToChat(i, "%s You have been unmuted, welcome to the server!", MESSAGE_PREFIX);
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
			SetClientListeningFlags(i, VOICE_MUTED);
		}
	}
}

public void OnClientDisconnect(int client)
{
	b_IsNew[client] = true;
}
