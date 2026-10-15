extends AudioStreamPlayer

@onready var stage1Tune = $Stage1
@onready var stage2Tune = $Stage2
@onready var stage3Tune = $Stage3
@onready var gameOverTune = $GameOver
@onready var menuTune = $Menu
@onready var overworldTune = $Overworld
@onready var restTune = $RestTime
@onready var standByTune = $StandByTune
var bgm_used
var current_bgm

func standBy():
	current_bgm.stream_paused=true
	# PLAYSFX.get_card()
	standByTune.play()

func stop_standBy():
	standByTune.stop()
	current_bgm.stream_paused=false

func stopMusic():
	standByTune.stop()
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
	current_bgm = stage1Tune
	stage1Tune.play()

func playStage2():
	stopMusic()
	current_bgm = stage2Tune
	stage2Tune.play()

func playStage3():
	stopMusic()
	current_bgm = stage3Tune
	stage3Tune.play()
		
func GameOver():
	stopMusic()
	current_bgm = gameOverTune
	gameOverTune.play()

func playMenuMusic():
	stopMusic()
	current_bgm = menuTune
	menuTune.play()
	
func playOverworldMusic():
	stopMusic()
	current_bgm = overworldTune
	overworldTune.play()

func ShopTheme():
	stopMusic()
	current_bgm = restTune
	restTune.play()
