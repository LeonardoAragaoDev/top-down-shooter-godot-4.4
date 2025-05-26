extends Node2D

@onready var player := $player

@export var enemy_scene : PackedScene
@export var spawn_margin := 200



func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = calculate_spawn_position()
	enemy.player = player

func calculate_spawn_position() -> Vector2:
	var screen_size = get_viewport().get_visible_rect().size
	var player_pos = player.global_position
	var spawn_distante := screen_size.length() / 2 + spawn_margin
	var angle := randf_range(0, TAU)
	var spawn_pos = player_pos + Vector2.RIGHT.rotated(angle) * spawn_distante
	
	return spawn_pos

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
