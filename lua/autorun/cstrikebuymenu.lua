
csBuyMenu = {}

local function Ammo_Buy(player, item, class)
	local ammoid = game.GetAmmoID(item.AmmoType)
	local amountwecangive = item.AmmoMaximum - player:GetAmmoCount(ammoid)

	player:GiveAmmo( math.min( amountwecangive, item.AmountToGive ), ammoid )
	
	local Rate = (amountwecangive / item.AmountToGive)
	if Rate < 1 then
		return math.ceil(item.Price * Rate)
	else
		return true -- successful, deduct money
	end
end
local function Ammo_CanBuy(player, item, class)
	local ammoid = game.GetAmmoID(item.AmmoType)
	return (player:GetAmmoCount(ammoid) < item.AmmoMaximum)
end

csBuyMenu.Items = {
	["kevlar"] = {
		NiceName = "Kevlar Vest",
		Icon = Material("entities/swcs_kevlar.png", "mips smooth"),
		Buy = function(player, item, class)
			player:SetArmor(100)
			return true -- successful, deduct money
		end,
		CanBuy = function(player, item, class)
			return (player:Armor() < 100)
		end,
		Price = 650,
		Trivia = {
			{ "Price", ": $650" },
			{ "Protects your torso against projectiles", "" },
		},
	},
	["kev_helm"] = {
		NiceName = "Kevlar Vest + Helmet",
		Icon = Material("entities/swcs_helmet_kevlar.png", "mips smooth"),
		Buy = function(player, item, class)
			local curmoney = player:GetNW2Int("cstrike_money",0)
			if !player:HasHelmet() then
				player:GiveHelmet()
				player:SetArmor(100)
			else
				player:ChatPrint("You already had a helmet, Kevlar replaced.")
				player:SetArmor(100)
				player:SetNW2Int("cstrike_money",curmoney + 350)
			end
			return true -- successful, deduct money
		end,
		CanBuy = function(player, item, class)
			return (player:Armor() < 100)
		end,
		Price = 1000,
		Trivia = {
			{ "Price", ": $1000" },
			{ "Protects your head and torso against projectiles", "" },
		},
	},
	["ammo_bundle"] = {
		NiceName = "Ammunition Bundle",
		Icon = Material("entities/swcs_ammo_generic.png","mips smooth"),
		Buy = function(player, item, class)
			local wep = player:GetActiveWeapon()
			local wepammo = wep:GetPrimaryAmmoType() or nil
			local wepammo2 = wep:GetSecondaryAmmoType() or false
			local maxclip = wep:GetMaxClip1()
			local maxclip2 = wep:GetMaxClip2()
			local mag1 = wep:Clip1()
			local mag2 = wep:Clip2()
			local ammotogive = 0
			local ammotogive2 = 0
			if wepammo != false or wepammo != nil then
				if mag1 >= 0 and maxclip != nil then
					ammotogive = (maxclip*10) - mag1
				elseif mag1 >= 0 and maxclip != nil and wepammo == 9 then
					ammotogive = (maxclip*31) - mag1
				elseif mag1 < 0 and wepammo >= 0 and player:GetAmmoCount(wepammo) >= 0 then
					if player:GetActiveWeapon().Primary == nil then
						ammotogive = 10
					else
						ammotogive = (player:GetActiveWeapon().Primary.DefaultClip * 10)
					end
				else
					ammotogive = 10
				end
				player:SetAmmo(ammotogive, wepammo)
			end
			if wepammo2 != false or wepammo2 != nil then
				if mag2 >= 0 and maxclip2 != nil then
					ammotogive2 = (maxclip2*10) - mag2
				elseif mag2 < 0 and wepammo2 >= 0 and player:GetAmmoCount(wepammo2) >= 0 then
					if player:GetActiveWeapon().Secondary == nil then
						ammotogive2 = 10
					else
						ammotogive2 = (player:GetActiveWeapon().Secondary.DefaultClip * 10)
					end
				else
					ammotogive2 = 10
				end
			
				player:SetAmmo(ammotogive2, wepammo2)
			end
			return true
		end,
		CanBuy = function(player, item, class)
			local weapblacklist = {
				["weapon_swcs_breachcharge"] = true,
				["weapon_dz_bumpmine"] = true,
				["weapon_swcs_healthshot"] = true,
				["weapon_dz_healthshot"] = true,
				["weapon_swcs_tagrenade"] = true,
				["weapon_swcs_taser"] = true,
				["weapon_swcs_smokegrenade"] = true,
				["weapon_swcs_snowball"] = true,
				["weapon_swcs_incgrenade"] = true,
				["weapon_swcs_molotov"] = true,
				["weapon_swcs_hegrenade"] = true,
				["weapon_swcs_flashbang"] = true,
				["weapon_swcs_decoy"] = true,
				["weapon_swcs_c4"] = true,
			}
			
			if player:GetActiveWeapon():GetPrimaryAmmoType() == -1 or weapblacklist[player:GetActiveWeapon():GetClass()] == true then
				return false
			else 
				return true 
			end
		end,
		Price = 800,
		Trivia = {
			{ "Price", ": $800" },
			{ "Fully refills currently held weapon. Doesn't work with Grenades or Equipment.", "" },
		},
	},
	["pist_hkp2000"] = {
		NiceName = "HK P2000",
		Class = "weapon_swcs_hkp2000",
		Trivia = {
			{"Price", ": $200"},
			{"Country of Origin", ": Germany"},
			{"Caliber", ": .357 SIG"},
			{"Mag Capacity", ": 13 Rounds"},
			{"Accurate and controllable, the German-made P2000 is a serviceable first-round pistol that works best against unarmored opponents.", ""},
		},
		Price = 200,
	},
	["pist_glock18"] = {
		NiceName = "Glock 18",
		Class = "weapon_swcs_glock",
		Trivia = {
			{"Price", ": $200"},
			{"Country of Origin", ": Austria"},
			{"Caliber", ": 9x19MM Parabellum"},
			{"Mag Capacity", ": 20 Rounds"},
			{"The Glock 18 is a serviceable first-round pistol that works best against unarmored opponents and is capable of firing three-round bursts.", ""},
		},
		Price = 200,
	},
	["pist_223"] = {
		NiceName = "USP-S",
		Class = "weapon_swcs_usp_silencer",
		Trivia = {
			{"Price", ": $200"},
			{"Country of Origin", ": Germany"},
			{"Caliber", ": .357 SIG"},
			{"Mag Capacity", ": 12 Rounds"},
			{"A fan favorite from Counter-Strike: Source, the Silenced USP Pistol has a detachable silencer that gives shots less recoil while suppressing attention-getting noise.", ""},
		},
		Price = 200,
	},
	["pist_usp"] = {
		NiceName = "K&M .45 Tactical",
		Class = "weapon_swcs_usp",
		Trivia = {
			{"Price", ": $200"},
			{"Country of Origin", ": Germany"},
			{"Caliber", ": .45 ACP"},
			{"Mag Capacity", ": 12 Rounds"},
			{"This decomissioned USP pistol has been re-purposed and maintained for a new round of conflicts. Boasting remade internals, it works just like new.", ""},
		},
		Price = 200,
	},
	["pist_p250"] = {
		NiceName = "P250",
		Class = "weapon_swcs_p250",
		Trivia = {
			{"Price", ": $300"},
			{"Country of Origin", ": Germany"},
			{"Caliber", ": .357 SIG"},
			{"Mag Capacity", ": 13 Rounds"},
			{"A low-recoil firearm with a high rate of fire, the P250 is a relatively inexpensive choice against armored opponents.", ""},
		},
		Price = 300,
	},
	["pist_fiveseven"] = {
		NiceName = "Five-SeveN",
		Class = "weapon_swcs_fiveseven",
		Trivia = {
			{"Price", ": $500"},
			{"Country of Origin", ": Belgium"},
			{"Caliber", ": FN 5.7x28MM"},
			{"Mag Capacity", ": 20 Rounds"},
			{"Highly accurate and armor-piercing, the pricy Five-Seven is a slow-loader that compensates with a generous 20-round magazine and forgiving recoil.", ""},
		},
		Price = 500,
	},
	["pist_tec9"] = {
		NiceName = "Tec-9",
		Class = "weapon_swcs_tec9",
		Trivia = {
			{"Price", ": $500"},
			{"Country of Origin", ": Sweden"},
			{"Caliber", ": 9x19MM Parabellum"},
			{"Mag Capacity", ": 18 Rounds"},
			{"An ideal pistol for the Terrorist on the move, the Tec-9 is lethal in close quarters and features a high magazine capacity.", ""},
		},
		Price = 500,
	},
	["pist_cz75"] = {
		NiceName = "CZ-75",
		Class = "weapon_swcs_cz75",
		Trivia = {
			{"Price", ": $500"},
			{"Country of Origin", ": Czech Republic"},
			{"Caliber", ": .357 SIG"},
			{"Mag Capacity", ": 12 Rounds"},
			{"A fully automatic variant of the CZ75, the CZ75-Auto is another inexpensive choice against armored opponents.\n But with very little ammo provided, strong trigger discipline is required.", ""},
		},
		Price = 500,
	},
	["pist_elite"] = {
		NiceName = "Dual Berettas",
		Class = "weapon_swcs_elite",
		Trivia = {
			{"Price", ": $300"},
			{"Country of Origin", ": Italy"},
			{"Caliber", ": 9x19MM Parabellum"},
			{"Mag Capacity", ": 15 Rounds x 2"},
			{"Firing two large-mag Berettas at once will lower accuracy and increase load times. On the bright side, you'll get to fire two large-mag Berettas at once.", ""},
		},
		Price = 300,
	},
	["pist_deagle"] = {
		NiceName = "Desert Eagle",
		Class = "weapon_swcs_deagle",
		Trivia = {
			{"Price", ": $700"},
			{"Country of Origin", ": United States"},
			{"Caliber", ": .50 Action Express"},
			{"Mag Capacity", ": 7 Rounds"},
			{"As expensive as it is powerful, the Desert Eagle is an iconic pistol that is difficult to master but surprisingly accurate at long range.", ""},
		},
		Price = 700,
	},
	["pist_revolver"] = {
		NiceName = "R8 Revolver",
		Class = "weapon_swcs_revolver",
		Trivia = {
			{"Price", ": $600"},
			{"Country of Origin", ": United States"},
			{"Caliber", ": .50 Action Express"},
			{"Mag Capacity", ": 8 Rounds"},
			{"The R8 Revolver delivers a highly accurate and powerful round at the expense of a lengthy trigger-pull.\nFiring rapidly by fanning the hammer may be the best option when point-blank stopping power is required.", ""},
		},
		Price = 600,
	},
	["pist_ragingbull"] = {
		NiceName = "Raging Bull",
		Class = "weapon_swcs_ragingbull",
		Trivia = {
			{"Price", ": $800"},
			{"Country of Origin", ": Brazil"},
			{"Caliber", ": .454 Casull"},
			{"Mag Capacity", ": 5 Rounds"},
			{"This huge revolver has immense stopping power, coupled with huge recoil.", ""},
		},
		Price = 800,
	},
	["pist_g2"] = {
		NiceName = "G2 Contender",
		Class = "weapon_swcs_g2",
		Trivia = {
			{"Price", ": $900"},
			{"Country of Origin", ": United States"},
			{"Caliber", ": .308 Lapua Magnum"},
			{"Mag Capacity", ": 1 Round"},
			{"A single-shot deadly handheld rifle. Includes a scope for mid-range encounters.", ""},
		},
		Price = 900,
	},
	["pist_m6c"] = {
		NiceName = "M6C Handgun",
		Class = "weapon_swcs_m6c",
		Trivia = {
			{"Price", ": $250"},
			{"Planet of Origin", ": Earth (UNSC)"},
			{"Caliber", ": 12.7x40MM"},
			{"Mag Capacity", ": 12 Rounds"},
			{"Manufactured by Misriah Armory, this pistol, part of the M6 series of Magnum pistols, comes with HP rounds and is meant for enforcement usage.", ""},
		},
		Price = 250,
	},
	["pist_m6g"] = {
		NiceName = "M6G Magnum",
		Class = "weapon_swcs_m6g",
		Trivia = {
			{"Price", ": $850"},
			{"Country of Origin", ": United States"},
			{"Caliber", ": 12.7x40MM"},
			{"Mag Capacity", ": 8 Rounds"},
			{"The M6G Magnum, part of the M6 series of pistols from Misriah Armory, is intended for military-use. With deadly stopping power, range and decent firerate, it is a very deadly pistol.", ""},
		},
		Price = 850,
	},	
	["pist_m6g_c"] = {
		NiceName = "M6G Magnum (Classic)",
		Class = "weapon_swcs_m6g_c",
		Trivia = {
			{"Price", ": $850"},
			{"Planet of Origin", ": Earth (UNSC)"},
			{"Caliber", ": 12.7x40MM"},
			{"Mag Capacity", ": 8 Rounds"},
			{"The M6G Magnum, part of the M6 series of pistols from Misriah Armory, is intended for military-use. With deadly stopping power, range and decent firerate, it is a very deadly pistol.", ""},
		},
		Price = 850,
	},
	["smg_mp9"] = {
		NiceName = "MP9",
		Class = "weapon_swcs_mp9",
		Trivia = {
			{"Price", ": $1250"},
			{"Country of Origin", ": Switzerland"},
			{"Caliber", ": .45 ACP"},
			{"Mag Capacity", ": 30 Rounds"},
			{"Manufactured in Switzerland, the cutting-edge MP9 SMG is an ergonomic polymer weapon favored by private security firms.", ""},
		},	
		Price = 1250,
	},
	["smg_mac10"] = {
		NiceName = "MAC-10",
		Class = "weapon_swcs_mac10",
		Trivia = {
			{"Price", ": $1050"},
			{"Country of Origin", ": United States"},
			{"Caliber", ": .45 ACP"},
			{"Mag Capacity", ": 30 Rounds"},
			{"Essentially a box that bullets come out of, the MAC-10 SMG boasts a high rate of fire, with poor spread accuracy and high recoil as trade-offs.", ""},
		},	
		Price = 1050,
	},
	["smg_bizon"] = {
		NiceName = "PP-Bizon",
		Class = "weapon_swcs_bizon",
		Trivia = {
			{"Price", ": $1400"},
			{"Country of Origin", ": Russia"},
			{"Caliber", ": 9X18MM Makarov"},
			{"Mag Capacity", ": 64 Rounds"},
			{"The Bizon SMG is low-damage, but offers a uniquely designed high-capacity drum magazine that reloads quickly.", ""},
		},	
		Price = 1400,		
	},
	["smg_mp7"] = {
		NiceName = "MP7",
		Class = "weapon_swcs_mp7",
		Trivia = {
			{"Price", ": $1500"},
			{"Country of Origin", ": Germany"},
			{"Caliber", ": 9x19MM Parabellum"},
			{"Mag Capacity", ": 30 Rounds"},
			{"Versatile but expensive, the German-made MP7 SMG is the perfect choice for high-impact close-range combat.", ""},
		},	
		Price = 1500,
	},
	["smg_mp5sd"] = {
		NiceName = "MP5-SD",
		Class = "weapon_swcs_mp5sd",
		Trivia = {
			{"Price", ": $1500"},
			{"Country of Origin", ": Germany"},
			{"Caliber", ": 9x19MM Parabellum"},
			{"Mag Capacity", ": 30 Rounds"},
			{"Often imitated but never equaled, the iconic MP5 is perhaps the most versatile and popular SMG in the world. This SD variant comes equipped with an integrated silencer, making an already formidable weapon whisper-quiet.", ""},
		},	
		Price = 1500,		
	},
	["smg_ump45"] = {
		NiceName = "UMP-45",
		Class = "weapon_swcs_ump45",
		Trivia = {
			{"Price", ": $1200"},
			{"Country of Origin", ": Germany"},
			{"Caliber", ": .45 ACP"},
			{"Mag Capacity", ": 25 Rounds"},
			{"The misunderstood middle child of the SMG family, the UMP45's small magazine is the only drawback to an otherwise versatile close-quarters automatic.", ""},
		},
		Price = 1200,
	},
	["smg_p90"] = {
		NiceName = "P90",
		Class = "weapon_swcs_p90",
		Trivia = {
			{"Price", ": $2350"},
			{"Country of Origin", ": Belgium"},
			{"Caliber", ": 5.7x28MM"},
			{"Mag Capacity", ": 50 Rounds"},
			{"Easily recognizable for its unique bullpup design, the P90 is a great weapon to shoot on the move due to its high-capacity magazine and low recoil.", ""},
		},
		Price = 2350,	
	},
	["smg_mp5"] = {
		NiceName = "MP5",
		Class = "weapon_swcs_mp5",
		Trivia = {
			{"Price", ": $1450"},
			{"Country of Origin", ": Germany"},
			{"Caliber", ": 9x19MM Parabellum"},
			{"Mag Capacity", ": 30 Rounds"},
			{"A timeless SMG, the MP5 is a high versatile and highly accurate Sub-Machinegun. Showing the true power of German engineering,\nthis weapon shows it still has a lot going for it.", ""},
		},	
		Price = 1450,			
	},
	["smg_c90"] = {
		NiceName = "ES C90",
		Class = "weapon_swcs_c90",
		Trivia = {
			{"Price", ": $2350"},
			{"Country of Origin", ": Belgium"},
			{"Caliber", ": 5.7x28MM"},
			{"Mag Capacity", ": 50 Rounds"},
			{"Easily recognizable for its unique bullpup design, the C90 is a great weapon to shoot on the move due to its high-capacity magazine and low recoil.", ""},
		},
		Price = 2350,	
	},
	["smg_tmp"] = {
		NiceName = "Schmidt TMP",
		Class = "weapon_swcs_tmp",
		Trivia = {
			{"Price", ": $1150"},
			{"Country of Origin", ": Switzerland"},
			{"Caliber", ": .45 ACP"},
			{"Mag Capacity", ": 30 Rounds"},
			{"Very similar to the MP9, the Schmidt TMP is a highly-versatile and portable sub-machinegun. With an attached silencer, this version is intended for surprise conflicts.", ""},
		},	
		Price = 1150,
	},
	["smg_m7"] = {
		NiceName = "M7 SMG",
		Class = "weapon_swcs_m7",
		Trivia = {
			{"Price", ": $1550"},
			{"Planet of Origin", ": Earth (UNSC)"},
			{"Caliber", ": 5×23MM Caseless FMJ"},
			{"Mag Capacity", ": 60 Rounds"},
			{"With a compact design, a large magazine and fast firerate, this small SMG is perfect for mowing down hordes of small targets.", ""},
		},	
		Price = 1550,
	},
	["rifle_famas"] = {
		NiceName = "FAMAS",
		Class = "weapon_swcs_famas",
		Trivia = {
			{"Price", ": $2050"},
			{"Country of Origin", ": France"},
			{"Caliber", ": 5.56MM"},
			{"Mag Capacity", ": 25 Rounds"},
			{"A cheap option for cash-strapped players, the FAMAS effectively fills the niche between more expensive rifles and the less-effective SMGs.", ""},
		},	
		Price = 2050,
	},
	["rifle_galilar"] = {
		NiceName = "Galil AR",
		Class = "weapon_swcs_galilar",
		Trivia = {
			{"Price", ": $1800"},
			{"Country of Origin", ": Israel"},
			{"Caliber", ": 5.56MM"},
			{"Mag Capacity", ": 35 Rounds"},
			{"A less expensive option among the terrorist-exclusive assault rifles, the Galil AR is a serviceable weapon in medium to long-range combat.", ""},
		},	
		Price = 1800,		
	},
	["rifle_m4a4"] = {
		NiceName = "M4A4",
		Class = "weapon_swcs_m4a1",
		Trivia = {
			{"Price", ": $3000"},
			{"Country of Origin", ": United States"},
			{"Caliber", ": 5.56MM"},
			{"Mag Capacity", ": 30 Rounds"},
			{"More accurate but less damaging than its AK-47 counterpart, the M4A4 is the full-auto assault rifle of choice for CTs.", ""},
		},	
		Price = 3000,				
	},
	["rifle_m4a1s"] = {
		NiceName = "M4A1-S",
		Class = "weapon_swcs_m4a1_silencer",
		Trivia = {
			{"Price", ": $2900"},
			{"Country of Origin", ": United States"},
			{"Caliber", ": 5.56MM"},
			{"Mag Capacity", ": 20 Rounds"},
			{"With a smaller magazine than its unmuffled counterpart, the silenced M4A1 provides quieter shots with less recoil and better accuracy.", ""},
		},
		Price = 2900
	},
	["rifle_ak47"] = {
		NiceName = "AK-47",
		Class = "weapon_swcs_ak47",
		Trivia = {
			{"Price", ": $2700"},
			{"Country of Origin", ": Russia"},
			{"Caliber", ": 7.62MM"},
			{"Mag Capacity", ": 30 Rounds"},
			{"Powerful and reliable, the AK-47 is one of the most popular assault rifles in the world. It is most deadly in short, controlled bursts of fire.", ""},
		},
		Price = 2700	
	},
	["rifle_aug"] = {
		NiceName = "AUG",
		Class = "weapon_swcs_aug",
		Trivia = {
			{"Price", ": $3300"},
			{"Country of Origin", ": Austria"},
			{"Caliber", ": 5.56MM"},
			{"Mag Capacity", ": 30 Rounds"},
			{"Powerful and accurate, the AUG scoped assault rifle compensates for its long reload times with low spread and a high rate of fire.", ""},
		},
		Price = 3300		
	},
	["rifle_sg553"] = {
		NiceName = "SG-553",
		Class = "weapon_swcs_sg556",
		Trivia = {
			{"Price", ": $3000"},
			{"Country of Origin", ": Swiss"},
			{"Caliber", ": 5.56MM"},
			{"Mag Capacity", ": 30 Rounds"},
			{"The terrorist-exclusive SG 553 is a premium scoped alternative to the AK-47 for effective long-range engagement.", ""},
		},
		Price = 3000		
	},
	["snip_ssg08"] = {
		NiceName = "SSG-08",
		Class = "weapon_swcs_ssg08",
		Trivia = {
			{"Price", ": $1700"},
			{"Country of Origin", ": Germany"},
			{"Caliber", ": 7.62MM"},
			{"Mag Capacity", ": 10 Rounds"},
			{"The SSG 08 bolt-action is a low-damage but very cost-effective sniper rifle, making it a smart choice for early-round long-range marksmanship.", ""},
		},
		Price = 1700				
	},
	["snip_awp"] = {
		NiceName = "AWP",
		Class = "weapon_swcs_awp",
		Trivia = {
			{"Price", ": $4750"},
			{"Country of Origin", ": United Kingdom"},
			{"Caliber", ": .338 Lapua Magnum"},
			{"Mag Capacity", ": 5 Rounds"},
			{"High risk and high reward, the infamous AWP is recognizable by its signature report and one-shot, one-kill policy.", ""},
		},
		Price = 4750				
	},
	["snip_scar20"] = {
		NiceName = "SCAR-20",
		Class = "weapon_swcs_scar20",
		Trivia = {
			{"Price", ": $5000"},
			{"Country of Origin", ": Belgium"},
			{"Caliber", ": 7.62MM"},
			{"Mag Capacity", ": 20 Rounds"},
			{"The SCAR-20 is a semi-automatic sniper rifle that trades a high rate of fire and powerful long-distance damage for sluggish movement speed and big price tag.", ""},
		},
		Price = 5000			
	},
	["snip_g3sg1"] = {
		NiceName = "G3SG1",
		Class = "weapon_swcs_g3sg1",
		Trivia = {
			{"Price", ": $5000"},
			{"Country of Origin", ": Germany"},
			{"Caliber", ": 7.62MM"},
			{"Mag Capacity", ": 20 Rounds"},
			{"The pricy G3SG1 lowers movement speed considerably but compensates with a higher rate of fire than other sniper rifles.", ""},
		},
		Price = 5000		
	},
	["rifle_galil"] = {
		NiceName = "IDF Defender",
		Class = "weapon_swcs_galil",
		Trivia = {
			{"Price", ": $2000"},
			{"Country of Origin", ": Israel"},
			{"Caliber", ": 7.62MM"},
			{"Mag Capacity", ": 35 Rounds"},
			{"An older revision of the Galil rifle, this one has been repaired, with its wooden parts replaced with steel and polymer, and internals refurbished.", ""},
		},
		Price = 2000			
	},
	["rifle_galilar_scope"] = {
		NiceName = "IDF Sentinel 22",
		Class = "weapon_swcs_galilar_scope",
		Trivia = {
			{"Price", ": $2100"},
			{"Country of Origin", ": Israel"},
			{"Caliber", ": 5.56MM"},
			{"Mag Capacity", ": 35 Rounds"},
			{"A less expensive option among the terrorist-exclusive assault rifles, the Galil AR is a serviceable weapon in medium to long-range combat. This one has a scope for extra-accuracy.", ""},
		},	
		Price = 2100,		
	},
	["rifle_scar17"] = {
		NiceName = "Scarab Carbine 17",
		Class = "weapon_swcs_scar17",
		Trivia = {
			{"Price", ": $3100"},
			{"Country of Origin", ": United States"},
			{"Caliber", ": 5.56MM"},
			{"Mag Capacity", ": 30 Rounds"},
			{"A more powerful alternative to the CT M4s, the SCAR-17 is the midweight counterpart to the SCAR-20. It provides good precision and stopping power at the cost of recoil.", ""},
		},	
		Price = 3100,			
	},
	["snip_scout"] = {
		NiceName = "Schmidt Scout",
		Class = "weapon_swcs_scout",
		Trivia = {
			{"Price", ": $1750"},
			{"Country of Origin", ": Germany"},
			{"Caliber", ": 7.62MM"},
			{"Mag Capacity", ": 10 Rounds"},
			{"The Scout is the older brother of the SSG-08. Boasting the same features as its newer counterpart, this one is here for those who miss the old-times!", ""},
		},
		Price = 1750		
	},
	["rifle_ma37"] = {
		NiceName = "MA37 ICWS",
		Class = "weapon_swcs_ma37",
		Trivia = {
			{"Price", ": $3350"},
			{"Planet of Origin", ": Earth (UNSC)"},
			{"Caliber", ": 7.62x51MM"},
			{"Mag Capacity", ": 32 Rounds"},
			{"The UNSC weapon of choice, the MA-37 is a weapon familiar in battles across the entire galaxy. It comes with a handy ammo-counter HUD and compass to help sole-soldiers.", ""},
		},
		Price = 3350
	},
	["rifle_ma37_c"] = {
		NiceName = "MA37 ICWS (Classic)",
		Class = "weapon_swcs_ma37_c",
		Trivia = {
			{"Price", ": $3350"},
			{"Planet of Origin", ": Earth (UNSC)"},
			{"Caliber", ": 7.62x51MM"},
			{"Mag Capacity", ": 32 Rounds"},
			{"The UNSC weapon of choice, the MA-37 is a weapon familiar in battles across the entire galaxy. It comes with a handy ammo-counter HUD and compass to help sole-soldiers.", ""},
		},
		Price = 3350
	},
	["snip_m392"] = {
		NiceName = "M392 DMR",
		Class = "weapon_swcs_dmr",
		Trivia = {
			{"Price", ": $5500"},
			{"Planet of Origin", ": Earth (UNSC)"},
			{"Caliber", ": 7.62x51MM"},
			{"Mag Capacity", ": 15 Rounds"},
			{"A solid choice for mobile Marksman units, the M392 is another staple in the UNSC units against foreign threats.", ""},
		},
		Price = 5500
	},
	["snip_carbine"] = {
		NiceName = "Covenant Carbine",
		Class = "weapon_swcs_carbine",
		Trivia = {
			{"Price", ": $4250"},
			{"Planet of Origin", ": Sangheilios (Covenant)"},
			{"Caliber", ": 8×60MM Caseless Radioactive"},
			{"Mag Capacity", ": 18 Rounds"},
			{"Manufactured by Iruiru Armory, this deadly rifle is capable of marksman use thanks to its unconventional caseless radioactive ammo. Using energy instead of propulsions for travel.", ""},
		},
		Price = 4250
	},
	["snip_srs99"] = {
		NiceName = "SRS99",
		Class = "weapon_swcs_srs99",
		Trivia = {
			{"Price", ": $6000"},
			{"Planet of Origin", ": Earth (UNSC)"},
			{"Caliber", ": 14.5×114MM"},
			{"Mag Capacity", ": 4 Rounds"},
			{"Manufactured by Misriah Armory, this deadly rifle is heavy as it is powerful. Used when you need big targets or small vehicles to stop, this rifle is sure to make some damage wherever it hits.", ""},
		},
		Price = 6000
	},
	["snip_srs99_c"] = {
		NiceName = "SRS99 (Classic)",
		Class = "weapon_swcs_srs99_c",
		Trivia = {
			{"Price", ": $6000"},
			{"Planet of Origin", ": Earth (UNSC)"},
			{"Caliber", ": 14.5×114MM"},
			{"Mag Capacity", ": 4 Rounds"},
			{"Manufactured by Misriah Armory, this deadly rifle is heavy as it is powerful. Used when you need big targets or small vehicles to stop, this rifle is sure to make some damage wherever it hits.", ""},
		},
		Price = 6000
	},
	["rifle_gry"] = {
		NiceName = "SAI GRY AR-15",
		Class = "weapon_swcs_gry",
		Trivia = {
			{"Price", ": $3200"},
			{"Country of Origin", ": United States"},
			{"Caliber", ": 5.56MM"},
			{"Mag Capacity", ": 45 Rounds"},
			{"A modified AR-15, similar to its other counterparts, its reliable and fast, even more so now with additional mechanism and barrel modifications.", ""},
		},	
		Price = 3200,
	},
	["rifle_asval"] = {
		NiceName = "AS-VAL",
		Class = "weapon_swcs_asval",
		Trivia = {
			{"Price", ": $3000"},
			{"Country of Origin", ": Russia"},
			{"Caliber", ": 7.62MM"},
			{"Mag Capacity", ": 30 Rounds"},
			{"A smaller and nimble version of the AS platform, the VAL comes equiped with a built-in silencer for covert operations.", ""},
		},	
		Price = 3000,
	},
	["shot_nova"] = {
		NiceName = "Nova",
		Class = "weapon_swcs_nova",
		Trivia = {
			{"Price", ": $1050"},
			{"Country of Origin", ": Italy"},
			{"Caliber", ": 12 Gauge Cartridge"},
			{"Tube Capacity", ": 8 Rounds"},
			{"The Nova's rock-bottom price tag makes it a great ambush weapon for a cash-strapped team.", ""},
		},	
		Price = 1050,		
	},
	["shot_mag7"] = {
		NiceName = "MAG-7",
		Class = "weapon_swcs_mag7",
		Trivia = {
			{"Price", ": $1300"},
			{"Country of Origin", ": South Africa"},
			{"Caliber", ": 12 Gauge Cartridge"},
			{"Mag Capacity", ": 5 Rounds"},
			{"The CT-exclusive Mag-7 delivers a devastating amount of damage at close range. Its rapid magazine-style reloads make it a great tactical choice.", ""},
		},	
		Price = 2000,		
	},
	["shot_sawedoff"] = {
		NiceName = "Sawed-Off",
		Class = "weapon_swcs_sawedoff",
		Trivia = {
			{"Price", ": $1100"},
			{"Country of Origin", ": United States"},
			{"Caliber", ": 12 Gauge Cartridge"},
			{"Tube Capacity", ": 7 Rounds"},
			{"The classic Sawed-Off deals very heavy close-range damage, but with its low accuracy, high spread and slow rate of fire, you'd better kill what you hit.", ""},
		},	
		Price = 1100,	
	},
	["mach_m249"] = {
		NiceName = "M249",
		Class = "weapon_swcs_m249",
		Trivia = {
			{"Price", ": $5200"},
			{"Country of Origin", ": Belgium"},
			{"Caliber", ": 5.56MM"},
			{"Box Capacity", ": 100 Rounds"},
			{"A strong open-area LMG, the M249 is the perfect choice for players willing to trade a slow fire rate for increased accuracy and a high ammo capacity.", ""},
		},	
		Price = 5200,			
	},
	["mach_negev"] = {
		NiceName = "Negev",
		Class = "weapon_swcs_negev",
		Trivia = {
			{"Price", ": $1700"},
			{"Country of Origin", ": Israel"},
			{"Caliber", ": 5.56MM"},
			{"Box Capacity", ": 150 Rounds"},
			{"The Negev is a beast that can keep the enemy at bay with its pin-point supressive fire, provided you have the luxury of time to gain control over it.", ""},
		},	
		Price = 1700,	
	},
	["shot_aa12"] = {
		NiceName = "AA-12",
		Class = "weapon_swcs_aa12",
		Trivia = {
			{"Price", ": $3000"},
			{"Country of Origin", ": United States"},
			{"Caliber", ": 12 Gauge Cartridge"},
			{"Mag Capacity", ": 20 Rounds"},
			{"The AA-12 is a fast-firing and low-recoil shotgun. With 20 rounds, one mag is enough to clear any room.", ""},
		},	
		Price = 3000,		
	},
	["shot_winchester"] = {
		NiceName = "Winchester 1887",
		Class = "weapon_swcs_winchester",
		Trivia = {
			{"Price", ": $1200"},
			{"Country of Origin", ": United States"},
			{"Caliber", ": 12 Gauge Cartridge"},
			{"Tube Capacity", ": 6 Rounds"},
			{"A Sawn-Off lever-action 12 gauge shotgun. Accurate on close range and light to use.", ""},
		},	
		Price = 1200,		
	},
	["shot_m3"] = {
		NiceName = "Leone M3 Shotgun",
		Class = "weapon_swcs_m3",
		Trivia = {
			{"Price", ": $1000"},
			{"Country of Origin", ": Italy"},
			{"Caliber", ": 12 Gauge Cartridge"},
			{"Tube Capacity", ": 8 Rounds"},
			{"The older variation of the Nova shotgun, the M3 is as good as the newer version, with a slightly smaller pricetag.", ""},
		},	
		Price = 1200,
	},
	["shot_m45"] = {
		NiceName = "M45 Shotgun",
		Class = "weapon_swcs_m45",
		Trivia = {
			{"Price", ": $2500"},
			{"Planet of Origin", ": Earth (UNSC)"},
			{"Caliber", ": 12 Gauge Cartridge"},
			{"Tube Capacity", ": 6 Shells"},
			{"The M45 Shotgun is a versatile short-range, room-cleaning weapon.", ""},
		},	
		Price = 2500,		
	},
	["heavy_m41"] = {
		NiceName = "M41 SPNKR",
		Class = "weapon_swcs_spnkr",
		Trivia = {
			{"Price", ": $8000"},
			{"Planet of Origin", ": Earth (UNSC)"},
			{"Caliber", ": Rocket-Propelled Grenades"},
			{"Battery Capacity", ": 2 Rockets"},
			{"When something really big needs to be taken down, the M41 SPNKR takes care of the job. A rotating 2-battery shoulder-mounted rocket launcher, it is useful for taking down any sort of vehicle, on air or ground.", ""},
		},	
		Price = 8000,		
	},
	["equip_incgrenade"] = {
		NiceName = "Incendiary Grenade",
		Class = "weapon_swcs_incgrenade",
		Trivia = {
			{"Price", ": $500"},
			{"Country of Origin", ": United States"},
			{"When thrown, the incendiary grenade releases a high-temperature chemical reaction capable of burning anyone within its wide blast radius.", ""},
		},	
		Price = 500,			
	},
	["equip_hegrenade"] = {
		NiceName = "HE Grenade",
		Class = "weapon_swcs_hegrenade",
		Trivia = {
			{"Price", ": $300"},
			{"Country of Origin", ": United States"},
			{"The high explosive fragmentation grenade administers high damage through a wide area, making it ideal for clearing out hostile rooms.", ""},
		},
		Price = 300,
	},
	["equip_flashbang"] = {
		NiceName = "Flashbang",
		Class = "weapon_swcs_flashbang",
		Trivia = {
			{"Price", ": $200"},
			{"Country of Origin", ": United States"},
			{"The non-lethal flashbang grenade temporarily blinds anybody within its concussive blast, making it perfect for flushing out closed-in areas. Its loud explosion also temporarily masks the sound of footsteps.", ""},
		},
		Price = 300,		
	},
	["equip_smokegrenade"] = {
		NiceName = "Smoke Grenade",
		Class = "weapon_swcs_smokegrenade",
		Trivia = {
			{"Price", ": $300"},
			{"Country of Origin", ": United States"},
			{"The smoke grenade creates a medium-area smoke screen. It can effectively hide your team from snipers, or even just create a useful distraction.", ""},
		},
		Price = 300,			
	},
	["equip_decoy"] = {
		NiceName = "Decoy Grenade",
		Class = "weapon_swcs_decoy",
		Trivia = {
			{"Price", ": $50"},
			{"Country of Origin", ": United States"},
			{"When thrown, the decoy grenade emulates the sound of the most powerful weapon you are carrying, creating the illusion of additional supporting forces.", ""},
		},
		Price = 50,		
	},
	["equip_molotov"] = {
		NiceName = "Molotov Cocktail",
		Class = "weapon_swcs_molotov",
		Trivia = {
			{"Price", ": $400"},
			{"Country of Origin", ": ???"},
			{"The Molotov is a powerful and unpredictable area denial weapon that bursts into flames when thrown on the ground, injuring any player in its radius.", ""},
		},	
		Price = 400,	
	},
	["equip_taser"] = {
		NiceName = "Zeus x27",
		Class = "weapon_swcs_taser",
		Trivia = {
			{"Price", ": $200"},
			{"Country of Origin", ": ???"},
			{"Perfect for close-range ambushes and enclosed area encounters, the single-shot x27 Zeus is capable of incapacitating an enemy in a single hit.", ""},
		},	
		Price = 200,		
	},
	["equip_tagrenade"] = {
		NiceName = "Tactical Awareness Grenade",
		Class = "weapon_swcs_tagrenade",
		Trivia = {
			{"Price", ": $100"},
			{"Country of Origin", ": United States"},
			{"The Tactical Awareness Grenade uses Sonar technology to map the surfaces it hits based on sound. When exploded, any nearby targets gets marked on the player's view.", ""},
		},
		Price = 100,
	},
	["equip_breach"] = {
		NiceName = "Breach Charge",
		Class = "weapon_swcs_breachcharge",
		Trivia = {
			{"Price", ": $650"},
			{"Country of Origin", ": United States"},
			{"A remotely-detonated package of explosives. With a smaller payload than the C4, those can be useful to protect entrances, open doors or even liquify small targets.", ""},
		},
		Price = 650,	
	},
	["equip_bumpmine"] = {
		NiceName = "Bump Mine",
		Class = "weapon_dz_bumpmine",
		Trivia = {
			{"Price", ": $300"},
			{"Country of Origin", ": ???"},
			{"An experimental ground-explosive. Using energy and springs, along with the ground itself, it impulses whoever steps on it on the direction the mine was planted at high speed and strength.", ""},
		},
		Price = 300,		
	},
	["equip_medishot"] = {
		NiceName = "Medi-Shot",
		Class = "weapon_swcs_healthshot",
		Trivia = {
			{"Price", ": $400"},
			{"Country of Origin", ": ???"},
			{"A vial containing Adrenaline and other healing chemicals with fast-acting effects. Injection takes effect shortly after use.", ""},
		},
		Price = 400,
	},
	["equip_dz_medishot"] = {
		NiceName = "Medi-Shot (DangerZone)",
		Class = "weapon_dz_healthshot",
		Trivia = {
			{"Price", ": $400"},
			{"Country of Origin", ": ???"},
			{"A vial containing Adrenaline and other healing chemicals with fast-acting effects. Injection takes effect shortly after use.", ""},
		},
		Price = 400,
	},
	["equip_balshield"] = {
		NiceName = "Ballistic Shield",
		Class = "weapon_swcs_balshield",
		Trivia = {
			{"Price", ": $1100"},
			{"Country of Origin", ": ???"},
			{"A protection device designed to deflect or absorb ballistic damage and help protect the carrier from an array of projectile calibers.", ""},
		},
		Price = 1100,		
	},
	["equip_riotshield"] = {
		NiceName = "Riot Shield",
		Class = "weapon_swcs_shield",
		Trivia = {
			{"Price", ": $1100"},
			{"Country of Origin", ": ???"},
			{"A protection device designed to deflect or absorb ballistic damage and help protect the carrier from an array of projectile calibers.", ""},
		},
		Price = 1100,		
	},
	["equip_c4"] = {
		NiceName = "C4 Explosive",
		Class = "weapon_swcs_c4",
		Trivia = {
			{"Price", ": $500"},
			{"Country of Origin", ": ???"},
			{"A homemade time-detonated payload of explosives. Upon activation, it will detonate after 30 seconds, unless defused.", ""},
		},
		Price = 500,			
	},
	["equip_defuse"] = {
		NiceName = "Defusal Kit",
		Icon = Material("entities/swcs_defuser.png", "mips smooth"),
		Buy = function(player, item, class)
			player:GiveDefuser()
			return true -- successful, deduct money
		end,
		CanBuy = function(player, item, class)
			return not player:HasDefuser()
		end,
		Price = 400,
		Trivia = {
			{ "Price", ": $400" },
			{ "A kit with a few defusal tools. Includes a code-cracker and a few common workshop tools which help with all sorts of explosive devices.", "" },
		},
	},
	["misc_snowball"] = {
		NiceName = "Snowball",
		Class = "weapon_swcs_snowball",
		Trivia = {
			{"Price", ": $25"},
			{"Country of Origin", ": ???"},
			{"A harmless snowball. Made of water, in cold weather. Spread the jolly spirit around!", ""},
		},
		Price = 25,			
	},
	["tool_axe"] = {
		NiceName = "Axe",
		Class = "weapon_swcs_axe",
		Trivia = {
			{"Price", ": $250"},
			{"Country of Origin", ": ???"},
			{"A common hatchet. Can be thrown for heavy physical damage.", ""},
		},
		Price = 250,			
	},
	["tool_hammer"] = {
		NiceName = "Hammer",
		Class = "weapon_swcs_hammer",
		Trivia = {
			{"Price", ": $250"},
			{"Country of Origin", ": ???"},
			{"A common hammer. Can be thrown for heavy physical damage.", ""},
		},
		Price = 250,			
	},
	["tool_spanner"] = {
		NiceName = "Spanner",
		Class = "weapon_swcs_spanner",
		Trivia = {
			{"Price", ": $250"},
			{"Country of Origin", ": ???"},
			{"A common spanner. Can be thrown for heavy physical damage.", ""},
		},
		Price = 250,			
	},
	["knife_ct"] = {
		NiceName = "Knife (CT)",
		Class = "weapon_swcs_knife_ct",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_t"] = {
		NiceName = "Knife (T)",
		Class = "weapon_swcs_knife_t",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_butfly"] = {
		NiceName = "Butterfly Knife",
		Class = "weapon_swcs_knife_butterfly",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_canis"] = {
		NiceName = "Survival Knife",
		Class = "weapon_swcs_knife_canis",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_canis"] = {
		NiceName = "Survival Knife",
		Class = "weapon_swcs_knife_canis",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_cord"] = {
		NiceName = "Paracord Knife",
		Class = "weapon_swcs_knife_cord",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_falchion"] = {
		NiceName = "Falchion Knife",
		Class = "weapon_swcs_knife_falchion",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_gg"] = {
		NiceName = "Golden Knife",
		Class = "weapon_swcs_knife_gg",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_ghost"] = {
		NiceName = "Spectral Shiv",
		Class = "weapon_swcs_knife_ghost",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_gypsy_jackknife"] = {
		NiceName = "Navaja Knife",
		Class = "weapon_swcs_knife_gypsy_jackknife",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_kukri"] = {
		NiceName = "Kukri Knife",
		Class = "weapon_swcs_knife_kukri",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_outdoor"] = {
		NiceName = "Nomad Knife",
		Class = "weapon_swcs_knife_outdoor",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_push"] = {
		NiceName = "Shadow Daggers",
		Class = "weapon_swcs_knife_push",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_skeleton"] = {
		NiceName = "Skeleton Knife",
		Class = "weapon_swcs_knife_skeleton",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_stiletto"] = {
		NiceName = "Stiletto Knife",
		Class = "weapon_swcs_knife_stiletto",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_survival_bowie"] = {
		NiceName = "Bowie Knife",
		Class = "weapon_swcs_knife_survival_bowie",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_ursus"] = {
		NiceName = "Ursus Knife",
		Class = "weapon_swcs_knife_ursus",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_widowmaker"] = {
		NiceName = "Talon Knife",
		Class = "weapon_swcs_knife_widowmaker",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_bayonet"] = {
		NiceName = "Bayonet",
		Class = "weapon_swcs_bayonet",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_classic"] = {
		NiceName = "Classic Knife",
		Class = "weapon_swcs_knife_css",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_flip"] = {
		NiceName = "Flip Knife",
		Class = "weapon_swcs_knife_flip",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_gut"] = {
		NiceName = "Gut Knife",
		Class = "weapon_swcs_knife_gut",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_karambit"] = {
		NiceName = "Karambit Knife",
		Class = "weapon_swcs_knife_karambit",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_m9_bayonet"] = {
		NiceName = "M9 Bayonet",
		Class = "weapon_swcs_knife_m9_bayonet",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_tactical"] = {
		NiceName = "Huntsman Knife",
		Class = "weapon_swcs_knife_tactical",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,
	},
	["knife_reach"] = {
		NiceName = "Reach Knife",
		Class = "weapon_swcs_knife_halo",
		Trivia = {
			{"Price", ": $100"},
		},
		Price = 100,		
	},
	["knife_ensword"] = {
		NiceName = "Energy Sword",
		Class = "weapon_swcs_sword",
		Trivia = {
			{"Price", ": $350"},
		},
		Price = 350,		
	},
}

