extends Node

func play_varied_sfx(node:String,from_here:float,to_here:float):
	var this_node = get_node(node)
	if not this_node.is_playing() and GLOBAL.sfx_on:
		this_node.pitch_scale = randf_range(from_here, to_here)
		this_node.play()

func alert():
	play_varied_sfx("Alert",0.9,1.35)

func unequip():
	play_varied_sfx("Unequip",0.9,1.35)

func play_this_sfx(node:String):
	var this_node = get_node(node)
	if not this_node.is_playing() and GLOBAL.sfx_on:
		this_node.play()

func shot():
	play_this_sfx("ShotSFX")

func player_hurt():
	play_this_sfx("PlayerHurtSFX")

func parried():
	play_this_sfx("ParriedSFX")

func dash():
	play_this_sfx("DashSFX")

func enemySpawn():
	play_this_sfx("EnemySpawnSFX")

func MenuSelect():
	play_this_sfx("MenuSelect")

func start_tune():
	play_this_sfx("StartTune")

func out_of_ammo():
	play_this_sfx("EmptyAmmo")

func portal_opens():
	play_this_sfx("PortalOpens")

func recover():
	play_this_sfx("Recover")

func recover_stop():
	$Recover.stop()

func play_this_sfx_unlimited(node:String):
	var this_node = get_node(node)
	if GLOBAL.sfx_on:
		this_node.play()

func died():
	play_this_sfx_unlimited("DiedSFX")

func hurt():
	play_this_sfx_unlimited("HurtSFX")

func slash():
	play_this_sfx_unlimited("SlashSFX")

func slash_shot():
	play_this_sfx_unlimited("SlashShotSFX")

func walk():
	play_this_sfx_unlimited("WalkSFX")

func MenuMove():
	play_this_sfx_unlimited("MenuMove")

func heal():
	play_this_sfx_unlimited("Heal")

func equip():
	play_this_sfx_unlimited("Equip")

func crunchyMash():
	play_this_sfx_unlimited("CrunchyMash")

func get_card():
	play_this_sfx_unlimited("GetCard")

func pick_coin():
	play_this_sfx_unlimited("Coin")

