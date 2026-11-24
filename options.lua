-- This script will run on all levels when mod is active.
-- Modding documentation: http://teardowngame.com/modding
-- API reference: http://teardowngame.com/modding/api.html

-- ORIS Railgun Overhaul by Mx. Pikachu The Silly Gal
-- https://steamcommunity.com/sharedfiles/filedetails/?id=3485586841
-- Patch v0.5.0

function init()
	-- DO UPDATE CHANGES HERE FROM NOW ON
	-- Updating/Setting Version String
	if ((GetString("savegame.mod.version")) == nil or (GetString("savegame.mod.version")) == '') then
		SetString("savegame.mod.version", "v0.5.0.4")
		end
	if GetString("savegame.mod.version") == "v0.3.9.0" then
		ClearKey("savegame.mod.fov_zoom")
		SetBool("savegame.mod.doommode", false)
	end
	if not (string.sub(GetString("savegame.mod.version"),1,4) == "v0.5") then
		SetString("savegame.mod.kb_pwr", 0.45)
		SetString("savegame.mod.fire_power", 1)
	end
	if not (GetString("savegame.mod.version") == "v0.5.0.4") then
		SetString("savegame.mod.version", "v0.5.0.4")
	end
	-- v0.3.4 Settings
	if ((GetString("savegame.mod.red")) == nil or (GetString("savegame.mod.red")) == '') then
		v034_defaults()
	end
	-- v0.3.8.X Toggles
	if ((GetString("savegame.mod.fire_power")) == nil or (GetString("savegame.mod.fire_power")) == '') then
		v038X_defaults()
	end
	-- Unimplemented Thirdperson Mode Fix
	if ((GetString("savegame.mod.doommode")) == nil or (GetString("savegame.mod.doommode")) == '') then
		SetBool("savegame.mod.doommode", false)
	end
	-- Experimental Unlimited Power Toggle
	if ((GetString("savegame.mod.unlimitPower")) == nil or (GetString("savegame.mod.unlimitPower")) == '') then
		SetBool("savegame.mod.unlimitPower", false)
	end
	-- v0.4.1 Defaults (Keybinds)
	if ((GetString("savegame.mod.keybind_ammoselect")) == nil or (GetString("savegame.mod.keybind_ammoselect")) == '') then
		v041_defaults()
	end
	
	UiMoveSND = "MOD/Assets/SFX/ui-click-menu-modern-interface-select-small-01.ogg"
	dot = "MOD/Assets/VFX/dot.png"
	grid = "MOD/Assets/VFX/GridOverlay.png"
	
	debug = false
	gridtoggle = false
	speedup = false
	sp = 0
	cselecta = 1
	cselectb = 1
	tselect = 1
	dselect = 1
	accentoutline = 0.25
	beamoutline = 0
	togglesoutline = 0
	Grab_Registry_Keys()
	rdone = true
	gdone = true
	bdone = true
	dselect_startupcorrection = true
	cselecta_startupcorrection = true
	togoutline = {}
	koutline = {}
	tdone = {}
	kdone = {}
	kinput = {}
	buttondone = {}
	buttonclicked = {}
	buttontime = {}
	keybind_prev = {}
	kselect = 1
	keybind_wait = 0
	toutbase = 0
	koutbase = 0
	PlaceholderSND = "MOD/Assets/SFX/kl_fiddlesticks.ogg"
end

function string.insert(str1, str2, str_pos)
    return str1:sub(1,str_pos)..str2..str1:sub(str_pos+1)
end

