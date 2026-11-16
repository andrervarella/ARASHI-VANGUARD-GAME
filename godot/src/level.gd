extends Node2D
# Fase genérica montada a partir de src/levels.gd: cenário, chão, plataformas, inimigos,
# dicas do tutorial, diálogos, chefe com arena, hub (Vila) com portais e Tetsu.

var level_id := "ferreiros"
var D: Dictionary
var GY := 900.0
var player: CharacterBody2D
var luke: Node2D
var hud: Control
var dlg: CanvasLayer
var cam: Camera2D
var frozen := false
var boss: Node
var arena_x0 := 0.0
var arena_x1 := 0.0
var _arena_on := false
var _boss_done := false
var _events_done := {}
var _prompts_done := {}
var _shake := 0.0
var _bg: Sprite2D
var _bg_layer: CanvasLayer
var _ui: CanvasLayer
var _toast: Label
var _banner: Label
var _interact_lbl: Label
var _interactables: Array = []   # {rect, prompt, cb}
var _safe_x := 0.0
var _luke_free := false
var _arena_walls: Array = []
var _pause: Control
var _dead := false

func _ready() -> void:
	var LV = load("res://src/levels.gd")
	D = LV.L[level_id]
	GY = LV.GY
	_build_bg()
	_build_world()
	# jogador
	player = load("res://src/player.gd").new()
	player.level = self
	var start_x: float = D["inicio"]
	var cp: Dictionary = Game.data.get("cp", {})
	if cp.get("fase", "") == level_id:
		start_x = float(cp["x"])
	player.position = Vector2(start_x, GY - 2.0)
	add_child(player)
	player.died.connect(_on_player_died)
	_safe_x = start_x
	# eventos antes do ponto de partida já contam como vistos
	for e in D["events"]:
		if float(e[0]) < start_x - 100.0 and start_x != float(D["inicio"]):
			_events_done[e[1]] = true
	for p in D["prompts"]:
		if float(p[0]) < start_x - 100.0:
			_prompts_done[p[1]] = true
	# Luke
	_luke_free = D.get("luke_inicio", false) or (level_id == "ferreiros" and Game.seen("luke_salvo"))
	if _luke_free:
		_spawn_luke(Vector2(start_x - 120.0, GY))
	# câmera
	cam = Camera2D.new()
	cam.zoom = Vector2(1.0, 1.0)
	cam.position_smoothing_enabled = true
	cam.position_smoothing_speed = 7.0
	cam.limit_left = 0
	cam.limit_right = int(D["largura"])
	cam.limit_bottom = int(GY + 150.0)
	cam.limit_top = int(GY - 2400.0)
	cam.position = Vector2(0, -120)
	player.add_child(cam)
	cam.make_current()
	# interface
	_ui = CanvasLayer.new()
	_ui.layer = 10
	add_child(_ui)
	hud = load("res://src/hud.gd").new()
	hud.player = player
	_ui.add_child(hud)
	player.ctl = hud
	hud.pause_requested.connect(_toggle_pause)
	hud.power_cycle_requested.connect(_cycle_power)
	_toast = Game.label("", 22, Color(1, 0.92, 0.75))
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.modulate.a = 0.0
	_ui.add_child(_toast)
	_banner = Game.label("", 24, Color(1, 0.97, 0.9))
	_banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_banner.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_banner.modulate.a = 0.0
	_ui.add_child(_banner)
	_interact_lbl = Game.label("", 18, Color(1, 0.9, 0.6))
	_interact_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_interact_lbl.visible = false
	add_child(_interact_lbl)
	_interact_lbl.z_index = 30
	_interact_lbl.scale = Vector2(1.0, 1.0)
	dlg = load("res://src/dialogue.gd").new()
	add_child(dlg)
	get_viewport().size_changed.connect(_layout_ui)
	_layout_ui()
	_build_vignette()
	Game.music(D["musica"], -9.0)
	Game.ambience(D.get("amb", ""), -20.0)
	if D.has("chefe"):
		_spawn_boss()

# ---------------- construção ----------------
func _build_bg() -> void:
	_bg_layer = CanvasLayer.new()
	_bg_layer.layer = -10
	add_child(_bg_layer)
	_bg = Sprite2D.new()
	var p := "res://assets/bg/%s.png" % D["bg"]
	if not ResourceLoader.exists(p):
		p = "res://assets/bg/ferreiros.png"
	_bg.texture = load(p)
	_bg.centered = false
	_bg_layer.add_child(_bg)

