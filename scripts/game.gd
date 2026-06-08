extends Node2D

#signal summon
@onready var summon_time = %EnemyTimer

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
	#summon_time.start()	
	#await summon_time.timeout
	#summon.emit()
