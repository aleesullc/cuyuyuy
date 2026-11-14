extends Area2D

@export var velocidad: float = 220.0
@export var tiempo_vida: float = 5.0

var direccion: Vector2 = Vector2.LEFT

func _ready() -> void:
    body_entered.connect(_al_tocar_cuerpo)
    get_tree().create_timer(tiempo_vida).timeout.connect(_terminar_vida)
    $AnimatedSprite2D.play("bala_ani")

func _physics_process(delta: float) -> void:
    global_position += direccion.normalized() * velocidad * delta

func _al_tocar_cuerpo(cuerpo: Node2D) -> void:
    if cuerpo.is_in_group("jugador") and cuerpo.has_method("recibir_danio"):
        cuerpo.recibir_danio()
        queue_free()
    elif cuerpo is StaticBody2D:
        queue_free()

func _terminar_vida() -> void:
    if is_instance_valid(self):
        queue_free()