func _build_vignette() -> void:
	var l := CanvasLayer.new()
	l.layer = 1
	add_child(l)
	var tr := TextureRect.new()
	var gt := GradientTexture2D.new()
	gt.fill = GradientTexture2D.FILL_RADIAL
	gt.fill_from = Vector2(0.5, 0.45)
	gt.fill_to = Vector2(1.05, 1.05)
	var g := Gradient.new()
	g.set_color(0, Color(0, 0, 0, 0))
	g.set_color(1, Color(0, 0, 0, 0.55))
	gt.gradient = g
	tr.texture = gt
	tr.set_anchors_preset(Control.PRESET_FULL_RECT)
	tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tr.stretch_mode = TextureRect.STRETCH_SCALE
	l.add_child(tr)
	# partículas de clima presas à câmera
	var pt := CPUParticles2D.new()
	pt.amount = 60
	pt.lifetime = 4.0
	pt.preprocess = 4.0
	pt.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	pt.emission_rect_extents = Vector2(1300, 20)
	pt.z_index = 25
	match D.get("particulas", ""):
		"brasas":
			pt.position = Vector2(0, 700)
			pt.direction = Vector2(0.2, -1)
			pt.gravity = Vector2(20, -40)
			pt.initial_velocity_min = 60
			pt.initial_velocity_max = 160
			pt.scale_amount_min = 3
			pt.scale_amount_max = 7
			pt.color = Color(1, 0.55, 0.15, 0.85)
		"petalas":
			pt.position = Vector2(0, -700)
			pt.direction = Vector2(0.5, 1)
			pt.gravity = Vector2(25, 40)
			pt.initial_velocity_min = 40
			pt.initial_velocity_max = 90
			pt.angular_velocity_min = -90
			pt.angular_velocity_max = 90
			pt.scale_amount_min = 5
			pt.scale_amount_max = 9
			pt.color = Color(0.85, 0.1, 0.2, 0.85)
		"incenso":
			pt.amount = 24
			pt.position = Vector2(0, 600)
			pt.direction = Vector2(0, -1)
			pt.gravity = Vector2(10, -20)
			pt.initial_velocity_min = 20
			pt.initial_velocity_max = 50
			pt.scale_amount_min = 18
			pt.scale_amount_max = 40
			pt.color = Color(0.6, 0.35, 0.75, 0.10)
		"chuva":
			pt.amount = 140
			pt.lifetime = 1.2
			pt.preprocess = 1.2
			pt.position = Vector2(0, -700)
			pt.direction = Vector2(-0.15, 1)
			pt.spread = 2
			pt.initial_velocity_min = 1100
			pt.initial_velocity_max = 1300
			pt.scale_amount_min = 2
			pt.scale_amount_max = 3
			pt.color = Color(0.7, 0.75, 0.9, 0.35)
		_:
			pt.emitting = false
	cam.add_child(pt)

func _static_rect(x: float, y: float, w: float, h: float, layer_bits: int, one_way := false) -> StaticBody2D:
	var sb := StaticBody2D.new()
	sb.collision_layer = layer_bits
	sb.collision_mask = 0
	var cs := CollisionShape2D.new()
	var rs := RectangleShape2D.new()
	rs.size = Vector2(w, h)
	cs.shape = rs
	cs.position = Vector2(x + w / 2.0, y + h / 2.0)
	cs.one_way_collision = one_way
	sb.add_child(cs)
	add_child(sb)
	return sb

func _build_world() -> void:
	for g in D["ground"]:
		_static_rect(g[0], GY, g[1] - g[0], 800.0, 1)
	for p in D["plats"]:
		_static_rect(p[0], GY - p[1], p[2], 22.0, 4, true)
	for b in D["blocks"]:
		_static_rect(b[0], GY - b[1], b[2], b[3], 1)
	# paredes das bordas
	_static_rect(-100.0, GY - 3000.0, 100.0, 4000.0, 1)
	_static_rect(D["largura"], GY - 3000.0, 100.0, 4000.0, 1)
	for b in D["breakables"]:
		var br = load("res://src/breakable.gd").new()
		br.kind = b[3]
		br.id = b[4]
		br.size = Vector2(b[1], b[2])
		br.position = Vector2(b[0], GY)
		br.level = self
		br.broken.connect(_on_broken)
		add_child(br)
		if b[4] == "luke" and not Game.seen("luke_salvo"):
			_luke_caged = Vector2(b[0] + b[1] / 2.0, GY)
	for f in D["foes"]:
		var y: float = GY - (float(f[2]) if f.size() > 2 else 0.0) - 2.0
		spawn_enemy(f[0], f[1], y)
	for pk in D["pickups"]:
		spawn_pickup(pk[2], Vector2(pk[0], GY - pk[1] - 50.0))
	# hub
	for n in D.get("npcs", []):
		_add_npc(n[0], n[1])
	for d in D.get("portas", []):
		_add_door(d)
	if _luke_caged != Vector2.ZERO:
		_spawn_luke(_luke_caged)
		luke.target = null
		luke.spr.play_anim("idle")

var _luke_caged := Vector2.ZERO

func spawn_enemy(kind: String, x: float, y: float) -> Node:
	var e = load("res://src/enemy.gd").new()
	e.kind = kind
	e.level = self
	e.position = Vector2(x, y)
	add_child(e)
	return e

func spawn_pickup(kind: String, pos: Vector2) -> void:
	var p = load("res://src/pickup.gd").new()
	p.kind = kind
	p.level = self
	p.position = pos
	add_child(p)

func _spawn_luke(pos: Vector2) -> void:
	luke = load("res://src/luke.gd").new()
	luke.level = self
	luke.position = pos
	luke.target = player
	add_child(luke)

