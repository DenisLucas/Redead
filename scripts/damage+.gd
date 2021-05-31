extends Area2D


export (int, 1, 5) var dam = 1
signal raisedam(dam)

func _on_firerate_body_entered(body):
	if body.name == "Player":
		emit_signal("raisedam", dam)
		queue_free()

