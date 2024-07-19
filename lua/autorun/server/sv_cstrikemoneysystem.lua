CreateConVar( "mp_startmoney", "1000" , {FCVAR_REPLICATED,FCVAR_NOTIFY,FCVAR_ARCHIVE} , "Money given at spawn")
CreateConVar( "mp_npckillreward", "50" , {FCVAR_REPLICATED,FCVAR_NOTIFY,FCVAR_ARCHIVE} , "Money given per killed NPC")
CreateConVar( "mp_playerkillreward", "300" , {FCVAR_REPLICATED,FCVAR_NOTIFY,FCVAR_ARCHIVE} , "Money given per killed Player")

-- NPC Blacklist for point system
NpcBlacklist = {
	"npc_citizen",
	"npc_mossman",
	"npc_eli",
	"npc_alyx",
	"npc_barney",
	"npc_dog",
	"npc_citizen",
	"npc_vortigaunt",
	"npc_kleiner",
	"npc_crow",
	"npc_pigeon",
	"npc_seagull"
}

-- Set money when the player spawns
hook.Add( "PlayerInitialSpawn", "initialspawnmoneyset", function(ply)
	
	local stmne = GetConVar("mp_startmoney"):GetInt()
	if ply:GetNW2Int("cstrike_money",0) != stmne then
		ply:SetNW2Int("cstrike_money",stmne)
	end
end)

hook.Add( "PlayerSpawn", "spawnmoneyset", function(ply)
	
	local stmne = GetConVar("mp_startmoney"):GetInt()
	if ply:GetNW2Int("cstrike_money",0) != stmne then
		ply:SetNW2Int("cstrike_money",stmne)
	end
end)

-- Kill points related
function RewardPlayer(victim, attacker, amount)
	local curmoney = attacker:GetNW2Int("cstrike_money",0)
	local finalreward
	if victim != attacker and attacker:IsPlayer() then 
		finalreward = curmoney + amount
		attacker:SetNW2Int("cstrike_money",finalreward)
	end
end

hook.Add( 'PlayerDeath', 'DeathReward', function( victim, inflictor, attacker )

	local reward = GetConVar( "mp_playerkillreward"):GetInt()
	RewardPlayer(victim, attacker , reward )
	
end)

hook.Add( 'OnNPCKilled', 'KillNPC_Reward', function( victim, inflictor, attacker )
	if not table.HasValue( NpcBlacklist , victim:GetClass() ) then
		local reward = GetConVar( "mp_npckillreward" ):GetInt()
		RewardPlayer(victim,inflictor,reward)
	end
end)