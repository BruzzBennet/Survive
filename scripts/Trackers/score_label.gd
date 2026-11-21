extends Label

var current_score = 0

func _process(_delta: float) -> void:
	if current_score < SCORE.actual:
		self.text= "Score: " + str(SCORE.actual)
		current_score = SCORE.actual
