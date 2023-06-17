extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var radius = 10 + randi() % 15
var connections = []
var angles = []
var stable = false
var portal = preload("res://Portal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	while not stable:
		stable = true
		for c in get_parent().get_children():
			if c == self:
				continue
			var distanceSq = self.position.distance_squared_to(c.position)
			if distanceSq < pow(radius*2,2):
				var angle = self.position.angle_to(c.position) + PI
				self.position += Vector2(cos(angle),sin(angle))
				stable = false

func link(sys):
	self.connections += [sys]
	self.angles += [get_angle_to(sys.position)]
	var p = portal.instance()
	$Portals.add_child(p)
	
