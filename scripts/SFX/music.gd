extends AudioStreamPlayer

@onready var stage1Tune = $Stage1
@onready var stage3Tune = $Stage3

func stopStage1():
	stage1Tune.stop()

func playStage1():
	stage1Tune.play()

func playStage3():
	stage3Tune.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