function tick(dt)
	if InputPressed("pause") and not disableinput then
		Save_Settings()
	end
	if InputPressed("F1") and not disableinput then
		debug = not debug
		if not debug then
			for i = 0, 20 do
				DebugPrint("")
			end
		end
	end
	if InputPressed("F7") and not disableinput then
		gridtoggle = not gridtoggle
	end
	if (debug and InputDown("f2") and InputDown("f3") and InputDown("f4")) and not disableinput then
		ClearKey1()
	end
	if buttonclicked[1] then
		button_click(1)
	end
	if buttonclicked[2] then
		button_click(2)
	end
	if buttonclicked[3] then
		button_click(3)
	end
	if debug == true then
		DebugWatch("Patch Version", GetString("savegame.mod.version"))
		DebugWatch("dselect", dselect)
		DebugWatch("speedup", speedup)
		--RGB Color Values
		--DebugColor()
		--Persitent Toggles/settings (introduced in v0.3.8)
		DebugToggles()
		DebugWatch("unlimitPower", unlimitPower)
		-- Keybinds
		--DebugKeybinds()
		--DebugReset()
	end
	if (InputPressed("l")) and not disableinput then
		long_lightbeam = not long_lightbeam
	end
	if (InputDown("f8") and InputPressed("f9")) and not disableinput then
		true_multiplayer_test = not true_multiplayer_test
	end
	if InputPressed("f10") then
		unlimitPower = not unlimitPower
	end
	if (InputDown("ctrl") or InputDown("menu_cancel")) and not disableinput then
		speedup = true
	else
		speedup = false
	end
	if (InputPressed("downarrow") or InputPressed("menu_down")) and not disableinput then
		if dselect == 1 then
			cselecta = cselecta + 1
			if cselecta == 4 then
				cselecta = 3
			end
		end
		if dselect == 2 then
			cselectb = cselectb + 1
			if cselectb == 4 then
				cselectb = 3
			end
		end
		if dselect == 3 then
			tselect = tselect + 1
			if tselect > 12 then
				tselect = 12
			end
		end
		if dselect == 4 then
			kselect = kselect + 1
			if kselect > 14 then
				kselect = 14
			end
		end
	end
	if (InputPressed("uparrow") or InputPressed("menu_up")) and not disableinput then
		if dselect == 1 then
			cselecta = cselecta - 1
			if cselecta < 1 then
				cselecta = 1
			end
		end
		if dselect == 2 then
			cselectb = cselectb - 1
			if cselectb < 1 then
				cselectb = 1
			end
		end
		if dselect == 3 then
			tselect = tselect - 1
			if tselect < 1 then
				tselect = 1
			end
		end
		if dselect == 4 then
			kselect = kselect - 1
			if kselect < 1 then
				kselect = 1
			end
		end
	end
	if InputPressed("space") and dselect == 4 then
		kinput[kselect] = true
	end
	if InputPressed("space") and dselect == 3 then
		if tselect == 4 then hideui = not hideui end
		if tselect == 6 then fpsmode = not fpsmode end
		if tselect == 5 then hiderechargeindicator = not hiderechargeindicator end
		if tselect == 7 then quickfire = not quickfire end
		if tselect == 8 then kb_unlimit = not kb_unlimit end
		if tselect == 9 then long_lightbeam = not long_lightbeam end
		if tselect == 10 then debug_default = not debug_default end
		if tselect == 11 then doommode = not doommode end
		if tselect == 12 then falloff = not falloff end
	end
	if (InputPressed("rightarrow") or InputPressed("menu_right")) and not disableinput then
		if dselect == 1 then
			if cselecta == 1 then
				red = red + 1 + sp
				if red > 255 then
					red = 255
				end
			end
			if cselecta == 2 then
				green = green + 1 + sp
				if green > 255 then
					green = 255
				end
			end
			if cselecta == 3 then
				blue = blue + 1 + sp
				if blue > 255 then
					blue = 255
				end
			end
		end
		if dselect == 2 then
			if cselectb == 1 then
				redb = redb + 1 + sp
				if redb > 255 then
					redb = 255
				end
			end
			if cselectb == 2 then
				greenb = greenb + 1 + sp
				if greenb > 255 then
					greenb = 255
				end
			end
			if cselectb == 3 then
				blueb = blueb + 1 + sp
				if blueb > 255 then
					blueb = 255
				end
			end
		end
		if dselect == 3 then
			if tselect == 1 then
				ammo_type = ammo_type + 1
				if ammo_type == 3 then
					ammo_type = 1
				end
			end
			if tselect == 2 then
				fire_power_int = fire_power_int + 1
				if fire_power_int > 15 then
					fire_power_int = 15
				end
			end
			if tselect == 3 then
				kb_pwr_int = kb_pwr_int + 0.5
				if kb_pwr_int > 20 then
					kb_pwr_int = 20
				end
			end
			if tselect == 4 then hideui = true end
			if tselect == 6 then fpsmode = true end
			if tselect == 5 then hiderechargeindicator = true end
			if tselect == 7 then quickfire = true end
			if tselect == 8 then kb_unlimit = true end
			if tselect == 9 then long_lightbeam = true end
			if tselect == 10 then debug_default = true end
			if tselect == 11 then doommode = true end
			if tselect == 12 then falloff = true end
		end
	end
	if (InputPressed("leftarrow") or InputPressed("menu_left")) and not disableinput then
		if dselect == 1 then
			if cselecta == 1 then
				red = red - 1 - sp
				if red < 0 then
					red = 0
				end
			end
			if cselecta == 2 then
				green = green - 1 - sp
				if green < 0 then
					green = 0
				end
			end
			if cselecta == 3 then
				blue = blue - 1 - sp
				if blue < 0 then
					blue = 0
				end
			end
		end
		if dselect == 2 then
			if cselectb == 1 then
				redb = redb - 1 - sp
				if redb < 0 then
					redb = 0
				end
			end
			if cselectb == 2 then
				greenb = greenb - 1 - sp
				if greenb < 0 then
					greenb = 0
				end
			end
			if cselectb == 3 then
				blueb = blueb - 1 - sp
				if blueb < 0 then
					blueb = 0
				end
			end
		end
		if dselect == 3 then
			if tselect == 1 then
				ammo_type = ammo_type - 1
				if ammo_type == 0 then
					ammo_type = 2
				end
			end
			if tselect == 2 then
				fire_power_int = fire_power_int - 1
				if fire_power_int < 2 then
					fire_power_int = 2
				end
			end
			if tselect == 3 then
				kb_pwr_int = kb_pwr_int - 0.5
				if kb_pwr_int < 0 then
					kb_pwr_int = 0
				end
			end
			if tselect == 4 then hideui = false end
			if tselect == 6 then fpsmode = false end
			if tselect == 5 then hiderechargeindicator = false end
			if tselect == 7 then quickfire = false end
			if tselect == 8 then kb_unlimit = false end
			if tselect == 9 then long_lightbeam = false end
			if tselect == 10 then debug_default = false end
			if tselect == 11 then doommode = false end
			if tselect == 12 then falloff = false end
		end
	end
	if (InputPressed("return") or InputPressed("menu_accept")) and not disableinput then
		dselect = dselect + 1
		if dselect == 5 then
			dselect = 1
		end
	end
	if waitforinput and InputPressed("any") then
		keybind_name = tostring(InputLastPressedKey())
		keybind_allow = keybind_invalidate(keybind_name)
		if not keybind_allow then
			keybind_name = tostring("Invalid Key")
			keybind_invalid = true
			keybind_wait = GetTime() + 2
			keybind_kinputprev = kselect
			keybind_name_ref = keybind_name
		end
		if keybind_name == tostring("") then
			keybind_name = tostring("No  Key  Bound")
			keybind_invalid = true
			keybind_wait = GetTime() + 2
			keybind_kinputprev = kselect
			keybind_name_ref = keybind_name
		end
		if kinput[1] == true then keybind_ammoselect = keybind_name end
		if kinput[2] == true then keybind_powerlvl_plus = keybind_name end
		if kinput[3] == true then keybind_powerlvl_minus = keybind_name end
		if kinput[4] == true then keybind_kickback_plus = keybind_name end
		if kinput[5] == true then keybind_kickback_minus = keybind_name end
		if kinput[6] == true then keybind_hideui = keybind_name end
		if kinput[7] == true then keybind_fpsmode = keybind_name end
		if kinput[8] == true then keybind_hidestatus = keybind_name end
		if kinput[9] == true then keybind_quickfire = keybind_name end
		if kinput[10] == true then keybind_unlimitkb_1 = keybind_name end
		if kinput[11] == true then keybind_unlimitkb_2 = keybind_name end
		if kinput[12] == true then keybind_debug = keybind_name end
		if kinput[13] == true then keybind_multiplayertest_1 = keybind_name end
		if kinput[14] == true then keybind_multiplayertest_2 = keybind_name end
		for i = 1, 14 do
			kinput[i] = false
		end
		disableinput = false
		waitforinput = false
	end
	if ((GetTime()) > tonumber(keybind_wait)) and (keybind_invalid == true) and (kinput[keybind_kinputprev] == false) and (keybind_name == keybind_name_ref) then
		if keybind_prev[keybind_kinputprev] == ("Invalid Key") then
			keybind_prev[keybind_kinputprev] = ("No  Key  Bound")
		end
		if keybind_prev[keybind_kinputprev] == ("") then
			keybind_prev[keybind_kinputprev] = ("No  Key  Bound")
		end
		if keybind_kinputprev == 1 then keybind_ammoselect = keybind_prev[1] end
		if keybind_kinputprev == 2 then keybind_powerlvl_plus = keybind_prev[2] end
		if keybind_kinputprev == 3 then keybind_powerlvl_minus = keybind_prev[3] end
		if keybind_kinputprev == 4 then keybind_kickback_plus = keybind_prev[4] end
		if keybind_kinputprev == 5 then keybind_kickback_minus = keybind_prev[5] end
		if keybind_kinputprev == 6 then keybind_hideui = keybind_prev[6] end
		if keybind_kinputprev == 7 then keybind_fpsmode = keybind_prev[7] end
		if keybind_kinputprev == 8 then keybind_hidestatus = keybind_prev[8] end
		if keybind_kinputprev == 9 then keybind_quickfire = keybind_prev[9] end
		if keybind_kinputprev == 10 then keybind_unlimitkb_1 = keybind_prev[10] end
		if keybind_kinputprev == 11 then keybind_unlimitkb_2 = keybind_prev[11] end
		if keybind_kinputprev == 12 then keybind_debug = keybind_prev[12] end
		if keybind_kinputprev == 13 then keybind_multiplayertest_1 = keybind_prev[13] end
		if keybind_kinputprev == 14 then keybind_multiplayertest_2 = keybind_prev[14] end
		keybind_wait = 0
		keybind_invalid = false
	end
end

function update(dt)
	red = math.floor(red + 0.5)
	green = math.floor(green + 0.5)
	blue = math.floor(blue + 0.5)
	redb = math.floor(redb + 0.5)
	greenb = math.floor(greenb + 0.5)
	blueb = math.floor(blueb + 0.5)
	if speedup then
		sp = 9
	else
		sp = 0
	end
	-- AAAAAAAA
	if rdone == true then
		cselecta = 1
		dselect = 1
	end
	if gdone == true then
		cselecta = 2
		dselect = 1
	end
	if bdone == true then
		cselecta = 3
		dselect = 1
	end
	-- BBBBBBBBB
	if rdoneb == true then
		cselectb = 1
		dselect = 2
	end
	if gdoneb == true then
		cselectb = 2
		dselect = 2
	end
	if bdoneb == true then
		cselectb = 3
		dselect = 2
	end
	-- CCCCCCCCC
	for i = 1, 11 do
		togdone_check(i)
	end
	for i = 1, 14 do
		kdone_check(i)
	end
	
	-- Colors Outlines	
	
	if cselecta == 1 then
		rselect = 0.65
	else
		rselect = 0.25
	end
	if cselecta == 2 then
		gselect = 0.65
	else
		gselect = 0.25
	end
	if cselecta == 3 then
		bselect = 0.65
	else
		bselect = 0.25
	end
	if cselectb == 1 then
		rselectb = 0.65
	else
		rselectb = 0.25
	end
	if cselectb == 2 then
		gselectb = 0.65
	else
		gselectb = 0.25
	end
	if cselectb == 3 then
		bselectb = 0.65
	else
		bselectb = 0.25
	end
	
	-- Toggles Outlines
	if dselect == 3 then
		toutbase = 0.25
	else
		toutbase = 0
	end
	if dselect == 4 then
		koutbase = 0.25
	else
		koutbase = 0
	end
	for i = 1, 12 do
		togoutline_check(i)
	end
	for i = 1, 14 do
		koutline_check(i)
	end
	if cselecta_startupcorrection then
		cselecta = 1
		cselecta_startupcorrection = false
	end
	if dselect_startupcorrection then
		dselect = 1
		dselect_startupcorrection = false
	end
	if dselect == 1 then
		rselectb = 0
		gselectb = 0
		bselectb = 0
		accentoutline = 0.25
		beamoutline = 0
		togglesoutline = 0
		toutbase = 0
		koutbase = 0
		keybindsoutline = 0
	end
	if dselect == 2 then
		rselect = 0
		gselect = 0
		bselect = 0
		accentoutline = 0
		beamoutline = 0.25
		togglesoutline = 0
		toutbase = 0
		koutbase = 0
		keybindsoutline = 0
	end
	if dselect == 3 then
		rselect = 0
		gselect = 0
		bselect = 0
		rselectb = 0
		gselectb = 0
		bselectb = 0
		accentoutline = 0
		beamoutline = 0
		koutbase = 0
		togglesoutline = 0.25
		keybindsoutline = 0
	end
	if dselect == 4 then
		rselect = 0
		gselect = 0
		bselect = 0
		rselectb = 0
		gselectb = 0
		bselectb = 0
		accentoutline = 0
		beamoutline = 0
		togglesoutline = 0
		keybindsoutline = 0.25
	end
