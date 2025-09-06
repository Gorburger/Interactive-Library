extends Control

@onready var shelves: VBoxContainer = $shelves
@onready var cover_preview: TextureRect = $BookLayer/CreateBook/CoverPreview
@onready var create_book: Control = $BookLayer/CreateBook
@onready var interaction_blocker: ColorRect = $BookLayer/InteractionBlocker
@onready var dark_background: ColorRect = $BookLayer/darkBackground
@onready var book_holder: Node2D = $Books
@onready var cover_texture: TextureRect = $BookLayer/OpenBook/CoverTexture
@onready var open_book_manager: Control = $BookLayer/OpenBook
@onready var pages_animation: AnimatedSprite2D = $BookLayer/OpenBook/PagesAnimation
@onready var preview_label: Label = $BookLayer/OpenBook/preview_label
@onready var trashbin: Control = $trashbin
@onready var left_placeholder: Label = $BookLayer/CreateBook/left_placeholder
@onready var right_placeholder: Label = $BookLayer/CreateBook/right_placeholder
@onready var rtl_font_options: OptionButton = $BookLayer/CreateBook/RTLoptions
@onready var ltr_font_options: OptionButton = $BookLayer/CreateBook/LTRoptions
@onready var cover_templates: Control = $BookLayer/CreateBook/cover_templates
@onready var last_button: TextureButton = $BookLayer/CreateBook/last_button
@onready var next_button: TextureButton = $BookLayer/CreateBook/next_button

@onready var next_page_sound: AudioStreamPlayer = $soundeffects/next_page_sound
@onready var last_page_sound: AudioStreamPlayer = $soundeffects/last_page_sound
@onready var closing_sound: AudioStreamPlayer = $soundeffects/closing_sound
@onready var opening_sound: AudioStreamPlayer = $soundeffects/opening_sound
@onready var grabbing_sound: AudioStreamPlayer = $soundeffects/grabbing_sound
@onready var select_sound_1: AudioStreamPlayer = $soundeffects/select_sound1
@onready var select_sound_2: AudioStreamPlayer = $soundeffects/select_sound2
@onready var select_sound_3: AudioStreamPlayer = $soundeffects/select_sound3

@onready var book_path := preload("res://scenes/book_object.tscn")
@onready var page_label_path := preload("res://scenes/page_text_label.tscn")

var book_color: Color = Color.WHITE
var book_content: String
var read_mode: bool = false
var current_book: Area2D
var current_page: int
var total_page_count: int
var left_page: bool = true
var book_data_array: Array[Dictionary]
var placeholder_font_settings: LabelSettings = load("res://fonts/preview_label_settings/vividly_regular_settings.tres")
var real_font_settings: LabelSettings = load("res://fonts/actual_label_settings/vividly_real_settings.tres")
var current_template: int = 0
var templates: Array[TextureRect]
var ltr_placeholder_text: String = "Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.

Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.

Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.

Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.

Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.

Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.

Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.

Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.

Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.

Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos."
var rtl_placeholder_text: String = "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی مورد نیاز، و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد، کتابهای زیادی در شصت و سه درصد گذشته حال و آینده، شناخت فراوان جامعه و متخصصان را می طلبد، تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی، و فرهنگ پیشرو در زبان فارسی ایجاد کرد، در این صورت می توان امید داشت که تمام و دشواری موجود در ارائه راهکارها، و شرایط سخت تایپ به پایان رسد و زمان مورد نیاز شامل حروفچینی دستاوردهای اصلی، و جوابگوی سوالات پیوسته اهل دنیای موجود طراحی اساسا مورد استفاده قرار گیرد.لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی مورد نیاز، و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد، کتابهای زیادی در شصت و سه درصد گذشته حال و آینده، شناخت فراوان جامعه و متخصصان را می طلبد، تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی، و فرهنگ پیشرو در زبان فارسی ایجاد کرد، در این صورت می توان امید داشت که تمام و دشواری موجود در ارائه راهکارها، و شرایط سخت تایپ به پایان رسد و زمان مورد نیاز شامل حروفچینی دستاوردهای اصلی، و جوابگوی سوالات پیوسته اهل دنیای موجود طراحی اساسا مورد استفاده قرار گیرد.لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی مورد نیاز، و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد، کتابهای زیادی در شصت و سه درصد گذشته حال و آینده، شناخت فراوان جامعه و متخصصان را می طلبد، تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی، و فرهنگ پیشرو در زبان فارسی ایجاد کرد، در این صورت می توان امید داشت که تمام و دشواری موجود در ارائه راهکارها، و شرایط سخت تایپ به پایان رسد و زمان مورد نیاز شامل حروفچینی دستاوردهای اصلی، و جوابگوی سوالات پیوسته اهل دنیای موجود طراحی اساسا مورد استفاده قرار گیرد."
var is_rtl : bool = false