local QuickAmmo = {
	["BULLET_PLAYER_9MM"] = {
		SortOrder = -1,
		Name = "9MM AMMO",
		Price = 30,
		Amount = 30,
		Max = 150,
	},
	["BULLET_PLAYER_357SIG"] = {
		SortOrder = -1.1,
		Name = ".357 SIG SAUER AMMO",
		Price = 30,
		Amount = 15,
		Max = 150,
	},
	["BULLET_PLAYER_357SIG_SMALL"] = {
		SortOrder = -1.2,
		Name = ".357 SIG SAUER AMMO (USP-S)",
		Price = 30,
		Amount = 15,
		Max = 150,
	},
	["BULLET_PLAYER_357SIG_P250"] = {
		SortOrder = -1.3,
		Name = ".357 SIG SAUER AMMO (P250)",
		Price = 30,
		Amount = 20,
		Max = 150,
	},
	["BULLET_PLAYER_357SIG"] = {
		SortOrder = -1.4,
		Name = ".357 SIG SAUER AMMO (CZ-75)",
		Price = 30,
		Amount = 12,
		Max = 48,
	},
	["BULLET_PLAYER_57MM"] = {
		SortOrder = -1.5,
		Name = "5.7MM AMMO",
		Price = 30,
		Amount = 7,
		Max = 35,
	},
	["BULLET_PLAYER_50AE"] = {
		SortOrder = -1.6,
		Name = ".50AE AMMO",
		Price = 40,
		Amount = 8,
		Max = 60,
	},
	["BULLET_PLAYER_45ACP"] = {
		SortOrder = -1.7,
		Name = ".45 ACP AMMO",
		Price = 50,
		Amount = 12,
		Max = 120,
	},
	["BULLET_PLAYER_BUCKSHOT"] = {
		SortOrder = -2,
		Name = "12 GAUGE BUCKSHOT AMMO",
		Price = 60,
		Amount = 20,
		Max = 80,
	},
	["BULLET_PLAYER_762MM"] = {
		SortOrder = -3,
		Name = "7.62MM AMMO",
		Price = 60,
		Amount = 30,
		Max = 180,
	},
	["BULLET_PLAYER_556MM"] = {
		SortOrder = -3.1,
		Name = "5.56MM AMMO",
		Price = 60,
		Amount = 30,
		Max = 210,
	},
	["BULLET_PLAYER_556MM_SMALL"] = {
		SortOrder = -3.2,
		Name = "5.56 AMMO (M4A1-S)",
		Price = 60,
		Amount = 30,
		Max = 210,
	},
	["BULLET_PLAYER_556MM_BOX"] = {
		SortOrder = -3.3,
		Name = "5.56MM AMMO BOX",
		Price = 80,
		Amount = 100,
		Max = 300,
	},
	["BULLET_PLAYER_338MAG"] = {
		SortOrder = -4,
		Name = ".338 LAPUA MAGNUM AMMO",
		Price = 100,
		Amount = 5,
		Max = 30,
	},
	["rpg_round"] = {
		SortOrder = -4.1,
		Name = "RPG ROUNDS",
		Price = 150,
		Amount = 1,
		Max = 6,
	},
}

