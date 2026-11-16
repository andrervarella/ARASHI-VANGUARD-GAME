extends Control
# Controles de toque (esquema aprovado v7) + botão PODER + barras de vida/poder/chefe.
#  - direcional único à esquerda: ◀ ▶ andam, ▼ agacha (▼+◀/▶ anda agachado)
#  - ATACAR e PULAR à direita; PODER em arco acima deles (proposta do doc de controles)
#  - toque no ícone do poder (canto superior esquerdo) troca o poder equipado
#  - ❚❚ no canto superior direito pausa
# Teclado: A/D ou setas, S/↓ agachar, espaço/W/↑ pular, J/X atacar, K/C poder, L/V defesa, Q trocar poder, Esc pausa.

signal pause_requested
signal power_cycle_requested

var move := 0.0
var jump_down := false
var attack_down := false
var power_down := false
var guard_down := false
var crouch_down := false
var jump_pressed := false
var attack_pressed := false
var power_pressed := false
var _jump_prev := false
var _attack_prev := false
var _power_prev := false

var player: Node
var boss: Node
var boss_name := ""
var show_controls := true

var _fingers := {}
var _stick_finger := -1
var _stick_vec := Vector2.ZERO
var _demo_vec := Vector2.ZERO
var BTN := {}
var STICK_C := Vector2.ZERO
const STICK_R := 68.0
const MARGIN := 18.0
const MARGIN_R := 104.0
var _portrait: Texture2D
var _icons := {}
var _btn_tex := {}
var _placa: Texture2D
var _q_prev := false
var _esc_prev := false
var _auto := OS.get_cmdline_user_args().has("--auto")
var _auto_t := 0.0

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_portrait = load("res://assets/portraits/ren.jpg")
	for k in ["attack", "jump", "power", "guard"]:
		var bp := "res://assets/ui/btn_%s.png" % k
		if ResourceLoader.exists(bp):
			_btn_tex[k] = load(bp)
	if ResourceLoader.exists("res://assets/ui/placa.png"):
		_placa = load("res://assets/ui/placa.png")
	_layout()
	if OS.get_cmdline_user_args().has("--demo-stick"):
		_demo_vec = Vector2(STICK_R * 0.8, STICK_R * 0.8)

func _layout() -> void:
	var vs := get_viewport_rect().size
	var w := vs.x
	var h := vs.y
	var ra := 40.0
	var rj := 46.0
	STICK_C = Vector2(MARGIN + 8.0 + STICK_R, h - MARGIN - STICK_R)
	var atk := Vector2(w - MARGIN_R - rj * 2.0 - 14.0 - ra, h - MARGIN - ra)
	var jmp := Vector2(w - MARGIN_R - rj, h - MARGIN - rj - 10.0)
	BTN = {
		"attack": {"pos": atk, "r": ra},
		"jump": {"pos": jmp, "r": rj},
		"power": {"pos": Vector2((atk.x + jmp.x) / 2.0 - 8.0, h - 160.0), "r": 34.0},
		"guard": {"pos": Vector2(atk.x - 64.0, h - 148.0), "r": 34.0},
	}

func _icon_power_rect() -> Rect2:
	return Rect2(Vector2(8, 62), Vector2(210, 50))

func _pause_rect() -> Rect2:
	var vs := get_viewport_rect().size
	return Rect2(Vector2(vs.x - 64, 8), Vector2(52, 44))

func _button_at(p: Vector2) -> String:
	var best := ""
	var best_d := 1e9
	for k in BTN:
		if k == "power" and Game.data["poderes"].is_empty():
			continue
		var d: float = p.distance_to(BTN[k]["pos"])
		if d <= BTN[k]["r"] * 1.3 and d < best_d:
			best = k
			best_d = d
	return best

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventScreenTouch:
		_layout()
		if event.pressed:
			if _pause_rect().has_point(event.position):
				pause_requested.emit()
				return
			if _icon_power_rect().has_point(event.position):
				power_cycle_requested.emit()
				return
			if not show_controls:
				return
			if _stick_finger == -1 and event.position.distance_to(STICK_C) <= STICK_R * 1.8:
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
			var b := _button_at(event.position)
			if b != "":
				_fingers[event.index] = b
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and not DisplayServer.is_touchscreen_available():
		if _pause_rect().has_point(event.position):
			pause_requested.emit()
		elif _icon_power_rect().has_point(event.position):
			power_cycle_requested.emit()

func release_all() -> void:
	_fingers.clear()
	_stick_finger = -1
	_stick_vec = Vector2.ZERO

