extends Node3D

func _ready():
	# Create a parent CSGCombiner3D node to hold all the shapes
	var combiner = CSGCombiner3D.new()
	add_child(combiner)

	# Random number generator
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# Create a random number of corridors
	for i in range(rng.randi_range(2, 5)):
		var corridor = CSGBox3D.new()
		corridor.size = Vector3(rng.randf_range(10, 30), 3, rng.randf_range(3, 10))
		corridor.translation = Vector3(rng.randf_range(-50, 50), 0, rng.randf_range(-50, 50))
		combiner.add_child(corridor)

	# Create a random number of rooms
	for i in range(rng.randi_range(2, 4)):
		var room_type = rng.randi_range(0, 2)
		var room
		if room_type == 0:
			room = CSGBox3D.new()
			room.size = Vector3(rng.randf_range(10, 20), rng.randf_range(5, 10), rng.randf_range(10, 20))
		elif room_type == 1:
			room = CSGSphere3D.new()
			room.radius = rng.randf_range(5, 15)
		else:
			room = CSGCylinder3D.new()
			room.radius = rng.randf_range(5, 10)
			room.height = rng.randf_range(5, 15)
		room.translation = Vector3(rng.randf_range(-50, 50), 0, rng.randf_range(-50, 50))
		combiner.add_child(room)
