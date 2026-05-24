extends CharacterBody2D

@export var max_speed: float = 600
@export var accel: float = 10
@export var friction: float = 0.15
const stamina_value = 500
const endurance = 25
var stamina = stamina_value
const visual_stamina_divide = 100

@onready var stamina_label = %Label

func _physics_process(delta: float) -> void:
	
	# 2. Set default speed
	var current_speed = max_speed
	
	# 3. Boost speed if "C" is also held down
	# Gets direction as a Vector2 (-1 to 1) using built-in arrow key actions
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if stamina<=(stamina_value+visual_stamina_divide): 
		var visual_stamina = floor(stamina/visual_stamina_divide)
		if direction != Vector2.ZERO and Input.is_key_pressed(KEY_C):
			if (visual_stamina)>0:
				current_speed = current_speed * 2
				stamina-=endurance
		else:
			if stamina<=(stamina_value-1):
				if direction == Vector2.ZERO:
					stamina+=5
				else:
					stamina+=1
		stamina_label.text="Stamina: " + str(visual_stamina)
		
	# Assigns velocity and normalizes it so diagonals aren't faster
	if direction != Vector2.ZERO:
		# Gradually accelerate towards the target speed
		velocity = velocity.lerp(direction * current_speed, accel * delta)
	else:
		# Gradually stop when no input is pressed
		velocity = velocity.lerp(Vector2.ZERO, friction)
	
	# Handles movement and collisions
	move_and_slide()
