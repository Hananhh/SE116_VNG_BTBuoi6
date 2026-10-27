extends Area3D
## this check point 's name - unique within its stage. the save file stores this, not coordinates.
@export var id := ""
@onready var _sprite: AnimatedSprite3D = $AnimatedSprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("spawn_points")
	body_entered.connect(_on_body_entered)
	_sprite.play("turn" if _is_current() else "idle")

func _on_body_entered(body: Node3D) -> void:
	if not (body is Player) or _is_current():
		return 
	if not (owner is Stage):
		push_warning("Chekpoint '%s' is not placed directly in a Stage - ignored" % id )
		return 
	GameManager.set_checkpoint(owner.scene_file_path, id)
	_sprite.play("turn")
	
## ower is the root of the scene this checkpoint was saved in - the stage 
func _is_current() -> bool:
	return owner is Stage and GameManager.checkpoint_id == id \
		and GameManager.checkpoint_stage == owner.scene_file_path
		
