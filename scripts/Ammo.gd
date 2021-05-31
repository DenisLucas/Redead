extends Area2D



export (int, 1, 20) var ammo = 1
signal raiseamm(muni)

func _on_firerate_body_entered(body):
	if body.name == "Player":

		emit_signal("raiseamm", ammo)
		queue_free()

