extends Node2D

@export var orbit_radius := 32.0
@export var rotation_speed := 15.0

var orbit_center
var angle
var bullet
var speed
var dir:=1.0

func _ready():
	bullet=get_parent()
	speed=bullet.speed 
	orbit_center=bullet.player
	angle = orbit_center.last_direction.angle()
	if orbit_center.last_direction.x < 0:
		dir = -1.0
		angle+=45.0

func _physics_process(delta):
	angle += rotation_speed * delta * dir

	bullet.global_position = orbit_center.global_position + Vector2(
		cos(angle),
		sin(angle)
	) * orbit_radius

	bullet.global_rotation = angle + PI / 2
