extends Spatial

#player movement variables
var run_speed : float = 8.0
var jump_length : float = 5.5
var jump_height : float = 2.0

# $ = kutsuu nodea
onready var runner = $Runner
onready var camera_pivot = $CameraPivot

var initial_road_count :int = 5
var road_scenes = [
	load("res://Road.tscn"),
	load("res://Road2.tscn"),
	load("res://Road3.tscn"),
	load("res://Road4.tscn"),
	load("res://Road5.tscn"),
	]
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	runner.setup_jump(jump_length, jump_height, run_speed)
	
	for i in range(initial_road_count):
		var road = make_random_road()
		road.translation.z = -(i+1) * Road.LENGHT
		add_child(road)


func _physics_process(delta):
	if runner.translation.z  <  -Road.LENGHT:
		runner.translation.z +=  Road.LENGHT
		
		for child in get_children():
			var road = child as Road
			
			if road:
				road.translation.z += Road.LENGHT
				if road.translation.z > Road.LENGHT:
					road.queue_free()
					
		var new_road := make_random_road()
		new_road.translation.z = - initial_road_count * Road.LENGHT
		add_child(new_road)
	
	
	camera_pivot.translation = runner.translation
	camera_pivot.translation.y = 0
		
		
func make_random_road() -> Road:
	var road_scene = road_scenes[randi() % road_scenes.size()]
	var road = road_scene.instance()
	return road 
