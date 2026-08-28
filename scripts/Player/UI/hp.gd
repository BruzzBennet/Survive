extends Control

@export var max_hp: float = 3.0
@onready var healthbar = %HPBar
@onready var hp_shown := healthbar.material as ShaderMaterial
var current_hp

func _ready():
 reload(max_hp)

func set_value(hp: float):
 if hp<current_hp:
  # print("less HP!")
  flash(Color.RED)
 if hp>=current_hp:
  PLAYSFX.heal()
  flash(Color.GREEN)
  # print("more HP!")
 current_hp=hp
 var percent = clamp(hp / max_hp, 0.0, 1.0)
 hp_shown.set_shader_parameter("value", percent)
 if hp > 2:
  hp_shown.set_shader_parameter("bar_color", Color.GREEN)
 elif hp > 1:
  hp_shown.set_shader_parameter("bar_color", Color.YELLOW)
 else:
  hp_shown.set_shader_parameter("bar_color", Color.RED)

func edit_max_hp(hp: float):
  hp_shown.set_shader_parameter("segments", hp)

func reload(hp):
 max_hp=hp
 current_hp=max_hp
 hp_shown.set_shader_parameter("segments", hp)
 if hp > 2:
  hp_shown.set_shader_parameter("bar_color", Color.GREEN)
 elif hp > 1:
  hp_shown.set_shader_parameter("bar_color", Color.YELLOW)
 else:
  hp_shown.set_shader_parameter("bar_color", Color.RED)

func flash(color: Color):
  # print("It does it!")
  hp_shown.set_shader_parameter("flash_color", color)
  hp_shown.set_shader_parameter("flash_modifier", 1.0)
  var tween = create_tween()

  tween.tween_property(
	  hp_shown,
	  "shader_parameter/flash_modifier",
	  0.0,
	  1
  )