func _spawn_boss() -> void:
	arena_x0 = D["arena"][0]
	arena_x1 = D["arena"][1]
	if Game.data["vencidos"].has(D["chefe"]):
		return
	var scr := "res://src/boss_%s.gd" % D["chefe"]
	boss = load(scr).new()
	boss.level = self
	boss.facing = -1
	boss.position = Vector2(arena_x1 - 320.0, GY - 2.0)
	add_child(boss)
	boss.defeated.connect(_on_boss_defeated)

func ground_at(x: float) -> float:
	for g in D["ground"]:
		if x >= g[0] and x <= g[1]:
			return GY
	return 99999.0

# ---------------- hub ----------------
func _add_npc(who: String, x: float) -> void:
	var n := Node2D.new()
	n.position = Vector2(x, GY)
	add_child(n)
	var p := "res://assets/sprites/%s/%s.json" % [who, who]
	if FileAccess.file_exists(p):
		var s = load("res://src/actor_sprite.gd").new()
		s.setup(who)
		n.add_child(s)
		s.play_anim("idle")
		s.set_facing(1)
	_interactables.append({"rect": Rect2(x - 120, GY - 200, 240, 200), "prompt": "ATACAR: falar", "cb": _talk_tetsu, "pos": Vector2(x, GY - 190)})

func _talk_tetsu() -> void:
	var n: int = Game.data["vencidos"].size()
	var id := "tetsu_1"
	if Game.seen("tetsu_1"):
		id = "tetsu_3" if n >= 2 else "tetsu_2"
	Game.mark(id)
	Game.save()
	say(id)

func _add_door(d: Array) -> void:
	var x: float = d[0]
	_doors.append(d)
	_interactables.append({"rect": Rect2(x - 110, GY - 300, 220, 300), "prompt": "ATACAR: entrar", "cb": func(): _enter_door(d), "pos": Vector2(x, GY - 250)})

var _doors: Array = []

func _door_state(d: Array) -> String:
	var target: String = d[1]
	if target == "":
		return "breve"
	var boss_of := {"torii": "baku", "palacio": "xui"}
	if Game.data["vencidos"].has(boss_of.get(target, "")):
		return "vencido"
	return "aberto"

func _enter_door(d: Array) -> void:
	match _door_state(d):
		"breve": toast("%s — em breve." % d[2])
		"vencido": toast("%s já foi derrotado." % d[3].split(" —")[0])
		"aberto":
			Game.sfx("ui_ok")
			frozen = true
			Game.data["cp"] = {}
			Game.data["etapa"] = d[1]
			Game.save()
			Game.goto("level", d[1])

func try_interact() -> bool:
	var it = _near_interactable()
	if it == null or not player.is_on_floor():
		return false
	it["cb"].call()
	return true

func _near_interactable() -> Variant:
	if player == null:
		return null
	for it in _interactables:
		if it["rect"].has_point(player.global_position + Vector2(0, -10)):
			return it
	return null

# ---------------- desenho do mundo ----------------
var _tx := {}
func prop(name: String) -> Texture2D:
	if not _tx.has(name):
		var p := "res://assets/props/%s.png" % name
		_tx[name] = load(p) if ResourceLoader.exists(p) else null
	return _tx[name]

func _draw_ground_tex(g: Array, t: Texture2D) -> void:
	# a textura já vem espelhada (emenda sem costura); repete sem cortes
	var tw := float(t.get_width())
	var th := float(t.get_height())
	var x: float = g[0]
	while x < g[1]:
		var w := minf(tw, g[1] - x)
		draw_texture_rect_region(t, Rect2(x, GY - 6.0, w, th), Rect2(fmod(x, tw) * 0.0, 0, w, th))
		x += w
	# bordas de penhasco nos dois lados do trecho
	for side in [0, 1]:
		var ex: float = g[0] if side == 0 else g[1]
		var dir := -1.0 if side == 0 else 1.0
		if (side == 0 and g[0] <= 0.0) or (side == 1 and g[1] >= float(D["largura"])):
			continue
		var pts := PackedVector2Array([Vector2(ex, GY - 6), Vector2(ex + dir * 10, GY + 30), Vector2(ex + dir * 4, GY + 70), Vector2(ex + dir * 16, GY + 120), Vector2(ex + dir * 8, GY + 200), Vector2(ex - dir * 30, GY + 200), Vector2(ex - dir * 30, GY - 6)])
		draw_colored_polygon(pts, D["chao"].darkened(0.35))
		draw_polyline(PackedVector2Array([Vector2(ex, GY - 6), Vector2(ex + dir * 10, GY + 30), Vector2(ex + dir * 4, GY + 70), Vector2(ex + dir * 16, GY + 120), Vector2(ex + dir * 8, GY + 200)]), D["borda"].darkened(0.2), 4.0)

