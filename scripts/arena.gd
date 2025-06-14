extends Node2D

@onready var player := $player

@export var enemy_scene : PackedScene
@export var spawn_margin := 200

var active_enemies : Array = []
var enemy_scenes: Dictionary = {
	"easy": preload("res://entities/enemyEasy.tscn"),
	"medium": preload("res://entities/enemyMedium.tscn"),
	"hard": preload("res://entities/enemyHard.tscn")
}
var current_wave := 1
var enemies_per_wave := 3
var time_between_enemies := 0.3
var time_between_waves := 1.0
var is_spawning := false

func _ready() -> void:
	spawn_wave()

func spawn_enemy():
	var enemy_scene = get_enemy_scene_for_wave(current_wave)
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = calculate_spawn_position()
	enemy.player = player
	
	active_enemies.append(enemy)
	enemy.tree_exited.connect(on_enemy_exit.bind(enemy))

func get_enemy_scene_for_wave(wave: int) -> PackedScene:
	if wave < 3:
		return enemy_scenes["easy"]
	elif wave < 6:
		return enemy_scenes["medium"]	
	else:
		return enemy_scenes["hard"]	

func on_enemy_exit(enemy):
	if enemy in active_enemies:
		active_enemies.erase(enemy)
	
	if active_enemies.is_empty():
		next_wave()

func next_wave():
	await get_tree().create_timer(time_between_waves).timeout
	current_wave += 1
	enemies_per_wave += 1
	is_spawning = false
	spawn_wave()

func spawn_wave():
	if is_spawning:
		return
	
	print("Starting wave %d" % current_wave )
	
	for i in enemies_per_wave:
		spawn_enemy()
		await get_tree().create_timer(time_between_enemies).timeout
	

func calculate_spawn_position() -> Vector2:
	var screen_size = get_viewport().get_visible_rect().size
	var player_pos = player.global_position
	var spawn_distante := screen_size.length() / 2 + spawn_margin
	var angle := randf_range(0, TAU)
	var spawn_pos = player_pos + Vector2.RIGHT.rotated(angle) * spawn_distante
	
	return spawn_pos

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