end

function togoutline_check(tselnum)
	if tselect == tselnum then
		togoutline[tselnum] = 0.45
	else
		togoutline[tselnum] = 0
	end
	if not (dselect == 3) then
		togoutline[tselnum] = 0
	end
end

function koutline_check(kselnum)
	if kselect == kselnum then
		koutline[kselnum] = 0.45
	else
		koutline[kselnum] = 0
	end
	if not (dselect == 4) then
		koutline[kselnum] = 0
	end
end

function togdone_check(i)
	if tdone[i] == true then
		tselect = i
		dselect = 3
	end
end

function kdone_check(i)
	if kdone[i] == true then
		kselect = i
		dselect = 4
	end
end

function draw(dt)
	-- True Multiplayer Test Toggle
	UiPush()
		UiTranslate(50,35)
		UiFont("regular.ttf", 24)
		UiText("''True'' Multiplayer Mode Test (Hold F8 + F9 to toggle)")
		UiTranslate(50,20)
		if not true_multiplayer_test then
			UiColor(1,0,0)
			UiText("Disabled")
		end
		if true_multiplayer_test then
			UiColor(0,1,0)
			UiText("Enabled")
		end
		UiTranslate(-50, 30)
		UiColor(1,1,1)
		UiText("Unlimited Power (Press F10 to toggle)")
		UiTranslate(50,20)
		if not unlimitPower then
			UiColor(1,0,0)
			UiText("Disabled")
		end
		if unlimitPower then
			UiColor(0,1,0)
			UiText("Enabled")
		end
	UiPop()
	canvas = UiCanvasSize()
	screenmiddlex = canvas.w/2
	screenmiddley = canvas.h/2
	-- Reset Buttons
	UiPush()
		UiTranslate(32, canvas.h - 144)
		UiTranslate(-8, -24)
		if not buttondone[1] then
			UiColor(0.35, 0.35, 0.35)
		else
			UiColor(0.1, 0.1, 0.1)
		end
		UiRoundedRect(216, 32, 4)
		UiTranslate(8, 24)
		UiColor(1,1,1)
		UiTextOutline(0,0,0,1,0.5)
		UiFont("regular.ttf", 24)
		UiText("Reset Color Values")
		UiTranslate(100, -16)
		if UiBlankButton(200, 32) then
			buttonclicked[1] = true
			buttontime[1] = GetTime() + 0.15
			v034_defaults()
			LoadColorValues()
		end
		UiTranslate(-100, 52)
		UiTranslate(-8, -24)
		if not buttondone[2] then
			UiColor(0.35, 0.35, 0.35)
		else
			UiColor(0.1, 0.1, 0.1)
		end
		UiRoundedRect(216, 32, 4)
		UiTranslate(8, 24)
		UiColor(1,1,1)
		UiText("Reset Toggle Values")
		UiTranslate(100, -16)
		if UiBlankButton(200, 32) then
			buttonclicked[2] = true
			buttontime[2] = GetTime() + 0.15
			v038X_defaults()
			LoadToggles()
		end
		UiTranslate(-100, 52)
		UiTranslate(-8, -24)
		if not buttondone[3] then
			UiColor(0.35, 0.35, 0.35)
		else
			UiColor(0.1, 0.1, 0.1)
		end
		UiRoundedRect(216, 32, 4)
		UiTranslate(8, 24)
		UiColor(1,1,1)
		UiText("Reset Keybind Values")
		UiTranslate(100, -16)
		if UiBlankButton(200, 32) then
			buttonclicked[3] = true
			buttontime[3] = GetTime() + 0.15
			v041_defaults()
			LoadKeybinds()
		end
	UiPop()
	-- Color Rectangles & FOV
	UiPush()
	-- Color Preview Rectangles
		-- Accent Color Rect
		UiTranslate(124, screenmiddley + 300)
		UiColor(red/255, green/255, blue/255)
		UiRoundedRect(356,32,16)
		UiFont("regular.ttf", 24)
		UiTranslate(0,-65)
		UiColor(1,1,1)
		-- Advice for color choice
		UiText("Generally Try to Avoid a Color that's too Dark")
		UiTranslate(0,25)
		UiText("or else the Light might not Show up at all.")
		-- Beam Rect
		UiTranslate(439, 40)
		UiColor(redb/255, greenb/255, blueb/255)
		UiRoundedRect(356,32,16)
		UiTranslate(0, -65)
		UiColor(1,1,1)
		UiText("Use the ARROW KEYS or D-PAD to Navigate")
		UiTranslate(0,25)
		UiText("Press ENTER (A or X on Controller) to Switch Selected Category")
		UiTranslate(0,25)
		UiText("Hold CTRL (B or Circle on Controller) to Speed up Color Sliders.")
		UiTranslate(783,-50)
		UiText("Press the SPACE BAR to Select a Keybind.")
		UiTranslate(0,25)
		UiText("When Cursor is Blinking, Press the Desired Key.")
		UiTranslate(0,25)
		UiText("Keys already being used by the Game itself will be Rejected.")
	UiPop()
	UiPush()
		UiFont("regular.ttf", 64)
		UiTranslate(960,screenmiddley - 180)
		UiColor(1,1,1)
		UiAlign("center")
		UiTextOutline(0.656,0.484,0.776, 8)
		UiText("Railgun Options Menu")
		UiTranslate(0,-128)
		if debug then
			UiTextOutline(0,0,0,0)
			UiFont("regular.ttf", 32)
			UiColor(1,1,1)
			UiText("Clear Registry Keys? (only applies to this mod)")
			UiTranslate(0,32)
			UiText("Hold F2 + F3 + F4")
			UiTranslate(0,32)
			UiTextOutline(0.5, 0, 0, 1, 0.25)
			UiColor(0.75,0.25,.25)
			UiText("WARNING: This will RESET all your custom railgun settings!")
		end
	UiPop()
	UiPush()
		if disableinput then
			UiDisableInput()
		else
			UiEnableInput()
		end
	-- Railgun Accent Color Info Box
		UiTranslate(124,screenmiddley - 144)
		UiColor(0.656,0.484,0.776)
		UiRoundedRect(356,356,8)
		UiColor(0.227, 0.169, 0.271)
		UiTranslate(8,8)
		UiRect(340,340,8)
		-- Box Title
		UiFont("regular.ttf", 32)
		UiTextOutline(0, 0, 0, 1, 0.5 + accentoutline)
		UiTextShadow(.1,.1,.1, accentoutline)
		UiColor(1,1,1)
		UiTranslate(8,24)
		UiText("Railgun Accent Color")
		-- Red Value Indicator
		UiTextOutline(0, 0, 0, 1, rselect)
		UiTextShadow(.1,.1,.1, rselect)
		UiColor(1,0.25,0.25)
		UiTranslate(0,36)
		UiText("Red :")
		UiTranslate(160, 35)
			if UiBlankButton(320, 100) then
				cselecta = 1
			end
			UiTranslate(-160, -35)
		UiTranslate(70,0)
		UiText(red)
		UiTranslate(-70,0)
		-- Green Value Indicator
		UiTextOutline(0, 0, 0, 1, gselect)
		UiTextShadow(.1,.1,.1, gselect)
		UiColor(0.25,1,0.25)
		UiTranslate(0,96)
		UiText("Green :")
		UiTranslate(160, 35)
			if UiBlankButton(320, 100) then
				cselecta = 2
			end
			UiTranslate(-160, -35)
		UiTranslate(92,0)
		UiText(green)
		UiTranslate(-92,0)
		-- Blue Value Indicator
		UiTextOutline(0, 0, 0, 1, bselect)
		UiTextShadow(.1,.1,.1, bselect)
		UiColor(0.25,0.75,1)
		UiTranslate(0,96)
		UiText("Blue :")
		UiTranslate(160, 35)
			if UiBlankButton(320, 100) then
				cselecta = 3
			end
			UiTranslate(-160, -35)
		UiTranslate(76,0)
		UiText(blue)
	UiPop()
	UiPush()
	-- Railgun Accent RGB Color Sliders
	-- Slider Backgrounds
		UiTranslate(175, screenmiddley - 44)
		UiColor(0.5,0.5,0.5)
		UiRoundedRect(255,24,12)
		UiTranslate(0,96)
		UiRoundedRect(255,24,12)
		UiTranslate(0,96)
		UiRoundedRect(255,24,12)
	-- Accent Sliders
		UiTranslate(-32,-212)
		-- Red Slider
		UiColor(1,0.25,0.25)
		red, rdone = UiSlider(dot, "x", red, 0, 255)
		UiTranslate(0,96)
		UiColor(0.25,1,0.25)
		-- Green Slider
		green, gdone = UiSlider(dot, "x", green, 0, 255)
		UiTranslate(0,96)
		UiColor(0.25,0.5,1)
		-- Blue Slider
		blue, bdone = UiSlider(dot, "x", blue, 0, 255)
	UiPop()
	UiPush()
		if disableinput then
			UiDisableInput()
		else
			UiEnableInput()
		end
	-- Railgun Beam Color Info Box
		UiTranslate(563,screenmiddley - 144)
		UiColor(0.75,0.75,0.25)
		UiRoundedRect(356,356,8)
		UiColor(.25,.25,0.1)
		UiTranslate(8,8)
		UiRect(340,340,8)
		-- Box Title
		UiFont("regular.ttf", 32)
		UiTextOutline(0, 0, 0, 1, 0.5 + beamoutline)
		UiTextShadow(.1,.1,.1, beamoutline)
		UiColor(1,1,1)
		UiTranslate(8,24)
		UiText("Railgun Beam Color")
		-- Red Value Indicator
		UiTextOutline(0, 0, 0, 1, rselectb)
		UiTextShadow(.1,.1,.1, rselectb)
		UiColor(1,0.25,0.25)
		UiTranslate(0,36)
		UiText("Red :")
		UiTranslate(160, 35)
			if UiBlankButton(320, 100) then
				cselectb = 1
			end
			UiTranslate(-160, -35)
		UiTranslate(70,0)
		UiText(redb)
		UiTranslate(-70,0)
		-- Green Value Indicator
		UiTextOutline(0, 0, 0, 1, gselectb)
		UiTextShadow(.1,.1,.1, gselectb)
		UiColor(0.25,1,0.25)
		UiTranslate(0,96)
		UiText("Green :")
		UiTranslate(160, 35)
			if UiBlankButton(320, 100) then
				cselectb = 2
			end
			UiTranslate(-160, -35)
		UiTranslate(92,0)
		UiText(greenb)
		UiTranslate(-92,0)
		-- Blue Value Indicator
		UiTextOutline(0, 0, 0, 1, bselectb)
		UiTextShadow(.1,.1,.1, bselectb)
		UiColor(0.25,0.75,1)
		UiTranslate(0,96)
		UiText("Blue :")
		UiTranslate(160, 35)
			if UiBlankButton(320, 100) then
				cselectb = 3
			end
			UiTranslate(-160, -35)
		UiTranslate(76,0)
		UiText(blueb)
	UiPop()
	UiPush()
	-- Railgun Beam RGB Color Sliders
	-- Slider Backgrounds
		UiTranslate(614,screenmiddley - 44)
		UiColor(0.5,0.5,0.5)
		UiRoundedRect(255,24, 12)
		UiTranslate(0,96)
		UiRoundedRect(255,24, 12)
		UiTranslate(0,96)
		UiRoundedRect(255,24, 12)
	-- Accent Sliders
		UiTranslate(-32,-212)
		-- Red Slider
		UiColor(1,0.25,0.25)
		redb, rdoneb = UiSlider(dot, "x", redb, 0, 255)
		UiTranslate(0,96)
		-- Green Slider
		UiColor(0.25,1,0.25)
		greenb, gdoneb = UiSlider(dot, "x", greenb, 0, 255)
		UiTranslate(0,96)
		-- Blue Slider
		UiColor(0.25,0.5,1)
		blueb, bdoneb = UiSlider(dot, "x", blueb, 0, 255)
	UiPop()
	UiPush()
		if disableinput then
			UiDisableInput()
		else
			UiEnableInput()
		end
	-- Persistent Toggles Box
		UiTranslate(960,screenmiddley - 144)
		UiColor(0.75,0.25,0.25)
		UiRoundedRect(356,356,8)
		UiColor(0.35, 0.1, 0.1)
		UiTranslate(8,8)
		UiRect(340,340,8)
		-- Box Title
		UiFont("regular.ttf", 32)
		UiTextOutline(0, 0, 0, 1, 0.5 + togglesoutline)
		UiTextShadow(.1,.1,.1, togglesoutline)
		UiColor(1,1,1)
		UiTranslate(8,24)
		UiText("Persistent Toggles")
		-- Peristent Toggles
			UiTranslate(0, 30)
			UiFont("regular.ttf", 24)
			-- Ammo Type
			UiTextOutline(0, 0, 0, 1, toutbase + togoutline[1])
			UiTextShadow(.1,.1,.1, togoutline[1])
			UiText("Ammo Type :")
			UiTranslate(144, 0)
			if ammo_type == 1 then
				UiColor(.25, 0.75, 1)
				UiText("Kinetic")
			end
			if ammo_type == 2 then
				UiColor(1, .75, .25)
				UiText("Incendiary")
			end
			if ammo_type == 3 then
				UiColor(1, .5, .5)
				UiText("Explosive")
			end
			UiTranslate(-144, -12.5)
			UiTranslate(160, 0)
			if UiBlankButton(320, 25) then
				tdone[1] = true
			else
				tdone[1] = false
			end
			UiTranslate(-160, 35)
			-- Fire Power
			UiColor(1,1,1)
			UiTextOutline(0, 0, 0, 1, toutbase + togoutline[2])
			UiTextShadow(.1,.1,.1, togoutline[2])
			UiText("Fire Power :")
			UiTranslate(144, 0)
			UiText(fire_power_int/10)
			UiTranslate(-144, -12.5)
			UiTranslate(160, 0)
			if UiBlankButton(320, 25) then
				tdone[2] = true
			else
				tdone[2] = false
			end
			UiTranslate(-160, 35)
			-- Kickback Power
			UiTextOutline(0, 0, 0, 1, toutbase + togoutline[3])
			UiTextShadow(.1,.1,.1, togoutline[3])
			UiText("Kickback Power :")
			UiTranslate(192, 0)
			UiText(kb_pwr_int/10)
			UiTranslate(-192, -12.5)
			UiTranslate(160, 0)
			if UiBlankButton(320, 25) then
				tdone[3] = true
			else
				tdone[3] = false
			end
			UiTranslate(-160, 35)
			-- Hide Ui
			UiTextOutline(0, 0, 0, 1, toutbase + togoutline[4])
			UiTextShadow(.1,.1,.1, togoutline[4])
			if hideui then
				t1text = "Hidden"
				UiColor(0.65,0.65,0.65)
			else 
				t1text = "Visible"
				UiColor(1,1,1)
			end
			UiText("Ui Box")
			UiTranslate(240,0)
			UiText(t1text)
			UiTranslate(-240,0)
			UiTranslate(160, -12.5)
			if UiBlankButton(320, 25) then
				tdone[4] = true
				hideui = not hideui
			else
				tdone[4] = false
			end
			UiTranslate(-160, 35)
			-- Hide Recharge Indicator
			UiTextOutline(0, 0, 0, 1, toutbase + togoutline[5])
			UiTextShadow(.1,.1,.1, togoutline[5])
			if hiderechargeindicator then
				t3text = "Hidden"
				UiColor(0.65,0.65,0.65)
			else 
				t3text = "Visible"
				UiColor(1,1,1)
			end
			UiText("Status Indicator")
			UiTranslate(240,0)
			UiText(t3text)
			UiTranslate(-240,0)
			UiTranslate(160, -12.5)
			if UiBlankButton(320, 25) then
				tdone[5] = true
				hiderechargeindicator = not hiderechargeindicator
			else
				tdone[5] = false
			end
			UiTranslate(-160, 35)
			-- FPS Mode
			UiTextOutline(0, 0, 0, 1, toutbase + togoutline[6])
			UiTextShadow(.1,.1,.1, togoutline[6])
			if fpsmode then
				t2text = "Enabled"
				UiColor(1,0.25,0.25)
			else 
				t2text = "Disabled"
				UiColor(0.65,0.65,0.65)
			end
			UiText("FPS Mode")
			UiTranslate(240,0)
			UiText(t2text)
			UiTranslate(-240,0)
			UiTranslate(160, -12.5)
			if UiBlankButton(320, 25) then
				tdone[6] = true
				fpsmode = not fpsmode
			else
				tdone[6] = false
			end
			UiTranslate(-160, 35)
			-- Quickfire
			UiTextOutline(0, 0, 0, 1, toutbase + togoutline[7])
			UiTextShadow(.1,.1,.1, togoutline[7])
			if quickfire then
				t4text = "Enabled"
				UiColor(1,1,0)
			else 
				t4text = "Disabled"
				UiColor(0.65,0.65,0.65)
			end
			UiText("Quickfire")
			UiTranslate(240,0)
			UiText(t4text)
			UiTranslate(-240,0)
			UiTranslate(160, -12.5)
			if UiBlankButton(320, 25) then
				tdone[7] = true
				quickfire = not quickfire
			else
				tdone[7] = false
			end
			UiTranslate(-160, 35)
			-- Unlimited Kickback (Not a great idea tbh, but really funny)
			UiTextOutline(0, 0, 0, 1, toutbase + togoutline[8])
			UiTextShadow(.1,.1,.1, togoutline[8])
			if kb_unlimit then
				t5text = "Enabled"
				UiColor(0,1,0)
			else 
				t5text = "Disabled"
				UiColor(0.65,0.65,0.65)
			end
			UiText("Unlimited Kickback")
			UiTranslate(240,0)
			UiText(t5text)
			UiTranslate(-240,0)
			UiTranslate(160, -12.5)
			if UiBlankButton(320, 25) then
				tdone[8] = true
				kb_unlimit = not kb_unlimit
			else
				tdone[8] = false
			end
			UiTranslate(-160, 35)
			-- Light Beam Length
			UiTextOutline(0, 0, 0, 1, toutbase + togoutline[9])
			UiTextShadow(.1,.1,.1, togoutline[9])
			if long_lightbeam then
				t6text = "Enabled"
				UiColor(1,1,1)
			else 
				t6text = "Disabled"
				UiColor(0.65,0.65,0.65)
			end
			UiText("Long Lightbeam")
			UiTranslate(240,0)
			UiText(t6text)
			UiTranslate(-240,0)
			UiTranslate(160, -12.5)
			if UiBlankButton(320, 25) then
				tdone[9] = true
				long_lightbeam = not long_lightbeam
			else
				tdone[9] = false
			end
			UiTranslate(-160, 35)
			-- Debug Default
			UiTextOutline(0, 0, 0, 1, toutbase + togoutline[10])
			UiTextShadow(.1,.1,.1, togoutline[10])
			if debug_default then
				t7text = "Enabled"
				UiColor(0.65,0.5,1)
			else 
				t7text = "Disabled"
				UiColor(0.65,0.65,0.65)
			end
			UiText("Debug Mode")
			UiTranslate(240,0)
			UiText(t7text)
			UiTranslate(-240,0)
			UiTranslate(160, -12.5)
			if UiBlankButton(320, 25) then
				tdone[10] = true
				debug_default = not debug_default
			else
				tdone[10] = false
			end
			UiTranslate(-160, 35)
			-- Doom Mode
			UiTextOutline(0, 0, 0, 1, toutbase + togoutline[11])
			UiTextShadow(.1,.1,.1, togoutline[11])
			if doommode then
				t8text = "Enabled"
				UiColor(0.5,0.75,1)
			else 
				t8text = "Disabled"
				UiColor(0.65,0.65,0.65)
			end
			UiText("Exp ThirdPerson Mode")
			UiTranslate(240,0)
			UiText(t8text)
			UiTranslate(-240,0)
			UiTranslate(160, -12.5)
			if UiBlankButton(320, 25) then
				tdone[11] = true
				doommode = not doommode
			else
				tdone[11] = false
			end
			UiTranslate(-160, 35)
			-- Doom Mode
			UiTextOutline(0, 0, 0, 1, toutbase + togoutline[12])
			UiTextShadow(.1,.1,.1, togoutline[12])
			if falloff then
				t9text = "Enabled"
				UiColor(0.34,0.34,1)
			else 
				t9text = "Disabled"
				UiColor(0.65,0.65,0.65)
			end
			UiText("Beam Falloff Mode")
			UiTranslate(240,0)
			UiText(t9text)
			UiTranslate(-240,0)
			UiTranslate(160, -12.5)
			if UiBlankButton(320, 25) then
				tdone[12] = true
				falloff = not falloff
			else
				tdone[12] = false
			end
			UiTranslate(-160, 35)
	UiPop()
	UiPush()
		if disableinput then
			UiDisableInput()
		else
			UiEnableInput()
		end
	-- Keybinds Box
		UiTranslate(1346,screenmiddley - 144)
		UiColor(0.50,0.50,0.50)
		UiRoundedRect(445,356,8)
		UiColor(0.25, 0.25, 0.25)
		UiTranslate(8,8)
		UiRect(429,340,8)
		-- Box Title
		UiFont("regular.ttf", 32)
		UiTextOutline(0, 0, 0, 1, 0.5 + keybindsoutline)
		UiTextShadow(.1,.1,.1, keybindsoutline)
		UiColor(1,1,1)
		UiTranslate(8,24)
		UiText("Keybinds")
		UiFont("regular.ttf", 24)
		UiTranslate(0, 25)
		-- Ammo Select Keybind
		UiTextOutline(0, 0, 0, 1, koutbase + koutline[1])
		UiTextShadow(.1,.1,.1, koutline[1])
		if kinput[1] == true then
			if not waitforinput then
				kstring1 = string.upper(tostring(keybind_ammoselect))
			else
				kstring1 = blink_cursor()
			end
		else
				kstring1 = string.upper(tostring(keybind_ammoselect))
		end
		UiText("Ammo Select  ——>  "..kstring1)
		UiTranslate(96, -10)
		UiTranslate(104, 0)
		if UiBlankButton(400, 20) or kinput[1] == true then
			keybind_prev[1] = tostring(keybind_ammoselect)
			kdone[1] = true
			kinput[1] = true
			disableinput = true
			waitforinput = true
		else
			kdone[1] = false
		end
		UiTranslate(-200, 31.5)
		-- Power Level Add Keybind
		UiTextOutline(0, 0, 0, 1, koutbase + koutline[2])
		UiTextShadow(.1,.1,.1, koutline[2])
		if kinput[2] == true then
			if not waitforinput then
				kstring2 = string.upper(tostring(keybind_powerlvl_plus))
			else
				kstring2 = blink_cursor()
			end
		else
			kstring2 = string.upper(tostring(keybind_powerlvl_plus))
		end
		UiText("Fire Power Plus  ——>  "..kstring2)
		UiTranslate(96, -10)
		UiTranslate(104, 0)
		if UiBlankButton(400, 20) or kinput[2] == true then
			keybind_prev[2] = tostring(keybind_powerlvl_plus)
			kdone[2] = true
			kinput[2] = true
			disableinput = true
			waitforinput = true
		else
			kdone[2] = false
		end
		UiTranslate(-200, 31.5)
		-- Power Level Minus Keybind
		UiTextOutline(0, 0, 0, 1, koutbase + koutline[3])
		UiTextShadow(.1,.1,.1, koutline[3])
		if kinput[3] == true then
			if not waitforinput then
				kstring3 = string.upper(tostring(keybind_powerlvl_minus))
			else
				kstring3 = blink_cursor()
			end
		else
			kstring3 = string.upper(tostring(keybind_powerlvl_minus))
		end
		UiText("Fire Power Minus  ——>  "..kstring3)
		UiTranslate(96, -10)
		UiTranslate(104, 0)
		if UiBlankButton(400, 20) or kinput[3] then
			keybind_prev[3] = tostring(keybind_powerlvl_minus)
			kdone[3] = true
			kinput[3] = true
			disableinput = true
			waitforinput = true
		else
			kdone[3] = false
		end
		UiTranslate(-200, 31.5)
		-- Kickback Plus Keybind
		UiTextOutline(0, 0, 0, 1, koutbase + koutline[4])
		UiTextShadow(.1,.1,.1, koutline[4])
		if kinput[4] == true then
			if not waitforinput then
				kstring4 = string.upper(tostring(keybind_kickback_plus))
			else
				kstring4 = blink_cursor()
			end
		else
			kstring4 = string.upper(tostring(keybind_kickback_plus))
		end
		UiText("Spread Plus  ——>  "..kstring4)
		UiTranslate(96, -10)
		UiTranslate(104, 0)
		if UiBlankButton(400, 20) or kinput[4] then
			keybind_prev[4] = tostring(keybind_kickback_plus)
			kdone[4] = true
			kinput[4] = true
			disableinput = true
			waitforinput = true
		else
			kdone[4] = false
		end
		UiTranslate(-200, 31.5)
		-- Kickback Minus Keybind
		UiTextOutline(0, 0, 0, 1, koutbase + koutline[5])
		UiTextShadow(.1,.1,.1, koutline[5])
		if kinput[5] == true then
			if not waitforinput then
				kstring5 = string.upper(tostring(keybind_kickback_minus))
			else
				kstring5 = blink_cursor()
			end
		else
			kstring5 = string.upper(tostring(keybind_kickback_minus))
		end
		UiText("Spread Minus  ——>  "..kstring5)
		UiTranslate(96, -10)
		UiTranslate(104, 0)
		if UiBlankButton(400, 20) or kinput[5] then
			keybind_prev[5] = tostring(keybind_kickback_minus)
			kdone[5] = true
			kinput[5] = true
			disableinput = true
			waitforinput = true
		else
			kdone[5] = false
		end
		UiTranslate(-200, 31.5)
		-- Hide Ui Box Keybind
		UiTextOutline(0, 0, 0, 1, koutbase + koutline[6])
		UiTextShadow(.1,.1,.1, koutline[6])
		if kinput[6] == true then
			if not waitforinput then
				kstring6 = string.upper(tostring(keybind_hideui))
			else
				kstring6 = blink_cursor()
			end
		else
			kstring6 = string.upper(tostring(keybind_hideui))
		end
		UiText("Hide Ui Box  ——>  "..kstring6)
		UiTranslate(96, -10)
		UiTranslate(104, 0)
		if UiBlankButton(400, 20) or kinput[6] then
			keybind_prev[6] = tostring(keybind_hideui)
			kdone[6] = true
			kinput[6] = true
			disableinput = true
			waitforinput = true
		else
			kdone[6] = false
		end
		UiTranslate(-200, 31.5)
		-- FPS Mode Keybind
		UiTextOutline(0, 0, 0, 1, koutbase + koutline[7])
		UiTextShadow(.1,.1,.1, koutline[7])
		if kinput[7] == true then
			if not waitforinput then
				kstring7 = string.upper(tostring(keybind_fpsmode))
			else
				kstring7 = blink_cursor()
			end
		else
			kstring7 = string.upper(tostring(keybind_fpsmode))
		end
		UiText("FPS Mode  ——>  "..kstring7)
		UiTranslate(96, -10)
		UiTranslate(104, 0)
		if UiBlankButton(400, 20) or kinput[7] then
			keybind_prev[7] = tostring(keybind_fpsmode)
			kdone[7] = true
			kinput[7] = true
			disableinput = true
			waitforinput = true
		else
			kdone[7] = false
		end
		UiTranslate(-200, 31.5)
		-- Hide Status Indicator Keybind
		UiTextOutline(0, 0, 0, 1, koutbase + koutline[8])
		UiTextShadow(.1,.1,.1, koutline[8])
		if kinput[8] == true then
			if not waitforinput then
				kstring8 = string.upper(tostring(keybind_hidestatus))
			else
				kstring8 = blink_cursor()
			end
		else
			kstring8 = string.upper(tostring(keybind_hidestatus))
		end
		UiText("Hide Status Indicator  ——>  "..kstring8)
		UiTranslate(96, -10)
		UiTranslate(104, 0)
		if UiBlankButton(400, 20) or kinput[8] then
			keybind_prev[8] = tostring(keybind_hidestatus)
			kdone[8] = true
			kinput[8] = true
			disableinput = true
			waitforinput = true
		else
			kdone[8] = false
		end
		UiTranslate(-200, 31.5)
		-- Quickfire Mode Keybind
		UiTextOutline(0, 0, 0, 1, koutbase + koutline[9])
		UiTextShadow(.1,.1,.1, koutline[9])
		if kinput[9] == true then
			if not waitforinput then
				kstring9 = string.upper(tostring(keybind_quickfire))
			else
				kstring9 = blink_cursor()
			end
		else
			kstring9 = string.upper(tostring(keybind_quickfire))
		end
		UiText("Quickfire Mode ——>  "..kstring9)
		UiTranslate(96, -10)
		UiTranslate(104, 0)
		if UiBlankButton(400, 20) or kinput[9] then
			keybind_prev[9] = tostring(keybind_quickfire)
			kdone[9] = true
			kinput[9] = true
			disableinput = true
			waitforinput = true
		else
			kdone[9] = false
		end
		UiTranslate(-200, 31.5)
		-- Unlimited Kickback Hold Keybind
		UiTextOutline(0, 0, 0, 1, koutbase + koutline[10])
		UiTextShadow(.1,.1,.1, koutline[10])
		if kinput[10] == true then
			if not waitforinput then
				kstring10 = string.upper(tostring(keybind_unlimitkb_1))
			else
				kstring10 = blink_cursor()
			end
		else
			kstring10 = string.upper(tostring(keybind_unlimitkb_1))
		end
		UiText("Unlimted Kickback Key 1  ——>  "..kstring10)
		UiTranslate(96, -10)
		UiTranslate(104, 0)
		if UiBlankButton(400, 20) or kinput[10] then
			keybind_prev[10] = tostring(keybind_unlimitkb_1)
			kdone[10] = true
			kinput[10] = true
			disableinput = true
			waitforinput = true
		else
			kdone[10] = false
		end
		UiTranslate(-200, 31.5)
		-- Unlimited Kickback Press Keybind
		UiTextOutline(0, 0, 0, 1, koutbase + koutline[11])
		UiTextShadow(.1,.1,.1, koutline[11])
		if kinput[11] == true then
			if not waitforinput then
				kstring11 = string.upper(tostring(keybind_unlimitkb_2))
			else
				kstring11 = blink_cursor()
			end
		else
			kstring11 = string.upper(tostring(keybind_unlimitkb_2))
		end
		UiText("Unlimted Kickback Key 2  ——>  "..kstring11)
		UiTranslate(96, -10)
		UiTranslate(104, 0)
		if UiBlankButton(400, 20) or kinput[11] then
			keybind_prev[11] = tostring(keybind_unlimitkb_2)
			kdone[11] = true
			kinput[11] = true
			disableinput = true
			waitforinput = true
		else
			kdone[11] = false
		end
		UiTranslate(-200, 31.5)
		-- Debug Mode Keybind
		UiTextOutline(0, 0, 0, 1, koutbase + koutline[12])
		UiTextShadow(.1,.1,.1, koutline[12])
		if kinput[12] == true then
			if not waitforinput then
				kstring12 = string.upper(tostring(keybind_debug))
			else
				kstring12 = blink_cursor()
			end
		else
			kstring12 = string.upper(tostring(keybind_debug))
		end
		UiText("Debug Mode  ——>  "..kstring12)
		UiTranslate(96, -10)
		UiTranslate(104, 0)
		if UiBlankButton(400, 20) or kinput[12] then
			keybind_prev[12] = tostring(keybind_debug)
			kdone[12] = true
			kinput[12] = true
			disableinput = true
			waitforinput = true
		else
			kdone[12] = false
		end
		UiTranslate(-200, 31.5)
		-- Multiplayer Balance Testing Keybind 1
		UiTextOutline(0, 0, 0, 1, koutbase + koutline[13])
		UiTextShadow(.1,.1,.1, koutline[13])
		if kinput[13] == true then
			if not waitforinput then
				kstring13 = string.upper(tostring(keybind_multiplayertest_1))
			else
				kstring13 = blink_cursor()
			end
		else
			kstring13 = string.upper(tostring(keybind_multiplayertest_1))
		end
		UiText("Multiplayer Balance Test Key 1 ——>  "..kstring13)
		UiTranslate(96, -10)
		UiTranslate(104, 0)
		if UiBlankButton(400, 20) or kinput[13] then
			keybind_prev[13] = tostring(keybind_multiplayertest_1)
			kdone[13] = true
			kinput[13] = true
			disableinput = true
			waitforinput = true
		else
			kdone[13] = false
		end
		UiTranslate(-200, 31.5)
		-- Multiplayer Balance Testing Keybind 2
		UiTextOutline(0, 0, 0, 1, koutbase + koutline[14])
		UiTextShadow(.1,.1,.1, koutline[14])
		if kinput[14] == true then
			if not waitforinput then
				kstring14 = string.upper(tostring(keybind_multiplayertest_2))
			else
				kstring14 = blink_cursor()
			end
		else
			kstring14 = string.upper(tostring(keybind_multiplayertest_2))
		end
		UiText("Multiplayer Balance Test Key 2 ——>  "..kstring14)
		UiTranslate(96, -10)
		UiTranslate(104, 0)
		if UiBlankButton(400, 20) or kinput[14] then
			keybind_prev[14] = tostring(keybind_multiplayertest_2)
			kdone[14] = true
			kinput[14] = true
			disableinput = true
			waitforinput = true
		else
			kdone[14] = false
		end
		UiTranslate(-200, 31.5)
	UiPop()
	UiPush()
		if debug and gridtoggle then
			UiImage(grid)
			UiTranslate(960,32)
			UiAlign("center")
			UiFont("regular.ttf", 32)
			UiText("Ui Design Reference Grid")
			UiTranslate(0,32)
			UiText("Blue = 128 pixels")
			UiTranslate(0,32)
			UiText("Green = 64 pixels")
			UiTranslate(0,32)
			UiText("Red = 32 pixels")
		end
	UiPop()
