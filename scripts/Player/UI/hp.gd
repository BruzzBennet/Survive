extends Control

@export var max_hp: float = 3.0
@onready var healthbar = %HPBar
@onready var hp_shown := healthbar.material as ShaderMaterial

func _ready():
 set_value(GLOBAL.health, false)

func set_value(hp: float, spawned=true): 
 hp_shown.set_shader_parameter("flash_modifier", 0.0)
 
 if hp<GLOBAL.health:
  flash(Color.RED)

 if hp>=GLOBAL.health:
  if spawned == true:
   PLAYSFX.heal()
   flash(Color.GREEN)

 if hp<=max_hp:
  GLOBAL.health=hp
 var percent = clamp(GLOBAL.health / max_hp, 0.0, 1.0)
 hp_shown.set_shader_parameter("value", percent)
 if hp > 2:
  hp_shown.set_shader_parameter("bar_color", Color.GREEN)
 elif hp > 1:
  hp_shown.set_shader_parameter("bar_color", Color.YELLOW)
 else:
  hp_shown.set_shader_parameter("bar_color", Color.RED)

func edit_max_hp(hp: float):
  hp_shown.set_shader_parameter("segments", hp)

# func reload(hp):
#  max_hp=hp
#  GLOBAL.health=max_hp
#  hp_shown.set_shader_parameter("segments", hp)
#  if hp > 2:
#   hp_shown.set_shader_parameter("bar_color", Color.GREEN)
#  elif hp > 1:
#   hp_shown.set_shader_parameter("bar_color", Color.YELLOW)
#  else:
#   hp_shown.set_shader_parameter("bar_color", Color.RED)

func flash(color: Color):
  hp_shown.set_shader_parameter("flash_color", color)
  hp_shown.set_shader_parameter("flash_modifier", 1.0)
  var tween = create_tween()

  tween.tween_property(
	  hp_shown,
	  "shader_parameter/flash_modifier",
	  0.0,
	  1
  )
