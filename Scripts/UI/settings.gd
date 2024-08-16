extends CanvasLayer


func _ready():
	match Singleton.locale:
		"en":
			$MarginContainer/VBoxContainer/Language/selected = 0
		"ru":
			$MarginContainer/VBoxContainer/Language/selected = 1


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")	


func _on_language_item_selected(index):
	match index:
		0:
			Singleton.locale = "en"
			TranslationServer.set_locale(Singleton.locale)
			updateUI()
		1:
			Singleton.locale = "ru"
			TranslationServer.set_locale(Singleton.locale)
			updateUI()


func updateUI():
	$MarginContainer/VBoxContainer/GameName.text = tr("SETTINGS")
	$MarginContainer/VBoxContainer/Setting1.text = tr("SETTING_1")
	$MarginContainer/VBoxContainer/Back.text = tr("BACKWARD")
