extends State

var host = null
var need_to_halt = false
var halted = false
export(float, 0.1, 1.0) var move_time := 0.15

func _enter(host):
	if host.type.anim.has_animation("move"):
		host.type.anim.play("move")
	self.host = host
	halted = false
	host.location.map.update_weight(host, false, true)
	_move()

func _exit(host):
	self.host = null

func _move():
	if host.path and host.tween:
		var loc: Location = host.path[0]
		var cost = host.get_movement_cost(loc)
		var ignore_halt = false
		if cost > host.moves_current or loc.unit and loc.unit.side != host.side:
			host.emit_signal("move_finished", host, host.location, false)
			host.change_state("idle")
			return

		if host.location.unit == host: #checks to make sure its not overriding existing units
			host.location.unit = null
		host.location = loc
		if not loc.unit:
			host.location.unit = host
		else:
			ignore_halt = true

		#warning-ignore:return_value_discarded
		host.tween.interpolate_property(host, "position", host.position, loc.position, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		#warning-ignore:return_value_discarded
		host.tween.start()

		if host.location.map.ZOC_tiles.has(host.location):
			host.moves_current = 0
			host.path = [loc]
			host.tween.stop(host, "positon")
		else:
			host.moves_current -= cost
		var new_unit_found = host.update_viewable()
		if need_to_halt:
			if host.path.size() > 1:
				host.path=[host.path[0]]
				need_to_halt = false
				halted = true
		if new_unit_found:
			if ignore_halt:
				need_to_halt = true
			else:
				if host.path.size() > 1:
					host.path = [host.path[0]]
					halted = true
		host.path.remove(0)

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	host.emit_signal("moved", host, host.location)
	if host.path:
		_move()
	else:
		host.emit_signal("move_finished", host, host.location, halted)
		host.change_state("idle")
