extends Node3D
class_name OtherCar

@export var speed: float = 5
@onready var car_lane = $"../"

var rng = RandomNumberGenerator.new()


#other car has a speed that falls within a certian range, slower than player
#has a raycast out forward a few meters to see if there's a car in front
#if there is, it's speed lerps to match the other car
#future - maybe lane changes

#it gets instatiated on a road module at a certain Z value (lane)
#and a random X value 


func _ready():
	#spawn a random car
	var index = rng.randi_range(0, Game.resources.car_models.size()-1)
	var instance = Game.resources.car_models[index].instantiate()
	add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	global_position.x -= (Game.speed - speed) * delta
	if global_position.x < -20:
		car_lane.spawnCar()
		queue_free()