# abismo entre trechos de chão: escuridão com névoa, para parecer buraco de verdade
func _draw_pits() -> void:
	var gs: Array = D["ground"]
	for i in range(gs.size() - 1):
		var x0: float = gs[i][1]
		var x1: float = gs[i + 1][0]
		var w := x1 - x0
		for k in range(12):
			var y := GY - 6.0 + k * 22.0
			draw_rect(Rect2(x0, y, w, 22.0), Color(0.02, 0.01, 0.03, clampf(0.15 + k * 0.08, 0.0, 0.95)))
		var tt := Time.get_ticks_msec() * 0.001
		for k in range(5):
			var fx := x0 + fmod(k * 53.0 + tt * 18.0, w)
			draw_circle(Vector2(fx, GY + 120.0 + sin(tt + k) * 8.0), 34.0, Color(0.6, 0.55, 0.7, 0.07))
		# pedrinhas soltas caindo da borda
		draw_rect(Rect2(x0 + 6, GY + 10 + fmod(tt * 60.0, 120.0), 5, 5), Color(0.3, 0.25, 0.25, 0.6))

func _draw() -> void:
	var top: Color = D["borda"]
	var fill: Color = D["chao"]
	var gt := prop("chao_" + level_id)
	_draw_pits()
	for g in D["ground"]:
		var r := Rect2(g[0], GY, g[1] - g[0], 800.0)
		draw_rect(r, fill)
		if gt:
			_draw_ground_tex(g, gt)
			draw_rect(Rect2(g[0], GY - 6.0 + gt.get_height(), g[1] - g[0], 800.0), fill.darkened(0.3))
			continue
		draw_rect(Rect2(g[0], GY, g[1] - g[0], 16.0), top)
		draw_rect(Rect2(g[0], GY + 16.0, g[1] - g[0], 6.0), top.darkened(0.45))
		var x: float = g[0]
		var i := 0
		while x < g[1]:
			var w := 70.0 + float((i * 37) % 50)
			draw_line(Vector2(x, GY + 22), Vector2(x, GY + 70), fill.darkened(0.4), 3.0)
			draw_rect(Rect2(x + 6, GY + 26, w - 12, 40), fill.lightened(0.05))
			draw_line(Vector2(x + 30, GY + 90), Vector2(x + 30, GY + 150), fill.darkened(0.35), 3.0)
			x += w
			i += 1
		# borda do abismo
		draw_rect(Rect2(g[0], GY, 6, 800), top.darkened(0.6))
		draw_rect(Rect2(g[1] - 6, GY, 6, 800), top.darkened(0.6))
	var pt := prop("plataforma_jade" if level_id == "palacio" else "plataforma")
	for p in D["plats"]:
		var r := Rect2(p[0], GY - p[1], p[2], 22.0)
		if pt:
			draw_texture_rect(pt, Rect2(r.position - Vector2(6, 2), Vector2(r.size.x + 12, pt.get_height() * (r.size.x + 12) / pt.get_width())), false)
			continue
		draw_rect(r, Color(0.33, 0.19, 0.11))
		draw_rect(Rect2(r.position, Vector2(r.size.x, 5)), Color(0.55, 0.35, 0.2))
		draw_rect(Rect2(r.position + Vector2(0, 17), Vector2(r.size.x, 5)), Color(0.15, 0.08, 0.05))
		for k in range(int(r.size.x / 60.0)):
			draw_line(r.position + Vector2(30 + k * 60, 5), r.position + Vector2(30 + k * 60, 17), Color(0.2, 0.11, 0.07), 2.0)
		draw_line(r.position + Vector2(8, 22), r.position + Vector2(8, 60), Color(0.45, 0.35, 0.25), 3.0)
		draw_line(r.position + Vector2(r.size.x - 8, 22), r.position + Vector2(r.size.x - 8, 60), Color(0.45, 0.35, 0.25), 3.0)
	for b in D["blocks"]:
		_draw_block(Rect2(b[0], GY - b[1], b[2], b[3]), b[4])
	for d in _doors:
		_draw_door(d)
	if D.has("portao_x"):
		var gx: float = D["portao_x"]
		var gtx := prop("portao")
		var glow := _gate_glow
		if gtx:
			draw_texture_rect(gtx, Rect2(gx - 300, GY - 600, 600, 610), false, Color(1, 1 - glow * 0.6, 1 - glow * 0.7))
		else:
			draw_rect(Rect2(gx - 260, GY - 560, 520, 560), Color(0.12, 0.1, 0.1))
			draw_circle(Vector2(gx, GY - 300), 120.0, Color(0.5, 0.35, 0.15))
		if glow > 0.0:
			draw_rect(Rect2(gx - 240, GY - 560, 480, 560), Color(1, 0.15, 0.1, 0.45 * glow))
	if _luke_caged != Vector2.ZERO and not _luke_free:
		pass

