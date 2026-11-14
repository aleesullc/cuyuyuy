
extends HBoxContainer

@export var corazon_lleno: Texture2D
@export var corazon_vacio: Texture2D

func actualizar_vida(vida: int) -> void:
	for i in range(3):
		var corazon = get_child(i) as TextureRect

		if i < vida:
			corazon.texture = corazon_lleno
		else:
			corazon.texture = corazon_vacio
