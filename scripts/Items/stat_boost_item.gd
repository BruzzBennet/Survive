extends Node2D

@export var item:Stat_Boost
@export var weapon:=true

func _ready() -> void:
	build(item)

func build(boost:Stat_Boost):
	if boost.mon_sprite:
		$MonSpirit.build_Mon(boost.mon_sprite)
	var item_is = "Current Weapon:"
	if !weapon:
		item_is="Current Suit:"
	$Label.text=item_is + "\n" + stat_shwocase(boost)
	
func stat_shwocase(equipment:Stat_Boost):
	var desc=""
	if equipment:
		if equipment.speed_boost!=0:
			desc+="Speed " + ifplus(equipment.speed_boost) + "\n"
		if equipment.defense_boost!=0:
			desc+="Defense " + ifplus(equipment.defense_boost) + "\n"
		if equipment.ammo_boost!=0:
			desc+="Ammo " + ifplus(equipment.ammo_boost) + "\n"
		if equipment.bullet_pierce_boost!=0:
			desc+="Pierce " + ifplus(equipment.bullet_pierce_boost) + "\n"
		if equipment.bullet_reach_boost!=0:
			desc+="Bullet Reach " + ifplus(equipment.bullet_reach_boost) + "\n"
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
			boost_this=body.weapon
		else:
			boost_this=body.suit
		if stat_boost.speed_boost!=0:
			boost_this.speed_boost+=stat_boost.speed_boost
		if stat_boost.defense_boost!=0:
			boost_this.defense_boost+=stat_boost.defense_boost
		if stat_boost.ammo_boost!=0:
			boost_this.ammo_boost+=stat_boost.ammo_boost
		if stat_boost.bullet_pierce_boost!=0:
			boost_this.bullet_pierce_boost+=stat_boost.bullet_pierce_boost
		if stat_boost.bullet_reach_boost!=0:
			boost_this.bullet_reach_boost+=stat_boost.bullet_reach_boost
		if weapon:
			body.stats_setup(GLOBAL.suit,boost_this)
		else:
			body.stats_setup(boost_this,GLOBAL.weapon)
		PLAYSFX.recover()
		queue_free()
		