func _draw_block(r: Rect2, style: String) -> void:
	var tex_name: String = {"caixas": "caixa", "viga": "telhado", "pedra": "pedra", "mesa": "mesa"}.get(style, "")
	var t := prop(tex_name) if tex_name != "" else null
	if t:
		if style == "caixas":
			var n := maxi(1, int(round(r.size.x / r.size.y)))
			var cw := r.size.x / n
			for i in range(n):
				var ch := r.size.y + 6.0
				draw_texture_rect(t, Rect2(r.position.x + i * cw - 4, r.end.y - ch + 4.0, cw + 8, ch), false)
		elif style == "viga":
			draw_texture_rect(t, Rect2(r.position.x - 30, r.position.y - 40, r.size.x + 60, r.size.y + 60), false)
		else:
			draw_texture_rect(t, Rect2(r.position.x - 6, r.position.y - 8, r.size.x + 12, r.size.y + 14), false)
		return
	match style:
		"caixas":
			var n := int(r.size.x / 60.0)
			for i in range(n):
				var cr := Rect2(r.position.x + i * 60.0, r.position.y, 60.0, r.size.y)
				draw_rect(cr, Color(0.36, 0.22, 0.13))
				draw_rect(cr, Color(0.12, 0.07, 0.05), false, 3.0)
				draw_line(cr.position, cr.end, Color(0.22, 0.13, 0.08), 4.0)
		"viga":
			# telhado desabado: telhas escuras em fileiras e viga em brasa embaixo
			draw_rect(r, Color(0.10, 0.07, 0.07))
			var rows := int((r.size.y - 50.0) / 34.0)
			for i in range(rows):
				var y := r.position.y + i * 34.0
				var off := 0.0 if i % 2 == 0 else 22.0
				var x := r.position.x - off
				while x < r.end.x:
					var tx0 := maxf(x, r.position.x)
					var tx1 := minf(x + 44.0, r.end.x)
					draw_rect(Rect2(tx0, y + 2, tx1 - tx0 - 3, 30), Color(0.20, 0.17, 0.19))
					draw_rect(Rect2(tx0, y + 2, tx1 - tx0 - 3, 6), Color(0.30, 0.26, 0.28))
					x += 44.0
			draw_rect(Rect2(r.position.x - 10, r.end.y - 50.0, r.size.x + 20, 40.0), Color(0.28, 0.14, 0.07))
			draw_rect(Rect2(r.position.x - 10, r.end.y - 50.0, r.size.x + 20, 8.0), Color(0.45, 0.25, 0.12))
			var glow := 0.5 + 0.3 * sin(Time.get_ticks_msec() * 0.006)
			draw_rect(Rect2(r.position.x, r.end.y - 14.0, r.size.x, 14.0), Color(1, 0.45, 0.1, glow))
			for i in range(int(r.size.x / 40.0)):
				var fx := r.position.x + 20.0 + i * 40.0
				var fh := 16.0 + 10.0 * sin(Time.get_ticks_msec() * 0.01 + i)
				draw_colored_polygon(PackedVector2Array([Vector2(fx - 10, r.end.y), Vector2(fx, r.end.y + fh), Vector2(fx + 10, r.end.y)]), Color(1, 0.6, 0.15, 0.85))
		"pedra":
			draw_rect(r, Color(0.24, 0.22, 0.25))
			draw_rect(Rect2(r.position, Vector2(r.size.x, 10)), Color(0.3, 0.42, 0.28))
			draw_rect(r, Color(0.1, 0.09, 0.11), false, 4.0)
			draw_line(r.position + Vector2(r.size.x * 0.4, 10), r.position + Vector2(r.size.x * 0.55, r.size.y), Color(0.12, 0.11, 0.13), 3.0)
		"mesa":
			draw_rect(Rect2(r.position + Vector2(10, 20), Vector2(r.size.x - 20, r.size.y - 20)), Color(0.25, 0.08, 0.08))
			draw_rect(Rect2(r.position, Vector2(r.size.x, 26)), Color(0.55, 0.42, 0.15))
			draw_rect(Rect2(r.position + Vector2(-6, 18), Vector2(r.size.x + 12, 30)), Color(0.5, 0.06, 0.1))
			for i in range(3):
				draw_circle(r.position + Vector2(30 + i * (r.size.x - 60) / 2.0, -10), 14, [Color(0.85, 0.3, 0.2), Color(0.9, 0.7, 0.2), Color(0.45, 0.7, 0.25)][i])
		_:
			draw_rect(r, Color(0.2, 0.2, 0.2))

func _draw_door(d: Array) -> void:
	var x: float = d[0]
	var st := _door_state(d)
	var red := Color(0.72, 0.08, 0.1) if st == "aberto" else (Color(0.35, 0.3, 0.3) if st == "breve" else Color(0.45, 0.35, 0.15))
	var h := 300.0
	var tt := prop("torii")
	if tt:
		var mod := Color(1, 1, 1) if st == "aberto" else (Color(0.45, 0.42, 0.45) if st == "breve" else Color(0.85, 0.75, 0.55))
		draw_texture_rect(tt, Rect2(x - 150, GY - 262, 300, 262), false, mod)
		if st == "aberto":
			var g2 := 0.18 + 0.12 * sin(Time.get_ticks_msec() * 0.004)
			draw_rect(Rect2(x - 78, GY - 160, 156, 160), Color(0.9, 0.2, 0.25, g2))
		_door_label(d, x, h, st)
		return
	draw_rect(Rect2(x - 100, GY - h, 22, h), red)
	draw_rect(Rect2(x + 78, GY - h, 22, h), red)
	draw_rect(Rect2(x - 130, GY - h - 30, 260, 26), red)
	draw_rect(Rect2(x - 115, GY - h + 30, 230, 18), red.darkened(0.2))
	draw_rect(Rect2(x - 140, GY - h - 38, 280, 10), Color(0.1, 0.05, 0.05))
	if st == "aberto":
		var g := 0.25 + 0.15 * sin(Time.get_ticks_msec() * 0.004)
		draw_rect(Rect2(x - 78, GY - h + 48, 156, h - 48), Color(0.9, 0.2, 0.25, g))
	elif st == "breve":
		draw_line(Vector2(x - 78, GY - h + 60), Vector2(x + 78, GY - 20), Color(0.5, 0.5, 0.5, 0.8), 4.0)
		draw_line(Vector2(x + 78, GY - h + 60), Vector2(x - 78, GY - 20), Color(0.5, 0.5, 0.5, 0.8), 4.0)
	_door_label(d, x, h, st)

