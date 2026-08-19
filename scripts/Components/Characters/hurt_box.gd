extends Area2D
class_name HurtBox_Component

var died_fx: PackedScene = preload("res://scenes/DiedExplosion.tscn")
var hurt_fx: PackedScene = preload("res://scenes/hurtParticles.tscn")
@export var max_health: int = 1
@export var takes_damage_from: attack_source
@export var score_value: int = 0
@export var receives_knockback: bool = false
@export var gets_stunned: bool = false

enum attack_source {
	player,
	enemy,
	none
}

@onready var sprite
@onready var hurt_time = $HurtTimer
var dead: bool = false
var is_hurt: bool = false
var is_invincible: bool = false
var health: float
var enemyCollisions = []
var hp
signal died

func _ready():
	health = max_health
	if takes_damage_from == attack_source.enemy:
		sprite = get_parent().get_node("Skeleton/Sprite")
		hp = get_tree().current_scene.get_node("HP")
		hp.reload(health)
	else:
		sprite = get_parent().get_node("Sprite")
	if sprite.material:
		sprite.material = sprite.material.duplicate()
		sprite.material.set_shader_parameter("flash_modifier", 0)

func _physics_process(_delta):
	if !is_hurt:
		for enemyArea in enemyCollisions:
			hurt_player()


func play_hit_flash() -> void:
	# Create a temporary tween that handles the animation timing
	var tween = create_tween()
	
	# 1. Instantly set the shader modifier to 1.0 (Fully Red)
	sprite.material.set_shader_parameter("flash_modifier", 1.0)
	
	# 2. Smoothly animate the parameter back to 0.0 over 0.2 seconds
	tween.tween_property(
		sprite.material,
		"shader_parameter/flash_modifier",
		0.0,
		0.2
	)

func knockback(attack: Attack):
	get_parent().velocity = (global_position - attack.position).normalized() * attack.knockback
	# get_parent().move_and_slide()


func damage(attack: Attack) -> void:
	if !is_hurt and !is_invincible:
		if takes_damage_from == attack.source:
			health -= attack.damage_done
			if gets_stunned:
				hit_stun()	
			if receives_knockback:
				knockback(attack)

			if takes_damage_from == attack_source.player:
				hurt_enemy()
			elif takes_damage_from == attack_source.enemy:
				hurt_player()

			if dead:
				return
			if health <= 0:
				dead = true
				add_death_explosion()

				if takes_damage_from == attack_source.player:
					dead_enemy()
				elif takes_damage_from == attack_source.enemy:
					gameover()
				get_parent().queue_free()


func add_death_explosion():
	var fx = died_fx.instantiate()
	fx.global_position = global_position
	get_tree().current_scene.add_child(fx)

func hurt_player():
	hp.set_value(health)
	var fx = hurt_fx.instantiate()
	fx.global_position = global_position
	get_tree().current_scene.add_child(fx)
	PLAYSFX.player_hurt()

func hit_stun():
	is_hurt = true
	hurt_time.start()
	await hurt_time.timeout
	is_hurt = false

func hurt_enemy():
	PLAYSFX.hurt()
	if sprite.material:
		play_hit_flash()

func dead_enemy():
	died.emit()
	SCORE.increaseBy(score_value)
	PLAYSFX.died()

func gameover():
	var death_timer = get_tree().current_scene.get_node("DeathTimer")
	death_timer.start()
	BGM.GameOver()
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(bus_index, true)

# func _on_area_entered(area):
# 	if area.name == "HitBox":
# 		enemyCollisions.append(area)

# func _on_area_exited(area):
# 	enemyCollisions.erase(area)