func _ready() -> void:
	await get_tree().process_frame
	load_books()
	shelves.hide()
	for template in cover_templates.get_children():
		templates.append(template)

func _on_file_selected(path: String) -> void:
	var text_file = FileAccess.open(path, FileAccess.READ)
	book_content = text_file.get_as_text()

func add_book_button_pressed() -> void:
	show_layer(create_book)

func _on_color_picker_color_changed(color: Color) -> void:
	select_sound_3.play()
	book_color = color
	cover_preview.modulate = color
	for template in templates:
		template.modulate = color

func _on_locate_file_button_pressed() -> void:
	var file_dialog = FileDialog.new()
	file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	file_dialog.set_use_native_dialog(true)
	file_dialog.set_access(FileDialog.ACCESS_FILESYSTEM)
	file_dialog.add_filter("*.txt", "Text Files")
	file_dialog.add_filter("*.lst", "Data list Files")
	file_dialog.add_filter("*.INI", "Initialization Files")
	file_dialog.add_filter("*.cfg", "Configuration Files")
	file_dialog.add_filter("*.nfo", "Info Files")
	file_dialog.add_filter("*.dat", "Data Files")
	file_dialog.add_filter("*.log", "Log Files")
	file_dialog.show()
	file_dialog.connect("file_selected", _on_file_selected)
	
func _on_done_button_pressed() -> void:
	var book = book_path.instantiate()
	book.content = book_content
	preview_label.text = book_content
	preview_label.label_settings = real_font_settings
	book.label_path = real_font_settings.resource_path
	book.modulate = book_color
	book.cover_path = templates[current_template].texture.resource_path
	cover_texture.modulate = book.modulate
	book_holder.add_child(book)
	create_page_layout(book)
	hide_layer(create_book)
	book_content = ""

func create_page_layout(book: Area2D, content: String =book_content, label_setting:LabelSettings=real_font_settings) -> void:
	preview_label.label_settings = label_setting
	var lines: int = preview_label.get_line_count()
	total_page_count =  ceili(lines / 13.00)
	left_page = !is_rtl
	for num in total_page_count:
		var page_label = page_label_path.instantiate()
		page_label.label_settings = label_setting
		open_book_manager.add_child(page_label)
		page_label.lines_skipped = num * 13.00
		page_label.text = content
		if is_rtl:
			page_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			page_label.position.x = 182 if left_page else 586
			left_page = !left_page
		else:
			page_label.position.x = 190 if left_page else 598
			left_page = !left_page
		book.pages.append(page_label)
	preview_label.text = ""
	book.total_pages_count = total_page_count

func hide_layer(section: Control) -> void:
	section.hide()
	dark_background.hide()
	interaction_blocker.hide()

func show_layer(section: Control):
	section.show()
	dark_background.show()
	interaction_blocker.show()

func start_read_mode(book: Area2D, _total_page_count: int, _current_page: int) -> void:
	pitch_randomizer(opening_sound, randf_range(1.2, 1.5))
	read_mode = true
	show_layer(open_book_manager)
	current_book = book
	total_page_count = _total_page_count
	current_page = _current_page
	cover_texture.modulate = current_book.modulate
	show_current_page()
	
func pitch_randomizer(sound: AudioStreamPlayer, pitch: float = randf_range(0.9, 1.1)) -> void:
	if not sound.playing:
		sound.pitch_scale = pitch
		sound.play()

