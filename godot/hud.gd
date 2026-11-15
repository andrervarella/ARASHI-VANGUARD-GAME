extends Control
# Controles de toque (multitoque) + teclado para teste no computador.
# Cada dedo (index) fica ligado a um botão até soltar.

var move := 0.0
var jump_down := false
var attack_down := false
var _jump_prev := false
var _attack_prev := false
var jump_pressed := false
var attack_pressed := false

var _fingers := {}   # index -> nome do botão
const BTN := {
	"left":   {"pos": Vector2(110, 440), "r": 62.0, "label": "◀"},
	"right":  {"pos": Vector2(270, 440), "r": 62.0, "label": "▶"},
	"attack": {"pos": Vector2(690, 455), "r": 58.0, "label": "ATACAR"},
	"jump":   {"pos": Vector2(840, 420), "r": 68.0, "label": "PULAR"},
}

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _button_at(p: Vector2) -> String:
	var best := ""
	var best_d := 1e9
	for k in BTN:
		var d: float = p.distance_to(BTN[k]["pos"])
		# zona de toque generosa (1.4x) para dedos grandes
		if d <= BTN[k]["r"] * 1.4 and d < best_d:
			best = k
			best_d = d
	return best

func _input(event: InputEvent) -> void:
	# eventos de toque já chegam em coordenadas do viewport (stretch aplicado)
	if event is InputEventScreenTouch:
		if event.pressed:
			_fingers[event.index] = _button_at(event.position)
		else:
			_fingers.erase(event.index)
	elif event is InputEventScreenDrag:
		_fingers[event.index] = _button_at(event.position)

func _process(_dt: float) -> void:
	var l := false
	var r := false
	var j := false
	var a := false
	for idx in _fingers:
		match _fingers[idx]:
			"left": l = true
			"right": r = true
			"jump": j = true
			"attack": a = true
	# teclado (teste no computador)
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): l = true
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): r = true
	if Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): j = true
	if Input.is_key_pressed(KEY_J) or Input.is_key_pressed(KEY_X): a = true
	move = (1.0 if r else 0.0) - (1.0 if l else 0.0)
	jump_pressed = j and not _jump_prev
	attack_pressed = a and not _attack_prev
	_jump_prev = j
	_attack_prev = a
	jump_down = j
	attack_down = a
	_state_l = l; _state_r = r
	queue_redraw()

var _state_l := false
var _state_r := false

func _draw() -> void:
	var font := ThemeDB.fallback_font
	for k in BTN:
		var on := false
		match k:
			"left": on = _state_l
			"right": on = _state_r
			"jump": on = jump_down
			"attack": on = attack_down
		var c: Vector2 = BTN[k]["pos"]
		var rad: float = BTN[k]["r"]
		draw_circle(c, rad, Color(0.85, 0.15, 0.2, 0.55 if on else 0.22))
		draw_arc(c, rad, 0, TAU, 40, Color(1, 1, 1, 0.55), 3.0)
		var t: String = BTN[k]["label"]
		var fs := 26 if t.length() == 1 else 18
		var sz := font.get_string_size(t, HORIZONTAL_ALIGNMENT_CENTER, -1, fs)
		draw_string(font, c + Vector2(-sz.x / 2.0, fs * 0.35), t, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color(1, 1, 1, 0.9))
	draw_string(font, Vector2(16, 26), "ARASHI VANGUARD — protótipo (arte provisória, não é o design final)", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(1, 1, 1, 0.75))
