extends CharacterBody2D

class_name Jugador

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready () -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("izquierda", "derecha")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	cambiar_sprite_lado(direction)
	move_and_slide()
	
func cambiar_sprite_lado(dir: float):
	if dir == 1:
		sprite_2d.flip_h=true
	elif dir ==-1:
		sprite_2d.flip_h=false
