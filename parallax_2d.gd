
extends Parallax2D

@export var velocidad_fondo: float = 100.0

func _process(delta: float) -> void:
	var direccion = Input.get_axis("izquierda", "derecha")

	scroll_offset.x -= direccion * velocidad_fondo * delta
