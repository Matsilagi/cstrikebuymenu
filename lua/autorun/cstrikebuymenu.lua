
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
		NiceName = "KEVLAR VEST",
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
			{ "Saves you from grivious wounds!!", "" },
		},
	},
}

local QuickAmmo = {
	["pistol"] = {
		SortOrder = -1,
		Name = "PISTOL AMMO",
		Price = 20,
		Amount = 30,
		Max = 150,
	},
	["ti_pistol_light"] = {
		SortOrder = -1.05,
		Name = "LIGHT PISTOL AMMO",
		Price = 20,
		Amount = 40,
		Max = 150,
	},
	["ti_pistol_heavy"] = {
		SortOrder = -1.1,
		Name = "HEAVY PISTOL AMMO",
		Price = 25,
		Amount = 15,
		Max = 150,
	},
	["ti_pdw"] = {
		SortOrder = -1.2,
		Name = "PDW AMMO",
		Price = 50,
		Amount = 20,
		Max = 150,
	},
	["357"] = {
		SortOrder = -1.3,
		Name = "MAGNUM AMMO",
		Price = 40,
		Amount = 8,
		Max = 60,
	},
	["buckshot"] = {
		SortOrder = -2,
		Name = "12G BUCKSHOT",
		Price = 60,
		Amount = 12,
		Max = 64,
	},
	["smg1"] = {
		SortOrder = -3,
		Name = "CARBINE AMMO",
		Price = 60,
		Amount = 30,
		Max = 180,
	},
	["ar2"] = {
		SortOrder = -3.1,
		Name = "RIFLE AMMO",
		Price = 80,
		Amount = 30,
		Max = 180,
	},
	["ti_rifle"] = {
		SortOrder = -3.2,
		Name = "HEAVY RIFLE AMMO",
		Price = 90,
		Amount = 30,
		Max = 180,
	},
	["ti_sniper"] = {
		SortOrder = -3.3,
		Name = "SNIPER AMMO",
		Price = 125,
		Amount = 10,
		Max = 30,
	},
	["smg1_grenade"] = {
		SortOrder = -4,
		Name = "40MM GRENADES",
		Price = 50,
		Amount = 1,
		Max = 5,
	},
	["rpg_round"] = {
		SortOrder = -4.1,
		Name = "RPG ROUNDS",
		Price = 100,
		Amount = 1,
		Max = 5,
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
				"PRICE PER CLIP", ": $" .. priceperround*weptable.ClipSize,
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
		Name = "PISTOLS",
		Title = "BUY PISTOLS (SECONDARY WEAPON)",
		Items = {
			"vertec",
			"p2000",
			"p250",
			"gsr1911",
			"mr96",
			"mtx_dual",
		},
	},
	{
		Name = "HEAVY",--"SHOTGUNS",
		Title = "BUY PISTOLS (SECONDARY WEAPON)",
		Items = {
			"bekas",
			"tgs12",
			"fp6",
			"m4star10",
			"m320",
			"mg4",
			"rpg7",
		},
	},
	{
		Name = "SMG",
		Title = "BUY PISTOLS (SECONDARY WEAPON)",
		Items = {
			"skorpion",
			"sphinx",
			"uzi",
			"xd45",
			"mp5",
			"mp7",
			"p90",
			"superv",
			"pdw",
		},
	},
	{
		Name = "RIFLES",
		Title = "BUY PISTOLS (SECONDARY WEAPON)",
		Items = {
			"ak47",
			"k1a",
			"amd65",
			"m4",
			"aug",
			"g36k",
			"sg551",
		},
	},
	{
		Name = "MARKSMAN",
		Title = "BUY PISTOLS (SECONDARY WEAPON)",
		Items = {
			"m1",
			"spr",
			"uratio",
			"dsa58",
			"m14",
			"hk417",
			"as50",

		},
	},
	{
		Name = "EQUIPMENT",
		Title = "BUY PISTOLS (SECONDARY WEAPON)",
		Items = {
			"kevlar",
		},
	},
	{
		Name = "ATTACHMENTS",
		Title = "BUY WEAPON ATTACHMENTS",
		Items = {
		},
	},
}

for i, v in SortedPairsByMemberValue(QuickAmmo, "SortOrder", true ) do
	table.insert( csBuyMenu.Categories[6].Items, "ammo_" .. i )
end

if CLIENT then
	local cvar_closeafterbuy = CreateClientConVar("csbuymenu_closeafterbuy", 2, true, false) -- 0 Don't Close, 1 Close, 2 Don't Close & Return To Main
	local cvar_alwaysquit = CreateClientConVar("csbuymenu_alwaysquit", 0, true, false)
	local function s( inp )
		return math.floor( inp * ( ScrH() / 512 ) )
	end
	local sizes = { 24, 18, 16, 10, 8 }
	for _, size in ipairs( sizes ) do
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

			draw.SimpleText( "BUY MENU", "CSBM_18_B", s(64-4), s(16+7), Color_Accent_1)
			draw.SimpleText( "YOU HAVE $16000", "CSBM_8", s(64-4+128), s(16+12), Color_Accent_1)
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
		csOpenBuyMenu()
	end)
	csOpenBuyMenu()
end

concommand.Add("cs_buy", function( ply, cmd, args )
	if CLIENT then return end
	if !ply or !ply:IsValid() then return end

	local Classname = args[1]
	local Classinfo = csBuyMenu.Items[Classname]
	if !Classinfo then return end

	local DeductMoney = true

	if Classinfo.CanBuy then
		if !Classinfo.CanBuy( ply, Classinfo, Classname ) then
			ply:ChatPrint("You can't buy " .. Classname .. ".")
			return
		end
	else
		if ply:HasWeapon(Classinfo.Class) then
			ply:ChatPrint("You already own this weapon.")
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
		end
		ply:ChatPrint("Purchase complete, deducted $" .. DeductMoney .. "")
	else
		ply:ChatPrint("Purchase complete, you haven't been charged")
	end
end)