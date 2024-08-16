extends CanvasLayer


func _ready():
	TranslationServer.set_locale(Singleton.locale)


func _process(delta):
	TranslationServer.set_locale(Singleton.locale)
	updateUI()
	

func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/testing_scene.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/options.tscn")
	
	
func updateUI():
	$MarginContainer/VBoxContainer/GameName.text = tr("GAME_NAME")
	$MarginContainer/VBoxContainer/StartGame.text = tr("START_GAME")
	$MarginContainer/VBoxContainer/Settings.text = tr("SETTINGS")
	$MarginContainer/VBoxContainer/Exit.text = tr("EXIT")

func _on_exit_pressed():
	get_tree().quit()