end

function keybind_invalidate(key)
	if string.lower(key) == tostring("super") or string.lower(key) == tostring(GetString("game.input.jump"))  or string.lower(key) == tostring(GetString('game.input.map')) or string.lower(key) == tostring(GetString('game.input.up')) or string.lower(key) == tostring(GetString('game.input.down')) or string.lower(key) == tostring(GetString('game.input.left')) or string.lower(key) == tostring(GetString('game.input.right')) or string.lower(key) == tostring(GetString('game.input.crouch')) or string.lower(key) == tostring(GetString('game.input.camera_view')) or string.lower(key) == tostring(GetString('game.input.flashlight')) or string.lower(key) == tostring(GetString('game.input.interact')) or string.lower(key) == tostring(GetString('game.input.pause')) or string.lower(key) == tostring("1")  or string.lower(key) == tostring("2") or string.lower(key) == tostring("3") or string.lower(key) == tostring("4") or string.lower(key) == tostring("5") or string.lower(key) == tostring("6") then
		authorized = false
	else
		authorized = true
	end
	return authorized
end

function blink_cursor()
	local trm = GetTime() % 2
	if (trm < 0.5) or (trm > 1 and trm < 1.5) then
		cursor = "_"
	else
		cursor = " "
	end
	return cursor
end

