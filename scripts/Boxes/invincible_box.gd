extends Area2D
class_name InvincibleBox_Component

func blocked():
	$SFX.play()
	get_parent().get_node("HurtBox").invincible()