func _door_label(d: Array, x: float, h: float, st: String) -> void:
	var font := Game.FONT_SERIF
	var col := Color(1, 0.9, 0.7) if st == "aberto" else Color(0.75, 0.72, 0.7)
	draw_string_outline(font, Vector2(x - 160, GY - 330), d[2], HORIZONTAL_ALIGNMENT_CENTER, 320, 26, 8, Color(0, 0, 0, 0.9))
	draw_string(font, Vector2(x - 160, GY - 330), d[2], HORIZONTAL_ALIGNMENT_CENTER, 320, 26, col)
	var sub: String = d[3] + ("  ✓" if st == "vencido" else ("  (em breve)" if st == "breve" else ""))
	draw_string_outline(font, Vector2(x - 160, GY - 298), sub, HORIZONTAL_ALIGNMENT_CENTER, 320, 20, 6, Color(0, 0, 0, 0.9))
	draw_string(font, Vector2(x - 160, GY - 298), sub, HORIZONTAL_ALIGNMENT_CENTER, 320, 20, col.darkened(0.1))

# ---------------- ciclo ----------------
func _process(dt: float) -> void:
	_update_bg()
	queue_redraw()
	if _shake > 0.0:
		_shake = maxf(0.0, _shake - 40.0 * dt)
		cam.offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * _shake
	else:
		cam.offset = Vector2.ZERO
	if player == null or frozen or _dead:
		_interact_lbl.visible = false
		return
	var px := player.global_position.x
	if player.is_on_floor() and ground_at(px) < 5000.0:
		_safe_x = px
	if player.global_position.y > GY + 600.0:
		_fell()
	for p in D["prompts"]:
		if not _prompts_done.has(p[1]) and px >= p[0]:
			_prompts_done[p[1]] = true
			banner(p[1])
	for e in D["events"]:
		if not _events_done.has(e[1]) and px >= e[0]:
			_events_done[e[1]] = true
			_event(e[1])
			return
	if D.has("chefe") and boss and not _arena_on and px > arena_x0 + 260.0:
		_start_arena()
	var it = _near_interactable()
	_interact_lbl.visible = it != null
	if it:
		_interact_lbl.text = it["prompt"]
		_interact_lbl.reset_size()
		_interact_lbl.position = it["pos"] - Vector2(_interact_lbl.size.x * 0.5, 0)

func _update_bg() -> void:
	if _bg == null or _bg.texture == null:
		return
	var vs := get_viewport().get_visible_rect().size
	var ts := _bg.texture.get_size()
	var s := maxf(vs.y * 1.08 / ts.y, vs.x * 1.12 / ts.x)
	_bg.scale = Vector2(s, s)
	var w := ts.x * s
	var hgt := ts.y * s
	var cx := cam.get_screen_center_position().x if cam else 0.0
	var f := clampf(cx / maxf(1.0, float(D["largura"])), 0.0, 1.0)
	_bg.position = Vector2(-(w - vs.x) * f, vs.y - hgt + (hgt - vs.y) * 0.25)

func _fell() -> void:
	player.velocity = Vector2.ZERO
	player.guarding = false
	player.take_damage(2, player.global_position.x)
	if player.hp > 0:
		player.global_position = Vector2(_safe_x - 60.0 * player.facing, GY - 4.0)
		player.invuln = 1.2

func shake(a: float) -> void:
	_shake = maxf(_shake, a)

func hitstop(t: float) -> void:
	Engine.time_scale = 0.08
	await get_tree().create_timer(t, true, false, true).timeout
	Engine.time_scale = 1.0

func toast(t: String) -> void:
	_toast.text = t
	_layout_ui()
	var tw := create_tween()
	_toast.modulate.a = 1.0
	tw.tween_interval(1.6)
	tw.tween_property(_toast, "modulate:a", 0.0, 0.5)

func banner(t: String) -> void:
	_banner.text = t
	_layout_ui()
	var tw := create_tween()
	tw.tween_property(_banner, "modulate:a", 1.0, 0.3)
	tw.tween_interval(4.5)
	tw.tween_property(_banner, "modulate:a", 0.0, 0.6)

