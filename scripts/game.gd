extends Node2D

<<<<<<< HEAD
#signal summon
=======
signal summon
>>>>>>> 9c91a8fcd3c2394a25665a2f9be610c3b7796d83
@onready var summon_time = %EnemyTimer

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
<<<<<<< HEAD
	pass
	#summon_time.start()	
	#await summon_time.timeout
	#summon.emit()
=======
	summon_time.start()	
	await summon_time.timeout
	summon.emit()
>>>>>>> 9c91a8fcd3c2394a25665a2f9be610c3b7796d83
