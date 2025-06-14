extends CharacterBody2D

@onready var square: Sprite2D = $square

@export var move_speed : float = 100.0
@export var health : int = 3

const BLOOD_PARTICLES = preload("res://prefabs/blood_particles.tscn")

var direction : Vector2 = Vector2.ZERO
var player : CharacterBody2D = null
var original_color = Color.WHITE
var knockback_velocity : Vector2 = Vector2.ZERO
var knockback_decay : float = 800.0
var knockback_force : float = 250

func _ready() -> void:
	player = Global.player
	original_color = square.modulate

func _physics_process(delta: float) -> void:
	if knockback_velocity.length() > 1:
		velocity = knockback_velocity
		
		move_and_slide()
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	else:
		if player:
			direction = global_position.direction_to(player.global_position)
			velocity = direction * move_speed
			
			move_and_slide()

func apply_knockback(force: Vector2):
	knockback_velocity = force
	
func hit_flash():
	square.modulate = Color.WHITE
	await get_tree().create_timer(0.1).timeout
	square.modulate = original_color

func take_damage(amount: int, source_position: Vector2):
	health -= amount
	var knockback_dir = (position - source_position).normalized()
	
	apply_knockback(knockback_dir * knockback_force)
	hit_flash()
	
	if health <= 0:
		var blood_instance = BLOOD_PARTICLES.instantiate()
		add_sibling(blood_instance)
		blood_instance.global_position = global_position
		blood_instance.rotation = direction.angle() + PI
		
		queue_free()
	
	print("Health enemy is " + str(health)) 
