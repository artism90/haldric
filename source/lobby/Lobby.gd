extends Control

signal back

onready var ip := $Setup/VBoxContainer/IP as LineEdit

onready var player_name := $Setup/VBoxContainer/HBoxContainer/Name as LineEdit
onready var host := $Setup/VBoxContainer/HBoxContainer3/Host as Button
onready var join := $Setup/VBoxContainer/HBoxContainer3/Join as Button
onready var leave := $Setup/VBoxContainer/Leave as Button

onready var input := $Room/Input as LineEdit
onready var display := $Room/Display as RichTextLabel

func _input(event: InputEvent):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			_send_message()

func _ready() -> void:
	Network.Lobby = self

func _exit_tree():
	Network.Lobby = null

func enter_room() -> void:
	leave.show()
	join.hide()
	host.hide()
	ip.hide()
	display.text = "Successfully Joined Room!\n"

remote func user_entered(id) -> void:
	display.text += str(Network.players[id].name) + " joined the room\n"

remote func user_exited(id) -> void:
	display.text += str(Network.players[id].name) + " left the room\n"

remote func server_disconnected() -> void:
	display.text += "Disconnected from Server\n"
	_on_Leave_pressed()

func _send_message() -> void:
	var msg: String = input.text
	input.text = ""
	var id: int = get_tree().get_network_unique_id()
	rpc("_receive_message", id, msg)

sync func _receive_message(id: int, msg: String) -> void:
	display.text += str(Network.players[id].name) + ": " + msg + "\n"

func _on_Join_pressed() -> void:
	Network.create_client(player_name.text, Network.DEFAULT_IP)

func _on_Host_pressed() -> void:
	leave.show()
	Network.create_server(player_name.text)
	display.text = "Room Created!\n"

func _on_Leave_pressed() -> void:
	leave.hide()
	join.show()
	host.show()
	ip.show()
	display.text += "Left Room\n"

func _on_Back_pressed() -> void:
	emit_signal("back")