for AmmoName, AmmoData in pairs( QuickAmmo ) do
	math.Round( (AmmoData.Price/AmmoData.Amount)*100 )
	local Hippie = {
		NiceName = AmmoData.Name,
		CanBuy = Ammo_CanBuy,
		Buy = Ammo_Buy,
		AmmoType = i,
		AmountToGive = AmmoData.Amount,
		AmmoMaximum = AmmoData.Max,
		Price = AmmoData.Price,
		Trivia = {
			{ "Price", ": $" .. AmmoData.Price .. " / " .. AmmoData.Amount .. " ROUNDS" },
			{ "Price per round", ": $" .. math.Round( AmmoData.Price/AmmoData.Amount, 2 ) },
		},
	}

	csBuyMenu.Items["ammo_" .. AmmoName] = Hippie
end

local LookupPrice = {
	-- pistols
	["vertec"]			= 300,
	["p2000"]			= 400,
	["p250"]			= 400,
	["gsr1911"]			= 550,
	["mr96"]			= 700,
	["mtx_dual"]		= 800,

	-- machine pistols
	["skorpion"]		= 1100,
	["sphinx"]			= 1200,
	["uzi"]				= 1300,
	["xd45"]			= 1400,
	-- smgs
	["mp5"]				= 1400,
	["mp7"]				= 1600,
	["p90"]				= 1900,
	["superv"]			= 1950,
	["pdw"]				= 2500,

	-- shotguns
	["bekas"]			= 1300,
	["tgs12"]			= 1450,
	["fp6"]				= 1500,
	["m4star10"]		= 2200,
	-- mgs
	["mg4"]				= 4200,
	-- equipment
	["m320"]			= 3300,
	["rpg7"]			= 4050,

	-- rifles
	["ak47"]			= 2000,
	["k1a"]				= 2300,
	["amd65"]			= 2600,
	["m4"]				= 3100,
	["aug"]				= 3200,
	["g36k"]			= 3300,
	["sg551"]			= 3500,

	-- sporters
	["m1"]				= 1650,
	-- marksmen
	["m14"]				= 3450,
	-- snipers
	["spr"]				= 2500,
	["uratio"]			= 2800,
	["as50"]			= 4750,
	-- battle rifles
	["dsa58"]			= 3250,
	["hk417"]			= 3650,
}

