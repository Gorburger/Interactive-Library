extends Control

var book: Area2D = null
var is_bin: bool = false

func select(_book: Area2D) -> void:
	modulate = Color.DIM_GRAY
	book = _book

func deselect() -> void:
	modulate = Color.WHITE
	book = null
