extends CanvasLayer


var locale_dict = {0: "en", 1: "ru", 2: "es"}
var Disp_serv_screen_mode_dict = {0: "WINDOW_MODE_FULLSCREEN", 1: "WINDOW_MODE_WINDOWED"}
var screen_mode_dict = {0: "Fullscreen", 1: "Windowed"}


func _ready():
	var select_lang_item = locale_dict.find_key(Singleton.locale)
	var select_screen_mode_item = screen_mode_dict.find_key(Singleton.screen_mode)
	$MarginContainer2/VBoxContainer/Language._select_int(select_lang_item)
	$"MarginContainer2/VBoxContainer/Screen mode"._select_int(select_screen_mode_item) 


func _on_language_item_selected(index):
	Singleton.locale = locale_dict[index]
	TranslationServer.set_locale(Singleton.locale)
	updateUI()


func _on_screen_mode_item_selected(index):
	Singleton.screen_mode = screen_mode_dict[index]
	var DS_screen_mode = Disp_serv_screen_mode_dict[index]
	var current_window = DisplayServer.MAIN_WINDOW_ID

	#DisplayServer.window_set_mode(DS_screen_mode, current_window)


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")	


func updateUI():
	$MarginContainer/VBoxContainer/GameName.text = tr("SETTINGS")
	$MarginContainer/VBoxContainer/Setting1.text = tr("SETTING_1")
	$MarginContainer/VBoxContainer/Back.text = tr("BACKWARD")
