-- This script will run on all levels when mod is active.
-- Modding documentation: http://teardowngame.com/modding
-- API reference: http://teardowngame.com/modding/api.html
-- LUA 5.1 reference: https://www.lua.org/manual/5.1/

-- Original mod "ORIS RAILGUN" by Dzage and Caped Karnage
-- https://steamcommunity.com/sharedfiles/filedetails/?id=2943418788

-- Kickback code from My Cresta's Hook Shotgun
-- https://steamcommunity.com/sharedfiles/filedetails/?id=2412621869

-- Teardown Discord for helping me figure out how the hell to do basic crap
-- https://discord.gg/teardown

-- Glitch Productions and Liam Vicker's "Murder Drones" for years of entertainment
-- https://www.glitchprod.com/murder-drones

-- Reskin and (eventual) Overhaul by Mx. Pikachu The Silly Gal
-- https://steamcommunity.com/sharedfiles/filedetails/?id=3485586841
-- Patch version v0.5.0

-- Development Hardware/Software Context
-- Edited using Geany on Ubuntu 24.04.4 LTS (Prev. Notepad++ on Win. 11)
-- UPDATE: Now edited using Kate on Bazzite
-- Teardown ran using Valve's Proton compatability layer
-- Display: 1920x1080 @ 144hz HDR
-- Motherboard: GIGA-BYTE B650 GAMING X AX V2
-- CPU: AMD Ryzen™ 7 7700X
-- RAM: 32 GB DDR5, G.Skill F5-6000J3636F16GX2-FX5 (2x16 GB)
-- GPU: NVIDIA GeForce RTX 3070 by EVGA
-- VRAM: 8 GB

-- I am SO sorry to whoever tries to read this code. Frankly it's a mess.
-- If you couldn't tell, I never took a class or course on programming lmao
-- I don't know shit about fuck

function init()
	-- Basic Tool Setup
	RegisterTool("ORIS_Railgun_MD_Reskin", "Uzi's Railgun", "MOD/Assets/Models/Railgun.vox",3)
	SetBool("game.tool.ORIS_Railgun_MD_Reskin.enabled", true)
	-- Defining used fonts
	mono_bold = "MOD/Assets/VFX/fonts/roboto_static/RobotoMono-Bold.ttf"
	console = "MOD/Assets/VFX/fonts/pixeldroidConsoleRegular.ttf"
	dseg14 = "MOD/Assets/VFX/fonts/DSEG14Modern-BoldItalic.ttf"
	regular = "regular.ttf"
	soundchecked = false
	-- Loading sounds
	FireSND = LoadSound("MOD/Assets/SFX/Fire.ogg")
	LaserSND = LoadSound("MOD/Assets/SFX/Laser.ogg")
	--ChargeSND = LoadSound("MOD/Assets/SFX/Charge.ogg")
	UiReadyEndSND = "MOD/Assets/SFX/ReadyEnd.ogg"
	UiBeepSND = "MOD/Assets/SFX/Beep.ogg"
	UiReadySND = "MOD/Assets/SFX/hightech_confirm3.ogg"
	ExplodeSND = LoadSound("MOD/Assets/SFX/hl2_explode_4.ogg")
	SteamReleaseSND = LoadSound("MOD/Assets/SFX/Steam-hiss-sound-effect.ogg")
	UiAmmoTypeSND = "MOD/Assets/SFX/ui-click-menu-modern-interface-select-small-01.ogg"
	Kicback_AdjustSND = "MOD/Assets/SFX/mechanical-plastic-click-06.ogg"
	Railgun_FailSND = LoadSound("MOD/Assets/SFX/railgun_explode.ogg")
	balarmSND = LoadSound("MOD/Assets/SFX/brig-alarm.ogg")
	PlaceholderSND = LoadSound("MOD/Assets/SFX/kl_fiddlesticks.ogg")
	CrackleSND = LoadSound("MOD/Assets/SFX/sparkfm_tri-90_sin-110.ogg")
	firebeam = 0
	kickback_falloff = 0
	-- haptics
	haptic_effect = CreateHaptic(1, 1, 0, 0)
	-- rando stuff
	--indicator_pvel_triggered = false
	debug_indicator = false
	
	-- DO UPDATE CHANGES HERE FROM NOW ON
	-- Updating/Setting Version String
	if ((GetString("savegame.mod.version")) == nil or (GetString("savegame.mod.version")) == '') then
		SetString("savegame.mod.version", "v0.5.0.3")
	end
	if GetString("savegame.mod.version") == "v0.3.9.0" then
		ClearKey("savegame.mod.fov_zoom")
		SetBool("savegame.mod.doommode", false)
	end
	if not (string.sub(GetString("savegame.mod.version"),1,4) == "v0.5") then
		SetString("savegame.mod.kb_pwr", 0.45)
		SetString("savegame.mod.fire_power", 1)
	end
	if not GetString("savegame.mod.version") == "v0.5.0.3" then
		SetString("savegame.mod.version", "v0.5.0.3")
	end
	-- v0.3.4 Settings
	if ((GetString("savegame.mod.highlight_color")) == nil or (GetString("savegame.mod.highlight_color")) == '') then
		v034_defaults()
	end
	-- v0.3.8.X Toggles
	if ((GetString("savegame.mod.fire_power")) == nil or (GetString("savegame.mod.fire_power")) == '') then
		v038X_defaults()
	end
	-- Experimental Unlimited Power Toggle
	if ((GetString("savegame.mod.unlimitPower")) == nil or (GetString("savegame.mod.unlimitPower")) == '') then
		SetBool("savegame.mod.unlimitPower", false)
	end
	-- v0.4.1 Defaults (Keybinds)
	if ((GetString("savegame.mod.keybind_ammoselect")) == nil or (GetString("savegame.mod.keybind_ammoselect")) == '') then
		v041_defaults()
	end
	-- v0.5.X Defaults (Keybinds)
	if ((GetString("savegame.mod.ui_font")) == nil or (GetString("savegame.mod.ui_font")) == '') then
		v05X_defaults()
	end
	-- Placeholders for when multiplayer is implemented
	--if [Grab Multiplayer] then
		--multiplayer = 1
		--else
		--multiplayer = 0
	--end
	
	-- Host Player Admin Settings
	-- (????)
	
	-- Intializing a thousand misc. variables
	Variable_Intialization()
	falloff = false
	-- Grabbing Registry Keys
	Grab_Registry_Keys()
	-- Multiplayer Balance Testing
	if true_multiplayer_test then
		multiplayer = 1
	else
		multiplayer = 0
	end
	if multiplayer == 1 then
		maxkickback = 150
		FPSmode = true
	end
	
	-- Ammo Delay + Paint Size Intializing
	if AmmoType == 1 then
		ATDelay = 0
		PaintSize = 1.3
	end
	if AmmoType == 2 then
		ATDelay = 4
		PaintSize = 1.75
	end
	if AmmoType == 3 then
		ATDelay = 8
		PaintSize = 2.5
	end
	
	-- Calculating Things needed for FOV Scope Adjustment
		zoom = false
		to_round = GetInt("options.gfx.fov") - 60
		divided = to_round / 7.5
		zoomfov = (7.5 * math.floor(divided)) + 60
		calc_zoomfov = zoomfov
		live_zoomfov = zoomfov
	-- Converting sRGB Values to 0-1 decimal RGB
		red = hcolor[1]/255
		green = hcolor[2]/255
		blue = hcolor[3]/255
		red_beam = bcolor[1]/255
		green_beam = bcolor[2]/255
		blue_beam = bcolor[3]/255
end

function rnd(mi, ma)
	return math.random(0, 1000)/1000*(ma-mi)+mi
end

local scrollPos = 1.5

