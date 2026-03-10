extends Control

func _ready() -> void:
	$VBoxContainer/HBoxContainer/"Zé Pilintra".pressed.connect(_escolher_ze)
	$VBoxContainer/HBoxContainer/"Maria Navalha".pressed.connect(_escolher_maria)

func _escolher_ze() -> void:
	GameManager.selecionar_personagem("ze_pilintra")
	get_tree().change_scene_to_file("res://scenes/world/main.tscn")

func _escolher_maria() -> void:
	GameManager.selecionar_personagem("maria_navalha")
	get_tree().change_scene_to_file("res://scenes/world/main.tscn")
