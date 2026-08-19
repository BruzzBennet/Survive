extends Resource
class_name Attack

@export var damage_done: float = 1
@export var knockback: float = 500
@export var position: Vector2
@export var source: attack_source

enum attack_source {
    player,
    enemy,
    test
}