function tick()
	if firebeam > 0 then
		beam()
	end
	if Debug then
		local name = InputLastPressedKey()
		if string.len(name) > 0 then
			DebugPrint(name) 
		end
	-- Enabling aimdot for Debug referencing
		SetBool("hud.aimdot", true)
	-- Debug Watch (comment or uncomment variables as needed)
		DebugWatch("Patch Version", GetString("savegame.mod.version"))
		--DebugWatch("HookedToCharge", HookedToCharge)
		--DebugWatch("recharging", recharging)
		DebugWatch("Charge", Charge)
		--DebugWatch("ammo", Ammo)
		--DebugWatch("beginfire", beginfire)
		--DebugWatch("PaintSize", PaintSize)
		--DebugWatch("ATDelay", ATDelay)
		--DebugWatch("HideUi", HideUi)
		--DebugWatch("HideUiToggle", HideUiToggle)
		--DebugWatch("HideRechargeMeter", HideRechargeMeter)
		--DebugWatch("HideRechargeMeterToggle", HideRechargeMeterToggle)
		--DebugWatch("smokeytime", smokeytime)
		--DebugWatch("LCharge", LCharge)
		--DebugWatch("firecount", firecount)
		--DebugWatch("Power_level", Power_lvl)
		--DebugWatch("kickbackpower", kickbackpower)
		--DebugWatch("FPSmode", FPSmode)
		--Debug_Scope_Zoom()
		--DebugWatch("GetPlayerCrouch()", GetPlayerCrouch())
		--DebugWatch("Player Grounded", isGrounded)
		--DebugWatch("crouch", crouch)
		--DebugWatch("Player Walking Speed", GetPlayerParam("walkingspeed"))
		--DebugWatch("Bpos", Bpos)
		--DebugWatch("ThirdPerson", TP_Pov)
		DebugWatch("tool_transform", tool_transform)
		--DebugWatch("hit", hit)
		--DebugWatch("startpos", startpos)
		--DebugWatch("endpos", endpos)
		--DebugWatch("direction", direction)
		--DebugWatch("hitdist", hitdist)
		--DebugWatch("dir", dir)
		--DebugWatch("dir2", dir2)
		--DebugWatch("light_dist", light_dist)
		--DebugWatch("LightSize", LightSize)
		--DebugWatch("light_hit", light_hit)
		--DebugWatch("game.input.camera_view", GetString("game.input.camera_view"))
		--DebugWatch("game.thirdperson", GetBool("game.thirdperson"))
		--DebugWatch("dist", dist)
		--DebugWatch("dist_P", dist_P)
		--DebugWatch("Delay", Delay)
		DebugWatch("RDelay", RDelay)
		DebugWatch("RDelayRnd", RDelayRnd)
		DebugWatch("RDelayRef", RDelayRef)
		--Debug_Status_Indicator()
		--DebugWatch("soundchecked", soundchecked)
		--DebugKeybinds()
		--DebugWatch("GetTime()", GetTime())
		--DebugWatch("dist", dist)
		--DebugWatch("falloff", falloff)
		--DebugWatch("railgun_fail", railgun_fail)
		--DebugWatch("railgun_fail_check", railgun_fail_check)
		--DebugWatch("countdown_warn", countdown_warn)
		--DebugWatch("countdown_popup_complete", countdown_popup_complete)
		--DebugWatch("countdown_crackle", countdown_crackle)
		--DebugWatch("countdown_zero", countdown_zero)
		--DebugWatch(failtime", failtime)
		--DebugWatch("unlimitPower", unlimitPower)
		--DebugWatch("railgun_fail_popup", railgun_fail_popup)
		--DebugWatch("railgun_fail_popup_count", railgun_fail_popup_count)
		--DebugWatch("popup_xscale", popup_xscale)
		--DebugWatch("popup_ytranslate", popup_ytranslate)
		--DebugWatch("snd_prog", GetSoundProgress(CrackleSND))
		--DebugWatch("snd_state", IsSoundPlaying(CrackleSND))
		--DebugWatch("random_flicker", random_flicker)
		--DebugWatch("water_count", water_count)
		--DebugWatch("water_lock", water_lock)
		--DebugWatch("old_inWater", old_inWater)
		--DebugWatch("inWater", inWater)
		--DebugWatch("brig_alarm_lock", brig_alarm_lock)
		--DebugWatch("blink", blink)
		--DebugWatch("repeat_delay_start", repeat_delay_start)
		--DebugWatch("repeat_regulate", repeat_regulate)
		--DebugWatch("haptics", haptics)
		--DebugWatch("haptic_degree", (RDelay-RDelayHapticRef)*2*(Power_lvl/0.7))
		--DebugWatch("ready_glitch_count", ready_glitch_count)
		--DebugWatch("ready_glitch_xscale", ready_glitch_xscale)
		--DebugWatch("ready_glitch_ytranslate", ready_glitch_ytranslate)
		--DebugWatch("glitch_path", glitch_path)
		--DebugWatch("fired", fired)
		--DebugWatch("crosshair_x", crosshair_x)
		--DebugWatch("crosshair_y", crosshair_y)
		--DebugWatch("old_crosshair_x", old_crosshair_x)
		--DebugWatch("old_crosshair_y", old_crosshair_y)
		--DebugWatch("pointpos", pointpos)
		--DebugWatch("crshr_midscrn_xdiff", crshr_midscrn_xdiff)
		--DebugWatch("crshr_midscrn_ydiff", crshr_midscrn_ydiff)
		--DebugWatch("ghost_crosshair", ghost_crosshair)
		--DebugWatch("crosshair_count", crosshair_count)
		--DebugWatch("crosshair_countdown", crosshair_countdown)
		--DebugWatch("indicator_x", indicator_x)
		--DebugWatch("indicator_y", indicator_y)
		--DebugWatch("indicator_x_table", indicator_x_table)
		--DebugWatch("indicator_y_table", indicator_x_table)
		--DebugWatch("indicator_adist", indicator_adist)
		--DebugWatch("indicator_madist", indicator_madist)
		--DebugWatch("old_indicator_x", old_indicator_x)
		--DebugWatch("old_indicator_y", old_indicator_y)
		--DebugWatch("indicator_pvel", indicator_pvel)
		--DebugWatch("indicator_pvel_check", indicator_pvel_check)
		--DebugWatch("indicator_pvel_triggered", indicator_pvel_triggered)
		DebugWatch("truegamefov", truegamefov)
		DebugWatch("fov_pol", fov_pol)
		DebugWatch("ui_fov_modifier", ui_fov_modifier)
		DebugWatch("ui_fov_desiredmod", ui_fov_desiredmod)
		DebugWatch("old_pov_is_fp", old_pov_is_fp)
		DebugWatch("TP_Pov", TP_Pov)
		--DebugWatch("Flying", GetPlayerParam("flyMode"))
		--DebugWatch("FPS", GetFps())
		--DebugWatch("PlayerPos", GetPlayerPos())
		--DebugWatch("tool_transform_x_table", tool_transform_x_table)
		--DebugWatch("tool_transform_y_table", tool_transform_y_table)
		--DebugWatch("tool_transform_z_table", tool_transform_z_table)
		--DebugWatch("tool_transform_x", tool_transform_x)
		--DebugWatch("tool_transform_y", tool_transform_y)
		--DebugWatch("tool_transform_z", tool_transform_z)
		--DebugWatch("muzzle_tool_transform", muzzle_tool_transform)
		--DebugWatch("kb_increase", kb_increase)
		--DebugWatch("kb_reduce", kb_reduce)
		--DebugWatch("spread", spread)
		--DebugWatch("spread_dist", spread_dist)
		--DebugWatch("working_rot", working_rot)
		--DebugWatch("hitpoint", hitpoint)
		--DebugWatch("pointpos", pointpos)
		--DebugWatch("firebeam", firebeam)
		--DebugWatch("spread_deviation", spread_deviation)
		--DebugWatch("ProgBarDelay", ProgBarDelay)
		--DebugWatch("OG_ProgBarDelay", OG_ProgBarDelay)
		--DebugWatch("fail_smoke_density", fail_smoke_density)
		--DebugWatch("cancel_fail_smoke_time", cancel_fail_smoke_time)
		--DebugWatch("smoke_fail", smoke_fail)
		DebugWatch("red", red)
		--DebugWatch("photon_ratio", photon_ratio)
		--DebugWatch("photon_type", photon_type)
		--DebugWatch("Photon_Pool", PhotonPool)
		--DebugWatch("kinetic_photons", kinetic_photons)
		--DebugWatch("random_photon_type", random_photon_type)
		DebugWatch("timeScale", timeScale)
		DebugWatch("Max_FPS", Max_FPS)
		DebugWatch("hitentity",hitentity)
	else
	-- Disabling default aimdot if debug is not toggled
		if GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin" then
			SetBool("hud.aimdot", false)
		else
			SetBool("hud.aimdot", true)
		end
	end
	-- Debug Indicator
	if InputPressed("i") and Debug then
		debug_indicator = not debug_indicator
	end
	-- WARNING Indicator Blink
	if countdown_check_warn then
		local trm = GetTime() % 2
		if (trm < 0.25) or (trm > 0.5 and trm < 0.75) or (trm > 1 and trm < 1.25) or (trm > 1.5 and trm < 1.75) then
			blink = true
		else
			blink = false
		end
	end
	-- Hide UI toggle handling
	if HideUiToggle then
		HideUi = true
	else
		if not TempHideUi then
			HideUi = false
		end
	end
	if not (InputPressed("extra0") or InputPressed("extra1") or InputPressed("extra2") or InputPressed("extra3") or InputPressed("grab")) and InputPressed("any") and ToggleMenu then
		ToggleMenu = false
		TempHideUi = false
		SetBool("savegame.mod.haptictoggle", haptics)
	end
	if not TempHideUi and not HideUiToggle then
		HideUi = false
	end
	if TempHideUi and not HideUiToggle then
		HideUi = true
	end
	-- Grabbing Player info
	playerhealth = GetPlayerHealth()
	PlayerVel = GetPlayerVelocity()
	PlayerAbsoluteSpeed = cubeRoot(math.abs(PlayerVel[1]+PlayerVel[2]+PlayerVel[3]))
	isGrounded = IsPlayerGrounded()
	playerpos = GetPlayerPos()
	if playerhealth == 0 then
		isDead = true else isDead = false
	end
	if Charge > 0 then
		muzzle_effect = true
	else
		muzzle_effect = false
	end
	-- Tool Transform
	-- (Due to an a delay between the game engine and lua code, elements tied to this will always be slightly out of sync)
	tool_transform = GetBodyTransform(GetToolBody())
	-- Camera Transform
	cam_transform = GetCameraTransform()
	-- Game FOV
	truegamefov = GetInt("options.gfx.fov")
	-- Third Person Crap
	if GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin" then
		if not GetBool("game.thirdperson") then
			SetToolAllowedZoom(1.5, 0.75)
			TP_Pov = false
		else 
			TP_Pov = true
		end
	else
		other_tool = true
	end
	-- Check for player camera change
	--if TP_Pov and InputPressed("game.input.camera_view") and old_pov_is_fp = true then
	--	old_pov_is_fp = false
	--end
	-- Debug Unlimited Power Toggle
	--if Debug and InputPressed("f10") then
		--unlimitPower = not unlimitPower
	--end
	-- Calculating maximum scoped in FOV based on user's FOV settings
	to_round = GetInt("options.gfx.fov") - 60
	divided = to_round / 7.5
	zoomfov = (7.5 * math.floor(divided)) + 60
	-- Fire Lightbeam
	if light_beam_spawn then
		light_beam()
	end
	-- Debug reference line for where beam will fire
	if GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin" then
		local attachmentPoint = Transform(VecScale(Vec(11.5, -8, 0), 0.05))
		
		--/ this line defines the laserlightTransform in world vec, done by translating the local vec inside the tool body out of the tool body
		local laserlightTransfrom=TransformToParentTransform(GetBodyTransform(GetToolBody()), attachmentPoint)
		
		--/ just in case its a nil, can remove this if statement if you want, its not needed
		if laserlightTransfrom~=nil then
			laserForwardTransform=TransformToParentVec(laserlightTransfrom,Vec(0.575,-0.4,-0.75))
			hit,startpos,endpos,direction,_,hitdist = GetPlayerAimInfo(laserlightTransfrom.pos,500)
			--DebugWatch("point_dist", hitdist)
			pointpos=endpos
			
			if Debug then
				DebugLine(pointpos,laserlightTransfrom.pos, 1, 1, 1, 0.5)
				DrawLine(pointpos,laserlightTransfrom.pos, 1, 0, 1, 1)
			end
		end
	end
	if railgun_fail_canceled then
		railgun_fail_cancel = false
		railgun_fail_canceled = false
	end
	if InputPressed("usetool") and GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin" and railgun_fail_countdown == true then
		func_railgun_fail_cancel()
		StopSound(Check_Crackle_SND)
		if GetTime() >= tonumber(countdown_warn) then
			cancel_fail = true
		end
		cancel_count = railgun_fail_popup_count
		if not fail_check then
			railgun_fail = false
			railgun_fail_check = false
			railgun_fail_countdown = false
			railgun_failing = false
			railgun_fail_popup = false
			railgun_fail_popup_count = 0
			fail_check = false
			countdown_warn = 999999999
			countdown_popup_complete = 999999999
			countdown_check_warn = false
			countdown_crackle = 999999999
			countdown_check_crackle = false
			countdown_zero = 999999999
			failtime = 999999999
			
			PlaySound(SteamReleaseSND, GetPlayerPos(), 0.125*fail_smoke_density)
			SetValue("cancel_fail_smoke_time", 0, "linear", 0.75)
			SetValue("fail_smoke_density", 0, "linear", 0.75)
		end
	end
	if Ammo == 1 and Charge >= 1 and not SoundStop then
		local Pos = GetPlayerPos()
		--PlaySound(ChargeSND, Pos, 1)
		SoundStop = true
	end
	if AmmoType == 4 then
		AmmoType = 1
	end
	if railgun_fail_check and not (GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin") then
		railgun_fail = true
		railgun_fail_countdown = true
		railgun_fail_check = false
		Railgun_Fail_Pause()
		countdown_check = false
		countdown_check_warn = false
		countdown_check_crackle = false
	end
	if railgun_fail_countdown then
		if not countdown_check then
			countdown_warn = GetTime() + 5
			countdown_flicker = GetTime() + 7.5
			countdown_crackle = GetTime() + 10
			countdown_zero = GetTime() + 15
			railgun_fail_popup_lock = false
			countdown_check = true
			smoke_fail = true
			SetValue("fail_smoke_density", 1, "linear", 15)
		end
		-- OKAY
		-- Begin Warning Sequence
		if GetTime() >= tonumber(countdown_warn) then
			if not railgun_fail_popup_lock then
				SetValue("railgun_fail_popup_count", 1, "linear", 0.166)
				railgun_fail_popup_lock = true
			end
			-- Indicator Blink
			if blink then
				if not brig_alarm_lock then
					BrigAlarm()
					brig_alarm_lock = true
				end
			else
				brig_alarm_lock = false
			end
			countdown_check_warn = true
		end
		-- Flicker the railgun light
		if GetTime() >= tonumber(countdown_flicker) then
			random_flicker = math.random()
		end
		-- Play Crackling Sound Effect
		if GetTime() >= tonumber(countdown_crackle) then
			if countdown_check_crackle == false then
				Check_Crackle_SND = PlaySound(CrackleSND, playerpos, 0.66)
				countdown_check_crackle = true
			end
		end
		-- Failure Inevitable: Begin playing sound and begin countdown to failure
		if GetTime() >= tonumber(countdown_zero) and not fail_check then
			failtime = GetTime() + 1.5
			PlaySound(Railgun_FailSND, playerpos, 1)
			fail_check = true
		end
	end
	if railgun_fail then
		Railgun_Fail_Pause()
		if (GetTime()) > tonumber(failtime) then
			railgun_fail_countdown = false
			fail_check = false
			PlaySound(ExplodeSND, playerpos, 1)
			Explosion(playerpos, 2 * Power_lvl)
			SetPlayerHealth(0)
			railgun_fail = false
			railgun_fail_popup_count = 0
			railgun_fail_popup = false
			countdown_warn = 999999999
			countdown_check_warn = false
			countdown_crackle = 999999999
			countdown_check_crackle = false
			countdown_zero = 999999999
			coundown_flicker = 999999999
			random_flicker = 1
			failtime = 999999999
			smoke_fail = false
			SetValue("cancel_fail_smoke_time", 1)
			SetValue("fail_smoke_density", 0)
		end
	end
	if GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin" and GetBool("game.map.enabled") == true then
		TempHideUi = true
	else
		if not ToggleMenu then
			TempHideUi = false
		end
	end
	--if GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin" and gamepad and PauseMenuButton("Railgun Toggles Menu", "main_top") then
	--	ToggleMenu = true
	--	TempHideUi = true
	--end
	if GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin" and PauseMenuButton("Railgun Options", "main_top") then
		new_ui_open = true
	end
	if ToggleMenu == true then
		SetCameraDof(0,100)
	end
	if GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin" and GetPlayerVehicle() == 0 and GetBool("game.player.canusetool") then
		if not ToggleMenu then
			-- Hide UI Toggle
			if InputPressed(keybind_hideui) then
				HideUiToggle = not HideUiToggle
			end
			-- AmmoType Selector
			if (InputPressed(keybind_ammoselect) or InputPressed("extra0")) and HookedToCharge == 0 then
				AmmoType = (AmmoType + 1)
				ammo_select_fade = 1
				SetValue("ammo_select_fade", 0, "linear", 0.25)
				UiSound(UiAmmoTypeSND, 0.5)
			end
		else
			if InputPressed("extra0") then
				HideUiToggle = not HideUiToggle
			end
		end
		-- Multiplayer Debug Balancing Toggle
		if InputDown(keybind_multiplayertest_1) and InputPressed(keybind_multiplayertest_2) then
			if multiplayer == 0 then
				if multiplayer_debugtoggle == 0 then
					multiplayer_debugtoggle = 1
					maxkickback = 150
				else
					multiplayer_debugtoggle = 0
					maxkickback = 200
				end
			end
		end
		-- Debug Toggle
		if InputPressed(keybind_debug) and (multiplayer == 0) then
			Debug = not Debug
			--if not debug then
			--	for i = 0, 20 do
			--		DebugPrint("")
			--	end
			--end
		end
		-- FPS Mode Toggle
		if InputPressed(keybind_fpsmode) or (InputPressed("extra2") and ToggleMenu and (not InputDown("grab"))) then
			if multiplayer == 0 then
				FPSmode = (not FPSmode)
			end
		end
		-- Status Indicator Toggle
		if InputPressed(keybind_hidestatus) or (InputPressed("extra3") and ToggleMenu and not InputDown("grab")) then
			HideRechargeMeter = (not HideRechargeMeter)
			HideRechargeMeterToggle = (not HideRechargeMeterToggle)
		end
		-- Quickfire Toggle
		if InputPressed(keybind_quickfire) or (InputPressed("extra1") and ToggleMenu) and not InputDown("grab") then
			if multiplayer == 0 then
				quickfire = (not quickfire)
			end
		end
		-- Falloff Toggle
		if InputPressed(keybind_falloff) or (InputPressed("extra3") and InputDown("grab") and ToggleMenu) then
			if multiplayer == 0 then
				falloff = (not falloff)
			end
		end
		-- Unlimited Kickback Toggle
		if (InputDown(keybind_unlimitkb_1) and InputPressed(keybind_unlimitkb_2)) or (InputDown("grab") and InputPressed("extra1") and ToggleMenu) then
			if multiplayer == 0 then
				kbunlimit = (not kbunlimit)
			end
		end
		-- Disable Haptics Toggle
		if InputDown("grab") and InputPressed("extra2") and ToggleMenu then
			haptics = not haptics
		end
		-- Misc. Beam Handling
		if Delay >= 0 and Ammo == 0 and Charge == 0 and not StopHole then
			railgun_fail_check = false
			firebeam = 1
			kickback_falloff = kb_adj
			inital_kickback = false
			SetValue("kickback_falloff", 0, "linear", 0.5)
			SetValue("firebeam", 0, "linear", 1)
			PlaySound(LaserSND, GetPlayerPos(), Power_lvl/0.65)
			PlaySound(SteamReleaseSND, GetPlayerPos(), (Power_lvl/0.65)*0.05)
			if GetInt("options.gfx.motionblur") == 1 then
				blurcount = 20
			blurtime = true
			end
			SparkVel = 1
			StopHole = true
		end
		if Ammo == 1 and Delay == 60 and Charge == 100 then
			if not ToggleMenu then
			-- Power Level Adjustment
			-- **********************
				if unlimitPower then
					max_power = 99
				else
					max_power = true_max_power
				end
				
			-- POWER_LVL PLUS
				if InputPressed(keybind_powerlvl_plus) or InputPressed("extra2") then
					Power_lvl = Power_lvl + 0.10
					power_snd_minus = false
					if not power_snd_plus then
						UiSound(Kicback_AdjustSND, 1)
					end
					if Power_lvl > max_power then
						power_snd_plus = true
						Power_lvl = max_power
					end
					repeat_delay_start[1] = GetTime() + 0.5
					repeat_regulate[1] = repeat_delay_start[1]
				end
			-- PLUS Delay Check
				if InputDown(keybind_powerlvl_plus) or InputDown("extra2") then
					kpp_check = RepeatDelay(1)
					kpp_reg = RepeatRegulate(1)
					if kpp_check and kpp_reg then
						Power_lvl = Power_lvl + 0.10
						power_snd_minus = false
						repeat_regulate[1] = GetTime() + 0.2
						if Power_lvl > max_power then
							Power_lvl = max_power
							power_snd_plus = true
						end
						if not power_snd_plus then
							UiSound(Kicback_AdjustSND, 1)
						end
					end
				end
				
			-- POWER_LVL MINUS
				if InputPressed(keybind_powerlvl_minus) or InputPressed("extra1") then
					Power_lvl = Power_lvl - 0.10
					power_snd_plus = false
					if not power_snd_minus then
						UiSound(Kicback_AdjustSND, 1)
					end
					if Power_lvl < 0.20 then
						power_snd_minus = true
						Power_lvl = 0.20
					end
					repeat_delay_start[2] = GetTime() + 0.5
					repeat_regulate[2] = repeat_delay_start[2]
				end
			-- MINUS Delay Check
				if InputDown(keybind_powerlvl_minus) or InputDown("extra1") then
					kpm_check = RepeatDelay(2)
					kpm_reg = RepeatRegulate(2)
					if kpm_check and kpm_reg then
						Power_lvl = Power_lvl - 0.10
						power_snd_plus = false
						repeat_regulate[2] = GetTime() + 0.2
						if Power_lvl < 0.20 then
							Power_lvl = 0.20
							power_snd_minus = true
						end
						if not power_snd_minus then
							UiSound(Kicback_AdjustSND, 1)
						end
					end
				end
				-- Gamepad Spread Adjustment
				-- ***************************
				if InputPressed("extra3") then
					spread = spread - spread_increment
					if spread < spread_increment then
						spread = spread_increment
					end
					if spread < 0 then
						spread = max_spread
					end
					repeat_delay_start[5] = GetTime() + 0.5
					repeat_regulate[5] = repeat_delay_start[5]
				end
				if InputDown("extra3") and RepeatDelay(5) and RepeatRegulate(5) then
					repeat_regulate[5] = GetTime() + 0.2
					spread = spread - spread_increment
					if spread < spread_increment then
						spread = spread_increment
					end
				end
				-- Keyboard Spread Adjustment
				-- ****************************
				-- Spread PLUS
				if InputPressed(keybind_kickback_plus) and not InputDown(keybind_kickback_minus) then
					spread = spread + spread_increment
					spread_snd_minus = false
					if not spread_snd_plus then
						UiSound(Kicback_AdjustSND, 1)
					end
					if spread > max_spread then
						spread = max_spread
						spread_snd_plus = true
					end
					repeat_delay_start[3] = GetTime() + 0.5
					repeat_regulate[3] = repeat_delay_start[3]
				end
							--PLUS Delay Check
				if InputDown(keybind_kickback_plus) and RepeatDelay(3) and RepeatRegulate(3) and not InputDown(keybind_kickback_minus) then
					repeat_regulate[3] = GetTime() + 0.2
					spread = spread + spread_increment
					spread_snd_minus = false
					if spread > max_spread then
						spread = max_spread
						spread_snd_plus = true
					end
					if not spread_snd_plus then
						UiSound(Kicback_AdjustSND, 1)
					end
				end
				-- Spread MINUS
				if InputPressed(keybind_kickback_minus) and not InputDown(keybind_kickback_plus) then
					spread = spread - spread_increment
					spread_snd_plus = false
					if spread < spread_increment then
						spread = spread_increment
						spread_snd_minus = true
					end
					if not spread_snd_minus then
						UiSound(Kicback_AdjustSND, 1)
					end
					repeat_delay_start[4] = GetTime() + 0.5
					repeat_regulate[4] = repeat_delay_start[4]
				end
							--MINUS Delay Check
				if InputDown(keybind_kickback_minus) and RepeatDelay(4) and RepeatRegulate(4) and not InputDown(keybind_kickback_plus) then
					repeat_regulate[4] = GetTime() + 0.2
					spread = spread - spread_increment
					spread_snd_plus = false
					if spread < spread_increment then
						spread = spread_increment
						spread_snd_minus = true
					else
						if not spread_snd_minus then
							UiSound(Kicback_AdjustSND, 1)
						end
					end
				end
			end
		end
	end
	if GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin" and InputPressed("usetool") and GetPlayerVehicle() == 0 and Ammo == 1 and Delay == 60 and Charge == 100 and GetBool("game.player.canusetool") and not (railgun_fail_cancel or recharging_ui or glitch2) then
			-- Thousand Miscellanious variable setups
			if beginready and readycount > 1 then
				eready = true
				eready_count = 1
			end
		-- Countdown Reset
			local u = 999999999
			countdown_vent_start = u
			countdown_vent_end = u
			countdown_glitch1_start = u
			countdown_glitch1_end = u
			countdown_glitch2_start = u
			countdown_glitch2_end = u
			countdown_ready_start = u
			countdown_ready_end = u
			countdown_eready_start = u
			countdown_eready_end = u
			countdown_fire_start = u
			countdown_fire_end = u
			countdown_RDelay_start = u
			countdown_RDelay_end = u
			RDelay_check = false
			fire_check = false
			eready_check = false
			cancel_fail_check = false
		-- 
			railgun_fail = false
			railgun_fail_check = true
			railgun_fail_popup = true
			railgun_fail_popup_count = 0
			beginfire = true
			local Pos = GetPlayerPos()
			Ammo = 0
			Delay = 4
			glitch2 = false
			beginglitch1 = false
			beginglitch2 = false
			beginready = false
			soundchecked = false
			UiReadySNDCheck = false
			RDelayBeepCheck = false
			glitch1count = 10
			glitch2count = 10
			fired = false
			ready = false
			readycount = 240
			ready_glitch_count = 0
			ventcount = 0
			ytranslate = 0
			-- Setting additional delay according to selected AmmoType
			if AmmoType == 1 then
				ATDelay = 0
			end
			if AmmoType == 2 then
				ATDelay = 4
			end
			if AmmoType == 3 then
				ATDelay = 8
			end
			-- Calculating RDelay
			RDelay = Power_lvl * 12.3 + ATDelay
			ProgBarDelay = Power_lvl * 12.3 + ATDelay + 1.666
			OG_ProgBarDelay = ProgBarDelay - 4.466
			-- Calculating Kickback Power
			kickbackpower = (1+(math.log10(Power_lvl)/math.log10(7)))*128*kb_adj
			--if kickbackpower > 200 and not kbunlimit then
			--	kickbackpower = 200
			--end
			-- More misc. variables
			Stop_Count = false
			LCharge = 100
			Charge = 100
			ParticleReset()
			Beam = true
			PlaySound(FireSND, Pos, 1)
		else
			if RDelay == 0 and GetPlayerVehicle() == 0 and Ammo == 0 then
				Ammo = 1
				StopHole = false
				SoundStop = false
				fired = true
				countdown_LCharge_start = GetTime()
				countdown_LCharge_end = GetTime() + 1.666
			end
	end
	-- Glitch 2 Trigger
	if GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin" and RDelay == 0 and GetPlayerVehicle() == 0 and Charge <= 100 and fired and recharging_ui == false then
		if glitch2_confirm then
			beginglitch2 = true
		end
	end
	-- Disabling Smoke if railgun is deselected
	if not (GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin") then
		smokeytime = false
	end
	-- Scoped In Handling
	if GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin"and GetBool("game.player.canusetool") then
		local body = GetPlayerGrabBody()
		local shape = GetPlayerGrabShape()
		-- Checking if tool is scoped in
		local current_zoom = tonumber(GetString("game.player.tool.zoom")) 
		if (current_zoom >= 1.25) then
			zoom = true
		else
			zoom = false
		end
		if InputDown("rmb") or (zoom == true) then
		-- Adding/Subtracting Mousewheel from calculated FOV
			calc_zoomfov = calc_zoomfov - InputValue("mousewheel")*7.5
		-- Controller Quick-Zoom
			if scroll_qz_timer < 0.05 then
				scroll_qz_reset()
			end
			if math.abs(InputValue("mousewheel")) == 1 and gamepad then
				if not scroll_quick_zoom then
					scroll_counter = 0
					scroll_quick_zoom = true
					SetValue("scroll_qz_timer", 1)
					SetValue("scroll_qz_timer", 0, "linear", 0.33)
				end
				if scroll_quick_zoom and scroll_qz_timer < 1 then
					scroll_counter = scroll_counter + InputValue("mousewheel")
					if scroll_counter >= 2 then
						calc_zoomfov = 30
						scroll_qz_reset()
					end 
					if scroll_counter <= (-2) then
						calc_zoomfov = truegamefov
						scroll_qz_reset()
					end
				end
			end
			grab = 0
			if calc_zoomfov < 30 then
				calc_zoomfov = 30
			end
			if calc_zoomfov > zoomfov then
				calc_zoomfov = zoomfov
			end
			SetValue("live_zoomfov", calc_zoomfov, "linear", 0.025)
			Aiming = true
			-- Walking Speed limitation
			SetPlayerParam("walkingspeed", 4.5)
			-- Grounded/Ungrounded Aiming Stability
			if isGrounded then
				sway = 0.25
				camshake = Power_lvl*1.1
			else
				sway = 0.5
				camshake = Power_lvl*1.54
			end
		else
			-- FOV Transition
			SetValue("live_zoomfov", zoomfov, "linear", 0.25)
			calc_zoomfov = zoomfov
			Aiming = false
			-- Walk speed and stablility reset
			SetPlayerParam("walkingspeed", 7)
			sway = 1
			camshake = Power_lvl*1.54
		end
		-- Apply Railgun offset
		if body == 0 and shape == 0 then
			local t = Transform()
			t.pos = Vec(RailgunOffset_X, RailgunOffset_Y, RailgunOffset_Z)
			SetToolTransform(t,sway)
		end
		-- Hand positioning
		SetToolHandPoseLocalTransform(Transform(Vec(0.6,-0.5,-0.75), QuatAxisAngle(Vec(0,0,0), 90.0)), Transform(Vec(0.6, -0.65, -1.0)))
	end
	-- Scoped FOV, Tool Offset, Recharge Indicator Hiding
	if Aiming and GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin" then
		-- Applying FOV
		SetCameraFov(live_zoomfov)
		-- Disabling Rechargemeter
		if not TP_Pov then
			HideRechargeMeterChecked = false
			if not HideRechargeMeter then
				HideRechargeMeter = true
			end
		end
		SetValue("RailgunOffset_X", -0.5755, "linear", 0.05)
		SetValue("RailgunOffset_Y", 0.15, "linear", 0.05)
		SetValue("RailgunOffset_Z", -0.15, "linear", 0.05)
	else
		-- reverting back to regular values
		if not HideRechargeMeterChecked then
			if not HideRechargeMeterToggle then
				HideRechargeMeterChecked = true
				HideRechargeMeter = false
			end
		end
		SetValue("RailgunOffset_X", -0.15, "cosine", 0.15)
		SetValue("RailgunOffset_Y", 0, "cosine", 0.15)
		SetValue("RailgunOffset_Z", 0, "cosine", 0.15)
	end
	-- Third Person Offset
	if TP_Pov then
		if Aiming then
			SetValue("RailgunOffset_X", -0.2755, "easeout", 0.15)
			SetValue("RailgunOffset_Y", 0, "easeout", 0.15)
			SetValue("RailgunOffset_Z", 0.5, "easeout", 0.15)
		else
			SetValue("RailgunOffset_X", -0.25, "easeout", 0.15)
			SetValue("RailgunOffset_Y", 0, "easeout", 0.15)
			SetValue("RailgunOffset_Z", 0.5, "easeout", 0.15)
		end
	end
	if Ammo == 1 and fired then
		HookedToCharge = 0
		LCharge = counter_fix(countdown_LCharge_start, countdown_LCharge_end, false, 100)
		Charge = math.floor(LCharge)
	end
	if (Charge > 100) or (LCharge > 100) then
		LCharge = 100
		Charge = 100
	end
	if Delay == 60 and Charge >= 100 then
		LCharge = 100
		Charge = 100
	end
	-- Railgun Smoke/Steam(?) Emissions
	if smokeytime then
		ParticleReset()
		ParticleType("smoke")
		ParticleColor(1, 1, 1)
		if not inWater then
			ParticleRadius(smoke_size)
			ParticleGravity(0.0, 0.75, 0.0)
			ParticleDrag(0.5)
			ParticleAlpha(0.075, 0.0)
			ParticleTile(0)
		else
			ParticleRadius(smoke_size/5)
			ParticleGravity(0.0, 0.85, 0.0)
			ParticleDrag(0.5)
			ParticleTile(2)
		end
		SpawnParticle(TransformToParentPoint(tool_transform, Vec(0.45,-0.25,-.85)), Vec(0, 0.5, 0), 0.5)
		SpawnParticle(TransformToParentPoint(tool_transform, Vec(0.45,-0.25,-.95)), Vec(0, 0.5, 0), 0.5)
		SpawnParticle(TransformToParentPoint(tool_transform, Vec(0.65,-0.25,-.85)), Vec(0, 0.5, 0), 0.5)
		SpawnParticle(TransformToParentPoint(tool_transform, Vec(0.65,-0.25,-.95)), Vec(0, 0.5, 0), 0.5)
	end
	if cancel_fail_smoke_time == 0 then
		smoke_fail = false
		SetValue("cancel_fail_smoke_time", 1)
		SetValue("fail_smoke_density", 0)
	end
	-- Railgun Failure Emissions
	if smoke_fail and (GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin") then
		ParticleReset()
		ParticleType("smoke")
		local color = 1 - fail_smoke_density
		ParticleColor(color, color, color)
		if not inWater then
			ParticleRadius(((fail_smoke_density)/6)*cancel_fail_smoke_time)
			ParticleGravity(0.0, 0.75, 0.0)
			ParticleDrag(0.5)
			ParticleAlpha(fail_smoke_density*0.5, 0.0)
			ParticleTile(0)
		else
			ParticleRadius(((fail_smoke_density)/20)*cancel_fail_smoke_time)
			ParticleGravity(0.0, 0.85, 0.0)
			ParticleDrag(0.5)
			ParticleTile(2)
		end
		SpawnParticle(TransformToParentPoint(tool_transform, Vec(0.45,-0.25,-.85)), Vec(0, 0.5, 0), 0.5)
		SpawnParticle(TransformToParentPoint(tool_transform, Vec(0.45,-0.25,-.95)), Vec(0, 0.5, 0), 0.5)
		SpawnParticle(TransformToParentPoint(tool_transform, Vec(0.65,-0.25,-.85)), Vec(0, 0.5, 0), 0.5)
		SpawnParticle(TransformToParentPoint(tool_transform, Vec(0.65,-0.25,-.95)), Vec(0, 0.5, 0), 0.5)
	end
-- Indicator Fade In/Out when Aiming/Not Aiming Animation
	if (not old_Aiming) and Aiming and not TP_Pov then
		indicator_lock = true
		indicator_lock_state = "contract"
		Aiming_count = 1
	end
	if ((not Aiming) and old_Aiming and not TP_Pov) or other_tool then
		other_tool = false
		indicator_lock = true
		indicator_lock_state = "expand"
		Aiming_count = 0
	end
	if indicator_lock and (indicator_lock_state == "contract") then
		SetValue("Aiming_count", 0, "linear", 0.1)
		if Aiming_count <= 0 then
			indicator_lock = false
			Aiming_count = 1
			old_Aiming = Aiming
		end
	end
	if indicator_lock and (indicator_lock_state == "expand") then
		SetValue("Aiming_count", 1, "linear", 0.1)
		if Aiming_count >= 1 then
			indicator_lock = false
			Aiming_count = 0
			old_Aiming = Aiming
		end
	end
	old_Aiming = Aiming
	indicator_shrink_ytranslate = (1 - Aiming_count)
	indicator_shrink_xscale = Aiming_count
	
-- Failure Cancel Shrink Animation
	if cancel_fail then
		if not cancel_fail_check then
			SetValue("cancel_count", 0, "linear", 0.167)
			cancel_fail_check = true
		end
		if cancel_count <= 0 then
			cancel_fail_check = false
			cancel_fail = false
			cancel_count = 1
		end
	end
	cancel_shrink_ytranslate = 1 - cancel_count
	cancel_shrink_xscale = cancel_count
	
-- Railgun Failure Popup Animation
	popup_ytranslate = (1 - railgun_fail_popup_count)
	popup_xscale = railgun_fail_popup_count
	
-- "VENTING HEAT" -> Glitch 1 -> "RECHARGING..." 
	if beginglitch1 then
		ventheat = false
		ventcount = 1
		if not glitch1 then
			SetValue("glitch1count", 0, "linear", 0.167)
			glitch1 = true
		end
		if glitch1count <= 0 then
			beginglitch1 = false
			glitch1 = false
			glitch1count = 10
			readycount = 240
			recharging_ui = true
			glitch2_confirm = true
		end
	end
	
-- "RECHARGING..." -> Glitch 2 -> "READY" //// "READY" Glitch
	if beginglitch2 then
		-- Establish Glitch 2 Timings
		if not glitch2 then
			SetValue("glitch2count", 0, "linear", 0.167)
			glitch2 = true
		end
		-- READY glitch handling
		ready_glitch_count = 10 - glitch2count
		ready_glitch_ytranslate = (10 - ready_glitch_count)/10
		ready_glitch_xscale = ready_glitch_count/11
		-- Continue Glitch2 handling
		if glitch2count <= 0 then
			glitch2 = false
			beginglitch2 = false
			glitch2_confirm = false
			glitch2count = 10
			readycount = 240
			beginready = true
			if not UiReadySNDCheck then
				UiSound(UiReadySND, 0.5)
				UiReadySNDCheck = true
			end
		end
	end
-- "READY" Indicator Handling
	if beginready then
		glitch2 = false
		if not ready then
			SetValue("readycount", 0, "linear", 4)
			ready = true
		end
		if (readycount <= 225 and readycount > 195) or (readycount <= 165 and readycount > 135) or (readycount <= 105 and readycount > 75) or (readycount <= 45 and readycount > 15) then
			readyflash = true
			readymltpy = 1.5
		else
			readyflash = false
			readymltpy = 1
		end
		ytranslate = (10 - readycount)/10
		xscale = readycount/11
		if readycount <= 0 or fired == false then
			glitch2 = false
			beginready = false
			fired = false
			ready = false
			readycount = 240
			soundchecked = false
			UiReadySNDCheck = false
			UiSound(UiReadyEndSND, 1)
		end
	end
-- Venting Heat Math Stuff
	if Charge <= 0 then
		if RDelay <= 1 and not (RDelay == 0) then
			ventheat = false
			if not recharging_ui then
				beginglitch1 = true
			end
		end
		if RDelay <= RDelayRef and not (RDelay <= 1) then
			if not soundchecked then
				UiSound(UiReadyEndSND, 1)
				SetValue("ventcount", 1, "linear", 0.167)
				PlaySound(SteamReleaseSND, GetPlayerPos(), 0.05)
			end
			soundchecked = true
			ventheat = true
			smokeytime = true
			SetValue("smoke_size", 0.5, "linear", 0.125)
			vent_ytranslate = 1 - ventcount
			vent_xscale = ventcount
		end
	end
	if smoke_size <= 0.495 then
		SetValue("smoke_size", 0, "linear", ProgBarDelay-1.666)
	end
-- Railgun READY Early Cancel Shrink Animation
	if eready == true then
		if not eready_check then
			SetValue("eready_count", 0, "linear", 0.167)
			eready_check = true
		end
		if eready_count <= 0 then
			eready = false
			eready_count = 1
		end
	end
	eready_shrink_ytranslate = 1 - eready_count
	eready_shrink_xscale = eready_count
	-- Check to see if player camera is underwater
	inWater, depth = IsPointInWater(cam_transform.pos)
	if inWater then
		water_lock = false
		SetValue("water_count", 60, "linear", 0)
		old_inWater = inWater
	end
	if (not inWater) and old_inWater and (not water_lock) then
		SetValue("water_count", 0, "linear", 1)
		water_lock = true
	end
	if water_lock then
		if water_count <= 0 then
			water_lock = false
			water_count = 60
			old_inWater = inWater
		end
	else
		old_inWater = inWater
	end
	-- RDelayRnd Defintition
	RDelayRnd = math.floor(RDelay + 1.666)
	-- Progress Bar
	if (RDelay >= (RDelayHapticRef)) and haptics then
		PlayHaptic(haptic_effect, (RDelay-RDelayHapticRef)*2*(Power_lvl/0.7)*firebeam)
	end
end
function update(dt)
	local Pos = GetPlayerPos()
	-- Play Gamepad Haptics
	if (beginfire == true) and (Charge < 100) and GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin" then
		haptic_intensity = ((100-Charge)/300)*kb_adj*(Power_lvl/0.7)
		if haptics then
			PlayHaptic(haptic_effect, haptic_intensity)
		end
	end
	if RDelayRnd <= RDelayRef and Charge < 100 then
		if RechargeCount == 0 and (not RDelayBeepCheck) and (not beginfire) then
			UiSound(UiBeepSND, 1)
			RDelayBeepCheck = true
		end
		if not (RDelayRnd == RDelayRndOld) then
			UiSound(UiBeepSND, 1)
		end
	end
	RDelayRndOld = RDelayRnd
	RechargeCount = math.floor((100 - Charge)/60)
	-- Ui Compaction Checks
	if LastInputDevice() == 1 then
		gamepad = false
		ui_compaction = 0
	else
		gamepad = true
		ui_compaction = 50
	end
	if multiplayer == 1 then
		if LastInputDevice() == 1 then
			ui_compaction = 50
		end
		if LastInputDevice() == 2 then
			ui_compaciton = 35
		end
	end
	if (Ammo == 1) and (HookedToCharge == 0) and (Charge < 100) then
		--smokeytime = true
		recharging = true
	end
	-- Capping RDelay
	if (RDelay > 29) then
		RDelay = 29
	end
	-- Paint Size
	if AmmoType == 1 then
		PaintSize = 1.3
	end
	if AmmoType == 2 then
		PaintSize = 1.75
	end
	if AmmoType == 3 then
		PaintSize = 2.5
	end
	if quickfire then
		if multiplayer == 0 then
			if (RDelay > 2.5) then
				countdown_RDelay_end = GetTime() + 2.5
				RDelay = 2.5
				ProgBarDelay = 2.5
			end
		end
	end
	if (Charge == 0) then
		--smokeytime = true
		if blurtime then
			blurcount = blurcount - 1
		end
	end
	if (Charge == 100) then
		recharging = false
		recharging_ui = false
		smokeytime = false
		SetValue("smoke_size", 0.1)
	end
	if not StopCount then
		Count = (Count + dt)
	end
	if Count >= 2.8 then
		Count = 0
		StopCount = true
	end
	if Charge <= 0 or LCharge <= 0 then
		Charge = 0
		LCharge = 0
	end
	if Ammo == 0 then
		if not RDelay_check then
			countdown_RDelay_start = GetTime()
			countdown_RDelay_end = GetTime() + (RDelay)
			Original_RDelay = RDelay
			RDelay_check = true
		end
		RDelay = counter_fix(countdown_RDelay_start, countdown_RDelay_end, true, Original_RDelay)
	end
	if Charge < 100 then
		ProgBarDelay = (ProgBarDelay - dt)
	end
	if Ammo == 0 and not Stop_Count then
		Delay = (Delay - dt)
	end
	if RDelay == 0 then
		Delay = 60
		Stop_Count = true
	end
	if Ammo == 0 then
		if not fire_check then
			countdown_fire_start = GetTime()
			countdown_fire_end = GetTime() + 1.5
			fire_check = true
		end
		LDelay = math.floor(Delay)
		if LCharge > 0 then
			HookedToCharge = 1
			Charge = math.floor(LCharge)
			LCharge = counter_fix(countdown_fire_start, countdown_fire_end, true, 100)
		end
	end
	
end
	
function draw(dt)
	-- Blurring Screen (only happens if player has motion blur enabled in game settings)
	if blurtime then
		if blurcount > 0 then
		UiBlur(blurcount/60)
		end
	else
		blurtime = false
		blurcount = 20
	end
	-- Getting Screen Info
	canvas = UiCanvasSize()
	screenmiddlex = canvas.w/2
	screenmiddley = canvas.h/2
-- ________________________
-- BRAND NEW User Interface (v0.5.0)
-- ************************
	if new_ui_open then
	UiPush()
		TempHideUi = true
	-- Lock input so player doesn't move
		UiMakeInteractive()
	-- Align to middle of the screen(?)
		UiAlign("center middle")
		UiTranslate(screenmiddlex, screenmiddley)
	-- Make background UI box based on railgun colors
		UiColor(red, green, blue, 0.75)
		UiRoundedRect(canvas.w*0.75,canvas.h*0.75,16)
		UiColor(0., 0, 0, 0.75)
		UiRect((canvas.w*0.75)-24,(canvas.h*0.75)-24)
		UiTranslate((-(canvas.w*0.375))+24, (-(canvas.w*0.1875))-24)
		UiAlign("left top")
		UiWindow((canvas.w*0.75)-24, (canvas.h*0.75)-24)
	-- Put buttons and interactive crap here
		UiTranslate(11, 22)
		-- Kickback Adjustment 
		UiFont(mono_bold, 24)
		UiTextOutline(0, 0, 0, 1, 0.2)
		UiColor(0.75, 0.75, 0.75)
		UiScale(0.25)
		if kb_adj % 1 == 0 then
			ui_kb_adj = string.autoinsert(tostring(kb_adj),".0")
		else
			ui_kb_adj = kb_adj
			if tostring(ui_kb_adj) == "1" then
				ui_kb_adj = "1.0"
			end
		end
		if UiImageButton("MOD/Assets/VFX/leftarrow.png") then
			kb_adj = kb_adj - 0.05
			if kb_adj < 0.1 then
				kb_adj = 0
			end
		end
		UiScale(4)
		UiTranslate(48, 8)
		UiText(string.autoinsert("Kickback Force Multiplier: ", ui_kb_adj))
		UiTranslate(340, -8)
		UiScale(0.25)
		if UiImageButton("MOD/Assets/VFX/rightarrow.png") then
			kb_adj = kb_adj + 0.05
			if kb_adj >= 2 then
				kb_adj = 2
			end
		end
		UiScale(4)
		UiTranslate(-396, 40)
		-- Hole resolution
		UiScale(0.25)
		if UiImageButton("MOD/Assets/VFX/leftarrow.png") then
			holecount_adj = holecount_adj - 1
			if holecount_adj < 1 then
				holecount_adj = 0
			end
		end
		UiScale(4)
		UiTranslate(48, 8)
		UiText(string.autoinsert("Hole Resoltuion: ", holecount_adj))
		UiTranslate(340, -8)
		UiScale(0.25)
		if UiImageButton("MOD/Assets/VFX/rightarrow.png") then
			holecount_adj = holecount_adj + 1
			if holecount_adj >= 100 then
				holecount_adj = 100
			end
		end
		UiScale(4)
		UiTranslate(-396, 40)
		-- Status Indicator
		if HideRechargeMeterToggle then
			UiColor(0.5,0.5,0.5)
			stat_button = "Hidden"
		else
			UiColor(0.75, 0.75, 0.75)
			stat_button = "Visible"
		end
		if UiTextButton(string.autoinsert("Status Indicator ", stat_button)) then
			HideRechargeMeter = (not HideRechargeMeter)
			HideRechargeMeterToggle = (not HideRechargeMeterToggle)
		end
		UiTranslate(0,30)
		-- FPS Mode
		if FPSmode then
			UiColor(0.75,0.75,0)
			fps_button = "Enabled"
		else
			UiColor(0.5,0.5,0.5)
			fps_button = "Disabled"
		end
		if UiTextButton(string.autoinsert("FPS Mode   ", fps_button)) then
			FPSmode = (not FPSmode)
		end
		UiTranslate(0,30)
		-- Quickfire
		if quickfire then
			UiColor(0.75,0.35,0,1)
			quick_button = "Enabled"
		else
			UiColor(0.5,0.5,0.5,1)
			quick_button = "Disabled"
		end
		if UiTextButton(string.autoinsert("Quickfire  ", quick_button)) then
			quickfire = (not quickfire)
		end
		UiTranslate(0,30)
		-- Quickfire
		if falloff then
			UiColor(0.75,0.25,0.25,1)
			fall_button = "Enabled"
		else
			UiColor(0.5,0.5,0.5,1)
			fall_button = "Disabled"
		end
		if UiTextButton(string.autoinsert("Falloff    ", fall_button)) then
			falloff = (not falloff)
		end
		UiTranslate(0,30)
		-- Kickback Unlimiter
		if kbunlimit then
			UiColor(0.75,0.4,0.4,1)
			kick_button = "Uncapped"
		else
			UiColor(0.5,0.5,0.5,1)
			kick_button = "Capped"
		end
		if UiTextButton(string.autoinsert("Kickback   ", kick_button)) then
			kbunlimit = (not kbunlimit)
		end
		UiTranslate(0,30)
		-- Font Selection
		if GetString("savegame.mod.ui_font") == "Console" then
			UiColor(0.5,0.2,1,1)
			font_button = "Console (Classic)"
		else
			UiColor(0.75,0,0.75,1)
			font_button = "Roboto"
		end
		if UiTextButton(string.autoinsert("Font:   ", font_button)) then
			if GetString("savegame.mod.ui_font") == "Console" then
				SetString("savegame.mod.ui_font", "Roboto")
				ui_font = mono_bold
				ui_font_adj = 0.75
			else
				SetString("savegame.mod.ui_font", "Console")
				ui_font = console
				ui_font_adj = 1
			end
		end
		UiTranslate(0,30)
	-- Close UI Button
		UiColor(0.75,0.75,0.75,1)
		if UiTextButton("[CLOSE Menu]") then
			new_ui_open = false
			TempHideUi = false
		end
		UiTranslate(12,30)
	-- Reset Registry Keys
		if Debug then
			if UiTextButton("[ !! CLEAR REGISTRY KEYS !! ]") then
				ClearALLKeys()
			end
		end
		UiTranslate(0,30)
		UiColor(red,green,blue,1)
		UiText("Railgun Highlight Color")
	-- Red Slider
		-- Value Indicator
		UiColor(1, 0.25, 0.25)
		UiTranslate(0,24)
		UiText(string.autoinsert("Red: ", math.floor(red*255)))
		-- Slider Track
		UiTranslate(16,24)
		UiScale(0.5)
		UiColor(0.5,0.5,0.5)
		UiRoundedRect(255,24,12)
		-- Slider UI Element
		UiTranslate(-32,-16)
		UiColor(1, 0.25, 0.25)
		red = UiSlider("MOD/Assets/VFX/dot.png", "x", red*255, 0, 255)
		red = red / 255
	-- Green Slider
			UiScale(2)
		-- Value Indicator
		UiColor(0.25, 1, 0.25)
		UiTranslate(0,36)
		UiText(string.autoinsert("Green: ", math.floor(green*255)))
		-- Slider Track
		UiTranslate(16,24)
		UiScale(0.5)
		UiColor(0.5,0.5,0.5)
		UiRoundedRect(255,24,12)
		-- Slider UI Element
		UiTranslate(-32,-16)
		UiColor(0.25, 1, 0.25)
		green = UiSlider("MOD/Assets/VFX/dot.png", "x", green*255, 0, 255)
		green = green / 255
	-- Blue Slider
			UiScale(2)
		-- Value Indicator
		UiColor(0.25, 0.75, 1)
		UiTranslate(0,36)
		UiText(string.autoinsert("Blue: ", math.floor(blue*255)))
		-- Slider Track
		UiTranslate(16,24)
		UiScale(0.5)
		UiColor(0.5,0.5,0.5)
		UiRoundedRect(255,24,12)
		-- Slider UI Element
		UiTranslate(-32,-16)
		UiColor(0.25, 0.75, 1)
		blue = UiSlider("MOD/Assets/VFX/dot.png", "x", blue*255, 0, 255)
		blue = blue / 255
	-- BEAM Color Sliders
			UiScale(2)
		UiTranslate(0,36)
		UiColor(red_beam,green_beam,blue_beam,1)
		UiText("Beam Color")
	-- Red_beam Slider
		-- Value Indicator
		UiColor(1, 0.25, 0.25)
		UiTranslate(0,24)
		UiText(string.autoinsert("Red: ", math.floor(red_beam*255)))
		-- Slider Track
		UiTranslate(16,24)
		UiScale(0.5)
		UiColor(0.5,0.5,0.5)
		UiRoundedRect(255,24,12)
		-- Slider UI Element
		UiTranslate(-32,-16)
		UiColor(1, 0.25, 0.25)
		red_beam = UiSlider("MOD/Assets/VFX/dot.png", "x", red_beam*255, 0, 255)
		red_beam = red_beam / 255
	-- Green_beam Slider
			UiScale(2)
		-- Value Indicator
		UiColor(0.25, 1, 0.25)
		UiTranslate(0,36)
		UiText(string.autoinsert("Green: ", math.floor(green_beam*255)))
		-- Slider Track
		UiTranslate(16,24)
		UiScale(0.5)
		UiColor(0.5,0.5,0.5)
		UiRoundedRect(255,24,12)
		-- Slider UI Element
		UiTranslate(-32,-16)
		UiColor(0.25, 1, 0.25)
		green_beam = UiSlider("MOD/Assets/VFX/dot.png", "x", green_beam*255, 0, 255)
		green_beam = green_beam / 255
	-- Blue Slider
			UiScale(2)
		-- Value Indicator
		UiColor(0.25, 0.75, 1)
		UiTranslate(0,36)
		UiText(string.autoinsert("Blue: ", math.floor(blue_beam*255)))
		-- Slider Track
		UiTranslate(16,24)
		UiScale(0.5)
		UiColor(0.5,0.5,0.5)
		UiRoundedRect(255,24,12)
		-- Slider UI Element
		UiTranslate(-32,-16)
		UiColor(0.25, 0.75, 1)
		blue_beam = UiSlider("MOD/Assets/VFX/dot.png", "x", blue_beam*255, 0, 255)
		blue_beam = blue_beam / 255
	-- SAVE Color Settings
			UiScale(2)
		UiTranslate(-12,36)
		UiColor(0.75,0.75,0.75,1)
		if GetTime() > color_notice_time then
			ui_color_text =  '[SAVE Color Settings]'
			color_notice_time = 999999999
			colors_saved = false
		else
			if colors_saved then
				UiColor(0.9,0.9,0.9,(color_notice_time - GetTime())+0.25)
				ui_color_text = '[Color Settings Saved!]'
			else
				ui_color_text =  '[SAVE Color Settings]'
			end
		end
		if UiTextButton(ui_color_text) then
			Save_Color_Settings()
			colors_saved = true
			color_notice_time = GetTime() + 0.75
		end
	-- Temp Notice
		UiColor(0.5,0.5,0.5,1)
		UiTranslate(400,-50)
		UiText("(Will move keybind settings here at some point.)")
		UiTranslate(0, 24)
		UiText("(You can change those for now in the options menu.)")
	UiPop()
	end
	-- Gamepad Toggles Menu
	if ToggleMenu then
		-- Create box in center of the screen
		UiPush()
		UiAlign("center middle")
		UiTranslate(screenmiddlex, screenmiddley)
		UiColor(red, green, blue)
		UiRoundedRect(380,410,16)
		UiColor(red*0.25, green*0.25, blue*0.25)
		UiRect(356,386)
		UiTranslate(-178, -206)
		UiAlign("left top")
		UiWindow(356, 386)
		if gamepad then
			-- Tell player to hold down thumbstick
			UiTextOutline(0, 0, 0, 1, 0.35)
			UiTranslate(11, 22)
			UiFont("bold.ttf", 26)
			UiColor(1, 1, 1)
			UiText("(Hold Down on Right Thumbstick!)")
			UiFont("regular.ttf", 24)
			UiTextOutline(0, 0, 0, 1, 0.2)
			UiTranslate(0, 35)
			-- Hide UI Toggle
			UiFont("bold.ttf", 24)
			if not HideUiToggle then
				UiColor(1, 1, 1)
				UiText("UI Box Visible:")
			else
				UiColor(0.5, 0.5, 0.5)
				UiText("UI Box Hidden")
			end
			UiTranslate(15, 20)
			UiColor(1, 1, 1)
			UiFont("regular.ttf", 24)
			UiText("Press Up on D-Pad")
			UiTranslate(-15, 30)
			-- FPS Mode Toggle
			UiFont("bold.ttf", 24)
			if not FPSmode then
				UiColor(0.5, 0.5, 0.5)
				UiText("FPS mode Disabled:")
			else
				UiColor(1, 1, 1)
				UiText("FPS mode Enabled:")
			end
			if multiplayer == 1 then
				UiColor(0.75, 0, 0.75)
			end
			UiTranslate(15, 20)
			UiColor(1, 1, 1)
			UiFont("regular.ttf", 24)
			UiText("Press Right on D-Pad")
			UiTranslate(-15, 30)
			-- Hide Recharge Meter Toggle
			UiFont("bold.ttf", 24)
			if HideRechargeMeterToggle then
				UiColor(0.5, 0.5, 0.5)
				UiText("Status Indicator Hidden:")
			else
				UiColor(1, 1, 1)
				UiText("Status Indicator Visible:")
			end
			UiTranslate(15, 20)
			UiColor(1, 1, 1)
			UiFont("regular.ttf", 24)
			UiText("Press Down on D-Pad")
			UiTranslate(-15, 30)
			-- Haptics Toggle
			UiFont("bold.ttf", 24)
			if haptics then
				UiColor(1, 1, 1)
				UiText("Haptics Enabled:")
			else
				UiColor(0.5, 0.5, 0.5)
				UiText("Haptics Disabled:")
			end
			UiTranslate(15, 20)
			UiColor(1, 1, 1)
			UiFont("regular.ttf", 24)
			UiText("Hold Left Trigger + Right on Dpad")
			UiTranslate(-15, 30)
			-- Singleplayer Exclusive Toggles
			if multiplayer == 0 then
				-- Quickfire Toggle
				UiFont("bold.ttf", 24)
				if quickfire then
					UiColor(1, 1, 1)
					UiText("Quickfire Enabled:")
				else
					UiColor(0.5, 0.5, 0.5)
					UiText("Quickfire Disabled:")
				end
				UiTranslate(15, 20)
				UiColor(1, 1, 1)
				UiFont("regular.ttf", 24)
				UiText("Press Left on D-Pad")
				UiTranslate(-15, 30)
				-- Falloff Toggle
				UiFont("bold.ttf", 24)
				if falloff then
					UiColor(1, 1, 1)
					UiText("Falloff Enabled:")
				else
					UiColor(0.5, 0.5, 0.5)
					UiText("Falloff Disabled:")
				end
				UiTranslate(15, 20)
				UiColor(1, 1, 1)
				UiFont("regular.ttf", 24)
				UiText("Left Trigger + Down on D-Pad")
				-- Unlimited Kickback Toggle
				UiTranslate(-15, 30)
				UiFont("bold.ttf", 24)
				if not kbunlimit then
					UiColor(0.5, 0.5, 0.5)
					UiText("Unlimited Kickback:")
				else
					UiColor(1, 1, 1)
					UiText("Unlimited Kickback:")
				end
				UiTranslate(15, 20)
				UiColor(1, 1, 1)
				UiFont("regular.ttf", 24)
				UiText("Left Trigger + Left on D-Pad")
			end
		end
		UiPop()
	end
-- UI Handling
if GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin" and GetPlayerVehicle() == 0 then
	local transform = tool_transform
	local offset = Vec(0,1,0)
	local finalTransform = TransformToParentPoint(transform,offset)
	local x,y = UiWorldToPixel(finalTransform)
	local body = GetPlayerGrabBody()
	local shape = GetPlayerGrabShape()
	-- Getting polarity of fov
	if GetInt("options.gfx.fov") >= 90 then
		fov_pol = true
	else
		fov_pol = false
	end
	ui_fov_desiredmod = 90 / GetInt("options.gfx.fov")
	if not TP_Pov then
		if not old_pov_is_fp then
			SetValue("ui_fov_modifier", 1, "linear", 0.1)
			if fov_pol then
				if ui_fov_modifier > 0.99 then
					old_pov_is_fp = true
				end
			else
				if ui_fov_modifier < 1.01 then
					old_pov_is_fpw = true
				end
			end
		else
			ui_fov_modifier = 1
		end
	else
		if old_pov_is_fp then
			SetValue("ui_fov_modifier", ui_fov_desiredmod, "linear", 0.1)
			if fov_pol then
				if ui_fov_modifier < ui_fov_desiredmod + 0.01 then
					old_pov_is_fp = false
				end
			else
				if ui_fov_modifier > ui_fov_desiredmod - 0.01 then
					old_pov_is_fp = false
				end
			end
		else
			ui_fov_modifier = ui_fov_desiredmod
		end
	end
	if body == 0 and shape == 0 and (not ToggleMenu) and (not isDead) and (not new_ui_open) then
	-- Crosshair Handling
		UiPush()
			UiTranslate(UiCenter(), UiMiddle())
			UiAlign("center middle")
			if Charge > 0 and not recharging then
				UiColor(red, green, blue, 0.75)
			end
			if recharging then
				UiColor(1, 0, 0, 0.75)
			end
			if railgun_fail then
				a = 3*pp_fail_intensity
				if a > 0.75 then
					a = 0.75
				end
				UiColor(1, 0, 0, a)
			end
			if Charge == 0 and not recharging then
				UiColor(0, 0, 0, 0.75)
			end
		-- Get Crosshair Postion based off where Railgun is pointing
			crosshair_x, crosshair_y, dist = UiWorldToPixel(pointpos)
		-- Calculate difference from last xy values
			crosshair_x_diff = value_diff(crosshair_x, old_crosshair_x)
			crosshair_y_diff = value_diff(crosshair_y, old_crosshair_y)
		-- Calculate difference from middle of the screen
			crshr_midscrn_xdiff = value_diff(0, crosshair_x)
			crshr_midscrn_ydiff = value_diff(0, crosshair_y)
			crshr_midscrn_diff = math.sqrt(((0-crosshair_x)^2+(0-crosshair_y)^2))
		-- Average out from last xy values over set threshold
			if crosshair_x_diff > 2 then crosshair_x = value_avg(old_crosshair_x, crosshair_x) end
			if crosshair_y_diff > 2 then crosshair_y = value_avg(old_crosshair_y, crosshair_y) end
		--  Lock Crosshair to middle of screen
			if (crshr_midscrn_diff > 40) and not scoped_zoom then
				if not crosshair_countdown then
					SetValue("crosshair_count", 0, "linear", 0.25)
					crosshair_count = 1
					crosshair_countdown = true
				end
				if crosshair_count <= 0 then
					ghost_crosshair = true
					crosshair_countdown = false
					crosshair_count = 1
				end
				if not ghost_crosshair then
					crosshair_x = 0
					crosshair_y = 0
				end
			else
				crosshair_x = 0
				crosshair_y = 0
				ghost_crosshair = false
				crosshair_countdown = false
				crosshair_count = 1
			end
		-- Check distance to aimpoint before setting Ui translation
			if dist > 0 then
				UiTranslate(crosshair_x, crosshair_y)
			end
		-- Save XY values for next update
			old_crosshair_x = crosshair_x
			old_crosshair_y = crosshair_y
		-- 
			if not uiscalecheck then
				UiScale(0.00555*zoomfov)
				uiscalecheck = true
				ui_scale = 0.00555*zoomfov
			end
			current_zoom = tonumber(GetString("game.player.tool.zoom"))
		--
			if not (current_zoom >= 1.25) then
				scoped_zoom = false
				SetValue("ui_scale", 0.00555*zoomfov, "linear", 0.025)
				if ui_scale < 0.5 then
					ui_scale = 0.5
				end
				UiScale(ui_scale*ui_fov_modifier)
				if not ghost_crosshair then
					UiImage("MOD/Assets/VFX/Crosshair.png")
				else
					if AmmoType == 3 then
						UiColor(1, 0, 0, 0.95)
					else
						UiColor(1, 0.5, 0, 0.95)
					end
					UiImage("MOD/Assets/VFX/Crosshair_warning.png")
				end
				if ghost_crosshair then
					UiTranslate(-crshr_midscrn_xdiff*2, -crshr_midscrn_ydiff*2)
				end
				if AmmoType == 1 then
					UiColor(0, 1, 1, ammo_select_fade)
					UiImage("MOD/Assets/VFX/Crosshair_kinetic_narrow.png")
				end
				if AmmoType == 2 then
					UiColor(1, .5, 0, ammo_select_fade)
					UiImage("MOD/Assets/VFX/Crosshair_incendiary.png")
				end
				if AmmoType == 3 then
					UiColor(1, 0.25, 0.25, ammo_select_fade)
					UiImage("MOD/Assets/VFX/Crosshair_explosive.png")
				end
				if ghost_crosshair then
					UiTranslate(crshr_midscrn_xdiff*2, crshr_midscrn_ydiff*2)
				end
			else
				scoped_zoom = true
				UiColor(red, green, blue, (current_zoom - 1)*1.5)
				if not TP_Pov then
					SetValue("ui_scale", ((1.777*zoomfov)-live_zoomfov)/(zoomfov*2), "linear", 0.025)
				else
					SetValue("ui_scale", 0.00555*zoomfov, "linear", 0.025)
				end
				UiScale(ui_scale)
				if not TP_Pov then
					UiImage("MOD/Assets/VFX/CrosshairAimed.png")
				else
					UiImage("MOD/Assets/VFX/Crosshair.png")
				end
			end
			if ghost_crosshair and not scoped_zoom then
				UiTranslate(-crshr_midscrn_xdiff*2, -crshr_midscrn_ydiff*2)
				if AmmoType == 3 then
					UiColor(1,0,0,1)
					UiImage("MOD/Assets/VFX/Crosshair_blocked.png")
				else
					UiColor(0.75,0.5,0,1)
					UiImage("MOD/Assets/VFX/Crosshair.png")
				end
				UiTranslate(crshr_midscrn_xdiff*2, crshr_midscrn_ydiff*2)
			end
			--if not scoped_zoom then
			--	UiColor(red,green,blue,0.25)
			--	UiScale((spread/3)+0.5)
			--	UiImage("MOD/Assets/VFX/UiSpread.png")
			--end
			-- Blurring crosshairs
			if water_lock or inWater then
				UiBlur(water_count/180)
			end
		UiPop()
	end
-- Status Indicator Handling
	UiPush()
		UiAlign("left")
	-- Universal Postioning of Status Indicator on screen
		if Aiming then
			indicator_x, indicator_y = UiWorldToPixel(TransformToParentPoint(tool_transform, Vec(0.55,-0.1,-1)))
			indicator_threshold = 0.2
		else
			indicator_x, indicator_y = UiWorldToPixel(TransformToParentPoint(tool_transform, Vec(0.5,-0.1,-1)))
			indicator_threshold = 0
		end
	-- Prevent Indicator from wrapping around screen
		if indicator_x < canvas.w*0.4 then
			indicator_x = canvas.w
			UiScale(0)
		end
	-- Retrieve moving average values
		indicator_x_avg = moving_avg_check(indicator_x_table)
		indicator_y_avg = moving_avg_check(indicator_y_table)
		indicator_fp_x_avg = moving_avg_check(indicator_fp_xtable)
		indicator_fp_y_avg = moving_avg_check(indicator_fp_ytable)
	-- Update moving average values before performing adjustments
		moving_avg_update(indicator_x_table, indicator_desired_table_length, indicator_x_table_cnt, indicator_x)
		moving_avg_update(indicator_y_table, indicator_desired_table_length, indicator_y_table_cnt, indicator_y)
		moving_avg_update(indicator_fp_xtable, 5, indicator_fp_xtable_cnt, indicator_x)
		moving_avg_update(indicator_fp_ytable, 5, indicator_fp_ytable_cnt, indicator_y)
	--Using standard algebraic distance forumla
		-- Calculate dist from last xy values
		indicator_adist = math.sqrt(((indicator_x-old_indicator_x)^2+(indicator_y-old_indicator_y)^2))
		-- Calculate dist from average xy values
		indicator_madist = math.sqrt(((indicator_x-old_indicator_x)^2+(indicator_y-old_indicator_y)^2))
	-- Caluclate Player Speed
		indicator_pvel_triggered = false
		indicator_pvel = GetPlayerVelocity()
		if math.abs(PlayerVel[1]) > 5 then
			indicator_pvel_check = true
			indicator_pvel_triggered = true
		end
		if math.abs(PlayerVel[2]) > 5 then
			indicator_pvel_check = true
			indicator_pvel_triggered = true
		end
		if math.abs(PlayerVel[3]) > 5 then
			indicator_pvel_check = true
			indicator_pvel_triggered = true
		end
	-- Revert indicator to moving average
		if TP_Pov or GetPlayerParam("flyMode") then
		-- Revert indicator to moving average
			if TP_Pov then
			indicator_x = indicator_x_avg + 50
			indicator_y = indicator_y_avg - 20
			end
			if GetPlayerParam("flyMode") and not TP_Pov then
			indicator_x = indicator_x_avg + 55
			indicator_y = indicator_y_avg + 30
			end
		end
		if not TP_Pov and not GetPlayerParam("flyMode") then
			indicator_x = indicator_fp_x_avg + 200
			indicator_y = indicator_fp_y_avg + 100
		end
	-- Average out from last update's xy values
		indicator_x = value_avg(old_indicator_x, indicator_x)
		indicator_y = value_avg(old_indicator_y, indicator_y)
	-- Save XY values for next update
		indicator_pvel_check = false
		old_indicator_x = indicator_x
		old_indicator_y = indicator_y
		UiTranslate(indicator_x, indicator_y)
		-- Individual Indicators
		if ((not HideRechargeMeter) or (indicator_lock and not HideRechargeMeterToggle)) and not (ToggleMenu) and ((dist > 0) or (countdown_check_warn)) then
			-- Common Counter to Recharge
			ProgBarDelay_processed = tostring(progbar_round(ProgBarDelay, 1))
			if ProgBarDelay < 10 then
				ProgBarDelay_processed = string.autoinsert(ProgBarDelay_processed:reverse(),0):reverse()
			end
			common_indicator_count = string.autoinsert("0:",ProgBarDelay_processed)
			if common_indicator_count == "0:010.0" then
				common_indicator_count = "0:10.0"
			end
			local uif = ui_fov_modifier
			-- Indicator Aiming Fade In/Out Animation
			if indicator_lock then
				if (Aiming_count >= indicator_threshold) and (Aiming_count < 1) then
					UiTranslate(0, indicator_shrink_ytranslate*178)
					UiScale(indicator_shrink_xscale, Aiming_count*uif)
					UiColorFilter(1, 1, 1, indicator_shrink_xscale)
				end
				if (Aiming_count < indicator_threshold) then
					UiScale(0)
				end
			end
			-- Debug Indicator
			if Debug and debug_indicator then
				UiColor(red, green, blue, 0.6)
				UiScale(0.4*uif, 0.4)
				UiImage("MOD/Assets/VFX/UiDebug.png")
			end
			-- Railgun Cancel Failure
			if cancel_fail then
				UiAlign("left")
				UiColor(1, 0, 0, (0.6*cancel_shrink_xscale))
				UiScale(0.4*uif, 0.4)
				if cancel_count >= indicator_threshold and cancel_count < 1 then
					UiTranslate(0, cancel_shrink_ytranslate*178)
					UiScale(cancel_shrink_xscale*uif, cancel_count)
				end
				if cancel_count < indicator_threshold then
					UiScale(0)
				end
				UiImage("MOD/Assets/VFX/UiRailgunFailWarn.png")
				if blink then
					UiColor(1, 0.75, 0.75, 0.7)
					UiTextOutline(1, 0, 0, 0.75, 0.1)
				else
					UiColor(0.75, 0.25, 0.25, 0.25)
				end
				UiTranslate(290, 160)
				UiFont(dseg14, 128)
				UiText("*WARNING*")
				UiTranslate(-108, 100)
				UiFont(dseg14, 40)
				UiText("DISCHARGE NOW")
			end
			-- Railgun Failure Warning
			if countdown_check_warn then
				UiAlign("left")
				UiColor(1, 0, 0, (0.6*popup_xscale))
				UiScale(0.4*uif, 0.4)
				if railgun_fail_popup_count >= indicator_threshold and railgun_fail_popup_count < 1 then
					UiTranslate(0, popup_ytranslate*178)
					UiScale(popup_xscale*uif, railgun_fail_popup_count*uif)
				end
				if railgun_fail_popup_count < indicator_threshold then
					UiScale(0)
				end
				UiImage("MOD/Assets/VFX/UiRailgunFailWarn.png")
				if blink then
					UiColor(1, 0.75, 0.75, 0.7)
					UiTextOutline(1, 0, 0, 0.75, 0.1)
				else
					UiColor(0.75, 0.25, 0.25, 0.25)
				end
				UiTranslate(290, 160)
				UiFont(dseg14, 128)
				UiText("*WARNING*")
				UiTranslate(-108, 100)
				UiFont(dseg14, 40)
				UiText("DISCHARGE NOW")
			end
			-- "VENTING HEAT"
			if ventheat and not quickfire then
				UiColor(1, 0.25, 0, (0.6*vent_xscale))
				UiScale(0.4*uif, 0.4)
				if ventcount >= indicator_threshold and ventcount < 1 then
					UiTranslate(0, vent_ytranslate*178)
					UiScale(vent_xscale*uif, ventcount*uif)
				end
				if ventcount < indicator_threshold then
					UiScale(0)
				end
				UiImage("MOD/Assets/VFX/UiVentBox.png")
				UiPush()
					progbar_multipy = 450/OG_ProgBarDelay
					progbar_current = OG_ProgBarDelay - ProgBarDelay
					UiImage("MOD/Assets/VFX/UiProgressBar.png",0,0,100+progbar_current*progbar_multipy,352)
				UiPop()
				UiTranslate(224,270)
				UiColor(1, 1, 1, 0.5)
				UiFont(dseg14,56)
				UiText(common_indicator_count)
			end
			-- "VENTING HEAT" -> "RECHARGING..." Ui Glitch
			if glitch1 and not quickfire then
				UiColor(1, 0.25, 0, 0.5)
				UiScale(0.4*uif, 0.4)
				local path = glitch_frame(math.ceil(glitch1count), "MOD/Assets/VFX/UiVentGlitch/")
				UiImage(path)
			end
			-- "RECHARGING..."
			if recharging_ui and not quickfire then
				UiColor(1, 0, 0, 0.6)
				UiScale(0.4*uif, 0.4)
				UiImage("MOD/Assets/VFX/UiRechargeBox.png")
				UiPush()
					progbar_multipy = 450/OG_ProgBarDelay
					progbar_current = OG_ProgBarDelay - ProgBarDelay
					UiImage("MOD/Assets/VFX/UiProgressBar.png",0,0,100+progbar_current*progbar_multipy,352)
				UiPop()
				-- Counter
				UiTranslate(224,270)
				UiColor(1, 1, 1, 0.5)
				UiFont(dseg14,56)
				UiText(common_indicator_count)
			end
			-- "RECHARGING..." -> "READY" Ui Glitch
			if glitch2 and not quickfire then
				UiColor(1, 0, 0, 0.5)
				UiScale(0.4*uif, 0.4)
				local path = glitch_frame(math.ceil(glitch2count), "MOD/Assets/VFX/UiRechargeGlitch/")
				UiImage(path)
			end
			-- Quickfire "READY" Glitch
			if ready_glitch_count > 0 and ready_glitch_count < 10 and quickfire then
				UiAlign("left")
				UiColor(red, green, blue, 0.6)
				UiScale(0.4*uif, 0.4)
				UiTranslate(0, ready_glitch_ytranslate*356)
				UiScale(ready_glitch_xscale*uif, (ready_glitch_count/10)*uif)
				-- Glitch Image Handling
				local path = glitch_frame(math.ceil(ready_glitch_count), "MOD/Assets/VFX/UiReadyGlitch/")
				UiImage(path)
				UiTranslate(175,270)
				UiColor(1,1,1,0.25*(ready_glitch_count/10))
				UiFont(dseg14,56)
				UiText("OV_CHRG")
			end
			-- "READY" / EREADY / QUICKFIRE READY
			if ready or eready then
				UiAlign("left")
				UiScale(0.4*uif, 0.4)
				if ready then
					if readycount < 10 then
						UiTranslate(0, ytranslate * 356)
						UiScale(xscale*uif, (readycount/10)*uif)
					end
				end
				if eready then
					if eready_count >= indicator_threshold and eready_count < 1 then
						UiTranslate(0, eready_shrink_ytranslate*178)
						UiScale(eready_shrink_xscale*uif, eready_count)
					end
					if eready_count < indicator_threshold then
						UiScale(0)
					end
				end
				if not quickfire then
					UiColor(red, green, blue, 0.5*readymltpy)
					if readyflash then
						ready_path = "MOD/Assets/VFX/UiReadyFlash.png"
					else
						ready_path = "MOD/Assets/VFX/UiReadyBox.png"
					end
				else
					UiColor(red, green, blue, 0.5*readymltpy)
					if not ready_glitch_frame_lock then
						SetValue("ready_glitch_frame", 10, "linear", 0.17)
						ready_glitch_frame_lock = true
					end
					if readyflash then
						ready_path = glitch_frame(math.floor(ready_glitch_frame), "MOD/Assets/VFX/UiReadyGlitchFlash/")
					else
						ready_path = glitch_frame(math.floor(ready_glitch_frame), "MOD/Assets/VFX/UiReadyGlitch/")
					end
				end
				UiImage(ready_path)
				if ready_glitch_frame == 10 then
					ready_glitch_frame = 1
					ready_glitch_frame_lock = false
				end
				UiFont(dseg14,56)
				if not quickfire then
					UiTranslate(224,270)
					UiColor(1, 1, 1, 0.5)
					UiText("0:00.0")
				else
					UiTranslate(175,270)
					UiColor(1,1,1,0.25*readymltpy)
					UiText("OV_CHRG")
				end
			end
		end
		-- Blurring Indicator
		if water_lock or inWater then
			UiBlur(water_count/180)
		end
	UiPop()
	-- Bottom left Corner UI Box
	if not HideUi and not isDead then
		UiPush()
		-- Ui Box
			UiColor(0, 0, 0, 0.75)
			UiTranslate(-240, (canvas.h-280) + ui_compaction)
			UiRect(540, 400)
			UiTranslate(4,0)
			UiColor(red, green, blue, 0.5)
			UiRectOutline(536, 396, 8)
			UiTranslate(2,2)
			UiColor(red, green, blue, 0.5)
			UiRectOutline(532, 392, 4)
		-- Title
			UiTranslate(239, 23)
			UiAlign("left")
			UiTextOutline(0, 0, 0, 1, 0.1)
			if ui_font == mono_bold then
				UiFont(ui_font, 32*ui_font_adj)
			else
				UiFont(ui_font, 26*ui_font_adj)
			end
			UiColor(red, green, blue, 0.85)
			UiText("UZI'S SICK AS HELL RAILGUN")
		-- Gamepad Stuff
			if gamepad == true then
				UiTranslate(0,15)
				UiColor(1, 1, 1)
				UiFont(ui_font, 21*ui_font_adj)
				UiText("(Hold Down on Right Thumbstick!)")
			end
		-- Hotkey for Ammo Type Switching
			if HookedToCharge == 0 then
				UiColorFilter(1, 1, 1)
			else
				UiColorFilter(.25, .25, .25)
			end
			UiTranslate(0,15)
			UiFont(ui_font, 21*ui_font_adj)	
			UiColor(.75, .75, .75)
			if gamepad == false then
				local string = string.upper(tostring(keybind_ammoselect))
				local str_lng = string.len(string)
				UiText(string.insert(string.insert("Ammo Type: (Press ", string, 19), " to switch)", 19+str_lng))
			else
				UiText("Ammo Type (Up > D-Pad)")
			end
		-- Ammo Types
			UiTranslate(15,20)
			UiFont(ui_font, 28*ui_font_adj)	
			if AmmoType == 1 then
				UiColor(.5, .5, 0.75)
			else
				UiColor(.75, .75, .75)
			end
			UiText("Kinetic")
			UiTranslate(0,15)
			if AmmoType == 2 then
				UiColor(0.75, .6, .25)
			else
				UiColor(.75, .75, .75)
			end
			UiText("Incendiary")
			UiTranslate(0,15)
			if AmmoType == 3 then
				UiColor(0.75, .25, .25)
			else
				UiColor(.75, .75, .75)
			end
			UiText("Explosive")
		-- Ammo Type Selection Indicator
			UiTranslate(-15, -30)
			UiFont(ui_font, 28*ui_font_adj)
			if AmmoType == 1 then	
				UiColor(.5, .5, 0.75)
				UiText(">")
				ui_ammotranslate = 30
			end
			if AmmoType == 2 then
				UiTranslate(0, 15)	
				UiColor(0.75, .6, .25)
				UiText(">")
				ui_ammotranslate = 15
			end
			if AmmoType == 3 then
				UiTranslate(0, 30)
				UiColor(0.75, .25, .25)
				UiText(">")
				ui_ammotranslate = 0
			end
			if AmmoType == 4 then
				ui_ammotranslate = 30
			end
			UiTranslate(0, ui_ammotranslate)
			UiResetColor()
		-- Firing Power
			UiTranslate(0, 20)
			if HookedToCharge == 0 and not recharging then
				UiColor(.75, .75, .75)
			else
				UiColor(.25, .25, .25)
			end
			UiText("Firing Power:")
			UiTranslate(144,0)
			if Power_lvl % 1 == 0 then
				ui_power_text = string.autoinsert(tostring(Power_lvl),".0")
			else
				ui_power_text = tostring(Power_lvl)
			end
			if ui_power_text == "1" then
				ui_power_text = "1.0"
			end
			UiText(ui_power_text)
			UiTranslate(-147,0)
		-- Firing Power Adjustment Keys
			UiTranslate(0,15)
			UiFont(ui_font, 21*ui_font_adj)
			if gamepad == false then
				local string1 = firstToUpper(tostring(keybind_powerlvl_plus))
				local string2 = firstToUpper(tostring(keybind_powerlvl_minus))
				local str_lng1 = string.len(string1)
				local str_lng2 = string.len(string2)
				UiText(string.insert((string.insert(string.insert(string.insert("(", string1, 1), " and ", 3+str_lng1), string2, 6+str_lng1)), " Keys)", 6+str_lng1+str_lng2))
				--UiText("(Up & Down Arrow Keys)")
			else
				UiText("(Left and Right > D-Pad)")
			end
		-- Spread Info
			if multiplayer == 0 then
				UiTranslate(0, 20)
				UiFont(ui_font, 28*ui_font_adj)	
				UiText("Beam Focus:")
				UiTranslate(130, 0)
				if tonumber(spread) < spread_increment and tonumber(spread) > 0 then
					spread = 0
				end
				if spread % 1 == 0 then
					ui_spread_text = string.autoinsert(tostring(spread),".00")
				else
					if spread % 0.5 == 0 then
						ui_spread_text = string.autoinsert(tostring(spread),"0")
					else
						ui_spread_text = tostring(spread)
						if tostring(ui_spread_text) == "1" then
							ui_spread_text = "1.0"
						end
					end
				end
				local ui_spread_text = string.autoinsert(ui_spread_text,"°")
				UiText(ui_spread_text)
				UiTranslate(-124,0)
			-- Assigned Keys
				UiTranslate(0,15)
				UiFont(ui_font, 21*ui_font_adj)
				if gamepad == false then
					local string1 = firstToUpper(tostring(keybind_kickback_minus))
					local string2 = firstToUpper(tostring(keybind_kickback_plus))
					local str_lng1 = string.len(string1)
					local str_lng2 = string.len(string2)
					UiText(string.insert((string.insert(string.insert(string.insert("(", string1, 1), " and ", 3+str_lng1), string2, 6+str_lng1)), " Keys)", 6+str_lng1+str_lng2))
					--UiText("(Left & Right Arrow Keys)")
				else
					UiText("(Down > D-Pad)")
				end
			end
		-- Hide Ui
			UiTranslate(0, 20)
			UiFont(ui_font, 24*ui_font_adj)	
			UiColor(.5, .5, .5)
			if gamepad == false then
				local string = string.upper(tostring(keybind_hideui))
				local str_lng = string.len(string)
				UiText(string.insert(string.insert("( ", string, 2)," ) Toggle Ui Box Visiblity", str_lng+2))
				--UiText("H -> Toggle UI")
			else
				UiText("(More Opt's in Toggles Menu)")
			end
			if multiplayer == 1 then
				UiTranslate(0,20)	
				UiColor(0.75, 0, 0.75)
				UiText("Multiplayer Mode Enabled")
			end
			if not gamepad then
			--Recharge Indicator
				UiTranslate(0, 17)
				if not HideRechargeMeterToggle then
					UiColor(.75, .75, .75)
				else
					UiColor(.5, .5, .5)
				end
				local string = string.upper(tostring(keybind_hidestatus))
				local str_lng = string.len(string)
				if HideRechargeMeterToggle then 
					status_indicator_str = "Hidden"
				else
					status_indicator_str = "Visible"
				end
				UiText(string.insert(string.insert(string.insert("( ", string, 2)," ) Status Indicator ", str_lng+2), status_indicator_str, str_lng+22))
				--UiText("F6 -> Hide Status Indicator")
			--FPS mode
				UiTranslate(0, 17)
				if not FPSmode then
					UiColor(.5, .5, .5)
				else
					UiColor(.75, .75, 0)
				end
				if multiplayer == 1 then
					UiColor(.75, 0, .75)
				end
				local string = string.upper(tostring(keybind_fpsmode))
				local str_lng = string.len(string)
				UiText("FPS Mode")
				UiTranslate(100, 0)
				if FPSmode then 
					UiText("Enabled")
				else
					UiText("Disabled")
				end
				UiTranslate(-100, 0)
				UiTranslate(225, 0)
				UiText(string.insert(string.insert("( ", string, 2), " )", str_lng+2))
				UiTranslate(-225, 0)
					--UiText("F5 -> FPS mode")
			end
		-- Single Player Exclusive Toggles
			if multiplayer == 0 and not gamepad then
				-- Quickfire
				UiTranslate(0,17)
				UiColor(.5, .5, .5)
				if quickfire then
					UiColor(0.75, 0.35, 0)
				end
				local string = string.upper(tostring(keybind_quickfire))
				local str_lng = string.len(string)
				UiText("Quickfire")
				UiTranslate(100, 0)
				if quickfire then 
					UiText("Enabled")
				else
					UiText("Disabled")
				end
				UiTranslate(-100, 0)
				UiTranslate(225, 0)
				UiText(string.insert(string.insert("( ", string, 2), " )", str_lng+2))
				UiTranslate(-225, 0)
					--UiText("F7 -> Quickfire")
				-- Falloff
				UiTranslate(0,17)
				UiColor(.5, .5, .5)
				if falloff then
					UiColor(0.75, 0.25, 0.25)
				end
				local string = string.upper(tostring(keybind_falloff))
				local str_lng = string.len(string)
				UiText("Falloff")
				UiTranslate(100, 0)
				if falloff then 
					UiText("Enabled")
				else
					UiText("Disabled")
				end
				UiTranslate(-100, 0)
				UiTranslate(225, 0)
				UiText(string.insert(string.insert("( ", string, 2), " )", str_lng+2))
				UiTranslate(-225, 0)
				-- Unlimited Kickback
				UiTranslate(0,17)
				UiColor(.5, 0.5, .5)
				if kbunlimit then
					UiColor(1, 0.75, 0.75)
				end
				local string1 = firstToUpper(tostring(keybind_unlimitkb_1))
				local string2 = firstToUpper(tostring(keybind_unlimitkb_2))
				local str_lng1 = string.len(string1)
				local str_lng2 = string.len(string2)
				UiText(string.insert((string.insert(string.insert(string.insert("Hold ", string1, 5), "+", 6+str_lng1), string2, 7+str_lng1)), " -> Unlimit Kikbck", 7+str_lng1+str_lng2))
					--UiText("Hold F8+F9 -> Unlimit Kikbck")
			end
		UiPop()
		-- Debug Toggles
		UiPush()
			UiAlign("left")
			UiTextOutline(0.75, 0, 0.75, 1, 0.5)
			UiTranslate(305, canvas.h-10)
			UiFont(ui_font, 28*ui_font_adj)	
			UiColor(1, 1, 1)
			if Debug then
				local string = string.upper(tostring(keybind_debug))
				local str_lng = string.len(string)
				UiText(string.insert(string, " -> Debug", str_lng))
				--UiText("F1 -> Debug")
			end
			if multiplayer_debugtoggle == 1 then
				UiTranslate(0, -30)
				local string1 = firstToUpper(tostring(keybind_multiplayertest_1))
				local string2 = firstToUpper(tostring(keybind_multiplayertest_2))
				local str_lng1 = string.len(string1)
				local str_lng2 = string.len(string2)
				UiText(string.insert((string.insert(string.insert(string.insert("Hold ", string1, 5), " + ", 6+str_lng1), string2, 10+str_lng1)), " -> Multiplayer Balance Testing", 10+str_lng1+str_lng2))
				--UiText("Hold Alt + M -> MultiplayerDebug")
			end
		UiPop()
	end
end
end


function RandomVector(magnitude)
	local x = Random()
	local y = Random()
	local z = Random()
	return Vec((x - 0.5) * 2 * magnitude, (y - 0.5) * 2 * magnitude, (z - 0.5) * 2 * magnitude)
end

function FireRandomVec_withfalloff(magnitude2, i)
	local x = math.random(-1, 1) * magnitude2 * ((41-i)/40)
	local y = math.random(-1, 1) * magnitude2 * ((41-i)/40)
	local z = math.random(-1, 1) * magnitude2 * ((41-i)/40)
	return Vec(x,y,z)
end

function FireRandomVec_nofalloff(magnitude2)
	local x = math.random(-1, 1) * magnitude2
	local y = math.random(-1, 1) * magnitude2
	local z = math.random(-1, 1) * magnitude2
	return Vec(x,y,z)
end

function Random()
	return math.random(0, 1000) / 1000
end

function fire_spawn_withfalloff(pos, pass_i)
	for i = 2, 15 do
		rv = VecAdd(pos, FireRandomVec_withfalloff(Power_lvl, pass_i))
		local PwrLvlProx = Power_lvl * 10
		if PwrLvlProx >= i then
			SpawnFire(rv)
			firecount = firecount + 1
		end
	end
end

function fire_spawn_nofalloff(pos)
	for i = 2, 15 do
		rv = VecAdd(pos, FireRandomVec_nofalloff(Power_lvl))
		local PwrLvlProx = Power_lvl * 10
		if PwrLvlProx >= i then
			SpawnFire(rv)
			firecount = firecount + 1
		end
	end
end

function rndFloat(mi, ma)
	return mi + (ma-mi)*(math.random(0, 1000000)/1000000.0)
end

function rndVec(length)
	local v = VecNormalize(Vec(math.random(-100,100), math.random(-100,100), math.random(-100,100)))
	return VecScale(v, length)	
end

function sparksEffect(pos, spark_i)
	if not FPSmode then
		if (AmmoType == 1) or (AmmoType == 2) then
			ParticleReset()
			ParticleEmissive(1 * (Power_lvl * 1.54), 0, "easeout")
			ParticleGravity(math.random(5, 8)*-1, math.random(8, 10)*-1, "smooth")
			ParticleRadius(math.random(20, 30)*.001, 0, "smooth")
			ParticleColor(1, 0.6, 0.5, 0.5, 0.1,0)
			ParticleTile(4)
			ParticleCollide(1)
			ParticleSticky(1)
			local sparklife = Power_lvl * 13
			if sparklife < 12 then
				sparklife = 12
			end
			if not falloff then 
				for i = 1, math.random(62, 204) do
					local vel = VecScale(RandomVector(1), math.random(1,2))
					SpawnParticle(pos, vel, sparklife)
				end
			else
				for i = 1, math.random(30, 60)*((121-spark_i)/120) do
					local vel = VecScale(RandomVector(1), math.random(1,2))
					SpawnParticle(pos, vel, sparklife)
				end
			end
		end
	end
end

function func_railgun_fail_cancel()
	railgun_fail_cancel = true
	railgun_fail_canceled = true
end

function beam()
	-- Multiplayer/MP Testing Player Health Logic
	--if multiplayer == 1 then
	--	SetPlayerHealth(playerhealth-Power_lvl*0.375)
	--end
	--if multiplayer_debugtoggle == 1 then
	--	SetPlayerHealth(playerhealth-Power_lvl*0.375)
	--end
	beginfire = false
	-- Beam Logic
	RDelayRef = RDelay - 2
	RDelayHapticRef = RDelay - 0.75
	LightTransform = tool_transform
	SetLightPos = false
	local Pos = GetPlayerPos()
	local transform = tool_transform
	local origin = TransformToParentPoint(transform, Vec(0.575,-0.4,-0.75))
	-- Find out where the railgun is being pointed by the player
		beam_hit, beam_startpos, beam_endpos, beam_direction, _, beam_distance = GetPlayerAimInfo(origin, 1000)
	-- Deal damage to other player
		--mp_didHit, mp_dist, mp_shape, mp_playerId, mp_playerDamageFactor = QueryShot(origin, beam_direction, 1000, 0, GetLocalPlayer())
		--if mp_didhit and IsPlayerValid(mp_playerId) then
		--	SetPlayerHealth(0.05*mp_playerDamageFactor, mp_playerId)
		--end
	local t = transform
	if beam_hit and beam_distance < 1000 then
		hdist = beam_distance
	end
	Bpos = beam_startpos
	dir = TransformToParentVec(t, Vec(0, 0, -1))
	dir2 = TransformToParentVec(t, Vec(0, 0, -0.5))
	dir3 = TransformToParentVec(t, Vec(0, 0, -0.333))
	hit_P, dist_P = beam_hit, beam_distance
	hitpoint1 = pointpos
	if not Debug or (Debug and multiplayer == 1) then
		camshake = Power_lvl*1.54
		if camshake > 1.2 then
			camshake = 1.2
		end
		ShakeCamera(camshake*0.5) 
	end
	-- Fix whaterver the hell this all means!!!
	if not inital_kickback then
		YYYrecoildir = TransformToParentVec(transform, Vec(0, 0, kickbackpower/3))
		SetPlayerVelocity(VecAdd(GetPlayerVelocity(), YYYrecoildir))
		inital_kickback = true
	else
		YYYrecoildir = TransformToParentVec(transform, Vec(0, 0, (kickbackpower*kickback_falloff)/120))
	end
	local YYYvel = GetPlayerVelocity()
	local YYYoldvel = VecCopy(YYYvel)
	local YYYvel = VecAdd(YYYvel, YYYrecoildir)
	if VecLength(YYYvel) > kickbackpower/3 then
		YYYvel = YYYoldvel
	end
	SetPlayerVelocity(YYYvel)
		--Holeoverride
			StopCount = false
			p = TransformToParentPoint(t, Vec(0.575, -0.595, -2))
			if falloff then
				beam_exp2 = beam_distance
			end
			if not falloff then
				beam_exp2 = beam_distance+40
			end
		-- Fire a photon X amount of times for this frame
		if not (GetPlayerHealth() == 0) then
			for lhc = 0, math.floor(holecount_adj * firebeam * Power_lvl * timeScale) do
			-- Convert Player chosen spread from Degrees to Radians
				local deci_spread = ((spread*math.pi)/180)*firebeam
			-- Calculate random deviation in the direction
				working_rot, spread_deviation = randomDeviatedVector(beam_direction, deci_spread)
			-- Fire off raycast in new direction
				spread_hit, spread_dist = QueryRaycast(beam_startpos, working_rot, 1000)
			-- Find hitpoint by scaling vector
				hitpoint = (VecAdd(beam_startpos, VecScale(working_rot, spread_dist)))
				--spread_deviation = math.sqrt((hitpoint[1]+pointpos[1])^2+(hitpoint[2]+pointpos[2])^2+(hitpoint[3]+pointpos[3])^2)
			-- Making "Long Hole" (REPLACE THIS TERM!!!!)
				for i = 0, math.floor(5*Power_lvl) do
					falloff_mltply = (5-i)/5
					max_dist = Power_lvl*30
					long_power = 0.2*falloff_mltply*firebeam*(1-spread_deviation)
					if beam_distance > max_dist then
						long_power = long_power*(max_dist/beam_distance)
					end
					if hit then
						if AmmoType == 1 then
							MakeHole(VecAdd(hitpoint, VecScale(working_rot, i)), long_power, long_power, long_power)
						end
						if AmmoType == 2 then
							local ignite_origin = VecAdd(hitpoint, VecScale(working_rot, i))
							local list = QueryAabbShapes(ignite_origin,ignite_origin)
							AddHeat(list[1],ignite_origin, firebeam*falloff_mltply)
						end
						Paint(VecAdd(hitpoint, VecScale(working_rot, i)), long_power*2, "explosion")
					end
					DrawLine(Bpos, hitpoint, red_beam, green_beam, blue_beam, 1)
				end
				if AmmoType == 3 then
					Explosion(hitpoint, long_power)
					--PlaySound(ExplodeSND, hitpoint, 0.5)
					--MakeHole(VecAdd(hitpoint, VecScale(working_rot, i)), long_power, long_power, long_power)
				end
			end
		end
			for i = 0, 40 do
				if falloff then
					falloff_mltply40 = (41-i)/40
				else
					falloff_mltply40 = 1
				end
				if not HideImpact and not FPSmode then
					--Paint(VecAdd(hitpoint1, VecScale(dir, i)), Power_lvl*PaintSize*falloff_mltply40, "explosion")
				end
				if not HideImpact and not FPSmode and AmmoType == 3 then
					--impactEffect(VecAdd(hitpoint1, VecScale(dir, i)))
				end
				-- AmmoType == 3 then
				--	Explosion(VecAdd(hitpoint1, VecScale(dir2, i)), Power_lvl*falloff_mltply40*firebeam)
				--	PlaySound(ExplodeSND, VecAdd(hitpoint1, VecScale(dir2, i)), 0.5)
				--end
			end
			--for i = 0, 120 do
			--	if not HideImpact or AmmoType == 3 then
			--		if not falloff then
			--			--sparksEffect(VecAdd(hitpoint3, VecScale(dir3, i)), 1)
			--		else
			--			--sparksEffect(VecAdd(hitpoint3, VecScale(dir3, i)), i)
			--		end
			--	end
			--end
		--else
		--	beam_exp2 = 1000
		--end
		if HideImpact then
			hdist = 250
		else
			if not HideImpact then
				hdist = beam_distance+350
			end
		end
		light_begin = true
		-- Spawn Beam
		ParticleCollide(0)
		ParticleTile(6)
		ParticleRadius(0.05, 0,"smooth")
		ParticleColor(red_beam, green_beam, blue_beam, 0, 0, 0)
		ParticleEmissive(5,0)
		ParticleDrag(0.0001)
		ParticleGravity(0)
		--for i3 = 0, beam_exp2, 0.01 do --0.01
		--	SpawnParticle(VecAdd(beam_startpos, VecScale(beam_direction, i3)), Vec(0, 0, 0), 1) --2.27
		--end
		beam_radius = spread*4.5
		if beam_radius < 0.1 then
			beam_radius = 0.1
		end
		beam_radius = beam_radius*firebeam
		ParticleRadius(0.08, beam_radius)
		ParticleAlpha(0.5*firebeam,0.,"linear")
		beam_speed = VecScale(beam_direction, 250)
		beam_lowspeed = VecScale(beam_direction, 50)
		--beam_startpos = VecAdd(beam_startpos, GetPlayerVelocity())
		--SpawnParticle(VecSub(VecSub(beam_startpos, VecScale(beam_direction,PlayerAbsoluteSpeed*0.4)), VecScale(beam_direction,1)), beam_speed, 0.25) --2.27
		--SpawnParticle(VecSub(VecSub(beam_startpos, VecScale(beam_direction,PlayerAbsoluteSpeed*0.15)), VecScale(beam_direction,1)), beam_speed, 0.25) --2.27
		--SpawnParticle(VecSub(beam_startpos, VecScale(beam_direction,PlayerAbsoluteSpeed)),beam_speed, 0.25)
		--ParticleRadius(0.08)
		--ParticleAlpha(firebeam,0,"linear")
		--SpawnParticle(TransformToParentPoint(tool_transform, Vec(0.575,-0.4,-0.2)), beam_lowspeed, 0.25)
		--SpawnParticle(VecSub(beam_startpos, VecScale(beam_direction,0.5)),beam_lowspeed, 0.2)
		--end
		-- Beam Pointlight Handling
		light_dist = beam_distance
		if (beam_distance > 50) or (not beam_hit) then
			light_dist = 50
		end
		if (not long_lightbeam) or FPSmode then
			beamptlightcnt = 10
		else
			beamptlightcnt = 50
		end
		--Beam line start and end points
		light_startpos = VecSub(beam_startpos, VecScale(beam_direction,4.5))
		light_endpos = VecAdd(beam_startpos, VecScale(beam_direction, light_dist))
		light_lastpos = light_startpos
		light_beam_spawn = true
		light_beam_lock = false
		LightSize = (Power_lvl/2)*(spread*2)+0.5
end

function light_beam()
	if not light_beam_lock then
		SetValue("LightSize", 0, "linear", 0.05)
		light_beam_lock = true
	end
	--Laser line start and end points
	for i=1, beamptlightcnt do
		local light_t = i/20
		p = VecLerp(light_startpos, light_endpos, light_t)
		PointLight(light_lastpos, red, green, blue, LightSize)
		light_lastpos = p
	end
	if LightSize <= 0 then
		light_beam_spawn = false
	end
end

function impactEffect(hitpoint1)
	--fire 
	local q = 1.0 
	local caliber = 50
	--- sparks
	local vel = 5
	for i=1, math.ceil(caliber)*4 do
		local v = rndVec(rndFloat(vel*0.5, vel*1.5))
		local life = rndFloat(0, 1)
		life = life*life * 10
		ParticleReset()
		ParticleEmissive(5, 0, "easeout")
		ParticleGravity(-5)
		ParticleRadius(0.03, 0.0, "easeout")
		ParticleColor(red_beam, green_beam, blue_beam, 1, 0.5, 0)
		ParticleTile(5)
		SpawnParticle(hitpoint1, v, life)
	end
end

function string.insert(str1, str2, str_pos)
    return str1:sub(1,str_pos)..str2..str1:sub(str_pos+1)
end

function string.autoinsert(str1, str2)
	local str_pos = string.len(str1)
    return str1:sub(1,str_pos)..str2..str1:sub(str_pos+1)
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function clamp(value, mi, ma)
	if value < mi then value = mi end
	if value > ma then value = ma end
	return value
end

function BrigAlarm()
	local pos = GetPlayerPos()
	PlaySound(balarmSND, pos)
end

function muzzleEffect()
	ParticleReset()
	local fps = GetFps()
	local melife = 0.02
	pp[1] = TransformToParentPoint(tool_transform, Vec(0.4,-0.3,-0.75)) 
	pp[2] = TransformToParentPoint(tool_transform, Vec(0.7,-0.3,-0.75))
	pp[3] = TransformToParentPoint(tool_transform, Vec(0.4,-0.3,-1.5)) 
	pp[4] = TransformToParentPoint(tool_transform, Vec(0.7,-0.3,-1.5))
	if railgun_fail == true then
		if GetTime() < tonumber(countdown_zero) then
			pp_fail_intensity = 0.25 * random_flicker
		else
			pp_fail_intensity = (1 - (failtime - GetTime()))*(3*(Power_lvl/0.7))
			if pp_fail_intensity < 0.25 then
				pp_fail_intensity = 0.25
			end
		end
	end
	if HookedToCharge == 0 then
		if not FPSmode then
			if Charge > 0 and not recharging and not railgun_fail then
				for i = 1, 4 do
					PointLight(pp[i], red, green, blue, 0.5)
				end
			end
			if recharging then
				for i = 1, 4 do
					PointLight(pp[i], 1, 0, 0, 0.5)
				end
			end
			if railgun_fail then
				for i = 1, 4 do
					PointLight(pp[i], 1, 0, 0, pp_fail_intensity)
				end
			end
		else
			if Charge > 0 and not recharging then
				for i = 1, 4 do
					PointLight(pp[i], red, green, blue, 0.25)
				end
			end
			if recharging then
				for i = 1, 4 do
					PointLight(pp[i], 1, 0, 0, 0.25)
				end
			end
			if railgun_fail then
				for i = 1, 4 do
					PointLight(pp[i], 1, 0, 0, pp_fail_intensity)
				end
			end
		end
	end
	if HookedToCharge == 1 then
		ParticleType("plain")
		ParticleRadius((100 - Charge)/ 1250)
		--DebugPrint((100 - Charge)/ 1250)
		ParticleTile(4)
		ParticleColor(red_beam,green_beam,blue_beam)
		ParticleAlpha(1,0,"linear")
		ParticleEmissive(0.27,5)
		ParticleGravity(0)
		if not FPSmode then
			for i = 1, 4 do
				PointLight(pp[i], red, green, blue, (100 - Charge) * (Power_lvl * 1.54) / 30)
			end
		else
			for i = 1, 4 do
				PointLight(pp[i], red, green, blue, (100 - Charge)/ 30)
			end
		end
		if not fpsmode then
			for i = 1, 32 do
				SpawnParticle(TransformToParentPoint(tool_transform, Vec(0.575,-0.4,-1.1 -(0.025*i))), PlayerVel, melife)
			end
		else
			for i = 1, 16 do
				SpawnParticle(TransformToParentPoint(tool_transform, Vec(0.575,-0.4,-1.1 -(0.05*i))), PlayerVel, melife)
			end
		end
	end
end

-- Start of section of ChatGPT code because I don't understand the math going on here.
function matVecMul(M, v)
    return {
        M[1][1]*v[1] + M[1][2]*v[2] + M[1][3]*v[3],
        M[2][1]*v[1] + M[2][2]*v[2] + M[2][3]*v[3],
        M[3][1]*v[1] + M[3][2]*v[2] + M[3][3]*v[3]
    }
end

function rotationMatrixFromAxisAngle(u, a)
    local x, y, z = u[1], u[2], u[3]
    local c, s = math.cos(a), math.sin(a)
    local t = 1 - c

    return {
        {t*x*x + c,     t*x*y - s*z, t*x*z + s*y},
        {t*x*y + s*z,   t*y*y + c,   t*y*z - s*x},
        {t*x*z - s*y,   t*y*z + s*x, t*z*z + c  }
    }
end

-- Returns ONE random direction deviated from dir by <= spread (radians)
function randomDeviatedVector(input_dir, input_spread)
    gpt_dir = VecNormalize(input_dir)

    -- Step 1: sample spherical cap around north pole
    local z = math.random() * (1 - math.cos(input_spread)) + math.cos(input_spread)
    local phi = math.random() * 2 * math.pi

    local r = math.sqrt(1 - z*z)
    local localVec = {
        r * math.cos(phi),
        r * math.sin(phi),
        z
    }

    -- Step 2: rotate from north pole to dir
    local north = {0, 0, 1}

    if gpt_dir[1] == 0 and gpt_dir[2] == 0 and gpt_dir[3] == 1 then
        return localVec
    end

	

    local axis = VecNormalize(VecCross(north, gpt_dir))
    local angle = math.acos(VecDot(north, gpt_dir))
    local R = rotationMatrixFromAxisAngle(axis, angle)

    local deviated = matVecMul(R, localVec)

	-- deviation in [0, 1]
	local dot = VecDot(VecNormalize(input_dir), VecNormalize(deviated))
	dot = math.max(-1, math.min(1, dot)) -- numerical safety

	local angle = math.acos(dot)
	local deviation = angle / input_spread

	return deviated, deviation
	
end

-- End of ChatGPT code. Pray to god I never have to enlist this shit again.

function render(dt)
	--local muzzle_copy = GetBodyTransform(GetToolBody())
	--local tool_pos = muzzle_copy.pos
	--local tool_rot = muzzle_copy.rot
	--tool_transform_x = moving_avg_check(tool_transform_x_table)
	--tool_transform_y = moving_avg_check(tool_transform_y_table)
	--tool_transform_z = moving_avg_check(tool_transform_z_table)
	--if not (tool_pos ~= old_tool_pos) then
	--	moving_avg_update(tool_transform_x_table, 144, tool_transform_x_cnt, tool_pos[1])
	--	moving_avg_update(tool_transform_y_table, 144, tool_transform_y_cnt, tool_pos[2])
	--	moving_avg_update(tool_transform_z_table, 144, tool_transform_z_cnt, tool_pos[3])
	--end
	--muzzle_tool_transform = Transform(Vec(tool_transform_x, tool_transform_y, tool_transform_z), tool_rot)
	if muzzle_effect and GetString("game.player.tool") == "ORIS_Railgun_MD_Reskin" then
		muzzleEffect()
	end
	--old_tool_pos = tool_pos
	timeScale = dt * GetFps()
	if GetFps() > Max_FPS then
		Max_FPS = GetFps()
	end
end

function v034_defaults()
	SetBool("savegame.mod.multi_test", false)
   	SetColor("savegame.mod.highlight_color", 0, 255, 0)
	SetColor("savegame.mod.beam_color", 255, 255, 255)
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
end

function v041_defaults()
	SetString("savegame.mod.keybind_ammoselect", "r")
	SetString("savegame.mod.keybind_powerlvl_plus", "uparrow")
	SetString("savegame.mod.keybind_powerlvl_minus", "downarrow")
	SetString("savegame.mod.keybind_kickback_plus", "rightarrow")
	SetString("savegame.mod.keybind_kickback_minus", "leftarrow")
	SetString("savegame.mod.keybind_hideui", "h")
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

function v05X_defaults()
	SetString("savegame.mod.ui_font", "Roboto")
end

function Grab_Registry_Keys()
	-- Original v0.3.4 Keys
	true_multiplayer_test = GetBool("savegame.mod.multi_test") == true
	hcolor = GetColor("savegame.mod.highlight_color")
	bcolor = GetColor("savegame.mod.beam_color")
	-- Persistent Toggles (v0.3.8.X)
	AmmoType = GetInt("savegame.mod.ammo_type")
	Power_lvl = GetString("savegame.mod.fire_power")
	kb_adj = GetString("savegame.mod.kb_pwr")
	HideUiToggle = GetBool("savegame.mod.hideui")
	FPSmode = GetBool("savegame.mod.fpsmode")
	HideRechargeMeter = GetBool("savegame.mod.hiderechargeindicator")
	quickfire = GetBool("savegame.mod.quickfire")
	falloff = GetBool("savegame.mod.falloff")
	kbunlimit = GetBool("savegame.mod.kb_unlimit")
	long_lightbeam = GetBool("savegame.mod.long_lightbeam")
	Debug = GetBool("savegame.mod.debug_default")
	-- Experimental Power Limit Disabler
	unlimitPower = GetBool("savegame.mod.unlimitPower")
	-- Keybinds (v0.4.1)
	keybind_ammoselect = GetString("savegame.mod.keybind_ammoselect")
	keybind_powerlvl_plus = GetString("savegame.mod.keybind_powerlvl_plus")
	keybind_powerlvl_minus = GetString("savegame.mod.keybind_powerlvl_minus")
	keybind_kickback_plus = GetString("savegame.mod.keybind_kickback_plus")
	keybind_kickback_minus = GetString("savegame.mod.keybind_kickback_minus")
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
	haptics = GetBool("savegame.mod.haptictoggle")
	-- v0.5.0.X Toggles
	--ui_font = GetString("savegame.mod.ui_font")
end

function Variable_Intialization()
	firecount = 0
	Ammo = 1
	Delay = 60
	Stop_Count = false
	Charge = 100
	recoil = 0
	LDelay = 0
	LCharge = 100
	RDelay = 8
	RDelayRef = 0
	RDelayHapticRef = 99
	fired = false
	blurcount = 20
	beginready = false
	beginglitch1 = false
	beginglitch2 = false
	ready = false
	ready_glitch_count = 0
	ready_glitch_frame = 1
	readycount = 240
	ventcount = 0
	glitch1count = 10
	glitch2count = 10
	RemoveUi = false
	TempHideUi = false
	HideUi = false
	RailgunOffset_X = 0
	RailgunOffset_Y = 0
	RailgunOffset_Z = 0
	sway = 1
	Pos = 0
	ldirection = 0
	SparkVel = 1
	hdist = 5
	StopHole = false
	SoundStop = true
	HideImpact = false
	Count = 0
	StopCount = true
	SetLightPos = false
	LightSize = 1
	kickbackpower = 120
	maxkickback = 200
	recharging = false
	HookedToCharge = 0
	multiplayer_debugtoggle = 0
	true_max_power = 3
	railgun_fail_popup_count = 0
	railgun_fail_popup = false
	countdown_warn = 999999999
	countdown_popup_complete = 999999999
	countdown_check_warn = false
	countdown_crackle = 999999999
	countdown_check_crackle = false
	random_flicker = 1
	countdown_zero = 999999999
	failtime = 999999999
	eready = false
	eready_count = 1
	cancel_fail = false
	cancel_count = 1
	Aiming = false
	Aiming_count = 10
	repeat_delay_start = {}
	repeat_regulate = {}
	indicator_desired_table_length = 20
	old_crosshair_x = 0
	old_crosshair_y = 0
	old_indicator_x = 950
	old_indicator_y = 600
	indicator_fp_xtable = {}
	indicator_fp_ytable = {}
	for i = 0, 5 do
		indicator_fp_xtable[i] = 1300
		indicator_fp_ytable[i] = 630
	end
	indicator_fp_xtable_cnt = 1
	indicator_fp_ytable_cnt = 1
	indicator_x_table = {}
	indicator_y_table = {}
	for i = 0, indicator_desired_table_length do
		indicator_x_table[i] = 950
		indicator_y_table[i] = 600
	end
	indicator_x_table_cnt = 1
	indicator_y_table_cnt = 1
	--tool_transform_x_table = {}
	--tool_transform_y_table = {}
	--tool_transform_z_table = {}
	--for i = 0, 144 do
	--	tool_transform_x_table[i] = 0
	--	tool_transform_y_table[i] = 0
	--	tool_transform_z_table[i] = 0
	--end
	--tool_transform_x_cnt = 1
	--tool_transform_y_cnt = 1
	--tool_transform_z_cnt = 1
	TP_Pov = GetBool("game.thirdperson")
	old_pov_is_fp = not TP_Pov
	pp = {}
	font_button = GetString("savegame.mod.ui_font")
	if font_button == "Console" then
		ui_font = console
		ui_font_adj = 1
	else
		ui_font = mono_bold
		ui_font_adj = 0.75
	end
	spread = 5
	hitpoint = "THIS_SHOULDN'T_EVER_BE_VISIBLE"
	beam_direction = "THIS_SHOULDN'T_EVER_BE_VISIBLE"
	spread_increment = 0.5
	max_spread = 15
	holecount_adj = 30
	scroll_qz_reset()
	ProgBarDelay = 0
	smoke_size = 0.1
	fail_smoke_density = 0
	cancel_fail_smoke_time = 1
	smoke_fail = false
	photon_ratio = 0.99
	Max_FPS = 0
	colors_saved = false
	color_notice_time = 999999999
end

-- Source - https://stackoverflow.com/a/41534034
-- Posted by Vlad
-- Retrieved 2026-03-15, License - CC BY-SA 3.0

function progbar_round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	local result = math.floor(num * mult + 0.5) / mult
	if result % 1 == 0 then
		result = tostring(result):autoinsert(".0")
	end
	return result
end


-- Legacy Frame Counter Reimplementation (Use the proper "SetValue()" function where possible!)
function counter_fix(start_time, end_time, decreasing, extra_multiply)
	-- Get length 
	total = end_time - start_time
	diff = GetTime() - start_time
	-- Diff Maximum
	if diff > total then
		diff = total
	end
	-- Diff Minimum
	if diff < 0 then
		diff = 0
	end
	-- Decreasing Counter
	if decreasing then
		diff = total - diff
	end
	-- Divide Diff by Total
	diff = diff / total
	-- Extra Multiplication
	result = diff * extra_multiply
	return result
end
	
-- Checks to see if its past the delay time
function RepeatDelay(input_id)
	delay_time = repeat_delay_start[input_id]
	true_time = GetTime()
	if (true_time >= delay_time) then
		return true
	else
		return false
	end
end

-- Checks to see if its past the regulate time
function RepeatRegulate(input_id)
	reg_time = repeat_regulate[input_id]
	current_time = GetTime()
	if (current_time >= reg_time) then
		return true
	else
		return false
	end
end

function scroll_qz_reset()
	scroll_counter = 0
	scroll_quick_zoom = false
	SetValue("scroll_qz_timer", 1)
	--PlaySound(PlaceholderSND)
end

function Debug_Scope_Zoom()
	DebugWatch("to_round", to_round)
	DebugWatch("divided", divided)
	DebugWatch("zoom", zoom)
	DebugWatch("current_tool_zoom", current_zoom)
	DebugWatch("zoomfov", zoomfov)
	DebugWatch("truegamefov", GetInt("options.gfx.fov"))
	DebugWatch("calc_zoomfov", calc_zoomfov)
	DebugWatch("live_zoomfov", live_zoomfov)
	DebugWatch("ui_scale", ui_scale)
	DebugWatch("MouseScroll", InputValue("mousewheel"))
	DebugWatch("scroll_counter", scroll_counter)
	DebugWatch("scroll_quick_zoom", scroll_quick_zoom)
	DebugWatch("scroll_qz_timer", scroll_qz_timer)
end

function Debug_Status_Indicator()
	DebugWatch("ventheat", ventheat)
	DebugWatch("ventcount", ventcount)
	DebugWatch("beginglitch1", beginglitch1)
	DebugWatch("glitch1", glitch1)
	DebugWatch("glitch1count", glitch1count)
	DebugWatch("beginglitch2", beginglitch1)
	DebugWatch("glitch2", glitch2)
	DebugWatch("glitch2count", glitch1count)
	DebugWatch("beginready", beginready)
	DebugWatch("ready", ready)
	DebugWatch("readycount", readycount)
	DebugWatch("eready", eready)
	DebugWatch("eready_check", eready_check)
end

function Save_Color_Settings()
	SetColor("savegame.mod.highlight_color", math.floor(red*255), math.floor(green*255), math.floor(blue*255))
	SetColor("savegame.mod.beam_color", math.floor(red_beam*255), math.floor(green_beam*255), math.floor(blue_beam*255))
end
	
function DebugKeybinds()
	DebugWatch("keybind_ammoselect", keybind_ammoselect)
	DebugWatch("keybind_powerlvl_plus", keybind_powerlvl_plus)
	DebugWatch("keybind_powerlvl_minus", keybind_powerlvl_minus)
	DebugWatch("keybind_kickback_minus", keybind_kickback_minus)
	DebugWatch("keybind_kickback_plus", keybind_kickback_plus)
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
end

function glitch_frame(num, func_path)
	local count = tostring(num)
	local count_lng = string.len(count)
	local path = func_path
	local path_lng = string.len(path)
	glitch_path = string.insert(string.insert(path, count, path_lng + count_lng),".png",  path_lng + count_lng + 4)
	return glitch_path
end

function value_diff(a, b)
	c = math.abs(a) - math.abs(b)
	return math.abs(c)
end

function value_avg(a, b)
	c = (a + b)/2
	return c
end

function cubeRoot(x)
	return (x ^ (1 / 3))
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function moving_avg_update(input_table, desired_length, input_table_last_pos, value)
	table.insert(input_table, value)
	if tablelength(input_table) >= desired_length then
		table.remove(input_table, input_table_last_pos)
		input_table_last_pos = input_table_last_pos + 1
	end
	return input_table_last_pos
end

function moving_avg_check(input_table)
    local total = 0
    for i = 1, tablelength(input_table) do
        local value = input_table[i] or 0
    -- problem line 2662 below
        total = total + value
    end
    local move_avg = total / tablelength(input_table)
    return move_avg
end

function Railgun_Fail_Pause()
	Ammo = 1
	Delay = 60
	Stop_Count = false
	Charge = 100
	recoil = 0
	LDelay = 0
	LCharge = 100
	RDelay = 8
	RDelayRef = 0
	RDelayHapticRef = 99
	fired = false
	blurcount = 20
	beginready = false
	beginglitch1 = false
	beginglitch2 = false
	ready = false
	readycount = 240
	ventcount = 0
	glitch1count = 10
	glitch2count = 10
	sway = 1
	Pos = 0
	ldirection = 0
	SparkVel = 1
	hdist = 5
	StopHole = false
	SoundStop = true
	HideImpact = false
	Count = 0
	StopCount = true
	kickbackpower = 120
	maxkickback = 200
	recharging = false
	HookedToCharge = 0
end

function ClearALLKeys()
	ClearKey("savegame.mod.version")
	ClearKey("savegame.mod.multi_test")
	ClearKey("savegame.mod.highlight_color")
	ClearKey("savegame.mod.beam_color")
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
	ClearKey("savegame.mod.ui_font")
	Menu()
end

	-- Gets expected total count of photons for this frame
		--Photon_Pool = math.floor(holecount_adj * firebeam * Power_lvl * timeScale)
	-- Finds ~75% of the photons, which will be the kinetic photons.
		--kinetic_photons = math.floor(Photon_Pool * photon_ratio)
	-- Fire a photon X amount of times for this frame
		--for lhc = 0, math.floor(holecount_adj * firebeam * Power_lvl * timeScale) do
		-- Pick a random number to decide whether we're firing a kinetic or incendiary photon
			--random_photon_type = math.random(0, Photon_Pool)
			--if random_photon_type > kinetic_photons then
			-- Firing a incendiary photon
			--	photon_type = 2
			-- Remove that incendiary photon from pool of photons
			--	Photon_Pool = Photon_Pool - 1
			--else
			-- Firing a kinetic photon
			--	photon_type = 1
			-- Remove that kinetic photon from pool of photons
			--	kinetic_photons = kinetic_photons - 1
			-- Reduce total size of pool of photons
			--	Photon_Pool = Photon_Pool - 1
			--end
