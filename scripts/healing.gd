extends Area2D



export (int, 1, 20) var hp = 2
signal raisehealth(life)

func _on_firerate_body_entered(body):
	if body.name == "Player":
		emit_signal("raisehealth", hp)
		queue_free()


