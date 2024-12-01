extends Node


@export var speed: float = 20
@export var lane_width: float = 2

var resources: GameResources

# Called when the node enters the scene tree for the first time.
func _ready():
	resources = load("res://resources/game_resources.tres")