local function ReloadTacRPWeapons()
	for i, weptable in pairs( weapons.GetList() ) do
		local class = weptable.ClassName

		if class:Left(6) != "tacrp_" then continue end
		local niceclass = class:Right(-7)

		if !LookupPrice[niceclass] then
			--print( "Failed " .. niceclass .. " (" .. class .. ") because it didn't have a price" )
			--print(' ["' .. niceclass .. '"]\t\t\t= 90000,')
			continue
		end

		local Hippie = {
			Class = class,
			Trivia = {},
			Price = LookupPrice[niceclass] or 133700,
		}

		table.insert(Hippie.Trivia, {
			"PRICE", ": $" .. Hippie.Price,
		})

		local AmmoItem = csBuyMenu.Items["ammo_" .. (weptable.Ammo_Expanded or weptable.Ammo)]
		if AmmoItem and weptable.ClipSize then
			local priceperround = AmmoItem.Price/AmmoItem.AmountToGive

			table.insert(Hippie.Trivia, {
				"PRICE PER CLIP", ": $" .. math.Round(priceperround*weptable.ClipSize),
			})
		end
		
		if weptable.Trivia_Caliber then
			table.insert(Hippie.Trivia, {
				"CALIBER", ": " .. weptable.Trivia_Caliber,
			})
		end

		if weptable.Trivia_Manufacturer then
			table.insert(Hippie.Trivia, {
				"MANUFACTURER", ": " .. weptable.Trivia_Manufacturer,
			})
		end

		if weptable.ClipSize then
			table.insert(Hippie.Trivia, {
				"CLIP CAPACITY", ": " .. weptable.ClipSize .. " ROUNDS",
			})
		end

		if weptable.RPM then
			table.insert(Hippie.Trivia, {
				"RATE OF FIRE", ": " .. math.Round(weptable.RPM) .. " RPM",
			})
		end

		if weptable.Trivia_Year then
			table.insert(Hippie.Trivia, {
				"YEAR", ": " .. weptable.Trivia_Year,
			})
		end

		--print( "Created " .. niceclass .. " (" .. class .. ") with price $" .. Hippie.Price )
		csBuyMenu.Items[niceclass] = Hippie
	end