func _process(_dt: float) -> void:
	_layout()
	var j := false
	var a := false
	var pw := false
	var gd := false
	for idx in _fingers:
		match _fingers[idx]:
			"jump": j = true
			"attack": a = true
			"power": pw = true
			"guard": gd = true
	var v := _stick_vec if _stick_finger != -1 else _demo_vec
	var dead := STICK_R * 0.30
	var l := v.x < -dead
	var r := v.x > dead
	var dn := v.y > dead * 1.1
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): l = true
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): r = true
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): dn = true
	if Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): j = true
	if Input.is_key_pressed(KEY_J) or Input.is_key_pressed(KEY_X): a = true
	if Input.is_key_pressed(KEY_K) or Input.is_key_pressed(KEY_C): pw = true
	if Input.is_key_pressed(KEY_L) or Input.is_key_pressed(KEY_V): gd = true
	var q := Input.is_key_pressed(KEY_Q)
	if q and not _q_prev:
		power_cycle_requested.emit()
	_q_prev = q
	var esc := Input.is_key_pressed(KEY_ESCAPE) or Input.is_key_pressed(KEY_P)
	if esc and not _esc_prev:
		pause_requested.emit()
	_esc_prev = esc
	if _auto:
		_auto_t += _dt
		r = fmod(_auto_t, 6.0) < 5.0
		l = not r
		a = fmod(_auto_t, 0.45) < 0.12
		j = fmod(_auto_t, 1.7) < 0.35
		pw = fmod(_auto_t, 5.0) < 0.1
		gd = fmod(_auto_t, 4.0) > 3.5
	move = (1.0 if r else 0.0) - (1.0 if l else 0.0)
	crouch_down = dn
	jump_pressed = j and not _jump_prev
	attack_pressed = a and not _attack_prev
	power_pressed = pw and not _power_prev
	_jump_prev = j
	_attack_prev = a
	_power_prev = pw
	jump_down = j
	attack_down = a
	power_down = pw
	guard_down = gd
	_sl = l
	_sr = r
	_sd = dn
	queue_redraw()

var _sl := false
var _sr := false
var _sd := false

const RED := Color(0.64, 0.09, 0.16)
const GOLD := Color(0.85, 0.7, 0.4)

