extends Node

signal stage_cleared

var remaining_enemies: int = 0
var is_stage_cleared: bool = false

	
func _ready() -> void:
	var enemies = get_tree().get_nodes_in_group("stage_enemy")
	remaining_enemies = enemies.size()

	for enemy in enemies:
		if enemy.has_signal("defeated"):
			enemy.defeated.connect(_on_enemy_defeated)
		else:
			push_warning(str(enemy.name) + " chưa có signal defeated")

	if remaining_enemies == 0:
		_finish_stage()

func _on_enemy_defeated() -> void:
	if is_stage_cleared:
		return

	remaining_enemies = max(remaining_enemies - 1, 0)
	print("Quái còn lại: ", remaining_enemies)

	if remaining_enemies == 0:
		_finish_stage()

func _finish_stage() -> void:
	if is_stage_cleared:
		return

	is_stage_cleared = true
	print("Đã tiêu diệt hết quái!")
	GameManager.unlock_door("exit")
	stage_cleared.emit()