function button_click(num)
	if GetTime() <= buttontime[num] then
		buttondone[num] = true
	else
		buttondone[num] = false
		buttonclicked[num] = false
	end
end

function v034_defaults()
	SetBool("savegame.mod.multi_test", false)
   	SetInt("savegame.mod.red", 0)
	SetInt("savegame.mod.green", 255)
	SetInt("savegame.mod.blue", 0)
	SetInt("savegame.mod.red_beam", 255)
	SetInt("savegame.mod.green_beam", 255)
	SetInt("savegame.mod.blue_beam", 255)
end

function v038X_defaults()
	SetInt("savegame.mod.ammo_type", 1)
	SetString("savegame.mod.fire_power", 1)
	SetString("savegame.mod.kb_pwr", 0.45)
	SetBool("savegame.mod.hideui", false)
	SetBool("savegame.mod.fpsmode", false)
	SetBool("savegame.mod.hiderechargeindicator", false)
	SetBool("savegame.mod.quickfire", false)
	SetBool("savegame.mod.falloff", false)
	SetBool("savegame.mod.kb_unlimit", false)
	SetBool("savegame.mod.long_lightbeam", false)
	SetBool("savegame.mod.debug_default", false)
	SetBool("savegame.mod.unlimitPower", false)
end

function v041_defaults()
	SetString("savegame.mod.keybind_ammoselect", "R")
	SetString("savegame.mod.keybind_powerlvl_plus", "uparrow")
	SetString("savegame.mod.keybind_powerlvl_minus", "downarrow")
	SetString("savegame.mod.keybind_kickback_plus", "rightarrow")
	SetString("savegame.mod.keybind_kickback_minus", "leftarrow")
	SetString("savegame.mod.keybind_hideui", "H")
	SetString("savegame.mod.keybind_fpsmode", "f6")
	SetString("savegame.mod.keybind_hidestatus", "f5")
	SetString("savegame.mod.keybind_quickfire", "f7")
	SetString("savegame.mod.keybind_falloff", "f8")
	SetString("savegame.mod.keybind_unlimitkb_1", "f9")
	SetString("savegame.mod.keybind_unlimitkb_2", "f10")
	SetString("savegame.mod.keybind_debug", "f1")
	SetString("savegame.mod.keybind_multiplayertest_1", "alt")
	SetString("savegame.mod.keybind_multiplayertest_2", "M")
	SetBool("savegame.mod.haptictoggle", true)
