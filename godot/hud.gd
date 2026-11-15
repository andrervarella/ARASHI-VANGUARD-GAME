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
var BTN := {}        # recalculado a cada quadro conforme o tamanho da tela
const MARGIN := 18.0
const MARGIN_R := 104.0   # folga à direita: o botão de sair da tela cheia do navegador fica ali

func _layout() -> void:
	var vs := get_viewport_rect().size   # tamanho real da tela (não depende do tamanho do Control)
	var w := vs.x
	var h := vs.y
	var rs := 30.0   # setas
	var ra := 31.0   # atacar
	var rj := 36.0   # pular
	BTN = {
		"left":   {"pos": Vector2(MARGIN + rs, h - MARGIN - rs), "r": rs},
		"right":  {"pos": Vector2(MARGIN + rs * 3.0 + 12.0, h - MARGIN - rs), "r": rs},
		"attack": {"pos": Vector2(w - MARGIN_R - rj * 2.0 - 12.0 - ra, h - MARGIN - ra), "r": ra},
		"jump":   {"pos": Vector2(w - MARGIN_R - rj, h - MARGIN - rj - 10.0), "r": rj},
	}

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_layout()

func _button_at(p: Vector2) -> String:
	_layout()
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
	_layout()
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
		var rad: float = BTN[k]["r"] * (0.94 if on else 1.0)
		draw_circle(c + Vector2(0, 3), rad + 2.0, Color(0, 0, 0, 0.25))
		draw_circle(c, rad, Color(0.07, 0.05, 0.09, 0.62 if on else 0.42))
		draw_arc(c, rad - 1.5, 0, TAU, 48, Color(0.64, 0.09, 0.16, 0.95 if on else 0.62), 3.0)
		draw_arc(c, rad - 5.0, 0, TAU, 48, Color(0.85, 0.7, 0.4, 0.55 if on else 0.28), 1.2)
		if on:
			draw_circle(c, rad - 6.0, Color(0.64, 0.09, 0.16, 0.30))
		_icon(k, c, rad, on)
	draw_string(font, Vector2(14, 22), "ARASHI VANGUARD — protótipo (arte provisória)", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color(1, 1, 1, 0.38))

func _icon(k: String, c: Vector2, rad: float, on: bool) -> void:
	var col := Color(0.96, 0.92, 0.86, 0.95 if on else 0.7)
	var u := rad * 0.36
	match k:
		"left":
			draw_colored_polygon(PackedVector2Array([c + Vector2(-u, 0), c + Vector2(u * 0.8, -u), c + Vector2(u * 0.8, u)]), col)
		"right":
			draw_colored_polygon(PackedVector2Array([c + Vector2(u, 0), c + Vector2(-u * 0.8, -u), c + Vector2(-u * 0.8, u)]), col)
		"jump":
			for i in range(2):
				var y := c.y + u * 0.5 - float(i) * u * 0.9
				draw_polyline(PackedVector2Array([Vector2(c.x - u, y + u * 0.2), Vector2(c.x, y - u * 0.6), Vector2(c.x + u, y + u * 0.2)]), col, 4.0)
		"attack":
			var tip := c + Vector2(u * 1.2, -u * 1.2)
			var guard := c + Vector2(-u * 0.35, u * 0.35)
			draw_line(guard, tip, col, 3.5)
			var perp := Vector2(0.7, 0.7) * u * 0.55
			draw_line(guard - perp, guard + perp, Color(0.85, 0.7, 0.4, 0.9 if on else 0.65), 3.0)
			draw_line(guard, c + Vector2(-u * 1.1, u * 1.1), Color(0.64, 0.09, 0.16, 0.95), 5.0)
