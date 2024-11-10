extends Control

var COLLECTION_ID = "relay_stats"
var DOC_ID = "all_data"

@onready var temp = $HBoxContainer/VBoxContainer/Temperature/HBoxContainer/Label2
@onready var humid = $HBoxContainer/VBoxContainer/Humidity/HBoxContainer/Label2
@onready var pressure = $HBoxContainer/VBoxContainer/Pressure/HBoxContainer/Label2
# Called when the node enters the scene tree for the first time.
@onready var temperature_graph: PlotItem = %Graph2D.add_plot_item("Temperature", Color.GREEN, 1.0)
@onready var humidity_graph: PlotItem = %Graph2D.add_plot_item("Humidity", Color.WEB_PURPLE, 1.5)
@onready var pressure_graph: PlotItem = %Graph2D.add_plot_item("Pressure", Color.BROWN, 2.0)

func _ready():
	%loading_screen.visible = true
	var doc = await load_data()
	temp.text = str(doc.doc_fields.temperature)
	humid.text = str(doc.doc_fields.humidity)
	pressure.text = str(doc.doc_fields.pressure)
	%loading_screen.hide()
	load_graphs()
	$graph_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_all_data():
	var doc = await load_data()
	temp.text = str(doc.doc_fields.temperature)
	humid.text = str(doc.doc_fields.humidity)
	pressure.text = str(doc.doc_fields.pressure)

func update_temp(x:int):
	temp.text = str(x)

func update_humid(x:int):
	humid.text = str(x)

func update_presssure(x:int):
	pressure.text = str(x)

func _on_controls_button_pressed():
	get_tree().change_scene_to_file("res://scenes/controller_display.tscn")
	pass # Replace with function body.


func _on_logout_pressed():
	Firebase.Auth.logout()
	get_tree().change_scene_to_file("res://scenes/authentication.tscn")
	

func load_data():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection : FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var task : FirestoreTask = collection.get_doc(DOC_ID)
		var finished_task : FirestoreTask = await task.task_finished
		var document = finished_task.document
		return document

func load_graphs():
	for x in range(0, 11, 1):
		var y = randf_range(0, 1)
		temperature_graph.add_point(Vector2(x, y))
	for x in range(0, 11, 1):
		var y = randf_range(0, 1)
		humidity_graph.add_point(Vector2(x, y))
	for x in range(0, 11, 1):
		var y = randf_range(0, 1)
		pressure_graph.add_point(Vector2(x, y))


func _on_timer_timeout():
	temperature_graph.remove_all()
	humidity_graph.remove_all()
	pressure_graph.remove_all()
	load_graphs()
	pass # Replace with function body.


func _on_temp_up_pressed():
	var doc = await load_data()
	var current_temp = int(doc.doc_fields.temperature)
	current_temp +=2
	var updated_data = {"temperature":current_temp}
	save_data(updated_data)
	update_temp(current_temp)

func save_data(data):
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection : FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var task : FirestoreTask = collection.update(DOC_ID,data)


func _on_temp_down_pressed():
	var doc = await load_data()
	var current_temp = int(doc.doc_fields.temperature)
	current_temp -=2
	var updated_data = {"temperature":current_temp}
	save_data(updated_data)
	update_temp(current_temp)


func _on_humid_up_pressed():
	var doc = await load_data()
	var current_humid = int(doc.doc_fields.humidity)
	current_humid +=2
	var updated_data = {"humidity":current_humid}
	save_data(updated_data)
	update_humid(current_humid)


func _on_humid_down_pressed():
	var doc = await load_data()
	var current_humid = int(doc.doc_fields.humidity)
	current_humid -=2
	var updated_data = {"humidity":current_humid}
	save_data(updated_data)
	update_humid(current_humid)


func _on_pressure_up_pressed():
	var doc = await load_data()
	var current_pressure = int(doc.doc_fields.pressure)
	current_pressure +=2
	var updated_data = {"pressure":current_pressure}
	save_data(updated_data)
	update_presssure(current_pressure)


func _on_pressure_down_pressed():
	var doc = await load_data()
	var current_pressure = int(doc.doc_fields.pressure)
	current_pressure -=2
	var updated_data = {"pressure":current_pressure}
	save_data(updated_data)
	update_presssure(current_pressure)


func _on_update_all_data_pressed():
	temperature_graph.remove_all()
	humidity_graph.remove_all()
	pressure_graph.remove_all()
	load_graphs()
	update_all_data()
	pass # Replace with function body.
