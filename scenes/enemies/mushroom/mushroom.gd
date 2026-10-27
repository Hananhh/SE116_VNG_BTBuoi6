extends EnemyCharacter

func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Run)
	super._ready()

signal defeated
var is_dead: bool = false
func die() -> void:
	if is_dead:
		return
	is_dead = true
	defeated.emit()
	queue_free()
