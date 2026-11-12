extends Node2D

func _ready():
    update()

func _process(_delta: float):
    update()

func update():
    $Amount.text=format_number(GLOBAL.mimin)

func format_number(value:int):
    if value<10:
        return "0"+str(value)
    else:
        return str(value)