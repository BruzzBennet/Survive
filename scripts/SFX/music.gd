extends AudioStreamPlayer

@onready var stage1Tune = $Stage1
@onready var stage2Tune = $Stage2
@onready var stage3Tune = $Stage3
@onready var gameOverTune = $GameOver
@onready var menuTune = $Menu
@onready var overworldTune = $Overworld
@onready var restTune = $RestTime
var bgm_used

func stopMusic():
	stage1Tune.stop()
	stage2Tune.stop()
	stage3Tune.stop()
	gameOverTune.stop()
	menuTune.stop()
	overworldTune.stop()
	restTune.stop()

func playStageMusic():
	stopMusic()
	while true:
			bgm_used = randi_range(1, 3)
			match bgm_used:
				1:
					playStage1()
					await stage1Tune.finished

				2:
					playStage2()
					await stage2Tune.finished

				3:
					playStage3()
					await stage3Tune.finished

func playStage1():
	stopMusic()
	stage1Tune.play()

func playStage2():
	stopMusic()
	stage2Tune.play()

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

func ShopTheme():
	stopMusic()
	restTune.play()
