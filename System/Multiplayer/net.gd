extends Control


func _on_host_button_down():
	$"..".host_game()
	$"..".start_game()

func _on_join_button_down():
	$"..".JoinByIP($"..".address)
	pass # Replace with function body.