end

function Grab_Registry_Keys()
	LoadColorValues()
	LoadToggles()
	LoadKeybinds()
end

function LoadColorValues()
	true_multiplayer_test = GetBool("savegame.mod.multi_test")
	red = GetInt("savegame.mod.red")
	green = GetInt("savegame.mod.green")
	blue = GetInt("savegame.mod.blue")
	redb = GetInt("savegame.mod.red_beam")
	greenb = GetInt("savegame.mod.green_beam")
	blueb = GetInt("savegame.mod.blue_beam")
end

function LoadToggles()
	ammo_type = GetInt("savegame.mod.ammo_type")
	fire_power_int = GetString("savegame.mod.fire_power")*10
	kb_pwr_int = GetString("savegame.mod.kb_pwr")*10
	hideui = GetBool("savegame.mod.hideui")
	fpsmode = GetBool("savegame.mod.fpsmode")
	hiderechargeindicator = GetBool("savegame.mod.hiderechargeindicator")
	quickfire = GetBool("savegame.mod.quickfire")
	falloff = GetBool("savegame.mod.falloff")
	kb_unlimit = GetBool("savegame.mod.kb_unlimit")
	long_lightbeam = GetBool("savegame.mod.long_lightbeam")
	debug_default = GetBool("savegame.mod.debug_default")
	doommode = GetBool("savegame.mod.doommode")
	unlimitPower = GetBool("savegame.mod.unlimitPower")
