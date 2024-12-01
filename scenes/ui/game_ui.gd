extends CanvasLayer
class_name GameUI

@export var distance_label: Label
@export var speed_label: Label

var score: int = 0:
	set(new_score):
		score = new_score
		_update_score_label()
		
var speed: int = 0:
	set(new_speed):
		speed = int(new_speed)
		_update_speed_label()
		
func _update_score_label():
	distance_label.text = str(score)
	
func _update_speed_label():
	speed_label.text = "Speed: " + str(speed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_score_label()

func _on_distance_changed(distance) -> void:
	score = distance
	
func _on_speed_changed(spd) -> void:
	speed = spd
