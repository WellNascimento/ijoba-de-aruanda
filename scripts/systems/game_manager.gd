extends Node

var personagem_selecionado: CharacterData = null

var ze_pilintra: CharacterData = preload("res://data/characters/ze_pilintra.tres")
var maria_navalha: CharacterData = preload("res://data/characters/maria_navalha.tres")

func selecionar_personagem(nome: String) -> void:
	match nome:
		"ze_pilintra":
			personagem_selecionado = ze_pilintra
		"maria_navalha":
			personagem_selecionado = maria_navalha
	print("Personagem selecionado: ", personagem_selecionado.nome)
