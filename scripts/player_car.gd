extends Node3D
class_name PlayerCar

@onready var game_manager = %GameManager
@onready var anim_player = $CarDashboard/CarSteering/AnimationPlayer
@export var cam_anim_player: AnimationPlayer

var positions = [-Game.lane_width, 0, Game.lane_width]
var curPos = 1

var swipeLength = 200
var startSwipe : Vector2
var curSwipe : Vector2
var swiping := false
var looking_down := false


@export var lane_change_smooth := 0.5
@export var accelSmooth := 1.0
@export var max_speed: float = 50.0
var target_speed = 20.0
@export var speed: float = 20.0:
	set(value):
		speed = clampf(value, 0, max_speed)
		Game.speed = speed
		game_manager.update_speed(speed)
		
func _ready():
	Game.speed = speed
	anim_player.stop()
	anim_player.clear_queue()

func change_lane(z1, z2):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector3(0, 0, z2-z1), lane_change_smooth).as_relative()
	if z1<z2:
		anim_player.play("TurnRight")
	elif z1>z2:
		anim_player.play("TurnLeft")

func _process(delta):
	swipe()
	handle_input()
	
func turn(swipedir):
	if swipedir == 1:
		if curPos < 2:
			curPos += 1
	elif swipedir == -1:
		if curPos > 0:
			curPos -= 1
	change_lane(position.z, positions[curPos])
	
func accelerate():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	target_speed += 10
	tween.tween_property(self, "speed", target_speed, accelSmooth)
	
func brake():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	target_speed -= 10
	tween.tween_property(self, "speed", target_speed, accelSmooth)
	
func look_up_down():
	if looking_down:
		#Look Up
		cam_anim_player.play("LookDown", -1, -3.0, true)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		looking_down = false
	else:
		#Look Down at phone
		cam_anim_player.play("LookDown", -1, 3.0)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		looking_down = true
	
func handle_input():
	if Input.is_action_just_pressed("left"):
		turn(-1)
	elif Input.is_action_just_pressed("right"):
		turn(1)
		
	if Input.is_action_just_pressed("accelerate"):
		accelerate()
	if Input.is_action_just_pressed("brake"):
		brake()
		
	if Input.is_action_just_pressed("checkphone"):
		look_up_down()

func swipe():
	if Input.is_action_just_pressed("press"):
		if !swiping:
			swiping = true
			startSwipe = get_viewport().get_mouse_position()
			
	if Input.is_action_pressed("press"):
		if swiping:
			curSwipe = get_viewport().get_mouse_position()
			if startSwipe.distance_to(curSwipe) >= swipeLength:
				if startSwipe.x - curSwipe.x < 0:
					turn(1)
				else:
					turn(-1)
				swiping = false
	else:
		if swiping:
			swiping = false


func _on_area_3d_area_entered(area: Area3D) -> void:
	print("Collided!")
	#game_manager.dead()
