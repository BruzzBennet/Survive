extends AudioStreamPlayer

@onready var stage1Tune = $Stage1
@onready var stage3Tune = $Stage3
@onready var gameOverTune = $GameOver
@onready var menuTune = $Menu
@onready var overworldTune = $Overworld

# func stopStage1():
# 	stopMusic()
# 	stage1Tune.stop()
func stopMusic():
	stage1Tune.stop()
	stage3Tune.stop()
	gameOverTune.stop()
	menuTune.stop()
	overworldTune.stop()

func playStage1():
	stopMusic()
	stage1Tune.play()

func playStage3():
	stopMusic()
	stage3Tune.play()

func GameOver():
	stopMusic()
	gameOverTune.play()

func playMenuMusic():
	stopMusic()
	menuTune.play()
	
func playOverworldMusic():
	stopMusic()
	overworldTune.play()
