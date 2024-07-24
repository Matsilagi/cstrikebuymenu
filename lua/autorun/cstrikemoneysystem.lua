if CLIENT then
	-- draw the money hud 
	
	surface.CreateFont( "CStrike_MoneyFont", {
		font		= "HalfLife2",
		size		= 32,
		weight		= 1000,
		extended	= false,
		additive	= true,
	} )
	
	surface.CreateFont( "CStrike_MoneyFont_Glyph", {
		font		= "Verdana",
		size		= 16,
		weight		= 1000,
		extended	= true,
		additive	= false,
	} )
	
	hook.Add( "HUDPaint", "CStrike_MoneyHUD", function()
		local ply = LocalPlayer()
		if IsValid(ply) and ply:Alive() then
			if GAMEMODE_NAME == "zombiesurvival" then
				if ply:Team() == TEAM_HUMAN and ply:GetNW2Int("cstrike_money",0) > 0 and not ENDROUND then
					draw.DrawText( "Money: $", "HUDFontSmallAA", ScrW() * 0.028, ScrH() * 0.875, Color(0, 150, 0, 255), TEXT_ALIGN_CENTER )
					draw.DrawText( tostring(ply:GetNW2Int("cstrike_money",0)), "HUDFontSmallAA", ScrW() * 0.0562, ScrH() * 0.873, Color(0, 150, 0, 255), TEXT_ALIGN_LEFT )
				elseif ply:Team() == TEAM_HUMAN and ply:GetNW2Int("cstrike_money",0) <= 0 and not ENDROUND then
					draw.DrawText( "Money: $", "HUDFontSmallAA", ScrW() * 0.028, ScrH() * 0.875, Color(220, 0, 0, 255), TEXT_ALIGN_CENTER )
					draw.DrawText( tostring(ply:GetNW2Int("cstrike_money",0)), "HUDFontSmallAA", ScrW() * 0.0562, ScrH() * 0.873, Color(220, 0, 0, 255), TEXT_ALIGN_LEFT )
				else
					return
				end
			else
				draw.RoundedBox( 5 , ScrW() * 0.885, ScrH() * 0.82, 180, 50, Color(0, 0, 0, 76) )
				if ply:GetNW2Int("cstrike_money",0) > 0 then
					draw.DrawText( "MONEY", "CStrike_MoneyFont_Glyph", ScrW() * 0.9056, ScrH() * 0.8416, Color( 32, 255, 32, 100 ), TEXT_ALIGN_CENTER )
					draw.DrawText( tostring(ply:GetNW2Int("cstrike_money",0)), "CStrike_MoneyFont", ScrW() * 0.969, ScrH() * 0.83, Color( 32, 255, 32, 128 ), TEXT_ALIGN_RIGHT )
				else
					draw.DrawText( "MONEY", "CStrike_MoneyFont_Glyph", ScrW() * 0.9056, ScrH() * 0.8416, Color( 180, 0, 0, 230 ), TEXT_ALIGN_CENTER )
					draw.DrawText( tostring(ply:GetNW2Int("cstrike_money",0)), "CStrike_MoneyFont", ScrW() * 0.969, ScrH() * 0.83, Color( 180, 0, 0, 230 ), TEXT_ALIGN_RIGHT )
				end
			end
		end
	end)
end

if SERVER then
	CreateConVar( "mp_startmoney", "800" , {FCVAR_REPLICATED,FCVAR_NOTIFY,FCVAR_ARCHIVE} , "Money given at spawn")
	CreateConVar( "mp_npckillreward", "50" , {FCVAR_REPLICATED,FCVAR_NOTIFY,FCVAR_ARCHIVE} , "Money given per killed NPC")
	CreateConVar( "mp_playerkillreward", "300" , {FCVAR_REPLICATED,FCVAR_NOTIFY,FCVAR_ARCHIVE} , "Money given per killed Player")
	CreateConVar( "mp_maxmoney", "16000", {FCVAR_REPLICATED,FCVAR_NOTIFY,FCVAR_ARCHIVE}, "Maximum amount of money a player can have" )

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
		"npc_seagull",
		"npc_antlion_grub",
		"npc_monk",
		"monster_cockroach"
	}

	-- Set money when the player spawns
	hook.Add( "PlayerInitialSpawn", "initialspawnmoneyset", function(ply)
		
		local stmne = GetConVar("mp_startmoney"):GetInt()
		local maxmoney = GetConVar("mp_maxmoney"):GetInt()
		if ply:GetNW2Int("cstrike_money",0) != math.min(stmne,maxmoney) then
			ply:SetNW2Int("cstrike_money",math.min(stmne,maxmoney))
		end
	end)

	hook.Add( "PlayerSpawn", "spawnmoneyset", function(ply)
		
		local stmne = GetConVar("mp_startmoney"):GetInt()
		local maxmoney = GetConVar("mp_maxmoney"):GetInt()
		if ply:GetNW2Int("cstrike_money",0) != math.min(stmne,maxmoney) then
			ply:SetNW2Int("cstrike_money",math.min(stmne,maxmoney))
		end
	end)

	-- Kill points related
	function RewardPlayer(victim, attacker, amount)
		local curmoney = attacker:GetNW2Int("cstrike_money",0)
		local maxmoney = GetConVar("mp_maxmoney"):GetInt()
		local finalreward
		if victim != attacker and attacker:IsPlayer() then 
			finalreward = curmoney + amount
			attacker:SetNW2Int("cstrike_money",math.min(finalreward,maxmoney))
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
end