end

csbuymenu_postentity = csbuymenu_postentity or false

if csbuymenu_postentity then
	ReloadTacRPWeapons()
end
hook.Add( "InitPostEntity", "TacRPCredit_InitPostEntity", function()
	ReloadTacRPWeapons()
	csbuymenu_postentity = true
end)

csBuyMenu.Categories = {
	{
		Name = "KNIVES",
		Title = "BUY KNIVES (MELEE)",
		Items = {
			"knife_ct",
			"knife_t",
			"knife_gg",
			"knife_ghost",
			"knife_bayonet",
			"knife_butfly",
			"knife_canis",
			"knife_classic",
			"knife_cord",
			"knife_falchion",
			"knife_flip",
			"knife_gut",
			"knife_gypsy_jackknife",
			"knife_karambit",
			"knife_kukri",
			"knife_m9_bayonet",
			"knife_outdoor",
			"knife_push",
			"knife_skeleton",
			"knife_stiletto",
			"knife_survival_bowie",
			"knife_tactical",
			"knife_ursus",
			"knife_widowmaker",
			"knife_reach",
			"knife_ensword"
		},
	},
	{
		Name = "PISTOLS",
		Title = "BUY PISTOLS (SECONDARY)",
		Items = {
			"pist_hkp2000",
			"pist_223",
			"pist_glock18",
			"pist_usp",
			"pist_p250",
			"pist_fiveseven",
			"pist_tec9",
			"pist_cz75",
			"pist_elite",
			"pist_deagle",
			"pist_revolver",
			"pist_g2",
			"pist_ragingbull",
			"pist_m6c",
			"pist_m6g",
			"pist_m6g_c"
		},
	},
	{
		Name = "SMGs",
		Title = "BUY SUB-MACHINEGUNS (PRIMARY)",
		Items = {
			"smg_mp9",
			"smg_mac10",
			"smg_bizon",
			"smg_mp7",
			"smg_mp5sd",
			"smg_ump45",
			"smg_p90",
			"smg_mp5",
			"smg_c90",
			"smg_tmp",
			"smg_m7",
		},
	},
	{
		Name = "RIFLES",
		Title = "BUY RIFLES (PRIMARY)",
		Items = {
			"rifle_famas",
			"rifle_galilar",
			"rifle_m4a4",
			"rifle_m4a1s",
			"rifle_ak47",
			"rifle_aug",
			"rifle_sg553",
			"snip_ssg08",
			"snip_awp",
			"snip_scar20",
			"snip_g3sg1",
			"rifle_scar17",
			"rifle_galil",
			"rifle_galilar_scope",
			"snip_scout",
			"rifle_gry",
			"rifle_asval",
			"rifle_ma37",
			"rifle_ma37_c",
			"snip_m392",
			"snip_carbine",
			"snip_srs99",
			"snip_srs99_c"
		},
	},
	{
		Name = "HEAVY",
		Title = "BUY HEAVY WEAPONS (PRIMARY)",
		Items = {
			"shot_nova",
			"shot_xm1014",
			"shot_mag7",
			"shot_sawedoff",
			"mach_m249",
			"mach_negev",
			"shot_m3",
			"shot_aa12",
			"shot_winchester",
			"shot_m45",
			"heavy_m41",
		},
	},
	{
		Name = "GRENADES",
		Title = "BUY GRENADES (AID)",
		Items = {
			"equip_hegrenade",
			"equip_flashbang",
			"equip_smokegrenade",
			"equip_decoy",
			"equip_molotov",
			"equip_incgrenade",
			"equip_taser",
			"equip_tagrenade",
			"equip_bumpmine",
			"equip_breach",
			"equip_c4",
			"misc_snowball",
		},
	},
	{
		Name = "EQUIPMENT",
		Title = "BUY EQUIPMENT (AID)",
		Items = {
			"kevlar",
			"kev_helm",
			"equip_defuse",
			"equip_balshield",
			"equip_riotshield",
			"equip_medishot",
			--"equip_dz_medishot",
			"tool_axe",
			"tool_hammer",
			"tool_spanner"
		},
	},
	{
	Name = "AMMO",
		Title = "BUY AMMUNITION (AID)",
		Items = {
			"ammo_bundle",
		},
	},
}