end

function LoadKeybinds()
	keybind_ammoselect = GetString("savegame.mod.keybind_ammoselect")
	keybind_powerlvl_plus = GetString("savegame.mod.keybind_powerlvl_plus")
	keybind_powerlvl_minus = GetString("savegame.mod.keybind_powerlvl_minus")
	keybind_kickback_minus = GetString("savegame.mod.keybind_kickback_minus")
	keybind_kickback_plus = GetString("savegame.mod.keybind_kickback_plus")
	keybind_hideui = GetString("savegame.mod.keybind_hideui")
	keybind_fpsmode = GetString("savegame.mod.keybind_fpsmode")
	keybind_hidestatus = GetString("savegame.mod.keybind_hidestatus")
	keybind_quickfire = GetString("savegame.mod.keybind_quickfire")
	keybind_falloff = GetString("savegame.mod.keybind_falloff")
	keybind_unlimitkb_1 = GetString("savegame.mod.keybind_unlimitkb_1")
	keybind_unlimitkb_2 = GetString("savegame.mod.keybind_unlimitkb_2")
	keybind_debug = GetString("savegame.mod.keybind_debug")
	keybind_multiplayertest_1 = GetString("savegame.mod.keybind_multiplayertest_1")
	keybind_multiplayertest_2 = GetString("savegame.mod.keybind_multiplayertest_2")
