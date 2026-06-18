extends Node

const SAVEFILE= "res://savefile.save"

var actual = 0
var highest = 0

func _ready() -> void:
	get_highest()

func increaseBy(points):
	actual+=points

func check():
	if actual>highest:
		var file = FileAccess.open(SAVEFILE, FileAccess.WRITE)
		file.store_32(actual)
		file=null

func get_highest():
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if FileAccess.file_exists(SAVEFILE):
		highest=file.get_32()
