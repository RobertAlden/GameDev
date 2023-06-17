extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var numOfSystems = 15
var systemScene = preload("res://System.tscn")
var curr_node = null
var displayGalaxy = true



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate()

func _draw():
	if displayGalaxy:
		for c in $Systems.get_children():
			draw_arc(c.position, c.radius, 0, TAU, 32, Color.white)
			for i in c.connections.size():
				var connectedSystem = c.connections[i]
				var angle = c.angles[i]
				var selfRingPos = Vector2((c.radius)*cos(angle),(c.radius)*sin(angle))
				angle += PI
				var destRingPos = Vector2((connectedSystem.radius)*cos(angle),(connectedSystem.radius)*sin(angle))
				draw_line((c.position+selfRingPos), (connectedSystem.position+destRingPos), Color.white)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()


func _input(event):
	if event.is_action_pressed("LClick"):
		var m_pos = get_global_mouse_position()
		print(m_pos)
		if displayGalaxy:
			for c in $Systems.get_children():
				var dist = m_pos.distance_to(c.global_position)
				print(dist)
				if dist < c.radius:
					displayGalaxy = false
					selectSystem(c)


func generate():
	for c in $Systems.get_children():
		c.queue_free()
	var angle_incr = ((TAU) / numOfSystems) + randf()
	var angle = randf() * TAU
	var distance = 10
	for i in numOfSystems:
		var s = systemScene.instance()
		s.position = Vector2(distance*cos(angle),distance*sin(angle))
		distance += 25 + randi() % 25
		angle += angle_incr
		angle_incr *= 0.99
		$Systems.add_child(s)
	var inc = 0
	while inc < numOfSystems*2:
		var systems = $Systems.get_children()
		var src = systems[inc % systems.size()]
		curr_node = src
		systems.sort_custom(self,"dist_sort")
		var dst = src
		while src == dst:
			dst = systems[randi() % (systems.size()-1) + 1]
		inc += int(join(src,dst))

func join(s,d):
	if not (d in s.connections or s in d.connections):
		s.link(d)
		d.link(s)
		return true
	return false

func dist_sort(a,b):
	return curr_node.position.distance_to(a.position) < curr_node.position.distance_to(b.position)

func selectSystem(system):
	get_parent().selectSystem(system)
