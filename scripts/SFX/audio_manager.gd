extends Node

@onready var shot_sfx = $ShotSFX
@onready var hurt_sfx = $HurtSFX
@onready var died_sfx = $DiedSFX
@onready var parried_sfx = $ParriedSFX
@onready var enemy_spawn_sfx = $EnemySpawnSFX
@onready var menu_move_sfx = get_node_or_null("MenuMove")
@onready var menu_select_sfx = get_node_or_null("MenuSelect")
@onready var start_tune_sfx = get_node_or_null("StartTune")
@onready var slash_sfx = $SlashSFX
@onready var slash_shot_sfx = $SlashShotSFX
@onready var player_hurt_sfx = $PlayerHurtSFX
@onready var walk_sfx = $WalkSFX
@onready var dash_sfx = $DashSFX
@onready var empty_gun = $EmptyAmmo
@onready var recover_sfx = $Recover

func shot():
	if not shot_sfx.is_playing():
		shot_sfx.play_sound()

func hurt():
	if not hurt_sfx.is_playing():
		hurt_sfx.play()

func player_hurt():
	# if not player_hurt_sfx.is_playing():
		player_hurt_sfx.play()

func died():
	#if not died_sfx.is_playing():
		died_sfx.play()

func parried():
	if not parried_sfx.is_playing():
		parried_sfx.play()

func slash():
	# if not slash_sfx.is_playing():
		slash_sfx.play()

func slash_shot():
	slash_shot_sfx.play()

func walk():
	walk_sfx.play()

func dash():
	dash_sfx.play()

func enemySpawn():
	if not enemy_spawn_sfx.is_playing():
		enemy_spawn_sfx.play()

func MenuMove():
	menu_move_sfx.play()

func MenuSelect():
#	if not menu_select_sfx.is_playing():
		menu_select_sfx.play()

func start_tune():
	if start_tune_sfx and !start_tune_sfx.is_playing():
		start_tune_sfx.play()

func out_of_ammo():
	empty_gun.play()

func recover():
	if not recover_sfx.is_playing():
		recover_sfx.play()

func recover_stop():
	recover_sfx.stop()