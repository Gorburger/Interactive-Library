extends Area2D
@onready var main_node: Control = $"../.."
@onready var sprite: Sprite2D = $sprite

var selected: bool = false
var rest_point : Vector2
var rest_nodes : Array[Node] = []
var selected_node: Control
var pages: Array[Label] = []
var current_page: int = 0
var total_pages_count: int
var content: String
var loaded_book: bool = false
var label_path: String
var cover_path: String 

func _ready() -> void:
	rest_nodes = get_tree().get_nodes_in_group("zone")
	if !loaded_book:
		for child in rest_nodes:
			if !child.book:
				rest_point = child.global_position
				child.select(self)
				selected_node = child
				break
	else:
		for child in rest_nodes:
			if child.global_position == rest_point:
				child.select(self)
				selected_node = child
				break
	global_position = rest_point
	sprite.texture = load(cover_path)

func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("drag"):
		main_node.pitch_randomizer(main_node.grabbing_sound)
		selected = true
		move_to_front()
		main_node.shelves.show()
		main_node.trashbin.show()
		Input.set_custom_mouse_cursor(preload("res://textures/cursor_grab.png"))
		
	elif Input.is_action_just_released("drag") and selected:
		main_node.pitch_randomizer(main_node.grabbing_sound)
		selected = false
		Input.set_custom_mouse_cursor(preload("res://textures/default_cursor.png"))
		var shortest_distance = 3500
		var closest_node
		
		for child in rest_nodes:
			var distance = global_position.distance_squared_to(child.global_position)
			if distance < shortest_distance:
				closest_node = child
				shortest_distance = distance
		if closest_node:
			if closest_node.book:
				closest_node.book.rest_point = rest_point
				closest_node.book.selected_node = selected_node
				selected_node.select(closest_node.book)
				closest_node.book.global_position = rest_point
			else:
				selected_node.deselect()
				
			closest_node.select(self)
			selected_node = closest_node
			rest_point = closest_node.global_position
		global_position = rest_point
		main_node.shelves.hide()
		main_node.trashbin.hide()
		
	elif Input.is_action_just_pressed("interact") and not selected:
		main_node.start_read_mode(self, total_pages_count, current_page)

func _process(_delta: float) -> void:
	if selected:
		global_position = get_global_mouse_position() + Vector2(9,3)