func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() < 3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if read_mode:
		if Input.is_action_pressed("ui_right"):
			if is_rtl:
				if current_page > 1:
					pages_animation.play("nextPage")
					pitch_randomizer(next_page_sound, randf_range(1, 1.3))
			else:
				if (current_page + 2) < total_page_count:
					pages_animation.play("nextPage")
					pitch_randomizer(next_page_sound, randf_range(1, 1.3))
			
		elif Input.is_action_pressed("ui_left"):
			if is_rtl:
				if (current_page + 2) < total_page_count:
					pages_animation.play("lastPage")
					pitch_randomizer(last_page_sound, randf_range(1, 1.1))
			else:
				if current_page > 1:
					pages_animation.play("lastPage")
					pitch_randomizer(last_page_sound, randf_range(1, 1.1))
			
		elif Input.is_action_just_pressed("exit") and not pages_animation.is_playing():
			hide_layer(open_book_manager)
			hide_current_pages()
			read_mode = false
			pitch_randomizer(closing_sound, randf_range(1, 1.3))

func show_current_page() -> void:
	current_book.pages[current_page].show()
	if total_page_count > 1 and (current_page + 1) < total_page_count:
		current_book.pages[current_page + 1].show()

func hide_previous_pages() -> void:
	current_book.pages[current_page - 1].hide()
	current_book.pages[current_page - 2].hide()

func hide_next_pages() -> void:
	current_book.pages[current_page + 2].hide()
	if (current_page + 3) < total_page_count:
		current_book.pages[current_page + 3].hide()

func hide_current_pages() -> void:
	current_book.pages[current_page].hide()
	if total_page_count > 1 and (current_page + 1) < total_page_count:
		current_book.pages[current_page + 1].hide()

func _on_pages_animation_finished() -> void:
	if pages_animation.animation == "lastPage":
		if is_rtl:
			current_page += 2
			hide_previous_pages()
		else:
			current_page -= 2
			hide_next_pages()
	else:
		if is_rtl:
			current_page -= 2
			hide_next_pages()
		else:
			current_page += 2
			hide_previous_pages()
	current_book.current_page = current_page
	show_current_page()

func _on_tree_exiting() -> void:
	save_books()

func save_books() -> void:
	var save_file = FileAccess.open("user://save_file.txt", FileAccess.WRITE)
	for book in book_holder.get_children():
		var data : Dictionary = {
		"color" : book.modulate,
		"rest_point": book.rest_point,
		"current_page": book.current_page,
		"content": book.content,
		"label_path": book.label_path,
		"cover_path": book.cover_path,
		"is_rtl": is_rtl
		}
		book_data_array.append(data)
	save_file.store_var(book_data_array)

func load_books() -> void:
	var save_file = FileAccess.open("user://save_file.txt", FileAccess.READ)
	if save_file == null:
		return
	if save_file.get_length() > 5:
		var load_array : Array[Dictionary] = save_file.get_var(true)
		for dictionary in load_array:
			var book = book_path.instantiate()
			book.loaded_book = true
			book.rest_point = dictionary["rest_point"]
			book.cover_path = dictionary["cover_path"]
			book_holder.add_child(book)
			book.current_page = dictionary["current_page"]
			book.content = dictionary["content"]
			book.modulate = dictionary["color"]
			book.label_path = dictionary["label_path"]
			is_rtl = dictionary["is_rtl"]
			cover_texture.modulate = book.modulate
			preview_label.text = book.content
			create_page_layout(book, book.content, load(book.label_path))


func _on_font_selected(index: int) -> void:
	pitch_randomizer(select_sound_2)
	apply_ltr_font(index)

func apply_ltr_font(index:int) -> void:
	match index:
		0:
			placeholder_font_settings = load("res://fonts/preview_label_settings/vividly_regular_settings.tres")
			real_font_settings = load("res://fonts/actual_label_settings/vividly_real_settings.tres")
		1:
			placeholder_font_settings = load("res://fonts/preview_label_settings/fresh_baked_settings.tres")
			real_font_settings = load("res://fonts/actual_label_settings/freshbaked_real_settings.tres")
		2:
			placeholder_font_settings = load("res://fonts/preview_label_settings/papernotes_settings.tres")
			real_font_settings = load("res://fonts/actual_label_settings/papernotes_real_settings.tres")
		3:
			placeholder_font_settings = load("res://fonts/preview_label_settings/trashhand_settings.tres")
			real_font_settings = load("res://fonts/actual_label_settings/trashhand_real_settings.tres")
		4:
			placeholder_font_settings = load("res://fonts/preview_label_settings/simplehandmade_settings.tres")
			real_font_settings = load("res://fonts/actual_label_settings/simplehandmade_real_settings.tres")
		5:
			placeholder_font_settings = load("res://fonts/preview_label_settings/handwriting_regular_settings.tres")
			real_font_settings = load("res://fonts/actual_label_settings/handwritingregular_real_settings.tres")
		6:
			placeholder_font_settings = load("res://fonts/preview_label_settings/water_lemon_settings.tres")
			real_font_settings = load("res://fonts/actual_label_settings/water_lemon_settings.tres")
	left_placeholder.label_settings = placeholder_font_settings
	right_placeholder.label_settings = placeholder_font_settings


