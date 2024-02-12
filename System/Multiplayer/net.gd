extends Control


func _on_host_button_down():
	$"..".host_game()
	$"..".start_game()

func _on_join_button_down():
	$"..".JoinByIP($"..".address)
	pass # Replace with function body.



func _on_quit_button_down():
	get_tree().quit()
