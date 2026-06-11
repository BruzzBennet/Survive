extends Label

@export var startingHP=5

func _ready():
	self.text="HP: " + str(startingHP)

func _on_player_hp(health) -> void:
	self.text="HP: " + str(health)
