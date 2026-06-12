extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#BGM.stopStage1()
	$Transition.color = Color.BLACK
	$Transition/AnimationPlayer.play("Fade_Out")
	#await PLAYSFX.start_tune_sfx.finished
	BGM.playStage1()
	#DisplayServer.window_set_size(Vector2i(1280, 720))
