extends CharacterBody2D

var summon_frames = [14]
@onready var animated_sprite_2d = get_node("Sprite")
@export var pozzap_to_summon : PackedScene


func _ready() -> void:
	add_to_group("enemy")

func _physics_process(_delta: float) -> void:
	animated_sprite_2d.play()

func _on_sprite_frame_changed() -> void:
	if animated_sprite_2d.frame == 12:
		$sfx.play()
	if animated_sprite_2d.frame in summon_frames:
		var pozzap=pozzap_to_summon.instantiate()
		get_tree().current_scene.add_child(pozzap)
		pozzap.global_position = global_position +  Vector2.RIGHT * 25
		pozzap.get_node("HurtBox").score_value=0
		pozzap.add_to_group("enemies")
