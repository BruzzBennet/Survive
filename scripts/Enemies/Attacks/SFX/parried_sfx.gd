extends AudioStreamPlayer2D


func play_sound(from_position = 0.0):
	if !self.is_playing():
		super.play(from_position)
