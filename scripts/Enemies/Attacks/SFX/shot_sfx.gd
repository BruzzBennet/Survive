extends AudioStreamPlayer2D

func play_sound(from_position = 0.0):
	randomize()
	pitch_scale = randf_range(0.5, 1.5)
	if !self.is_playing():
		super.play(from_position)
