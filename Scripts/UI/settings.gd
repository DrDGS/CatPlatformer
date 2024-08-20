extends CanvasLayer


var locale_dict = {0: "en", 1: "ru", 2: "es"}


func _ready():
	var select_lang_item = locale_dict.find_key(Singleton.locale)
	$MarginContainer/VBoxContainer/Language._select_int(select_lang_item) 


func _on_language_item_selected(index):
	Singleton.locale = locale_dict[index]
	TranslationServer.set_locale(Singleton.locale)
	updateUI()
	
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")	


func updateUI():
	$MarginContainer/VBoxContainer/GameName.text = tr("SETTINGS")
	$MarginContainer/VBoxContainer/Setting1.text = tr("SETTING_1")
	$MarginContainer/VBoxContainer/Back.text = tr("BACKWARD")