func _on_close_button_pressed() -> void:
	hide_layer(create_book)

func _on_next_template_pressed() -> void:
	if current_template + 1 < cover_templates.get_child_count():
		pitch_randomizer(select_sound_1)
		last_button.disabled = false
		current_template +=1
		if current_template + 1 == cover_templates.get_child_count():
			next_button.disabled = true
		templates[current_template].show()
		templates[current_template - 1].hide()

func _on_last_button_pressed() -> void:
	if current_template > 0:
		pitch_randomizer(select_sound_1)
		next_button.disabled = false
		current_template -=1
		if current_template == 0:
			last_button.disabled = true
		templates[current_template].show()
		templates[current_template + 1].hide()


func _on_rtl_on_button_toggled(toggled_on: bool) -> void:
	ltr_font_options.visible = !toggled_on
	rtl_font_options.visible = toggled_on
	is_rtl = toggled_on
	left_page = !toggled_on
	if toggled_on:
		apply_rtl_font(rtl_font_options.selected)
		right_placeholder.lines_skipped = 0
		left_placeholder.lines_skipped = 13
		left_placeholder.text = rtl_placeholder_text
		right_placeholder.text = rtl_placeholder_text
		left_placeholder.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		right_placeholder.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		left_placeholder.position.x = 169
		right_placeholder.position.x = 513
	else:
		apply_ltr_font(ltr_font_options.selected)
		right_placeholder.lines_skipped = 13
		left_placeholder.lines_skipped = 0
		left_placeholder.text = ltr_placeholder_text
		right_placeholder.text = ltr_placeholder_text
		left_placeholder.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		right_placeholder.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		left_placeholder.position.x = 183
		right_placeholder.position.x = 526

func _on_rtl_font_selected(index: int) -> void:
	pitch_randomizer(select_sound_2)
	apply_rtl_font(index)

func apply_rtl_font(index:int) -> void:
	match index:
		0:
			placeholder_font_settings = load("res://fonts/preview_label_settings/RTLSettings/Phalls-khodkar.tres")
			real_font_settings = load("res://fonts/actual_label_settings/rtl-settings/Phalls-khodkar.tres")
		1:
			placeholder_font_settings = load("res://fonts/preview_label_settings/RTLSettings/Neirizi.tres")
			real_font_settings = load("res://fonts/actual_label_settings/rtl-settings/Neirizi.tres")
		2:
			placeholder_font_settings = load("res://fonts/preview_label_settings/RTLSettings/A.Shekari.tres")
			real_font_settings = load("res://fonts/actual_label_settings/rtl-settings/a-shekari.tres")
		3:
			placeholder_font_settings = load("res://fonts/preview_label_settings/RTLSettings/Dastnevis.tres")
			real_font_settings = load("res://fonts/actual_label_settings/rtl-settings/dastnevis.tres")
		4:
			placeholder_font_settings = load("res://fonts/preview_label_settings/RTLSettings/Mj-Ghalam2.tres")
			real_font_settings = load("res://fonts/actual_label_settings/rtl-settings/mj-ghalam2.tres")
		5:
			placeholder_font_settings = load("res://fonts/preview_label_settings/RTLSettings/Digi-Paeez-Regular.tres")
			real_font_settings = load("res://fonts/actual_label_settings/rtl-settings/digi-paeez-regular.tres")
		6:
			placeholder_font_settings = load("res://fonts/preview_label_settings/RTLSettings/Digi-Maryam-Regular.tres")
			real_font_settings = load("res://fonts/actual_label_settings/rtl-settings/digi-maryam-regular.tres")
	left_placeholder.label_settings = placeholder_font_settings
	right_placeholder.label_settings = placeholder_font_settings
