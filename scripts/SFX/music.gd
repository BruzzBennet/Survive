extends AudioStreamPlayer

@onready var stage1Tune = $Stage1
@onready var stage2Tune = $Stage2
@onready var stage3Tune = $Stage3
@onready var gameOverTune = $GameOver
@onready var menuTune = $Menu
@onready var overworldTune = $Overworld
var bgm_used

# func stopStage1():
# 	stopMusic()
# 	stage1Tune.stop()
func stopMusic():
	stage1Tune.stop()
	stage2Tune.stop()
	stage3Tune.stop()
	gameOverTune.stop()
	menuTune.stop()
	overworldTune.stop()

func playStageMusic():
	while true:
			bgm_used = randi_range(1, 3)
		# var bgm_list=[3,2,1]
		# for bgm_used in bgm_list:
			match bgm_used:
				1:
					print("PLAY STAGE 1")
					playStage1()
					await stage1Tune.finished
					print("FINISHED 1")

				2:
					print("PLAY STAGE 2")
					playStage2()
					await stage2Tune.finished
					print("FINISHED 2")

				3:
					print("PLAY STAGE 3")
					playStage3()
					await stage3Tune.finished
					print("FINISHED 3")

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
