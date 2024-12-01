extends Node3D

@onready var game_manager: GameManager = %GameManager
@export var modules: Array[PackedScene] = []

var amt = 10
var rng = RandomNumberGenerator.new()
var offset = 32;

var firstModule: Module
var lastModule: Module

# Called when the node enters the scene tree for the first time.
func _ready():
	for n in amt:
		spawnModule()

func _process(delta):
	if firstModule:
		var delta_dist: float = Game.speed * delta
		firstModule.position.x -= delta_dist
		game_manager.update_distance(delta_dist)
		
		if firstModule.position.x < -offset:
			spawnModule()
			var new_top_node:Module = firstModule.child_module
			new_top_node.reparent(self)
			firstModule.queue_free()
			firstModule = new_top_node

func spawnModule():
	rng.randomize()
	var num = rng.randi_range(0, modules.size()-1)
	var instance = modules[num].instantiate()
	
	if not firstModule:
		firstModule = instance as Module
		lastModule = instance as Module
		firstModule.position.x = 0
		add_child(firstModule)
	else:
		instance.position.x = offset
		lastModule.add_child(instance)
		lastModule.child_module = instance
		lastModule = instance as Module
		
	
	
	
