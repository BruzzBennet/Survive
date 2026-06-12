extends Node

@onready var shot_sfx = $ShotSFX
@onready var hurt_sfx = $HurtSFX
@onready var died_sfx = $DiedSFX
@onready var parried_sfx = $ParriedSFX
@onready var start_tune_sfx = get_node_or_null("StartTune")

func _ready():
	print(get_children())

func shot():
	if not shot_sfx.is_playing():
		shot_sfx.play_sound()

func hurt():
	if not hurt_sfx.is_playing():
		hurt_sfx.play()

func died():
	#if not died_sfx.is_playing():
		died_sfx.play()

func parried():
	if not parried_sfx.is_playing():
		parried_sfx.play()

func start_tune():
	if start_tune_sfx and !start_tune_sfx.is_playing():
		start_tune_sfx.play()
