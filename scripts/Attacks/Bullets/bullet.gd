extends CharacterBody2D

var speed: int = 250
var time_on_field: float = 0.0
var max_time_on_field: float = 0.4
var enemies_pierced: int = 0
var max_enemies_pierced: int = 1
var direction: Vector2 
var damage_done:= 1.0

func _ready():
	$HitBox.area_entered.connect(_on_area_entered)
	add_to_group("bullet")
	$HitBox.attack.damage_done=damage_done

func _on_area_entered(body):
	if body is HurtBox_Component and body.get_parent().is_in_group("enemies"):
		# print("yes")
		enemies_pierced+=1
	
func _physics_process(delta):
	time_on_field += delta
	velocity = direction * speed
	move_and_slide()
	# if !floating:
	if get_slide_collision_count() > 0 or enemies_pierced>=max_enemies_pierced or time_on_field>=max_time_on_field:
		queue_free()

func _on_timer_timeout():
	queue_free()
