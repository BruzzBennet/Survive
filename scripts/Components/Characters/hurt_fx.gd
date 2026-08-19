extends AnimatedSprite2D


func play_hit_flash() -> void:
	# Get the sprite node
	var sprite = $Sprite
	
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
