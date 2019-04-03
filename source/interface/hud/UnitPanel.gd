extends Control

onready var unit_name := $NinePatchRect/CenterContainer/VBoxContainer/Name as Label
onready var image := $NinePatchRect/CenterContainer/VBoxContainer/Image/Unit as TextureRect
onready var level := $NinePatchRect/CenterContainer/VBoxContainer/General/Level as Label
onready var type := $NinePatchRect/CenterContainer/VBoxContainer/General/Type as Label
onready var race := $NinePatchRect/CenterContainer/VBoxContainer/General/Race as Label
onready var hp := $NinePatchRect/CenterContainer/VBoxContainer/Stats/Row1/HP as Label
onready var xp := $NinePatchRect/CenterContainer/VBoxContainer/Stats/Row1/XP as Label
onready var mp := $NinePatchRect/CenterContainer/VBoxContainer/Stats/Row2/MP as Label
onready var defense := $NinePatchRect/CenterContainer/VBoxContainer/Stats/Row2/D as Label

onready var tween := $Tween as Tween

var unit: Unit = null

func _ready() -> void:
	clear_unit()

# TODO: maybe find a better way to do this
func _process(delta: float) -> void:
	if unit:
		image.texture = unit.sprite.texture

func update_unit(target: Unit) -> void:
	unit = target

	tween.interpolate_property(self, "modulate", modulate, Color("ffffffff"), 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	unit_name.text = unit.name
	image.texture = unit.sprite.texture
	image.set_material(unit.sprite.get_material())
	level.text = str("L", unit.type.level)
	type.text = str(unit.type.ID)
	race.text = str(unit.type.race)
	hp.text = "HP: %d/%d" % [unit.health_current, unit.type.health]
	xp.text = "XP: %d/%d" % [unit.experience_current, unit.type.experience]
	mp.text = "MP: %d/%d" % [unit.moves_current,  unit.type.moves]

func clear_unit() -> void:
	tween.interpolate_property(self, "modulate", modulate, Color("00ffffff"), 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	unit_name.text = "-"
	image.texture = null
	level.text = "-"
	type.text = "-"
	race.text = "-"
	hp.text = "-"
	xp.text = "-"
	mp.text = "-"
