extends Control

@export var imagenes: Array[Texture2D] = []

var indice = 0

func _ready():
	if imagenes.is_empty():
		return

	$TextureButton.texture_normal = imagenes[0]
	$TextureButton.pressed.connect(siguiente_imagen)

func siguiente_imagen():
	indice += 1

	if indice < imagenes.size():
		$TextureButton.texture_normal = imagenes[indice]
	else:
		get_tree().change_scene_to_file("res://escenas/tutorial.tscn")
