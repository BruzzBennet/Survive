extends CPUParticles2D

func _ready():
	emitting = false
	await get_tree().process_frame
	restart()
	emitting = true
