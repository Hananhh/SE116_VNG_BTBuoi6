extends AnimatableBody3D

@export var offset := Vector3(6, 0, 0)
@export var speed := 10.0
@export var acceleration := 9.8

var _start: Vector3
var _target: Vector3
var _going_out := true
var _current_speed := 0.0
var _is_moving := false

@onready var _interactive_area = $InteractiveArea3D


func _ready() -> void:
	_start = position
	_target = _start

	_interactive_area.interacted.connect(_on_interacted)


func _physics_process(delta: float) -> void:
	if not _is_moving:
		return

	var distance := position.distance_to(_target)

	var stopping_distance := 0.0
	if acceleration > 0.0:
		stopping_distance = (
			_current_speed * _current_speed
			/ (2.0 * acceleration)
		)
		
	if distance <= stopping_distance:
		_current_speed = move_toward(
			_current_speed, 0.0, acceleration * delta
		)
	else:
		_current_speed = move_toward(
			_current_speed, speed, acceleration * delta
		)

	position = position.move_toward(_target, _current_speed * delta)

	if position.is_equal_approx(_target):
		position = _target
		_current_speed = 0.0
		_is_moving = false
		
func _on_interacted() -> void:
	if _is_moving:
		return
	_going_out = not _going_out
	
	if _going_out:
		_target = _start + offset
	else:
		_target = _start
	_current_speed = 0.0
	_is_moving = true
