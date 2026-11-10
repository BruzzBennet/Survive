extends Node2D

@export var item:Stat_Boost
@export var weapon:=true

func _ready() -> void:
	build(item)

func build(boost:Stat_Boost):
	# if boost.mon_sprite:
	# 	$MonSpirit.build_Mon(boost.mon_sprite)
	item=boost
	var item_is = "to Weapon"
	if !weapon:
		item_is="to Suit"
	$Label.text= stat_shwocase(boost) + item_is
	
func stat_shwocase(equipment:Stat_Boost):
	var desc=""
	if equipment:
		if equipment.bullet_speed_boost!=0:
			desc+="Bullet Speed " + ifplus(equipment.bullet_speed_boost) + ". " + "\n"
		if equipment.stamina_boost!=0:
			desc+="Stamina " + ifplus(equipment.stamina_boost) + ". " + "\n"
		if equipment.bullet_power_boost!=0:
			desc+="Bullet Pierce " + ifplus(equipment.bullet_power_boost) + ". " + "\n"
		if equipment.bullet_reach_boost!=0:
			desc+="Bullet Reach " + ifplus(equipment.bullet_reach_boost) + ". " + "\n"
		if equipment.stamina_recover_boost!=0:
			desc+="Recover  " + ifplus(equipment.stamina_recover_boost) + ". " + "\n"
		return desc

func ifplus(value:int):
	if value>0:
		return "+" + str(value)
	else:
		return str(value)

func _on_area_2d_body_entered(body: Node2D) -> void:
	var boost_this
	var stat_boost=item
	if body is Player_Unit:
		if weapon:
			if GLOBAL.weapon==GLOBAL.base_weapon:
				return
			boost_this=body.weapon.stat_boost
		else:
			if GLOBAL.suit==GLOBAL.base_suit:
				return
			boost_this=body.suit.stat_boost
		if stat_boost.bullet_speed_boost!=0:
			boost_this.bullet_speed_boost+=stat_boost.bullet_speed_boost
		if stat_boost.stamina_boost!=0:
			boost_this.stamina_boost+=stat_boost.stamina_boost
		if stat_boost.bullet_power_boost!=0:
			boost_this.bullet_power_boost+=stat_boost.bullet_power_boost
		if stat_boost.bullet_reach_boost!=0:
			boost_this.bullet_reach_boost+=stat_boost.bullet_reach_boost
		if weapon:
			body.stats_setup(GLOBAL.suit,body.weapon)
		else:
			body.stats_setup(body.suit,GLOBAL.weapon)
		PLAYSFX.recover()
		queue_free()
		
