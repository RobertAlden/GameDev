extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active_system = null



# Called when the node enters the scene tree for the first time.
func _ready():
	$Galaxy.position = get_viewport().size/2


func selectSystem(system):
	if active_system == null:
		active_system = system
