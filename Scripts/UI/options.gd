extends CanvasLayer


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")	


func _on_language_item_selected(index):
	match index:
			0:
				TranslationServer.set_locale("en")
				updateUI()
			1:
				TranslationServer.set_locale("ru")
				updateUI()
				
func updateUI():
	$MarginContainer/VBoxContainer/GameName.text = tr("SETTINGS")
	$MarginContainer/VBoxContainer/Setting1.text = tr("SETTING_1")
	$MarginContainer/VBoxContainer/Back.text = tr("BACKWARD")
#	$(get_tree().get_root().get_node("MarginContainer/VBoxContainer/GameName")).text = tr("GAME_NAME")
	
