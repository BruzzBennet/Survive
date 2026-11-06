extends CharacterBody2D

var base_speed: = 250.0
var speed=base_speed
var time_on_field: float = 0.0
var max_time_on_field: float = 0.4
var enemies_pierced: int = 0
var max_enemies_pierced: int = 1
var direction: Vector2 
var damage_done:= 1.0
var reach
var reach_check
var player
signal limit_reached

func new_pierce(amount:int):
	max_enemies_pierced=amount

func new_speed(amount:float):
	speed=amount

func new_time(amount:float):
	max_time_on_field=amount

func set_player(node:Node2D):
	player=node

func _ready():
	reach=base_speed*max_time_on_field
	$HitBox.area_entered.connect(_on_area_entered)
	add_to_group("bullet")
	$HitBox.attack.damage_done=damage_done

func _on_area_entered(body):
	if body is HurtBox_Component and body.get_parent().is_in_group("enemies"):
		enemies_pierced+=1
	
func _physics_process(delta):
	time_on_field += delta
	velocity = direction * speed
	reach_check=speed*time_on_field
	# print(str(reach_check))
	move_and_slide()
	if get_slide_collision_count() > 0 \
	or enemies_pierced>=max_enemies_pierced \
	# or time_on_field>=max_time_on_field\
	or reach<=reach_check:
		limit_reached.emit()
		queue_free()

