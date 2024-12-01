extends Node
class_name GameManager

@onready var timer: Timer = $Timer
@export var ui: GameUI
@export var player: PlayerCar

var distance_travelled: float = 0


func _ready():
	#connect signals
	ui._on_speed_changed(Game.speed)
	
func update_distance(dist):
	distance_travelled += dist
	ui._on_distance_changed(distance_travelled)
	
func update_speed(speed: float):
	ui._on_speed_changed(speed)
	
func dead():
	Game.speed = 0
	timer.wait_time = 3
	timer.start()

func restart_game():
	Game.speed = 20
	distance_travelled = 0
	get_tree().reload_current_scene()

func _on_timer_timeout() -> void:
	restart_game()
	