func _draw() -> void:
	var font := Game.FONT_SERIF
	var vs := get_viewport_rect().size
	# --- retrato e barras (estilo jogo de luta) ---
	if player:
		var pc := Vector2(38, 38)
		draw_circle(pc, 30, Color(0, 0, 0, 0.6))
		if _portrait:
			draw_texture_rect(_portrait, Rect2(pc - Vector2(26, 26), Vector2(52, 52)), false)
		var pcol: Color = Game.POWERS[Game.data["equipado"]]["cor"]
		draw_arc(pc, 28, 0, TAU, 40, GOLD, 2.5)
		draw_arc(pc, 31, 0, TAU, 40, pcol, 2.0)
		var hpmax := float(Game.hp_max())
		var bw := 210.0
		_bar(Vector2(74, 18), Vector2(bw, 16), float(player.hp) / hpmax, Color(0.86, 0.12, 0.18), Color(1, 0.55, 0.45))
		for i in range(1, int(hpmax)):
			var x := 74.0 + bw * i / hpmax
			draw_line(Vector2(x, 19), Vector2(x, 33), Color(0, 0, 0, 0.5), 1.0)
		_bar(Vector2(74, 40), Vector2(160, 9), player.ki / 100.0, pcol.lightened(0.1), pcol.lightened(0.5))
		# custo do poder
		var cost: float = Game.POWERS[Game.data["equipado"]]["custo"]
		if cost > 0:
			draw_line(Vector2(74 + 160 * cost / 100.0, 38), Vector2(74 + 160 * cost / 100.0, 51), Color(1, 1, 1, 0.8), 2.0)
		# poder equipado (toque para trocar)
		var pname: String = Game.POWERS[Game.data["equipado"]]["nome"]
		if Game.data["poderes"].size() > 0:
			var r := _icon_power_rect()
			if _placa:
				draw_texture_rect(_placa, r, false, Color(1, 1, 1, 0.95))
			else:
				draw_rect(r, Color(0.05, 0.02, 0.04, 0.55))
			var key: String = Game.data["equipado"] if Game.data["equipado"] != "" else "fio"
			var pi := "res://assets/icons/%s.png" % key
			if not _icons.has(pi) and ResourceLoader.exists(pi):
				_icons[pi] = load(pi)
			draw_circle(r.position + Vector2(28, 25), 22, Color(0, 0, 0, 0.55))
			draw_arc(r.position + Vector2(28, 25), 22, 0, TAU, 32, pcol, 2.0)
			if _icons.has(pi):
				draw_texture_rect(_icons[pi], Rect2(r.position + Vector2(8, 5), Vector2(40, 40)), false)
			var pn: String = pname if Game.data["equipado"] != "" else "Katana de Ren"
			draw_string_outline(font, r.position + Vector2(56, 24), pn, HORIZONTAL_ALIGNMENT_LEFT, 150, 14, 4, Color(0, 0, 0, 0.9))
			draw_string(font, r.position + Vector2(56, 24), pn, HORIZONTAL_ALIGNMENT_LEFT, 150, 14, Color(1, 0.93, 0.78))
			draw_string(font, r.position + Vector2(56, 40), "toque para trocar", HORIZONTAL_ALIGNMENT_LEFT, 150, 10, Color(1, 0.85, 0.6, 0.7))
	# --- pausa ---
	var pr := _pause_rect()
	draw_rect(pr, Color(0.05, 0.02, 0.04, 0.45))
	draw_rect(Rect2(pr.get_center() + Vector2(-9, -11), Vector2(6, 22)), Color(1, 0.95, 0.85, 0.8))
	draw_rect(Rect2(pr.get_center() + Vector2(3, -11), Vector2(6, 22)), Color(1, 0.95, 0.85, 0.8))
	# --- chefe ---
	if boss and is_instance_valid(boss) and boss.get("hp") != null and boss.hp > 0:
		var bw2 := clampf(vs.x - 640.0, 260.0, 460.0)
		var bp := Vector2((vs.x - bw2) / 2.0, 22)
		draw_string_outline(font, bp + Vector2(0, -2), boss_name, HORIZONTAL_ALIGNMENT_CENTER, bw2, 16, 5, Color(0, 0, 0, 0.95))
		draw_string(font, bp + Vector2(0, -2), boss_name, HORIZONTAL_ALIGNMENT_CENTER, bw2, 16, Color(1, 0.88, 0.7))
		_bar(bp + Vector2(0, 6), Vector2(bw2, 12), float(boss.hp) / float(boss.hp_max), Color(0.7, 0.05, 0.1), Color(1, 0.5, 0.2))
	if not show_controls:
		return
	# --- direcional ---
	var c := STICK_C
	draw_circle(c + Vector2(0, 4), STICK_R + 3.0, Color(0, 0, 0, 0.3))
	draw_circle(c, STICK_R, Color(0.06, 0.05, 0.07, 0.62))
	draw_arc(c, STICK_R - 2.0, 0, TAU, 64, Color(0.86, 0.66, 0.25, 0.95), 5.0)
	draw_arc(c, STICK_R - 6.5, 0, TAU, 64, Color(0.45, 0.3, 0.1, 0.9), 2.0)
	draw_arc(c, STICK_R - 12.0, 0, TAU, 64, Color(RED.r, RED.g, RED.b, 0.55), 2.0)
	for ang in [0.0, PI / 2.0, PI, 3.0 * PI / 2.0]:
		draw_circle(c + Vector2(cos(ang + PI / 4.0), sin(ang + PI / 4.0)) * (STICK_R - 2.0), 4.0, Color(0.95, 0.8, 0.4))
	var u := STICK_R * 0.20
	var off := STICK_R * 0.68
	_arrow(c + Vector2(-off, 0), Vector2(-1, 0), u, _sl)
	_arrow(c + Vector2(off, 0), Vector2(1, 0), u, _sr)
	_arrow(c + Vector2(0, off), Vector2(0, 1), u, _sd)
	var v := _stick_vec if _stick_finger != -1 else _demo_vec
	if v.length() > STICK_R * 0.55:
		v = v.normalized() * STICK_R * 0.55
	var active := _stick_finger != -1 or _demo_vec != Vector2.ZERO
	draw_circle(c + v + Vector2(0, 3), 27.0, Color(0, 0, 0, 0.35))
	draw_circle(c + v, 26.0, Color(0.12, 0.08, 0.09, 0.95))
	draw_circle(c + v, 20.0, Color(RED.r, RED.g, RED.b, 0.95 if active else 0.75))
	draw_circle(c + v + Vector2(-6, -6), 7.0, Color(1, 0.6, 0.6, 0.35))
	draw_arc(c + v, 26.0, 0, TAU, 40, Color(0.86, 0.66, 0.25, 0.95), 3.0)
	# --- botões ---
	for k in BTN:
		if k == "power" and Game.data["poderes"].is_empty():
			continue
		var on: bool = {"jump": jump_down, "attack": attack_down, "power": power_down, "guard": guard_down}[k]
		var bc: Vector2 = BTN[k]["pos"]
		var rad: float = BTN[k]["r"] * (0.94 if on else 1.0)
		var ring := RED
		if k == "power":
			ring = Game.POWERS[Game.data["equipado"]]["cor"]
			if player and player.ki < float(Game.POWERS[Game.data["equipado"]]["custo"]):
				ring = ring.darkened(0.5)
		if _btn_tex.has(k):
			var sz := rad * 2.25 * (0.93 if on else 1.0)
			var mod := Color(1.25, 1.15, 1.0, 1.0) if on else Color(1, 1, 1, 0.88)
			if k == "power":
				mod = Color(ring.r * 0.5 + 0.6, ring.g * 0.5 + 0.6, ring.b * 0.5 + 0.6, 0.92 if not on else 1.0)
			draw_circle(bc + Vector2(0, 4), sz * 0.47, Color(0, 0, 0, 0.35))
			draw_texture_rect(_btn_tex[k], Rect2(bc - Vector2(sz, sz) / 2.0, Vector2(sz, sz)), false, mod)
			if on:
				draw_circle(bc, sz * 0.42, Color(ring.r, ring.g, ring.b, 0.18))
			continue
		draw_circle(bc + Vector2(0, 3), rad + 2.0, Color(0, 0, 0, 0.25))
		draw_circle(bc, rad, Color(0.07, 0.05, 0.09, 0.62 if on else 0.42))
		draw_arc(bc, rad - 1.5, 0, TAU, 48, Color(ring.r, ring.g, ring.b, 0.95 if on else 0.7), 3.0)
		draw_arc(bc, rad - 5.0, 0, TAU, 48, Color(GOLD.r, GOLD.g, GOLD.b, 0.55 if on else 0.28), 1.2)
		if on:
			draw_circle(bc, rad - 6.0, Color(ring.r, ring.g, ring.b, 0.30))
		_icon(k, bc, rad, on)

