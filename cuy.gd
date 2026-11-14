
extends CharacterBody2D

# ===== VIDA DEL CUY =====

signal vida_cambiada(vida_actual: int)

@export var vida_maxima: int = 3
var vida_actual: int = 3

# ===== MOVIMIENTO =====

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D

# ===== SISTEMA DE CAIDAS =====

@export var limite_caida: float = 550.0

var posicion_segura: Vector2
var posicion_inicializada: bool = false
var tiempo_seguro: float = 0.0

var recuperandose: bool = false


func _ready() -> void:
	vida_actual = vida_maxima
	posicion_segura = global_position


func _physics_process(delta: float) -> void:

	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Salto
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimiento horizontal
	var direccion := Input.get_axis("izquierda", "derecha")
	velocity.x = direccion * SPEED

	# Voltear al cuy segun la direccion
	if direccion != 0:
		animacion.flip_h = direccion < 0
		animacion.play("caminar_cuy")
	else:
		animacion.play("esperando_cuy")

	move_and_slide()

	# Guardar una posicion segura
	if is_on_floor():
		tiempo_seguro += delta

		if tiempo_seguro >= 0.5:
			posicion_segura = global_position
			posicion_inicializada = true
			tiempo_seguro = 0.0
	else:
		tiempo_seguro = 0.0

	# Detectar caida
	if global_position.y > limite_caida:
		caer()


# ===== CAIDAS =====

func caer() -> void:
	if recuperandose:
		return

	recuperandose = true

	recibir_danio()

	if vida_actual > 0:
		global_position = posicion_segura + Vector2(0, -8)
		velocity = Vector2.ZERO
		recuperandose = false


# ===== RECIBIR DAÑO =====

func recibir_danio() -> void:
	if vida_actual <= 0:
		return

	vida_actual -= 1
	vida_cambiada.emit(vida_actual)

	if vida_actual <= 0:
		get_tree().call_deferred("reload_current_scene")


# ===== RECUPERAR VIDA =====

func recuperar_vida() -> void:
	if vida_actual >= vida_maxima:
		return

	vida_actual += 1
	vida_cambiada.emit(vida_actual)


# ===== TECLAS DE PRUEBA =====

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_H:
			recibir_danio()
		elif event.keycode == KEY_J:
			recuperar_vida()
