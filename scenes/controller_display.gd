extends Control

@onready var light1:bool=false;
@onready var light2:bool=false;
@onready var light3:bool=false;
@onready var light4:bool=false;
@onready var last_user = $last_user
var lights = [light1,light2,light3,light4]
var light_names = ["light1","light2","light3","light4"]
var COLLECTION_ID = "relay_stats"
var DOC_ID = "all_data"

func _ready():
	%loading_screen.visible = true
	var doc = await load_data()
	change_color(light_names[0],doc.doc_fields.relay1)
	change_color(light_names[1],doc.doc_fields.relay2)
	change_color(light_names[2],doc.doc_fields.relay3)
	change_color(light_names[3],doc.doc_fields.relay4)
	$HBoxContainer/VBoxContainer/relay1.button_pressed = doc.doc_fields.relay1
	$HBoxContainer/VBoxContainer/relay2.button_pressed = doc.doc_fields.relay2
	$HBoxContainer/VBoxContainer/relay3.button_pressed = doc.doc_fields.relay3
	$HBoxContainer/VBoxContainer/relay4.button_pressed = doc.doc_fields.relay4
	last_user.text = "last used by: "+str(doc.doc_fields.last_user)
	%loading_screen.hide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_color(lightX,stat:bool):
	#print(lightX,stat)
	if stat == false :
		get_node("HBoxContainer/lights_VBoxContainer/"+lightX).texture = load("res://assets/signal_red.png")
	elif stat == true :
		get_node("HBoxContainer/lights_VBoxContainer/"+lightX).texture = load("res://assets/signal_green.png")


func _on_relay_1_toggled(button_pressed):
	lights[0] = !lights[0] 
	change_color(light_names[0],lights[0])
func _on_relay_2_toggled(button_pressed):
	lights[1] = !lights[1]
	change_color(light_names[1],lights[1])
func _on_relay_3_toggled(button_pressed):
	lights[2] = !lights[2]
	change_color(light_names[2],lights[2])
func _on_relay_4_toggled(button_pressed):
	lights[3] = !lights[3]
	change_color(light_names[3],lights[3])


func _on_dashboard_button_pressed():
	get_tree().change_scene_to_file("res://scenes/data_dashboard.tscn")


func _on_send_data_pressed():
	save_data()
	pass # Replace with function body.

func save_data():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var user_email = Firebase.Auth.auth.email
		var collection : FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var data ={"relay1":lights[0],"relay2":lights[1],"relay3":lights[2],"relay4":lights[3],"last_user":user_email}
		var task : FirestoreTask = collection.update(DOC_ID,data)
	

func load_data():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection : FirestoreCollection = Firebase.Firestore.collection(COLLECTION_ID)
		var task : FirestoreTask = collection.get_doc(DOC_ID)
		var finished_task : FirestoreTask = await task.task_finished
		var document = finished_task.document
		return document
		



func _on_uodate_data_pressed():
	var doc = await load_data()
	change_color(light_names[0],doc.doc_fields.relay1)
	change_color(light_names[1],doc.doc_fields.relay2)
	change_color(light_names[2],doc.doc_fields.relay3)
	change_color(light_names[3],doc.doc_fields.relay4)
	$HBoxContainer/VBoxContainer/relay1.button_pressed = doc.doc_fields.relay1
	$HBoxContainer/VBoxContainer/relay2.button_pressed = doc.doc_fields.relay2
	$HBoxContainer/VBoxContainer/relay3.button_pressed = doc.doc_fields.relay3
	$HBoxContainer/VBoxContainer/relay4.button_pressed = doc.doc_fields.relay4
	last_user.text = "last used by: "+str(doc.doc_fields.last_user)
	pass # Replace with function body.
