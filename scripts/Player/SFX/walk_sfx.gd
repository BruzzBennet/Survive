extends AudioStreamPlayer2D

func play_sound(from_position = 0.0):
	randomize()
	pitch_scale = randf_range(0.9, 1.1)

	super.play(from_position)