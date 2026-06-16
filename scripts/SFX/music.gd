extends AudioStreamPlayer

@onready var stage1Tune = $Stage1
@onready var stage3Tune = $Stage3
@onready var gameOverTune = $GameOver

func stopStage1():
	stage1Tune.stop()

func playStage1():
	stage1Tune.play()

func playStage3():
	stage3Tune.play()

func GameOver():
	stopStage1()
	gameOverTune.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
