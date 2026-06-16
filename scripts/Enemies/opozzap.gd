extends CharacterBody2D

signal died
signal summon
var summon_frames = [14]
@export var health = 5
@export var slash_damage = 1
@export var bullet_damage = 1
var damage
var damage_animation
@onready var animated_sprite_2d = %AnimatedSprite2D
@onready var summoner = %PozzapSummoner
@onready var hit_fx = %FX

func _ready() -> void:
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	animated_sprite_2d.play()

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.frame in summon_frames:
		summon.emit(global_position, Vector2.RIGHT)

func _on_hit_box_area_entered(area) -> void:
	if area.is_in_group("bullet") or area.is_in_group("slash"):
		if area.is_in_group("bullet"):
			damage = bullet_damage
			damage_animation = "Hurt"
		else:
			damage = slash_damage
			damage_animation = "ReallyHurt"
		health -= damage
		PLAYSFX.hurt()
		if health <= 0:
			PLAYSFX.died()
			died.emit(global_position)
			queue_free()
		hit_fx.play(damage_animation)
		await hit_fx.animation_finished
		hit_fx.play("RESET")
