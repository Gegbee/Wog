extends Node2D

#enemy list stored in res://Enemies/Types.gd     <= autoloaded
export var type = 2
export var player_path : NodePath

var enemy_type = Types.enemy_dict[type]
var enemy = load(enemy_type)

func spawn():
#	var enemy_instance = enemy.instance()
#	var child = add_child(enemy_instance)
	var enemy = preload('res://Enemies/boney.tscn').instance()
	mySprite.init(a, b)
	getparent().add_child(mySprite)


func _on_Timer_timeout():
	spawn()