for i, v in SortedPairsByMemberValue(QuickAmmo, "SortOrder", true ) do
	table.insert( csBuyMenu.Categories[8].Items, "ammo_" .. i )
end

if CLIENT then

	-- draw the money hud 
	hook.Add( "HUDPaint", "CStrike_Money", function()
		local ply = LocalPlayer()
		draw.RoundedBox( 5 , ScrW() * 0.9, ScrH() * 0.85, 150, 50, Color(0, 0, 0, 128) )
		draw.DrawText( tostring(ply:GetNW2Int("cstrike_money",0)) .. " $ ", "DermaLarge", ScrW() * 0.95, ScrH() * 0.86, Color( 100, 250, 50, 255 ), TEXT_ALIGN_CENTER )
	end)

	local ERRORICON = Material("entities/unknown.png", "mips smooth")
	local cvar_closeafterbuy = CreateClientConVar("csbuymenu_closeafterbuy", 2, true, false) -- 0 Don't Close, 1 Close, 2 Don't Close & Return To Main
	local cvar_alwaysquit = CreateClientConVar("csbuymenu_alwaysquit", 0, true, false)
	local function s( inp )
		return math.floor( inp * ( ScrH() / 512 ) )
	end
	local sizes = { 32, 24, 18, 16, 10, 8 }
	for _, size in ipairs( sizes ) do
		surface.CreateFont("CSBM_Logo_"..size, {
			font = "Coolvetica",
			extended = false,
			size = s(size),
			weight = 500,
		})
		surface.CreateFont("CSBM_"..size, {
			font = "Verdana",
			extended = false,
			size = s(size),
			weight = 900,
		})
		surface.CreateFont("CSBM_"..size.."_I", {
			font = "Verdana",
			extended = false,
			size = s(size),
		})
		surface.CreateFont("CSBM_"..size.."_B", {
			font = "Verdana Bold",
			extended = false,
			size = s(size),
			weight = 500,
		})
	end
	local Color_Dark_1 = Color( 0, 0, 0, 200 )
	local Color_Dark_2 = Color( 0, 0, 0, 128 )

	local Color_Accent_1 = Color( 255, 176, 0, 255 )
	local Color_Accent_2 = Color( 188, 112, 0, 255 )
	local Color_Accent_3 = Color( 188, 112, 0, 128 )
	local Color_Accent_4 = Color( 255, 176, 0, 100 )
	function csOpenBuyMenu()
		local ply = LocalPlayer()
		local money = ply:GetNW2Int("cstrike_money",0)
		if BuyFrame and BuyFrame:IsValid() then BuyFrame:Remove() BuyFrame = nil end
		BuyFrame = vgui.Create("DFrame")
		BuyFrame:SetSize( s(640), s(480) )
		BuyFrame:Center()
		BuyFrame:MakePopup()
		BuyFrame:SetTitle("")
		BuyFrame:ShowCloseButton(false)

		local CloseButton = BuyFrame:Add("DButton")
		CloseButton:SetSize( s(15), s(14) )
		CloseButton:SetY(s(8))

		function CloseButton:DoClick()
			BuyFrame:Remove()
			BuyFrame = nil
		end

		function CloseButton:Paint(w, h)
			surface.SetDrawColor( Color_Dark_2 )
			surface.DrawRect( 0, 0, w, h )
			surface.SetDrawColor( Color_Accent_3 )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			draw.SimpleText( "X", "CSBM_10_B", s(4), s(2), Color_Accent_1)
			return true
		end

		function BuyFrame:PerformLayout( w, h )
			CloseButton:SetX( w - CloseButton:GetWide() - s(8) )
		end

		BuyFrame.ListOptions = "MainMenu"

		function BuyFrame:Paint( w, h )
			draw.RoundedBoxEx( s(8), 0, s(64), w, h-s(64), Color_Dark_1, false, false, true, true )
			draw.RoundedBoxEx( s(8), 0, 0, w, s(64-1), Color_Dark_1, true, true, false, false )

			surface.SetDrawColor( Color_Accent_1 )
			surface.DrawRect( s(16), s(16), s(32), s(32) )

			draw.SimpleText( "g", "CSBM_Logo_32", s(28.5-4), s(6+7), Color_Dark_1)
			draw.SimpleText( "BUY MENU", "CSBM_18_B", s(64-4), s(16+7), Color_Accent_1)
			draw.SimpleText( "YOU HAVE $" .. money, "CSBM_8", s(64-4+128), s(16+12), Color_Accent_1)
			draw.SimpleText( "SHOP BY CATEGORY", "CSBM_8", s(48 + (160+16+16)/2), s(64+14), Color_Accent_1, TEXT_ALIGN_CENTER)
			return true
		end

		local Scroller = BuyFrame:Add("DScrollPanel")
		Scroller:SetSize( s(160+16+16), s(16+16+20+(16+20)*6) )
		Scroller:SetPos( s(48), s(48+48) )
		Scroller.pnlCanvas:DockPadding( s(16), s(16), s(16), s(16) )
		Scroller.VBar:SetWide( 6 )
		Scroller.VBar:SetHideButtons( true )
		
		function Scroller.VBar:Paint(w, h) return end
		function Scroller.VBar.btnGrip:Paint(w, h)
			surface.SetDrawColor( Color_Accent_3 )
			surface.DrawRect( 0, 3, 3, h-6 )
			surface.SetDrawColor( Color_Accent_1 )
			surface.DrawRect( 0, 3, 1, h-6 )
			surface.DrawRect( 3, 3, 1, h-6 )
			surface.DrawRect( 1, 3, 2, 1 )
			surface.DrawRect( 1, h-3-1, 2, 1 )
		end
		function Scroller:PerformLayoutInternal()
			local Tall = self.pnlCanvas:GetTall()
			local Wide = self:GetWide()
			local YPos = 0
		
			self:Rebuild()
		
			self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )
			YPos = self.VBar:GetOffset()
		
			--if ( self.VBar.Enabled ) then Wide = Wide - self.VBar:GetWide() end
		
			self.pnlCanvas:SetPos( 0, YPos )
			self.pnlCanvas:SetWide( Wide )
		
			self:Rebuild()
		
			if ( Tall != self.pnlCanvas:GetTall() ) then
				self.VBar:SetScroll( self.VBar:GetScroll() ) -- Make sure we are not too far down!
			end
		end
		function Scroller:Paint(w, h)
			surface.SetDrawColor( Color_Dark_2 )
			surface.DrawRect( 0, 0, w, h )

			surface.SetDrawColor( Color_Accent_3 )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )

			return true
		end
		BuyFrame.Deviants = {}
		BuyFrame.HoveredItem = nil

		local QuitButton
		function BuyFrame:OnKeyCodePressed( key )
			if key == KEY_0 then
				QuitButton:DoClick()
			elseif key == KEY_1 then
				if BuyFrame.Deviants[1] then
					BuyFrame.Deviants[1]:DoClick()
				end
			elseif key == KEY_2 then
				if BuyFrame.Deviants[2] then
					BuyFrame.Deviants[2]:DoClick()
				end
			elseif key == KEY_3 then
				if BuyFrame.Deviants[3] then
					BuyFrame.Deviants[3]:DoClick()
				end
			elseif key == KEY_4 then
				if BuyFrame.Deviants[4] then
					BuyFrame.Deviants[4]:DoClick()
				end
			elseif key == KEY_5 then
				if BuyFrame.Deviants[5] then
					BuyFrame.Deviants[5]:DoClick()
				end
			elseif key == KEY_6 then
				if BuyFrame.Deviants[6] then
					BuyFrame.Deviants[6]:DoClick()
				end
			elseif key == KEY_7 then
				if BuyFrame.Deviants[7] then
					BuyFrame.Deviants[7]:DoClick()
				end
			elseif key == KEY_8 then
				if BuyFrame.Deviants[8] then
					BuyFrame.Deviants[8]:DoClick()
				end
			elseif key == KEY_9 then
				if BuyFrame.Deviants[9] then
					BuyFrame.Deviants[9]:DoClick()
				end
			end
		end

		local function GenerateButtons()
			if BuyFrame.Deviants then
				for i, v in pairs(BuyFrame.Deviants) do
					v:Remove()
				end
				BuyFrame.Deviants = {}
			end
			local MAKEFROM = csBuyMenu.Categories
			local shopping = BuyFrame.ListOptions != "MainMenu"
			if shopping then
				if csBuyMenu.Categories[BuyFrame.ListOptions] then
					MAKEFROM = csBuyMenu.Categories[BuyFrame.ListOptions].Items
				end
			else
				MAKEFROM = csBuyMenu.Categories
			end


			for i, Entry in ipairs(MAKEFROM) do
				--if !shopping then Entry = csBuyMenu.Categories[Entry] end -- Category gets replaced with the table
				local wepdata
				local itemdata = csBuyMenu.Items[Entry]
				if shopping and !itemdata then ErrorNoHalt("Item in buymenu '" .. Entry .. "' has no item definition\n") continue end
				if shopping then
					wepdata = weapons.Get(itemdata.Class)
				end
				local CateButton = Scroller:Add("DButton")
				CateButton:SetSize( s(160), s(20) )
				CateButton:SetPos( s(64), 0 )
				BuyFrame.Deviants[i] = CateButton
				CateButton.Entry = Entry
				
				CateButton:Dock(TOP)
				CateButton:DockMargin( 0, 0, 0, s(16) )
	
				function CateButton:Paint(w, h)
					surface.SetDrawColor( self:IsHovered() and Color_Accent_4 or Color_Dark_2 )
					surface.DrawRect( 0, 0, w, h )
	
					surface.SetDrawColor( Color_Accent_3 )
					surface.DrawOutlinedRect( 0, 0, w, h, 1 )
					
					if shopping then
						if wepdata then
							draw.SimpleText( i .. " " .. wepdata.PrintName:upper(), "CSBM_8", s(6), s(6), Color_Accent_1 )
						else
							draw.SimpleText( i .. " " .. itemdata.NiceName:upper(), "CSBM_8", s(6), s(6), Color_Accent_1 )
						end
					else
						draw.SimpleText( i .. " " .. Entry.Name:upper(), "CSBM_8", s(6), s(6), Color_Accent_1 )
					end
					return true
				end

				function CateButton:Think()
					if shopping and self:IsHovered() then
						BuyFrame.HoveredItem = CateButton.Entry
					end
				end

				function CateButton:DoClick()
					if shopping then
						RunConsoleCommand("cs_buy", Entry)
						if cvar_closeafterbuy:GetInt() == 0 then
						elseif cvar_closeafterbuy:GetInt() == 1 then
							BuyFrame:Remove()
							BuyFrame = nil
						else
							BuyFrame.ListOptions = "MainMenu"
							GenerateButtons( Scroller, BuyFrame )
						end
					else
						BuyFrame.ListOptions = i
						GenerateButtons( Scroller, BuyFrame )
					end
					return
				end
			end
		end
		GenerateButtons( Scroller, BuyFrame )
		
		QuitButton = BuyFrame:Add("DButton")
		QuitButton:SetSize( s(160), s(20) )
		QuitButton:SetPos( s(16+48), s(480-20-48) )

		function QuitButton:Paint(w, h)
			surface.SetDrawColor( self:IsHovered() and Color_Accent_4 or Color_Dark_2 )
			surface.DrawRect( 0, 0, w, h )

			surface.SetDrawColor( Color_Accent_3 )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )
			
			draw.SimpleText((BuyFrame.ListOptions != "MainMenu" and !cvar_alwaysquit:GetBool()) and "0 BACK" or "0 CANCEL", "CSBM_8", s(6), s(6), Color_Accent_1)
			return true
		end

		function QuitButton:DoClick()
			if BuyFrame.ListOptions == "MainMenu" or cvar_alwaysquit:GetBool() then
				BuyFrame:Remove()
				BuyFrame = nil
			else
				BuyFrame.ListOptions = "MainMenu"
				GenerateButtons()
			end
		end
		
		local The = (640-48-48-16-160-16-16)
		local PrettyImage = BuyFrame:Add("DPanel")
		PrettyImage:SetSize( s(The), s(The/2) )
		PrettyImage:SetPos( s(48+16+160+16+16), s(48+48) )

		function PrettyImage:Paint(w, h)
			if !BuyFrame.HoveredItem then return end
			surface.SetDrawColor( Color_Dark_2 )
			surface.DrawRect( 0, 0, w, h )

			surface.SetDrawColor( Color_Accent_3 )
			surface.DrawOutlinedRect( 0, 0, w, h, 1 )

			local bh = BuyFrame.HoveredItem
			local Classinfo = csBuyMenu.Items[bh]
			if bh and Classinfo then
				if !Classinfo.Icon and Classinfo.Class then
					Classinfo.Icon = Material("entities/"..Classinfo.Class..".png", "mips smooth")
					if Classinfo.Icon:IsError() then
						Classinfo.Icon = ERRORICON
					end
				end
				if Classinfo.Icon then
					surface.SetMaterial(Classinfo.Icon)
					surface.SetDrawColor( 255, 255, 255 )
					surface.DrawTexturedRect( w/2 - w/2, h/2 - w/2, w, w )
				end
				local old = DisableClipping(true)
					for i, v in ipairs(Classinfo.Trivia) do
						draw.SimpleText( v[1]:upper(), "CSBM_8", 0, h + s(8 + ((i-1)*16)), Color_Accent_1 )
						draw.SimpleText( v[2]:upper(), "CSBM_8", w/2, h + s(8 + ((i-1)*16)), Color_Accent_1 )
					end
				DisableClipping(old)
			end
			return true
		end
	end
	concommand.Add("cs_buymenu", function()
		local ply = LocalPlayer()
		if GAMEMODE_NAME == "zombiesurvival" and ply:Team() != TEAM_HUMAN then
			ply:ChatPrint("This team can't buy weapons.")
		else
			csOpenBuyMenu()
		end
	end)
