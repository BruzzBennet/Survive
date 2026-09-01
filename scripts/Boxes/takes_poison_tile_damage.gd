extends Area2D

@onready var hurtBox=get_parent().get_node("HurtBox")

func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer:
		var layer_mask = PhysicsServer2D.body_get_collision_layer(body_rid)
		if layer_mask & (1 << 4):
			if hurtBox:
				hurtBox.player_touched_poison()
				hurtBox.knockback(body)
