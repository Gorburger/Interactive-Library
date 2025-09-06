extends Control
@onready var closing_sound: AudioStreamPlayer = $closing_sound

var is_bin: bool = true
var book = null

func select(_book: Area2D) -> void:
	for page in _book.pages:
		page.queue_free()
	_book.queue_free()
	closing_sound.play()
