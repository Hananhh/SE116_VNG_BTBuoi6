extends AnimatableBody3D

@export var offset := Vector3(0, 4, 0)
## Meters per second.
@export var speed := 2.0
## Seconds to wait at each end.
@export var wait_time := 1.0
## Gia tốc (m/s²)
@export var acceleration := 9.8

var _start: Vector3
var _going_out := true 
var _wait := 0.0
var _current_speed := 0.0

func _ready() -> void:
	_start = position
	
func _physics_process(delta: float) -> void:
	if _wait > 0.0:
		_wait -= delta 
		return
	var target := _start + offset if _going_out else _start
	var distance := position.distance_to(target)

	# Giảm tốc khi gần đến đích
	var stopping_distance := (_current_speed * _current_speed/ (2.0 * acceleration))
	if distance <= stopping_distance:
		_current_speed = max(_current_speed - acceleration * delta,0.0)
	else:
		_current_speed = min(_current_speed + acceleration * delta,speed)

	## Dùng để di chuyển đến đích
	position = position.move_toward(target, _current_speed * delta)
	## cái này dùng để đến đích thì đổi hưởng
	if position.is_equal_approx(target):
		_going_out = not _going_out
		_wait = wait_time
