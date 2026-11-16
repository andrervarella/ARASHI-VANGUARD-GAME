extends Control
# Controles de toque multitoque:
#  - direcional único à esquerda (deslizar o polegar): ◀ ▶ andam, ▼ agacha,
#    ▼ + ◀/▶ (diagonal) anda agachado
#  - ATACAR e PULAR à direita
# Teclado para teste no computador: A/D ou setas, S/↓ agachar, espaço pular, J/X atacar.

var move := 0.0
var jump_down := false
var attack_down := false
var crouch_down := false
var _jump_prev := false
var _attack_prev := false
var jump_pressed := false
var attack_pressed := false

var _fingers := {}          # index -> "attack" | "jump"
var _stick_finger := -1
var _stick_vec := Vector2.ZERO
var _demo_vec := Vector2.ZERO
var BTN := {}
var STICK_C := Vector2.ZERO
const STICK_R := 68.0
const MARGIN := 18.0
const MARGIN_R := 104.0   # folga à direita: botão de sair da tela cheia do navegador

func _layout() -> void:
	var vs := get_viewport_rect().size
	var w := vs.x
	var h := vs.y
	var ra := 40.0   # atacar
	var rj := 46.0   # pular
	STICK_C = Vector2(MARGIN + 8.0 + STICK_R, h - MARGIN - STICK_R)
	BTN = {
		"attack": {"pos": Vector2(w - MARGIN_R - rj * 2.0 - 14.0 - ra, h - MARGIN - ra), "r": ra},
		"jump":   {"pos": Vector2(w - MARGIN_R - rj, h - MARGIN - rj - 10.0), "r": rj},
	}

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_layout()
	if OS.get_cmdline_user_args().has("--demo-stick"):   # só para teste de render
		_demo_vec = Vector2(STICK_R * 0.8, STICK_R * 0.8)

func _button_at(p: Vector2) -> String:
	_layout()
	var best := ""
	var best_d := 1e9
	for k in BTN:
		var d: float = p.distance_to(BTN[k]["pos"])
		if d <= BTN[k]["r"] * 1.35 and d < best_d:
			best = k
			best_d = d
	return best

func _in_stick_zone(p: Vector2) -> bool:
	_layout()
	return p.distance_to(STICK_C) <= STICK_R * 1.8

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _stick_finger == -1 and _in_stick_zone(event.position):
				_stick_finger = event.index
				_stick_vec = event.position - STICK_C
			else:
				var b := _button_at(event.position)
				if b != "":
					_fingers[event.index] = b
		else:
			if event.index == _stick_finger:
				_stick_finger = -1
				_stick_vec = Vector2.ZERO
			_fingers.erase(event.index)
	elif event is InputEventScreenDrag:
		if event.index == _stick_finger:
			_stick_vec = event.position - STICK_C
		elif _fingers.has(event.index):
			_fingers[event.index] = _button_at(event.position)

func _process(_dt: float) -> void:
	_layout()
	var j := false
	var a := false
	for idx in _fingers:
		match _fingers[idx]:
			"jump": j = true
			"attack": a = true
	var v := _stick_vec if _stick_finger != -1 else _demo_vec
	var dead := STICK_R * 0.30
	var l := v.x < -dead
	var r := v.x > dead
	var dn := v.y > dead * 1.1
	# teclado (teste no computador)
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): l = true
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): r = true
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): dn = true
	if Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): j = true
	if Input.is_key_pressed(KEY_J) or Input.is_key_pressed(KEY_X): a = true
	move = (1.0 if r else 0.0) - (1.0 if l else 0.0)
	crouch_down = dn
	jump_pressed = j and not _jump_prev
	attack_pressed = a and not _attack_prev
	_jump_prev = j
	_attack_prev = a
	jump_down = j
	attack_down = a
	_sl = l
	_sr = r
	_sd = dn
	queue_redraw()

var _sl := false
var _sr := false
var _sd := false

func _draw() -> void:
	var font := ThemeDB.fallback_font
	# --- direcional ---
	var c := STICK_C
	draw_circle(c + Vector2(0, 3), STICK_R + 2.0, Color(0, 0, 0, 0.25))
	draw_circle(c, STICK_R, Color(0.07, 0.05, 0.09, 0.42))
	draw_arc(c, STICK_R - 1.5, 0, TAU, 64, Color(0.64, 0.09, 0.16, 0.62), 3.0)
	draw_arc(c, STICK_R - 6.0, 0, TAU, 64, Color(0.85, 0.7, 0.4, 0.28), 1.2)
	var u := STICK_R * 0.20
	var off := STICK_R * 0.68
	_arrow(c + Vector2(-off, 0), Vector2(-1, 0), u, _sl)
	_arrow(c + Vector2(off, 0), Vector2(1, 0), u, _sr)
	_arrow(c + Vector2(0, off), Vector2(0, 1), u, _sd)
	var v := _stick_vec if _stick_finger != -1 else _demo_vec
	if v.length() > STICK_R * 0.55:
		v = v.normalized() * STICK_R * 0.55
	var active := _stick_finger != -1 or _demo_vec != Vector2.ZERO
	draw_circle(c + v, 26.0, Color(0.64, 0.09, 0.16, 0.75 if active else 0.45))
	draw_arc(c + v, 26.0, 0, TAU, 40, Color(0.85, 0.7, 0.4, 0.7), 2.0)
	# --- botões de ação ---
	for k in BTN:
		var on := jump_down if k == "jump" else attack_down
		var bc: Vector2 = BTN[k]["pos"]
		var rad: float = BTN[k]["r"] * (0.94 if on else 1.0)
		draw_circle(bc + Vector2(0, 3), rad + 2.0, Color(0, 0, 0, 0.25))
		draw_circle(bc, rad, Color(0.07, 0.05, 0.09, 0.62 if on else 0.42))
		draw_arc(bc, rad - 1.5, 0, TAU, 48, Color(0.64, 0.09, 0.16, 0.95 if on else 0.62), 3.0)
		draw_arc(bc, rad - 5.0, 0, TAU, 48, Color(0.85, 0.7, 0.4, 0.55 if on else 0.28), 1.2)
		if on:
			draw_circle(bc, rad - 6.0, Color(0.64, 0.09, 0.16, 0.30))
		_icon(k, bc, rad, on)
	draw_string(font, Vector2(14, 22), "ARASHI VANGUARD — protótipo (arte provisória)", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color(1, 1, 1, 0.38))

func _arrow(p: Vector2, dir: Vector2, u: float, on: bool) -> void:
	var col := Color(0.96, 0.92, 0.86, 0.95 if on else 0.5)
	var perp := Vector2(-dir.y, dir.x)
	draw_colored_polygon(PackedVector2Array([p + dir * u, p - dir * u * 0.8 + perp * u, p - dir * u * 0.8 - perp * u]), col)

func _icon(k: String, c: Vector2, rad: float, on: bool) -> void:
	var col := Color(0.96, 0.92, 0.86, 0.95 if on else 0.7)
	var u := rad * 0.36
	match k:
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
