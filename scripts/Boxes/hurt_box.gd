extends Area2D
class_name HurtBox_Component

var died_fx: PackedScene = preload("res://scenes/DiedExplosion.tscn")
var hurt_fx: PackedScene = preload("res://scenes/hurtParticles.tscn")
var shared_material: ShaderMaterial
@export var defense: float = 1.0
@export var takes_damage_from: attack_source
@export var receives_knockback: bool = false
@export var gets_stunned: bool = false
@export var drops: Equipment
@export var mimin:=false
var score_value: = 100
var max_health:= 100.0
var extra_heal:=0.0
var drops_items:bool

enum attack_source {
	player,
	enemy,
	both,
	none
}

@onready var sprite
@onready var hurt_time = $HurtTimer
var dead: bool = false
var is_hurt: bool = false
var is_invincible: bool = false
var health: float
var enemyCollisions = []
var hpUI
var yes_or_no_healer = 0
signal died
var damage_tile_location=[
	Vector2i(2,2),
	Vector2i(3,2),
	Vector2i(2,3),
	Vector2i(3,3),
	Vector2i(2,4),
	Vector2i(3,4),
	Vector2i(2,2),
	Vector2i(3,2)
	]
var idle=0.0

func _ready():
	if takes_damage_from == attack_source.enemy:
			set_collision_layer_value(4, true)
			set_collision_mask_value(2, true)
			set_collision_mask_value(3, true)
			set_collision_mask_value(5, true)
			health=GLOBAL.health
			max_health=GLOBAL.base_health
			drops_items=false
			if drops:
				drops.duplicate()
			hpUI = get_tree().current_scene.get_node("HenshinMenu/UI")
			defense=GLOBAL.defense
			defense=max(defense,0)
	elif takes_damage_from == attack_source.player:
			set_collision_layer_value(2, true)
			set_collision_mask_value(4, true)
			set_collision_mask_value(5, true)
			set_collision_mask_value(6, true)
			
			health = max_health
			if GLOBAL.current_level>=50:
				defense+=1.0
			drops_items=true

	if takes_damage_from == attack_source.enemy or mimin:
		sprite = get_parent().get_node("Skeleton/Sprite")
		for piece in get_parent().get_node("Skeleton").get_children():
			if piece is Sprite2D and piece != sprite:
					shared_material = ShaderMaterial.new()
					shared_material.shader = preload("res://scenes/hurt_shader.gdshader")
					piece.material = shared_material
	else:
		sprite = get_parent().get_node("Sprite")
	if sprite.material:
		sprite.material = sprite.material.duplicate()
		sprite.material.set_shader_parameter("flash_modifier", 0)


func flash_action(sprite_to_flash):
	sprite_to_flash.material.set_shader_parameter("flash_modifier", 1.0)
	var tween = create_tween()

	# 2. Smoothly animate the parameter back to 0.0 over 1 second
	tween.tween_property(
		sprite_to_flash.material,
		"shader_parameter/flash_modifier",
		0.0,
		1.5
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

func heals(_amount=0.5):
	cancel_flash()
	play_flash(Color.GREEN)
	# var new_hp = health+amount+extra_heal
	var new_hp=max_health*1/4
	# new_hp-=health
	hpUI.set_hp(new_hp)
	if new_hp<=max_health:
		health+=new_hp
	else:
		health=max_health
		SCORE.increaseBy(250)

func set_max_hp_UI(set_hp):
	hpUI.edit_max_hp(set_hp)

func set_hp_UI(set_hp):
	GLOBAL.health=set_hp

func play_flash(color:Color):
	sprite.material.set_shader_parameter("flash_color", color)

	if takes_damage_from == attack_source.enemy:
		for piece in get_parent().get_node("Skeleton").get_children():
			if piece is Sprite2D:
				piece.material.set_shader_parameter("flash_color", color)
				flash_action(piece)
	else:
		flash_action(sprite)

func becomes_invincible(flash=true):
	cancel_flash()
	if flash:
		play_flash(Color.BLUE)
	is_invincible=true

func no_longer_invincible():
	# cancel_flash()
	is_invincible=false

func invincible(time=0.65,flash=true):
	becomes_invincible(flash)
	await get_tree().create_timer(time).timeout
	no_longer_invincible()

func knockback(attack: Variant):
	if attack is Attack:
		get_parent().velocity = (global_position - attack.position).normalized() * attack.knockback
	else:
			get_parent().velocity = -get_parent().last_direction.normalized() * 500


func damage(attack: Attack) -> void:
	if !is_hurt and !is_invincible:
		if takes_damage_from == attack.source:
			# var damage_done=attack.damage_done - defense
			var base_value = max_health
			var damage_done=ceil(base_value*(1/(1+defense)))
			
			if gets_stunned:
				hit_stun()	
			if receives_knockback:
				knockback(attack)

			match takes_damage_from:
				attack_source.player:
					hurt_enemy()
				attack_source.enemy:
					hurt_player(damage_done)
			
			health -= damage_done

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

func player_touched_poison():
			health -= max_health*(1/(1+defense))
			if gets_stunned:
				hit_stun()	
			hurt_player(max_health*(1/(1+defense)))
			if dead:
				return
			if health <= 0:
				dead = true
				add_death_explosion()
				gameover()
				get_parent().queue_free()

func add_death_explosion():
	var fx = died_fx.instantiate()
	fx.global_position = global_position
	get_tree().current_scene.add_child(fx)

func hurt_player(damage_taken:float):
	cancel_flash()
	play_flash(Color.RED)
	hpUI.set_hp(damage_taken*-1)
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
		cancel_flash()
		play_flash(Color.RED)

func dead_enemy(increase_score=true):
	died.emit()
	if increase_score:
		SCORE.increaseBy(score_value)
	PLAYSFX.died()
	var drop_item = randi_range(0,3)
	if drop_item==0:
		call_deferred("item_drop")
		

func item_drop():
	if !drops==null:
		var item_dropped=drops
		var card=preload("res://scenes/items/Mon_card_item.tscn")
		var card_drop = card.instantiate()
		card_drop.global_position=global_position
		card_drop.item=item_dropped
		card_drop.item.stat_boost.duplicate()
		get_tree().current_scene.add_child(card_drop)
		
func spawn(this: Variant):
	var spawn_this=this.instantiate()
	spawn_this.global_position=global_position
	get_tree().current_scene.add_child(spawn_this)

func gameover():
	var death_timer = get_tree().current_scene.get_node("DeathTimer")
	death_timer.start()
	BGM.GameOver()
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(bus_index, true)
	

func _on_body_entered(body: Node2D) -> void:
	if takes_damage_from == attack_source.enemy:
		if body is Healing_Item:
			await heals()
			body.queue_free()