end

concommand.Add("cs_buy", function( ply, cmd, args )
	if CLIENT then return end
	if !ply or !ply:IsValid() then return end

	local Classname = args[1]
	local Classinfo = csBuyMenu.Items[Classname]
	if !Classinfo then return end
	local plymoney = ply:GetNW2Int("cstrike_money",0)
	if Classinfo.Price > plymoney then ply:ChatPrint("Not enough funds to buy this item!") ply:EmitSound(Sound("buymenu/deny.wav")) return end

	local DeductMoney = true
	local finalmoney

	if Classinfo.CanBuy then
		if !Classinfo.CanBuy( ply, Classinfo, Classname ) then
			ply:ChatPrint("You can't buy " .. Classname .. ".")
			ply:EmitSound(Sound("buymenu/deny.wav"))
			return
		end
	else
		if ply:HasWeapon(Classinfo.Class) then
			ply:ChatPrint("You already own this weapon.")
			ply:EmitSound(Sound("buymenu/deny.wav"))
			return
		end
	end
	if !Classinfo.Buy then
		ply:Give(Classinfo.Class)
		ply:SelectWeapon(Classinfo.Class)
	else
		DeductMoney = Classinfo.Buy( ply, Classinfo, Classname )
	end

	if DeductMoney then
		if isnumber(DeductMoney) then
		else
			DeductMoney = Classinfo.Price
			finalmoney = ply:GetNW2Int("cstrike_money",0) - DeductMoney
			ply:SetNW2Int("cstrike_money",finalmoney)
		end
		ply:ChatPrint("Purchase complete, deducted $" .. DeductMoney .. "")
		ply:EmitSound(Sound("buymenu/buy.wav"))
	else
		ply:ChatPrint("Purchase complete, you haven't been charged")
		ply:EmitSound(Sound("buymenu/buy.wav"))
	end
end)