extends Area2D

export (float, 0.0,1.0) var amm = 0.2
signal raiserate(amm)

func _on_firerate_body_entered(body):
	if body.name == "Player":
		emit_signal("raiserate", amm)
