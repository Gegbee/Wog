extends Item2D

var used : bool = false

func use():
	if !used:
		used = true
		$Timer.start(0.5)
		for body in $Area2D.get_overlapping_bodies():
			if body.is_in_group('entity'):
				body.damage(2)


func _on_Timer_timeout():
	used = false
