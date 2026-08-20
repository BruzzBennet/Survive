extends Area2D
class_name HurtBox_Component

var died_fx: PackedScene = preload("res://scenes/DiedExplosion.tscn")
var hurt_fx: PackedScene = preload("res://scenes/hurtParticles.tscn")
var shared_material: ShaderMaterial
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
		for piece in get_parent().get_node("Skeleton").get_children():
			if piece is Sprite2D and piece != sprite:
					shared_material = ShaderMaterial.new()
					shared_material.shader = preload("res://scenes/hurt_shader.gdshader")
					piece.material = shared_material
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


func flash_action(sprite_to_flash):
	sprite_to_flash.material.set_shader_parameter("flash_modifier", 1.0)
	var tween = create_tween()

	# 2. Smoothly animate the parameter back to 0.0 over 1 second
	tween.tween_property(
		sprite_to_flash.material,
		"shader_parameter/flash_modifier",
		0.0,
		1
	)

func change_color(character,color:Color):
	character.material.set_shader_parameter("flash_modifier", 0.5)
	character.material.set_shader_parameter("flash_color", color)

func is_tired():
	if takes_damage_from == attack_source.enemy:
		for piece in get_parent().get_node("Skeleton").get_children():
			if piece is Sprite2D:
				# Frozen color: Color(0.25,0.75,1.0,0.5)
				change_color(piece,Color(0.5,0.5,0.5,0.5))
	else:
		change_color(sprite,Color(0.25,0.75,0.1,0.5))

func cancel_flash():
	sprite.material.set_shader_parameter("flash_modifier", 0.0)
	if takes_damage_from == attack_source.enemy:
		for piece in get_parent().get_node("Skeleton").get_children():
			if piece is Sprite2D:
				piece.material.set_shader_parameter("flash_modifier", 0.0)

func heals(amount:int):
	PLAYSFX.recover()
	play_flash(Color(0.0, 1.0, 0.0, 1.0))
	hp.set_value(health+amount)

func play_flash(color:Color):
	sprite.material.set_shader_parameter("flash_color", color)

	if takes_damage_from == attack_source.enemy:
		for piece in get_parent().get_node("Skeleton").get_children():
			if piece is Sprite2D:
				piece.material.set_shader_parameter("flash_color", color)
				flash_action(piece)
	else:
		flash_action(sprite)

func becomes_invincible():
	cancel_flash()
	play_flash(Color(0.0, 0.0, 1.0, 1.0))
	is_invincible=true

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
	play_flash(Color(1.0, 0.0, 0.0, 1.0))
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
		play_flash(Color(1.0, 0.0, 0.0, 1.0))

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
