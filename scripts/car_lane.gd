extends Node3D
class_name CarLane


@export var offset: float
@export var lane_speed: int = 10
@export var num_cars: int = 10
@export var min_distance: float = 10
@export var max_distance: float = 100
@export var initial_distance: float = 10

var rng = RandomNumberGenerator.new()

var last_car : Node3D

func _ready() -> void:
	for n in num_cars:
		spawnCar()


func spawnCar():
	#spawn a car in this lane at a random distance ahead of the prev

	var dist = rng.randf_range(min_distance, max_distance)
	if last_car :
		dist += last_car.global_position.x
	else:
		dist += initial_distance
	
	var carInstance: OtherCar = Game.resources.other_car.instantiate()
	
	carInstance.position.z = offset
	carInstance.position.x =  dist
	carInstance.speed = lane_speed
	add_child(carInstance)
	
	last_car = carInstance
	
