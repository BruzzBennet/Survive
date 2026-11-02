extends Node

func _ready():
    var script = load("res://scripts/Attacks/Bullets/bullet.gd")

    print("PATH: ", script.resource_path)
    print("UID: ", ResourceUID.id_to_text(
        ResourceLoader.get_resource_uid("res://scripts/Attacks/Bullets/bullet.gd")
    ))