end

function Save_Settings()
	SetBool("savegame.mod.multi_test", true_multiplayer_test)
	SetInt("savegame.mod.red", red)
	SetInt("savegame.mod.green", green)
	SetInt("savegame.mod.blue", blue)
	SetInt("savegame.mod.red_beam", redb)
	SetInt("savegame.mod.green_beam", greenb)
	SetInt("savegame.mod.blue_beam", blueb)
	--Persitent Toggles/settings (introduced in v0.3.8)
	SetInt("savegame.mod.ammo_type", ammo_type)
	SetString("savegame.mod.fire_power", fire_power_int/10)
	SetString("savegame.mod.kb_pwr", kb_pwr_int/10)
	SetBool("savegame.mod.hideui", hideui)
	SetBool("savegame.mod.fpsmode", fpsmode)
	SetBool("savegame.mod.hiderechargeindicator", hiderechargeindicator)
	SetBool("savegame.mod.quickfire", quickfire)
	SetBool("savegame.mod.kb_unlimit", kb_unlimit)
	SetBool("savegame.mod.long_lightbeam", long_lightbeam)
	SetBool("savegame.mod.debug_default", debug_default)
	-- all in le head
	SetBool("savegame.mod.doommode", doommode)
	-- not in le head
	SetBool("savegame.mod.unlimitPower", unlimitPower)
	-- v0.4.1.0
	SetString("savegame.mod.keybind_ammoselect", keybind_ammoselect)
	SetString("savegame.mod.keybind_powerlvl_plus", keybind_powerlvl_plus)
	SetString("savegame.mod.keybind_powerlvl_minus", keybind_powerlvl_minus)
	SetString("savegame.mod.keybind_kickback_plus", keybind_kickback_plus)
	SetString("savegame.mod.keybind_kickback_minus", keybind_kickback_minus)
	SetString("savegame.mod.keybind_hideui", keybind_hideui)
	SetString("savegame.mod.keybind_fpsmode", keybind_fpsmode)
	SetString("savegame.mod.keybind_hidestatus", keybind_hidestatus)
	SetString("savegame.mod.keybind_quickfire", keybind_quickfire)
	SetString("savegame.mod.keybind_unlimitkb_1", keybind_unlimitkb_1)
	SetString("savegame.mod.keybind_unlimitkb_2", keybind_unlimitkb_2)
	SetString("savegame.mod.keybind_debug", keybind_debug)
	SetString("savegame.mod.keybind_multiplayertest_1", keybind_multiplayertest_1)
	SetString("savegame.mod.keybind_multiplayertest_2", keybind_multiplayertest_2)
	SetBool("savegame.mod.falloff", falloff)
	Menu()
end

function ClearKey1()
	ClearKey("savegame.mod.version")
	ClearKey("savegame.mod.multi_test")
	ClearKey("savegame.mod.red")
	ClearKey("savegame.mod.green")
	ClearKey("savegame.mod.blue")
	ClearKey("savegame.mod.red_beam")
	ClearKey("savegame.mod.green_beam")
	ClearKey("savegame.mod.blue_beam")
	ClearKey("savegame.mod.ammo_type")
	ClearKey("savegame.mod.fire_power")
	ClearKey("savegame.mod.kb_pwr")
	ClearKey("savegame.mod.hideui")
	ClearKey("savegame.mod.fpsmode")
	ClearKey("savegame.mod.hiderechargeindicator")
	ClearKey("savegame.mod.quickfire")
	ClearKey("savegame.mod.falloff")
	ClearKey("savegame.mod.kb_unlimit")
	ClearKey("savegame.mod.long_lightbeam")
	ClearKey("savegame.mod.debug_default")
	ClearKey("savegame.mod.doommode")
	ClearKey("savegame.mod.unlimitPower")
	ClearKey("savegame.mod.keybind_ammoselect")
	ClearKey("savegame.mod.keybind_powerlvl_plus")
	ClearKey("savegame.mod.keybind_powerlvl_minus")
	ClearKey("savegame.mod.keybind_kickback_plus")
	ClearKey("savegame.mod.keybind_kickback_minus")
	ClearKey("savegame.mod.keybind_hideui")
	ClearKey("savegame.mod.keybind_fpsmode")
	ClearKey("savegame.mod.keybind_hidestatus")
	ClearKey("savegame.mod.keybind_quickfire")
	ClearKey("savegame.mod.keybind_falloff")
	ClearKey("savegame.mod.keybind_unlimitkb_1")
	ClearKey("savegame.mod.keybind_unlimitkb_2")
	ClearKey("savegame.mod.keybind_debug")
	ClearKey("savegame.mod.keybind_multiplayertest_1")
	ClearKey("savegame.mod.keybind_multiplayertest_2")
	ClearKey("savegame.mod.haptictoggle")
	Menu()
end

function DebugColor()
	DebugWatch("cselecta", cselecta)
	DebugWatch("cselectb", cselectb)
	DebugWatch("red", red)
	DebugWatch("green", green)
	DebugWatch("blue", blue)
	DebugWatch("redb", redb)
	DebugWatch("greenb", greenb)
	DebugWatch("blueb", blueb)
	DebugWatch("rdone", rdone)
	DebugWatch("gdone", gdone)
	DebugWatch("bdone", bdone)
	DebugWatch("rdoneb", rdoneb)
	DebugWatch("gdoneb", gdoneb)
	DebugWatch("bdoneb", bdoneb)
end

function DebugToggles()
	DebugWatch("tselect", tselect)
	DebugWatch("togoutline", togoutline)
	DebugWatch("tdone", tdone)
	DebugWatch("true_multiplayer_test", true_multiplayer_test)
	DebugWatch("savegame.mod.multi_test", GetBool("savegame.mod.multi_test"))
	DebugWatch("ammo_type", ammo_type)
	DebugWatch("fire_power_int", fire_power_int)
	DebugWatch("kb_pwr_int", kb_pwr_int)
	DebugWatch("hideui", hideui)
	DebugWatch("fpsmode", fpsmode)
	DebugWatch("hiderechargeindicator", hiderechargeindicator)
	DebugWatch("quickfire", quickfire)
	DebugWatch("kb_unlimit", kb_unlimit)
	DebugWatch("long_lightbeam", long_lightbeam)
	DebugWatch("debug_default", debug_default)
	DebugWatch("doommode", doommode)
end

function DebugKeybinds()
	local name = InputLastPressedKey()
	if string.len(name) > 0 then
		DebugPrint(name) 
	end
	DebugWatch("keybind_ammoselect", keybind_ammoselect)
	DebugWatch("keybind_powerlvl_plus", keybind_powerlvl_plus)
	DebugWatch("keybind_powerlvl_minus", keybind_powerlvl_minus)
	DebugWatch("keybind_kickback_plus", keybind_kickback_plus)
	DebugWatch("keybind_kickback_minus", keybind_kickback_minus)
	DebugWatch("keybind_hideui", keybind_hideui)
	DebugWatch("keybind_fpsmode", keybind_fpsmode)
	DebugWatch("keybind_hidestatus", keybind_hidestatus)
	DebugWatch("keybind_quickfire", keybind_quickfire)
	DebugWatch("keybind_falloff", keybind_falloff)
	DebugWatch("keybind_unlimitkb_1", keybind_unlimitkb_1)
	DebugWatch("keybind_unlimitkb_2", keybind_unlimitkb_2)
	DebugWatch("keybind_debug", keybind_debug)
	DebugWatch("keybind_multiplayertest_1", keybind_multiplayertest_1)
	DebugWatch("keybind_multiplayertest_2", keybind_multiplayertest_2)
	DebugWatch("disableinput", disableinput)
	DebugWatch("cursor", GetTime() % 2)
	DebugWatch("time", GetTime())
	DebugWatch("kinput", kinput)
	DebugWatch("kselect", kselect)
	DebugWatch("keybind_invald", keybind_invald)
	DebugWatch("keybind_wait", keybind_wait)
	DebugWatch("keybind_kinputprev", keybind_kinputprev)
	DebugWatch("keybind_prev", keybind_prev)
	DebugWatch("keybind_previous", keybind_previous)
end

function DebugReset()
	DebugWatch("buttonclicked", buttonclicked)
	DebugWatch("buttondone", buttondone)
	DebugWatch("buttontime", buttontime)
end