func _bar(p: Vector2, s: Vector2, f: float, col: Color, hi: Color) -> void:
	f = clampf(f, 0.0, 1.0)
	draw_rect(Rect2(p - Vector2(2, 2), s + Vector2(4, 4)), Color(0, 0, 0, 0.7))
	draw_rect(Rect2(p, s), Color(0.15, 0.05, 0.07, 0.9))
	draw_rect(Rect2(p, Vector2(s.x * f, s.y)), col)
	draw_rect(Rect2(p, Vector2(s.x * f, s.y * 0.35)), Color(hi.r, hi.g, hi.b, 0.6))
	draw_rect(Rect2(p - Vector2(2, 2), s + Vector2(4, 4)), GOLD, false, 1.5)

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
			draw_line(guard - perp, guard + perp, Color(GOLD.r, GOLD.g, GOLD.b, 0.9 if on else 0.65), 3.0)
			draw_line(guard, c + Vector2(-u * 1.1, u * 1.1), Color(RED.r, RED.g, RED.b, 0.95), 5.0)
		"guard":
			# tsuba (guarda da katana)
			draw_circle(c, u * 1.25, Color(col.r, col.g, col.b, 0.85))
			draw_circle(c, u * 0.95, Color(0.12, 0.06, 0.06, 0.95))
			draw_rect(Rect2(c - Vector2(u * 0.18, u * 0.6), Vector2(u * 0.36, u * 1.2)), Color(col.r, col.g, col.b, 0.9))
			for ang in [0.785, 2.356, 3.927, 5.498]:
				draw_circle(c + Vector2(cos(ang), sin(ang)) * u * 0.62, u * 0.16, Color(GOLD.r, GOLD.g, GOLD.b, 0.9))
		"power":
			# chama estilizada
			var pts := PackedVector2Array()
			for i in range(13):
				var ang := TAU * i / 12.0
				var rr := u * (1.25 if i % 2 == 0 else 0.6)
				pts.append(c + Vector2(sin(ang), -cos(ang)) * rr)
			draw_colored_polygon(pts, Color(col.r, col.g, col.b, 0.85))
			draw_circle(c, u * 0.45, Color(0.1, 0.05, 0.05, 0.9))