func _layout_ui() -> void:
	var vs := get_viewport().get_visible_rect().size
	_toast.position = Vector2(0, vs.y * 0.3)
	_toast.size = Vector2(vs.x, 40)
	_banner.position = Vector2(vs.x * 0.18, 64)
	_banner.size = Vector2(vs.x * 0.64, 80)

# ---------------- diálogos e eventos ----------------
func say(id: String, after := Callable()) -> void:
	var LV = load("res://src/levels.gd")
	if OS.get_cmdline_user_args().has("--nodlg"):
		await get_tree().process_frame
		if after.is_valid():
			after.call()
		return
	frozen = true
	player.locked = true
	player.velocity.x = 0.0
	hud.release_all()
	hud.show_controls = false
	dlg.say(LV.D[id])
	await dlg.finished
	await get_tree().create_timer(0.12).timeout
	hud.release_all()
	hud.show_controls = true
	frozen = false
	player.locked = false
	if after.is_valid():
		after.call()

var _gate_glow := 0.0

func _event(id: String) -> void:
	match id:
		"portao":
			_gate_sequence()
		"baku_prologo":
			_baku_prologue()
		"intro_vila":
			if not Game.seen("intro_vila"):
				Game.mark("intro_vila")
				say(id)
		_:
			say(id)

func _on_broken(id: String) -> void:
	match id:
		"luke":
			if Game.seen("luke_salvo"):
				return
			Game.mark("luke_salvo")
			_luke_free = true
			_luke_caged = Vector2.ZERO
			luke.target = player
			Game.sfx("bark", -2.0)
			say("luke")
		"segredo":
			spawn_pickup("vida", Vector2(4100, GY - 90))
			if not Game.seen("segredo"):
				Game.mark("segredo")
				say("segredo")

func _gate_sequence() -> void:
	await say("portao")
	frozen = true
	player.locked = true
	hud.release_all()
	var gx: float = D["portao_x"]
	var tw := create_tween()
	player.spr.set_facing(1)
	player.facing = 1
	player.spr.play_anim("run")
	tw.tween_property(player, "position:x", gx - 330.0, absf(gx - 330.0 - player.position.x) / 400.0)
	await tw.finished
	for i in range(3):
		player.pose("attack")
		Game.sfx("anvil", -2.0)
		Game.sfx("slash3", -6.0)
		shake(6.0 + i * 4.0)
		load("res://src/fxsprite.gd").play(self, "aparo", Vector2(gx - 250.0, GY - 120.0), {"scale_px": 2.0 + i * 0.5})
		await get_tree().create_timer(0.55).timeout
	Game.sfx("impact", 2.0)
	Game.sfx("chains", 0.0)
	Game.flash(Color(1, 0.1, 0.1, 0.9), 1.2)
	shake(22.0)
	create_tween().tween_property(self, "_gate_glow", 1.0, 0.6)
	var cols := [Color(1, 0.2, 0.15), Color(0.7, 0.95, 0.3), Color(0.65, 0.4, 1), Color(0.2, 0.9, 0.6), Color(1, 0.45, 0.75), Color(0.6, 0.3, 0.9), Color(0.95, 0.95, 1)]
	for i in range(7):
		var ang := -PI / 2.0 + (i - 3) * 0.32
		load("res://src/fx.gd").spawn(self, "streak", Vector2(gx, GY - 320.0), {"r": ang, "col": cols[i], "life": 1.6})
		Game.sfx("whisper" if i % 2 == 0 else "power", -10.0)
		await get_tree().create_timer(0.12).timeout
	player.pose("idle")
	await get_tree().create_timer(1.2).timeout
	_baku_prologue()

func _baku_prologue() -> void:
	frozen = true
	player.locked = true
	player.velocity.x = 0.0
	hud.release_all()
	var b = load("res://src/actor_sprite.gd").new()
	b.setup("baku")
	b.position = Vector2(player.global_position.x + 360.0, GY)
	b.set_facing(-1)
	b.play_anim("idle")
	b.modulate = Color(0, 0, 0, 0)
	add_child(b)
	Game.stop_music()
	Game.sfx("impact", 0.0)
	Game.sfx("evil_laugh", -4.0)
	shake(12.0)
	var tw := create_tween()
	tw.tween_property(b, "modulate", Color(1, 1, 1, 1), 1.2)
	await tw.finished
	await say("baku_prologo")
	frozen = true
	player.locked = true
	# Baku avança e corta; Ren não tem chance (prólogo)
	b.play_anim("walk")
	var tw2 := create_tween()
	tw2.tween_property(b, "position:x", player.global_position.x + 170.0, 0.6)
	await tw2.finished
	b.play_anim("slash", true)
	await get_tree().create_timer(0.55).timeout
	Game.sfx("slash3", 2.0)
	Game.sfx("ren_hurt", 0.0)
	shake(18.0)
	Game.flash(Color(0.9, 0.05, 0.1, 0.85), 0.8)
	player.pose("hurt")
	var tw3 := create_tween()
	tw3.tween_property(player, "position:x", player.position.x - 160.0, 0.3)
	tw3.parallel().tween_property(player.spr, "rotation", -1.3, 0.4)
	await get_tree().create_timer(1.6).timeout
	Game.sfx("baku_laugh", -2.0)
	Game.data["cp"] = {}
	Game.advance("ferreiros")

