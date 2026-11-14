extends CharacterBody2D

# Un mismo enemigo y una misma bala se reutilizan en todos los niveles.
@export var escena_bala: PackedScene
@export var distancia_ataque: float = 350.0
@export var tiempo_animacion_disparo: float = 0.22

@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D
@onready var temporizador: Timer = $Timer
@onready var salida_bala: Marker2D = $Marker2D

var cuy: CharacterBody2D
var atacando: bool = false


func _ready() -> void:
    # El grupo debe estar asignado al Cuy que esta en la escena activa.
    cuy = get_tree().get_first_node_in_group("jugador") as CharacterBody2D
    temporizador.timeout.connect(disparar)
    animacion.play("caminar_ene")


func _physics_process(delta: float) -> void:
    # El enemigo no escucha el teclado del jugador.
    if not is_on_floor():
        velocity += get_gravity() * delta
    velocity.x = 0.0
    move_and_slide()


func disparar() -> void:
    # Rebuscar por si se instancio otro cuy posteriormente.
    if not is_instance_valid(cuy):
        cuy = get_tree().get_first_node_in_group("jugador") as CharacterBody2D
    if not is_instance_valid(cuy) or atacando or escena_bala == null:
        return
    if global_position.distance_to(cuy.global_position) > distancia_ataque:
        return

    atacando = true
    var direccion_disparo: Vector2 = (cuy.global_position - salida_bala.global_position).normalized()
    if direccion_disparo == Vector2.ZERO:
        direccion_disparo = Vector2.LEFT

    animacion.flip_h = direccion_disparo.x > 0
    animacion.play("disparar_ene")

    # No esperar animation_finished: algunas animaciones tienen un solo frame
    # o usan repeticion, asi que dicha senal puede no llegar nunca.
    await get_tree().create_timer(tiempo_animacion_disparo).timeout
    if not is_inside_tree():
        return
    if not is_instance_valid(cuy):
        atacando = false
        animacion.play("caminar_ene")
        return

    var bala = escena_bala.instantiate()
    get_tree().current_scene.add_child(bala)
    # Generar fuera del cuerpo del enemigo para evitar colision instantanea.
    bala.global_position = salida_bala.global_position + direccion_disparo * 54.0
    bala.direccion = direccion_disparo

    animacion.play("caminar_ene")
    atacando = false
