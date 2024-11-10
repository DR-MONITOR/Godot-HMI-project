extends Control

@onready var slider = $VSlider
@onready var liq_sphere =$liq_sphere

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	liq_sphere.material.set_shader_parameter("fill_value",-convert_value(slider.value/100)-0.4)
	#print(liq_sphere.material.get_shader_parameter("fill_value"))
	if slider.value == 100:
		get_tree().change_scene_to_file("res://scenes/authentication.tscn")
	pass

func convert_value(value):
	value = clamp(value, 0.0, 1.0)
	return value * 2.0 - 1.0


func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.