func _start_arena() -> void:
	_arena_on = true
	Game.data["cp"] = {"fase": level_id, "x": arena_x0 + 120.0}
	Game.save()
	cam.limit_left = int(arena_x0)
	cam.limit_right = int(arena_x1)
	# arena inteira na tela: luta concentrada, sem chefe fora de vista
	var vs := get_viewport().get_visible_rect().size
	var z := clampf(vs.x / (arena_x1 - arena_x0), 0.8, 1.0)
	create_tween().tween_property(cam, "zoom", Vector2(z, z), 0.8)
	_arena_walls.append(_static_rect(arena_x0 - 100.0, GY - 3000.0, 100.0, 3000.0, 1))
	Game.stop_music()
	Game.sfx("chains", -2.0)
	hud.boss = boss
	hud.boss_name = boss.display_name
	await say("chefe_" + D["chefe"])
	Game.music("chefe", -7.0)
	boss.start()

func _on_boss_defeated() -> void:
	if _boss_done:
		return
	_boss_done = true
	hud.boss = null
	Game.stop_music()
	Game.sfx("victory", -2.0)
	for f in get_tree().get_nodes_in_group("foes"):
		f.die()
	for s in get_tree().get_nodes_in_group("enemy_shot"):
		s.queue_free()
	await get_tree().create_timer(1.0).timeout
	await say("fim_" + D["chefe"])
	Game.data["vencidos"].append(D["chefe"])
	Game.data["cp"] = {}
	Game.save()
	Game.advance(level_id)

func _on_player_died() -> void:
	_dead = true
	frozen = true
	Game.stop_music()
	Game.sfx("loss", -4.0)
	var l := Game.label("VOCÊ CAIU", 54, Color(0.95, 0.2, 0.25))
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var vs := get_viewport().get_visible_rect().size
	l.position = Vector2(0, vs.y * 0.38)
	l.size = Vector2(vs.x, 70)
	l.modulate.a = 0.0
	_ui.add_child(l)
	create_tween().tween_property(l, "modulate:a", 1.0, 0.6)
	await get_tree().create_timer(2.4).timeout
	Game.goto("level", level_id)

# ---------------- pausa e poderes ----------------
func _cycle_power() -> void:
	if Game.data["poderes"].is_empty() or frozen:
		return
	var p := Game.cycle_power()
	player.apply_outfit()
	Game.sfx("powerup", -6.0)
	Game.flash(Color(Game.POWERS[p]["cor"].r, Game.POWERS[p]["cor"].g, Game.POWERS[p]["cor"].b, 0.35), 0.3)
	load("res://src/fx.gd").spawn(player, "ring", Vector2(0, -70), {"col": Game.POWERS[p]["cor"], "r": 110.0, "life": 0.35})
	toast(Game.POWERS[p]["nome"])

func _toggle_pause() -> void:
	if _pause:
		_pause.queue_free()
		_pause = null
		get_tree().paused = false
		return
	if frozen:
		return
	get_tree().paused = true
	hud.release_all()
	var c := Control.new()
	c.process_mode = Node.PROCESS_MODE_ALWAYS
	c.set_anchors_preset(Control.PRESET_FULL_RECT)
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.6)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	c.add_child(dim)
	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 10)
	c.add_child(vb)
	vb.add_child(Game.label("PAUSA — " + D["nome"], 26, Color(1, 0.9, 0.7)))
	vb.add_child(Game.label(Game.VERSION, 12, Color(1, 1, 1, 0.5), false))
	var inv := "Itens: "
	if Game.data["itens"].is_empty():
		inv += "nenhum"
	else:
		var names := []
		for k in Game.data["itens"]:
			names.append(Game.ITEMS[k]["nome"])
		inv += ", ".join(names)
	var pw := "Poderes: Ren"
	for k in Game.data["poderes"]:
		pw += ", " + Game.POWERS[k]["nome"]
	var info := Game.label(inv + "\n" + pw, 15, Color(0.9, 0.88, 0.85), false)
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.custom_minimum_size = Vector2(420, 0)
	vb.add_child(info)
	vb.add_child(Game.button("CONTINUAR", _toggle_pause))
	if not D.get("hub", false):
		vb.add_child(Game.button("RECOMEÇAR FASE", func():
			get_tree().paused = false
			Game.goto("level", level_id)))
		if Game.data["vencidos"].size() > 0:
			vb.add_child(Game.button("VOLTAR À VILA", func():
				get_tree().paused = false
				Game.data["cp"] = {}
				Game.goto("level", "vila")))
	vb.add_child(Game.button("MENU INICIAL", func():
		get_tree().paused = false
		Game.save()
		Game.goto("title")))
	_ui.add_child(c)
	var vs := get_viewport().get_visible_rect().size
	vb.reset_size()
	vb.position = Vector2((vs.x - 420.0) / 2.0, vs.y * 0.16)
	_pause = c
