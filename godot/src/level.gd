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
	cam.zoom = Vector2(1.2, 1.2)
	cam.position_smoothing_enabled = true
	cam.position_smoothing_speed = 7.0
	cam.limit_left = 0
	cam.limit_right = int(D["largura"])
	cam.limit_bottom = int(GY + 125.0)
	cam.limit_top = int(GY - 2400.0)
	cam.position = Vector2(0, -95)
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
	_build_foreground()
	if D.get("memoria", false):
		_build_memory_filter()
	Game.music(D["musica"], -9.0)
	Game.ambience(D.get("amb", ""), -20.0)
	if D.has("chefe") and not Game.data["vencidos"].has(D["chefe"]):
		_spawn_boss()
	elif D.has("chefe"):
		arena_x0 = D["arena"][0]
		arena_x1 = D["arena"][1]

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
	# fundo um pouco mais escuro que os personagens: eles saltam da tela (leitura)
	_bg.modulate = Color(0.82, 0.8, 0.85)
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
		if Game.seen("quebrado_%s_%s" % [level_id, b[4]]):
			continue
		var br = load("res://src/breakable.gd").new()
		br.kind = b[3]
		br.id = b[4]
		br.size = Vector2(b[1], b[2])
		br.position = Vector2(b[0], GY - (float(b[5]) if b.size() > 5 else 0.0))
		br.level = self
		br.broken.connect(_on_broken)
		add_child(br)

	# arranjos feitos à mão, sorteados a cada visita (variação controlada; chefe nunca varia)
	var foes: Array = D["foes"]
	var arr: Array = D.get("arranjos", [])
	if not arr.is_empty():
		var ua := OS.get_cmdline_user_args()
		var ix := randi() % arr.size()
		if ua.has("--arranjo"):
			ix = int(ua[ua.find("--arranjo") + 1]) % arr.size()
		foes = arr[ix]
	var liberta: bool = D.has("chefe") and Game.data["vencidos"].has(D["chefe"])
	var k := 0
	for f in foes:
		k += 1
		# a zona de emboscada começa vazia: os inimigos dela chegam juntos
		var in_amb := false
		for a in D.get("emboscadas", []):
			if not liberta and float(f[1]) > a["x0"] and float(f[1]) < a["x1"]:
				in_amb = true
		if in_amb:
			continue
		# o mundo reage: sem o demônio, metade das tropas se dispersou
		if liberta and k % 2 == 0:
			continue
		var y: float = GY - (float(f[2]) if f.size() > 2 else 0.0) - 2.0
		var e = spawn_enemy(f[0], f[1], y, f[3] if f.size() > 3 else "")
		if liberta:
			e.hp = maxi(1, e.hp - 1)
			e.hp_max = e.hp
	for pk in D["pickups"]:
		spawn_pickup(pk[2], Vector2(pk[0], GY - pk[1] - 50.0))
	for a in D.get("altares", []):
		_add_altar(a)
	# hub
	for n in D.get("npcs", []):
		_add_npc(n[0], n[1])
	if D.get("hub", false):
		_spawn_refugees()
	for d in D.get("portas", []):
		_add_door(d)
	if level_id == "ferreiros" and not Game.seen("luke_salvo"):
		_setup_prologue()

var _luke_caged := Vector2.ZERO

func spawn_enemy(kind: String, x: float, y: float, variant := "") -> Node:
	var e = load("res://src/enemy.gd").new()
	e.kind = kind
	e.variant = variant
	e.level = self
	e.position = Vector2(x, y)
	add_child(e)
	return e

func spawn_pickup(kind: String, pos: Vector2) -> void:
	if kind == "vida":
		var key := "frag_%s_%d" % [level_id, int(pos.x)]
		if Game.seen(key):
			return
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

var _refugees: Array = []   # [x, textura, flip]
func _spawn_refugees() -> void:
	var R: Dictionary = load("res://src/levels.gd").RESGATE
	var lst: Array = Game.data.get("resgatados", [])
	var xs := [400.0, 530.0, 660.0, 1120.0, 1250.0, 1380.0, 4680.0, 4760.0, 280.0]
	var i := 0
	for key in lst:
		if i >= xs.size():
			break
		var parts := String(key).split(":")
		var info: Dictionary = R.get(parts[0], {})
		var falas: Array = info.get("falas", [])
		var idx := int(parts[1].replace("jaula_", "")) - 1
		var fala: String = falas[idx] if idx >= 0 and idx < falas.size() else "Obrigado, ferreiro."
		var x: float = xs[i]
		# no refúgio eles estão em paz: poses paradas (não correndo)
		var kinds := _ald_list()
		if not kinds.is_empty():
			var v := _villager(kinds[i % kinds.size()], Vector2(x, GY + 2.0), -1 if i % 3 == 0 else 1, "idle")
			if i % 3 == 1:
				# alguns andam devagar pelo acampamento
				var tw := create_tween().set_loops()
				tw.tween_callback(func(): v.play_anim("walk", true, 0.8); v.set_facing(1))
				tw.tween_property(v, "position:x", x + 70.0, 2.2)
				tw.tween_callback(func(): v.play_anim("idle"))
				tw.tween_interval(1.5)
				tw.tween_callback(func(): v.play_anim("walk", true, 0.8); v.set_facing(-1))
				tw.tween_property(v, "position:x", x, 2.2)
				tw.tween_callback(func(): v.play_anim("idle"))
				tw.tween_interval(1.5)
		_interactables.append({"rect": Rect2(x - 70, GY - 170, 140, 170), "prompt": "ATACAR: ouvir", "cb": func(): banner(fala), "pos": Vector2(x, GY - 170)})
		i += 1
	if lst.size() > 0 and int(Game.data.get("refugio_visto", 0)) < lst.size():
		Game.data["refugio_visto"] = lst.size()
		call_deferred("banner", "O refúgio cresce: %d almas libertas." % lst.size())

func _talk_tetsu() -> void:
	var v: Array = Game.data["vencidos"]
	var id := "tetsu_1"
	if not Game.seen("tetsu_1"):
		id = "tetsu_1"
	elif v.has("xui"):
		id = "tetsu_3"
	elif v.has("baku"):
		id = "tetsu_2" if not Game.seen("tetsu_2") else "tetsu_r2"
	else:
		id = "tetsu_r1"
	# já ouviu o essencial? então o mestre conta uma lenda ("perguntar mais")
	if Game.seen(id) and id != "tetsu_1":
		var n := int(Game.data.get("lenda", 0))
		Game.data["lenda"] = n + 1
		id = "tetsu_lenda_%d" % (n % 3 + 1)
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
	if target == "torii" and not Game.seen("tetsu_1"):
		return "selado"
	if target == "palacio" and not Game.data["vencidos"].has("baku"):
		return "selado"
	return "aberto"

func _enter_door(d: Array) -> void:
	match _door_state(d):
		"breve": toast("%s — em breve." % d[2])
		"selado":
			if d[1] == "torii":
				toast("Fala primeiro com o mestre Tetsu.")
			else:
				toast("Este caminho ainda está selado. Derrota Baku primeiro.")
		"vencido":
			Game.sfx("ui_ok")
			frozen = true
			Game.data["cp"] = {}
			Game.save()
			toast("Revisitando %s..." % d[2])
			Game.goto("level", d[1])
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
		draw_texture_rect_region(t, Rect2(x, GY - 3.0, w, th), Rect2(fmod(x, tw) * 0.0, 0, w, th), D.get("tom_chao", Color.WHITE))
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
	var gt := prop("chao_" + D.get("chao_de", level_id))
	_draw_pits()
	_draw_decor()
	for g in D["ground"]:
		var r := Rect2(g[0], GY, g[1] - g[0], 800.0)
		draw_rect(r, fill)
		if gt:
			_draw_ground_fog(g)
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
	_draw_actor_shadows()
	for rf in _refugees:
		var tx: Texture2D = rf[1]
		if tx:
			var hh := 135.0
			var ww := tx.get_width() * 135.0 / float(tx.get_height())
			_shadow(Vector2(rf[0], GY), ww * 0.8)
			draw_texture_rect(tx, Rect2(rf[0] - ww / 2.0, GY - hh + 2.0, ww, hh), false)
	for b in D["blocks"]:
		_draw_block(Rect2(b[0], GY - b[1], b[2], b[3]), b[4])
	var at := prop("altar")
	if at:
		for x in _altares:
			# lanterna de pedra na escala do Ren (~150 px), apoiada no chão
			var ah := 172.0
			var aw := ah * float(at.get_width()) / float(at.get_height())
			_shadow(Vector2(x, GY), aw * 0.9)
			draw_texture_rect(at, Rect2(x - aw / 2.0, GY - ah + 3.0, aw, ah), false)
			draw_circle(Vector2(x, GY - ah * 0.5), 46.0 + 4.0 * sin(Time.get_ticks_msec() * 0.003), Color(1, 0.7, 0.3, 0.08))
	for d in _doors:
		_draw_door(d)
	if D.has("portao_x"):
		var gx: float = D["portao_x"]
		var gtx := prop("portao_aberto" if _gate_open and prop("portao_aberto") else "portao")
		var glow := _gate_glow
		if gtx:
			draw_texture_rect(gtx, Rect2(gx - 300, GY - 600, 600, 610), false)
		else:
			draw_rect(Rect2(gx - 260, GY - 560, 520, 560), Color(0.12, 0.1, 0.1))
			draw_circle(Vector2(gx, GY - 300), 120.0, Color(0.5, 0.35, 0.15))
		if glow > 0.0:
			# brilho só no vão do portão, não na arte inteira
			draw_circle(Vector2(gx, GY - 220), 180.0 * glow, Color(1, 0.85, 0.6, 0.18 * glow))
			draw_rect(Rect2(gx - 90, GY - 420, 180, 420), Color(1, 0.9, 0.7, 0.22 * glow))
	if level_id == "ferreiros":
		_draw_fence()
	_draw_ghosts()
	_draw_amb_walls()

# fachadas, barracas e lanternas: plano do meio, um pouco mais escuras para não confundir com o caminho
func _draw_decor() -> void:
	for d in D.get("decor", []):
		var t := prop(d[0])
		if t == null:
			continue
		var h := float(d[2])
		var w := h * float(t.get_width()) / float(t.get_height())
		var x := float(d[1])
		_shadow(Vector2(x, GY), w * 0.8)
		draw_texture_rect(t, Rect2(x - w / 2.0, GY - h + 4.0, w, h), false, Color(0.78, 0.74, 0.78))

func _shadow(c: Vector2, w: float) -> void:
	var pts := PackedVector2Array()
	for i in range(18):
		var a := TAU * i / 18.0
		pts.append(c + Vector2(cos(a) * w * 0.5, sin(a) * 7.0))
	draw_colored_polygon(pts, Color(0, 0, 0, 0.38))

# sombra sob quem está no chão (Ren, Luke, inimigos)
func _draw_actor_shadows() -> void:
	var list: Array = []
	if player:
		list.append([player, 70.0])
	if luke and is_instance_valid(luke):
		list.append([luke, 52.0])
	for f in get_tree().get_nodes_in_group("foes"):
		if f.get("uses_gravity") and not f.get("dead"):
			list.append([f, float(f.get("w")) * 1.4])
	for it in list:
		var n: Node2D = it[0]
		var p := n.global_position
		# acha o chão logo abaixo (chão principal ou plataforma)
		var fy := GY
		for pl in D["plats"]:
			var py := GY - float(pl[1])
			if p.x >= pl[0] and p.x <= pl[0] + pl[2] and p.y <= py + 4.0 and py - p.y < 260.0:
				fy = py
				break
		var on_ground := false
		for g in D["ground"]:
			if p.x >= g[0] and p.x <= g[1]:
				on_ground = true
		if fy == GY and not on_ground:
			continue
		var h := clampf(fy - p.y, 0.0, 260.0)
		var k := 1.0 - h / 300.0
		_shadow(Vector2(p.x, fy + 1.0), float(it[1]) * k)

# faixa de névoa no pé do cenário: o fundo pintado "desce" até o piso
func _draw_ground_fog(g: Array) -> void:
	var c: Color = D.get("nevoa_chao", Color(0.18, 0.08, 0.14))
	var top := Color(c.r, c.g, c.b, 0.0)
	var mid := Color(c.r, c.g, c.b, 0.3)
	var pts := PackedVector2Array([Vector2(g[0], GY - 70.0), Vector2(g[1], GY - 70.0), Vector2(g[1], GY - 4.0), Vector2(g[0], GY - 4.0)])
	draw_polygon(pts, PackedColorArray([top, top, mid, mid]))

func _draw_block(r: Rect2, style: String) -> void:
	var tex_name: String = {"caixas": "caixa", "viga": "telhado", "pedra": "pedra", "mesa": "mesa"}.get(style, "")
	var t := prop(tex_name) if tex_name != "" else null
	if t:
		# sombra de contato: tudo assenta no chão
		_shadow(Vector2(r.get_center().x, r.end.y), r.size.x * 0.62)
		if style == "caixas":
			# pilhas de caixas lado a lado, sem esticar a arte
			var asp := float(t.get_width()) / float(t.get_height())
			var n := maxi(1, int(round(r.size.x / (r.size.y * asp))))
			var cw := r.size.x / n
			for i in range(n):
				draw_texture_rect(t, Rect2(r.position.x + i * cw, r.position.y + 2.0, cw, r.size.y + 2.0), false)
		elif style == "viga":
			var tl := prop("toldo")
			if tl:
				# toldo em chamas sustentado por dois postes até o chão; passa-se agachado por baixo
				draw_texture_rect(tl, Rect2(r.position.x - 40, r.end.y - 67.5, r.size.x + 80, 180), false)
			else:
				draw_texture_rect(t, Rect2(r.position.x - 30, r.position.y - 40, r.size.x + 60, r.size.y + 60), false)
		elif style == "pedra":
			draw_texture_rect(t, Rect2(r.position.x - 8, r.position.y - 6, r.size.x + 16, r.size.y + 10), false)
		else:
			draw_texture_rect(t, Rect2(r.position.x - 6, r.position.y - 8, r.size.x + 12, r.size.y + 12), false)
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
		var mod := Color(1, 1, 1) if st == "aberto" else (Color(0.45, 0.42, 0.45) if st in ["breve", "selado"] else Color(0.85, 0.75, 0.55))
		# torii em escala real: ~2,4× a altura do Ren
		draw_texture_rect(tt, Rect2(x - 206, GY - 360, 412, 360), false, mod)
		if st == "aberto":
			var g2 := 0.18 + 0.12 * sin(Time.get_ticks_msec() * 0.004)
			draw_rect(Rect2(x - 106, GY - 220, 212, 220), Color(0.9, 0.2, 0.25, g2))
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
	draw_string_outline(font, Vector2(x - 160, GY - 196), d[2], HORIZONTAL_ALIGNMENT_CENTER, 320, 26, 8, Color(0, 0, 0, 0.9))
	draw_string(font, Vector2(x - 160, GY - 196), d[2], HORIZONTAL_ALIGNMENT_CENTER, 320, 26, col)
	var sub: String = d[3] + ("  ✓" if st == "vencido" else ("  (em breve)" if st == "breve" else ("  (selado)" if st == "selado" else "")))
	draw_string_outline(font, Vector2(x - 160, GY - 166), sub, HORIZONTAL_ALIGNMENT_CENTER, 320, 20, 6, Color(0, 0, 0, 0.9))
	draw_string(font, Vector2(x - 160, GY - 166), sub, HORIZONTAL_ALIGNMENT_CENTER, 320, 20, col.darkened(0.1))

# ---------------- ciclo ----------------
func _process(dt: float) -> void:
	_update_bg()
	queue_redraw()
	if _shake > 0.0:
		_shake = maxf(0.0, _shake - 40.0 * dt)
		cam.offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * _shake
	else:
		cam.offset = Vector2.ZERO
	_update_tension(dt)
	if player == null or frozen or _dead:
		_interact_lbl.visible = false
		return
	var px := player.global_position.x
	_check_ambush(px)
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
	elif D.has("chefe") and boss == null and not _arena_on and px > arena_x0 + 260.0:
		_arena_on = true
		_leave_free_land()
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
	var cx := cam.get_screen_center_position().x if cam else 0.0
	var f := clampf(cx / maxf(1.0, float(D["largura"])), 0.0, 1.0)
	if D.has("bg_chao"):
		# o chão pintado no fundo fica exatamente na linha do chão jogável (mesmo ambiente)
		var gy_screen: float = (get_viewport().get_canvas_transform() * Vector2(0, GY)).y
		var fr: float = D["bg_chao"]
		var s2 := maxf(vs.x * 1.12 / ts.x, (gy_screen + 4.0) / (ts.y * fr))
		_bg.scale = Vector2(s2, s2)
		_bg.position = Vector2(-(ts.x * s2 - vs.x) * f, gy_screen - ts.y * fr * s2)
		return
	var s := maxf(vs.y * 1.08 / ts.y, vs.x * 1.12 / ts.x)
	_bg.scale = Vector2(s, s)
	var w := ts.x * s
	var hgt := ts.y * s
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
var _gate_open := false
var no_death := false
var _fence_wall: StaticBody2D
var _fence_broken := false
var _cao_wall: StaticBody2D
var _cao_guard: Node

func _event(id: String) -> void:
	match id:
		"intro_ferreiros":
			_intro_prologue()
		"cao":
			_cao_scene()
		"portao":
			_gate_sequence()
		"memoria_1", "memoria_2", "memoria_3":
			_whisper(id)
		"memoria_porta":
			_memory_gate()
		"intro_vila":
			if not Game.seen("intro_vila"):
				Game.mark("intro_vila")
				say(id)
			elif Game.data["poderes"].has("carmesim") and not Game.seen("tetsu_carmesim"):
				# a origem da Forma Carmesim, contada pelo mestre na volta ao Refúgio
				Game.mark("tetsu_carmesim")
				Game.save()
				say("tetsu_carmesim")
		_:
			if id.begins_with("intro_"):
				if Game.seen(id):
					return
				Game.mark(id)
			say(id)

func _on_broken(id: String) -> void:
	Game.mark("quebrado_%s_%s" % [level_id, id])
	Game.save()
	match id:
		"segredo":
			spawn_pickup("vida", Vector2(4100, GY - 90))
			say("segredo")
		"nevoa":
			say("segredo_nevoa")
		"selo_carmesim":
			say("segredo_selo")
		_:
			if id.begins_with("jaula"):
				_free_prisoner(id)
			elif id.begins_with("caixa"):
				for b in D["breakables"]:
					if b[4] == id and randf() < 0.55:
						spawn_pickup(["cura", "ki", "cura"][randi() % 3], Vector2(float(b[0]) + float(b[1]) / 2.0, GY - 60.0))

# ---------------- prisioneiros: a história contada jogando ----------------
func _free_prisoner(id: String) -> void:
	var R: Dictionary = load("res://src/levels.gd").RESGATE.get(level_id, {})
	var key := "%s:%s" % [level_id, id]
	var lst: Array = Game.data.get("resgatados", [])
	if not lst.has(key):
		lst.append(key)
	Game.data["resgatados"] = lst
	Game.save()
	var br_x := 0.0
	for b in D["breakables"]:
		if b[4] == id:
			br_x = float(b[0]) + float(b[1]) / 2.0
	Game.sfx("sino", -10.0, 0.05)
	load("res://src/fx.gd").spawn(self, "ring", Vector2(br_x, GY - 70), {"col": Color(1, 0.85, 0.5), "r": 90.0, "life": 0.5})
	# o liberto agradece e corre de volta pelo caminho seguro
	var kinds := _ald_list()
	if not kinds.is_empty():
		var v := _villager(kinds[randi() % kinds.size()], Vector2(br_x, GY + 2.0), -1, "idle")
		var tw := create_tween()
		tw.tween_interval(1.0)
		tw.tween_callback(func(): v.play_anim("walk", true, 1.9))
		tw.tween_property(v, "position:x", v.position.x - 560.0, 1.8)
		tw.parallel().tween_property(v, "modulate:a", 0.0, 1.8).set_delay(0.8)
		tw.tween_callback(v.queue_free)
	var n := 0
	for k in lst:
		if String(k).begins_with(level_id + ":"):
			n += 1
	if R.has("grito"):
		load("res://src/fx.gd").spawn(self, "text", Vector2(br_x, GY - 210), {"txt": "Obrigado, ferreiro!", "col": Color(1, 0.92, 0.75), "life": 1.4})
	banner("Libertos nesta terra: %d/3 — eles esperarão no refúgio." % n)

# ---------------- prólogo: cerca, o cão sem dono e o soldado ----------------
func _setup_prologue() -> void:
	# Ren preso no cercado da praça; o cão late do lado de fora
	_fence_wall = _static_rect(400.0, GY - 600.0, 30.0, 600.0, 1)
	_spawn_luke(Vector2(560.0, GY))
	luke.set_skin("luke_rua")
	luke.target = null
	luke.spr.set_facing(-1)
	# soldado que maltrata o cão (só age depois da cena)
	_cao_guard = spawn_enemy("guarda", 2620.0, GY - 2.0)
	_cao_guard.set("hold", true)
	_cao_guard.facing = -1
	_cao_wall = _static_rect(2900.0, GY - 600.0, 30.0, 600.0, 1)

func _draw_fence() -> void:
	if Game.seen("luke_salvo") and not _fence_wall:
		return
	var x0 := 40.0
	var x1 := 420.0
	var x := x0
	var i := 0
	while x <= x1:
		var broken := _fence_broken and x > 360.0
		if not broken:
			var hgt := 190.0 + float((i * 37) % 30)
			draw_rect(Rect2(x, GY - hgt, 14, hgt), Color(0.28, 0.18, 0.11))
			draw_rect(Rect2(x + 2, GY - hgt, 4, hgt), Color(0.4, 0.27, 0.16))
			draw_colored_polygon(PackedVector2Array([Vector2(x, GY - hgt), Vector2(x + 7, GY - hgt - 14), Vector2(x + 14, GY - hgt)]), Color(0.28, 0.18, 0.11))
		x += 34.0
		i += 1
	var rail_end := 360.0 if _fence_broken else x1
	draw_rect(Rect2(x0, GY - 150, rail_end - x0 + 14, 10), Color(0.22, 0.14, 0.09))
	draw_rect(Rect2(x0, GY - 70, rail_end - x0 + 14, 10), Color(0.22, 0.14, 0.09))

func _intro_prologue() -> void:
	if Game.seen("luke_salvo"):
		return
	Game.sfx("bark", -4.0)
	await say("intro_ferreiros")
	frozen = true
	player.locked = true
	player.spr.set_facing(1)
	player.facing = 1
	player.pose("attack")
	await get_tree().create_timer(0.25).timeout
	player.pose("idle")
	Game.sfx("break", 0.0)
	shake(8.0)
	_fence_broken = true
	if _fence_wall:
		_fence_wall.queue_free()
		_fence_wall = null
	for k in range(4):
		load("res://src/fx.gd").spawn(self, "dust", Vector2(400.0 + randf_range(-20, 20), GY - randf_range(20, 150)), {"r": 60.0, "life": 0.5})
	# o cão corre na frente, mostrando o caminho
	Game.sfx("bark", -6.0)
	luke.spr.set_facing(1)
	luke.spr.play_anim("run")
	var tw := create_tween()
	tw.tween_property(luke, "position:x", 2440.0, 3.2)
	tw.tween_callback(func():
		luke.spr.play_anim("idle")
		luke.spr.set_facing(1))
	await get_tree().create_timer(0.4).timeout
	frozen = false
	player.locked = false
	banner("Siga o cão.")

func _cao_scene() -> void:
	if Game.seen("luke_salvo") or _cao_guard == null or not is_instance_valid(_cao_guard):
		return
	frozen = true
	player.locked = true
	hud.release_all()
	player.velocity.x = 0.0
	luke.position.x = 2440.0
	luke.spr.set_facing(1)
	# o soldado maltrata o cão
	for k in range(3):
		_cao_guard.spr.play_anim("attack", true, 1.2)
		await get_tree().create_timer(0.35).timeout
		Game.sfx("hit1", -4.0)
		# Luke não reage: ele gane e chora como um filhote
		Game.sfx_remote("ganido", 2.0, "bark")
		load("res://src/fxsprite.gd").play(self, "acerto", luke.position + Vector2(10, -40), {"scale_px": 1.6})
		var tw := create_tween()
		tw.tween_property(luke, "position:x", luke.position.x - 40.0, 0.15)
		luke.spr.modulate = Color(1, 0.5, 0.5)
		await get_tree().create_timer(0.35).timeout
		luke.spr.modulate = Color.WHITE
	_cao_guard.spr.play_anim("walk")
	luke.spr.modulate = Color(0.85, 0.85, 0.9)
	Game.sfx_remote("choro", 0.0, "")
	await say("cao")
	luke.spr.modulate = Color.WHITE
	_cao_guard.set("hold", false)
	_cao_guard.connect("defeated", _amizade)
	banner("Derrote o soldado!")

func _amizade() -> void:
	await get_tree().create_timer(0.6).timeout
	frozen = true
	player.locked = true
	hud.release_all()
	# Ren se aproxima do cão
	player.pose("run")
	var dx := luke.position.x - 110.0
	player.spr.set_facing(1 if dx > player.position.x else -1)
	var tw := create_tween()
	tw.tween_property(player, "position:x", dx, absf(dx - player.position.x) / 380.0 + 0.05)
	await tw.finished
	player.spr.set_facing(1)
	player.facing = 1
	player.pose("crouch")
	luke.spr.set_facing(-1)
	Game.music("vila", -12.0)
	await say("amizade_1")
	frozen = true
	player.locked = true
	# Ren tira um pedaço da faixa e amarra no pescoço do cão
	Game.sfx("pickup", -4.0)
	load("res://src/fxsprite.gd").play(self, "aparo", luke.position + Vector2(0, -50), {"scale_px": 1.4, "tint": Color(1, 0.6, 0.6)})
	await get_tree().create_timer(0.4).timeout
	luke.set_skin("luke")
	luke.spr.set_facing(-1)
	load("res://src/fx.gd").spawn(self, "ring", luke.position + Vector2(0, -40), {"col": Color(0.95, 0.2, 0.25), "r": 70.0, "life": 0.5})
	Game.mark("luke_salvo")
	await say("amizade_2")
	Game.music(D["musica"], -9.0)
	player.pose("idle")
	luke.target = player
	_luke_free = true
	if _cao_wall:
		_cao_wall.queue_free()
		_cao_wall = null
	Game.save()

# ---------------- o Grande Portão ----------------
func _gate_sequence() -> void:
	await say("portao")
	frozen = true
	player.locked = true
	hud.release_all()
	var gx: float = D["portao_x"]
	var tw := create_tween()
	player.spr.set_facing(1)
	player.facing = 1
	player.pose("run")
	tw.tween_property(player, "position:x", gx - 330.0, absf(gx - 330.0 - player.position.x) / 400.0)
	await tw.finished
	for i in range(3):
		player.pose(["attack", "rising", "finisher"][i])
		Game.sfx("anvil", -2.0)
		Game.sfx("slash3", -6.0)
		shake(6.0 + i * 4.0)
		load("res://src/fxsprite.gd").play(self, "aparo", Vector2(gx - 250.0, GY - 120.0), {"scale_px": 2.0 + i * 0.5})
		await get_tree().create_timer(0.55).timeout
	# o eixo-mestre se parte e as portas se abrem
	Game.sfx("impact", 2.0)
	Game.sfx("chains", 0.0)
	Game.flash(Color(1, 0.95, 0.8, 0.9), 1.0)
	shake(22.0)
	_gate_open = true
	create_tween().tween_property(self, "_gate_glow", 1.0, 0.6)
	for k in range(6):
		load("res://src/fx.gd").spawn(self, "dust", Vector2(gx + randf_range(-200, 200), GY - randf_range(0, 400)), {"r": 90.0, "life": 0.8})
	player.pose("idle")
	await get_tree().create_timer(0.8).timeout
	# o povo foge pelos portões
	_villagers_flee(gx)
	await get_tree().create_timer(2.2).timeout
	# os selos se rompem: sete rastros de luz
	var cols := [Color(1, 0.2, 0.15), Color(0.7, 0.95, 0.3), Color(0.65, 0.4, 1), Color(0.2, 0.9, 0.6), Color(1, 0.45, 0.75), Color(0.6, 0.3, 0.9), Color(0.95, 0.95, 1)]
	for i in range(7):
		var ang := -PI / 2.0 + (i - 3) * 0.32
		load("res://src/fx.gd").spawn(self, "streak", Vector2(gx, GY - 520.0), {"r": ang, "col": cols[i], "life": 1.6})
		Game.sfx("whisper" if i % 2 == 0 else "power", -12.0)
		await get_tree().create_timer(0.12).timeout
	await get_tree().create_timer(0.8).timeout
	_baku_prologue()

func _villagers_flee(gx: float) -> void:
	# o povo foge correndo pelo portão: aldeões no estilo do Ren, com passos de verdade
	var kinds := _ald_list()
	if kinds.is_empty():
		return
	kinds.shuffle()
	for i in range(22):
		var kind: String = kinds[i % kinds.size()]
		var v := _villager(kind, Vector2(gx - 900.0 - i * 58.0 + randf_range(-30, 30), GY + 2.0), 1, "walk", randf_range(1.9, 2.3))
		v.z_index = -1 if i % 3 == 0 else 2
		v.modulate = Color(0.88, 0.84, 0.84)
		var sp := randf_range(330.0, 430.0)
		var dur := (gx - v.position.x) / sp
		var tw := create_tween()
		tw.tween_interval(i * 0.12)
		tw.tween_property(v, "position:x", gx + randf_range(-40, 40), dur)
		tw.tween_property(v, "modulate:a", 0.0, 0.4)
		tw.tween_callback(v.queue_free)
	Game.sfx("step1", -6.0)

# ---------------- Forma Carmesim (fim da fase 2, DEC-020 / T-018) ----------------
var _carm_done := false

func carmesim_awaken() -> void:
	# A crise: a marca do peito (o sacrifício roubado de Arashi) bebe a energia do demônio
	# e transborda. Ren passa mal, Xui reconhece a oferenda, e o vermelho explode.
	if _carm_done or player == null or player.state == "dead":
		return
	_carm_done = true
	frozen = true
	player.locked = true
	player.velocity.x = 0.0
	hud.release_all()
	var ui_red := ColorRect.new()
	ui_red.color = Color(0.5, 0.0, 0.03, 0.0)
	ui_red.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui_red.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ui.add_child(ui_red)
	var veias = load("res://src/veias_fx.gd").new()
	player.add_child(veias)
	var z0 := cam.zoom
	create_tween().tween_property(cam, "zoom", z0 * 1.28, 1.6).set_trans(Tween.TRANS_SINE)
	# 1) dor no peito: mão na marca, o corpo curva (batidas cada vez mais rápidas)
	player.pose("hurt")
	Game.sfx("ren_hurt", -2.0)
	var gaps := [0.75, 0.6, 0.48, 0.38]
	for k in range(gaps.size()):
		Game.sfx("coracao", 2.0 + k)
		veias.power = 0.2 + k * 0.18
		shake(3.0 + k * 2.0)
		var tw := create_tween()
		tw.tween_property(ui_red, "color:a", 0.18 + k * 0.05, 0.08)
		tw.tween_property(ui_red, "color:a", 0.05 + k * 0.03, 0.3)
		if k == 1:
			player.pose("tired")
			Game.sfx("whisper", 0.0)
		await get_tree().create_timer(gaps[k]).timeout
	# 2) cai de joelhos; o demônio reconhece o que há dentro dele
	player.pose("crouch")
	Game.sfx("ren_effort", -4.0)
	await say("carmesim_desperta")
	# 3) a explosão: grito, coluna vermelha, onda
	veias.power = 1.0
	for k in range(3):
		Game.sfx("coracao", 6.0)
		shake(6.0 + k * 3.0)
		load("res://src/fx.gd").spawn(self, "ring", player.position + Vector2(0, -90), {"col": Color(1, 0.1, 0.15), "r": 70.0 + k * 50.0, "life": 0.4})
		await get_tree().create_timer(0.22).timeout
	Game.sfx("ren_effort", 4.0)
	Game.sfx("impact", 2.0)
	Game.sfx("hit_big", 0.0)
	Game.flash(Color(1, 0.12, 0.08, 0.9), 0.5)
	player.set_carmesim(true, -1.0)
	player.pose("idle")
	veias.queue_free()
	_carm_pillar()
	shake(20.0)
	banner("FORMA CARMESIM")
	var t2 := create_tween()
	t2.tween_property(cam, "zoom", z0, 0.5)
	t2.parallel().tween_property(ui_red, "color:a", 0.0, 0.8)
	await get_tree().create_timer(0.7).timeout
	ui_red.queue_free()
	await say("carmesim_desperta_2")
	player.pose("idle")
	frozen = false
	player.locked = false

# coluna de energia vermelha subindo do Ren + brasas
func _carm_pillar() -> void:
	var p := CPUParticles2D.new()
	p.one_shot = true
	p.emitting = true
	p.amount = 90
	p.lifetime = 1.1
	p.explosiveness = 0.85
	p.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	p.emission_rect_extents = Vector2(40, 10)
	p.direction = Vector2(0, -1)
	p.spread = 12.0
	p.initial_velocity_min = 500.0
	p.initial_velocity_max = 1100.0
	p.gravity = Vector2(0, 300)
	p.scale_amount_min = 4.0
	p.scale_amount_max = 9.0
	var g := Gradient.new()
	g.set_color(0, Color(1, 0.85, 0.7, 1))
	g.set_color(1, Color(0.8, 0.0, 0.05, 0))
	p.color_ramp = g
	p.position = player.position
	p.z_index = 20
	add_child(p)
	get_tree().create_timer(1.6).timeout.connect(p.queue_free)
	for k in range(3):
		load("res://src/fx.gd").spawn(self, "ring", player.position + Vector2(0, -80), {"col": Color(1, 0.2, 0.15), "r": 160.0 + k * 90.0, "life": 0.5 + k * 0.1})

func _carmesim_calm() -> void:
	frozen = true
	player.locked = true
	player.velocity.x = 0.0
	hud.release_all()
	if luke == null or not is_instance_valid(luke):
		player.set_carmesim(false)
		return
	luke.target = null
	# Ren caminha, possuído, para o centro da arena (fica sempre em quadro)
	var mid := (arena_x0 + arena_x1) * 0.5 if arena_x1 > arena_x0 else player.position.x
	var dir := signf(mid - player.position.x)
	if dir == 0.0:
		dir = 1.0
	var dest := player.position.x + dir * minf(absf(mid - player.position.x), 260.0)
	player.facing = int(dir)
	player.spr.set_facing(player.facing)
	Game.sfx("whisper", 2.0)
	shake(6.0)
	player.pose("run")
	player.spr.speed_scale = 0.45
	var tw := create_tween()
	tw.tween_property(player, "position:x", dest, 1.2)
	await tw.finished
	player.pose("idle")
	await say("carmesim_calma_1")
	frozen = true
	player.locked = true
	var side := signf(luke.position.x - player.position.x)
	if side == 0.0:
		side = dir
	player.facing = int(side)
	player.spr.set_facing(player.facing)
	luke.spr.set_facing(-int(side))
	luke.spr.play_anim("run")
	var tw2 := create_tween()
	tw2.tween_property(luke, "position:x", player.position.x + side * 80.0, 0.45)
	await tw2.finished
	luke.spr.play_anim("idle")
	Game.sfx("bark", 0.0)
	await get_tree().create_timer(0.4).timeout
	Game.sfx("absorb", 0.0)
	for k in range(3):
		load("res://src/fx.gd").spawn(self, "ring", luke.position + Vector2(0, -40), {"col": Color(0.6, 1, 0.8), "r": 160.0 + k * 90.0, "life": 0.8})
		await get_tree().create_timer(0.15).timeout
	player.set_carmesim(false)
	player.pose("crouch")
	await get_tree().create_timer(0.9).timeout
	await say("carmesim_calma_2")
	player.pose("idle")
	luke.target = player
	if not Game.data["poderes"].has("carmesim"):
		Game.data["poderes"].append("carmesim")
		Game.save()
	banner("Nova habilidade: Forma Carmesim (ki cheio)")
	await get_tree().create_timer(1.4).timeout

# ---------------- Baku reivindica as oferendas ----------------
func _baku_prologue() -> void:
	frozen = true
	player.locked = true
	player.velocity.x = 0.0
	hud.release_all()
	Game.stop_music()
	Game.sfx("impact", 0.0)
	Game.sfx("evil_laugh", -4.0)
	shake(12.0)
	var gx: float = D["portao_x"]
	arena_x0 = gx - 1000.0
	arena_x1 = gx - 120.0
	var b = load("res://src/boss_baku.gd").new()
	b.level = self
	b.facing = -1
	b.set("prologo", true)
	b.position = Vector2(player.global_position.x + 380.0, GY - 2.0)
	b.modulate = Color(0, 0, 0, 0)
	add_child(b)
	boss = b
	var tw := create_tween()
	tw.tween_property(b, "modulate", Color(1, 1, 1, 1), 1.2)
	await tw.finished
	await say("baku_prologo")
	# luta impossível: Ren resiste, mas não vence
	_arena_walls.append(_static_rect(arena_x0 - 100.0, GY - 3000.0, 100.0, 3000.0, 1))
	_arena_walls.append(_static_rect(arena_x1, GY - 3000.0, 100.0, 3000.0, 1))
	no_death = true
	hud.boss = b
	hud.boss_name = "BAKU — a Ira"
	Game.music("chefe", -7.0)
	banner("Resista!")
	b.start()
	var t := 0.0
	while t < 14.0 and player.hp > 3:
		await get_tree().create_timer(0.25).timeout
		t += 0.25
	# Baku derruba Ren
	frozen = true
	player.locked = true
	hud.release_all()
	hud.boss = null
	b.set_physics_process(false)
	b.spr.material = null
	b.telegraph_t = 0.0
	b.face_player()
	b.spr.play_anim("slash", true, 1.3)
	await get_tree().create_timer(0.45).timeout
	Game.sfx("slash3", 2.0)
	Game.sfx("ren_hurt", 0.0)
	shake(18.0)
	Game.flash(Color(0.9, 0.05, 0.1, 0.85), 0.8)
	player.facing = 1 if b.position.x > player.position.x else -1
	player.spr.set_facing(player.facing)
	player.pose("fall")
	player.set("state", "dead")
	var tw3 := create_tween()
	tw3.tween_property(player, "position:x", player.position.x - 90.0 * player.facing, 0.35)
	Game.stop_music()
	await get_tree().create_timer(1.0).timeout
	# Baku avança para o golpe final... e o cão se põe na frente
	b.spr.play_anim("walk")
	var tw4 := create_tween()
	tw4.tween_property(b, "position:x", player.position.x + 220.0 * signf(b.position.x - player.position.x), 1.0)
	luke.target = null
	luke.spr.play_anim("run")
	var tw5 := create_tween()
	tw5.tween_property(luke, "position:x", player.position.x + 90.0 * signf(b.position.x - player.position.x), 0.6)
	await tw4.finished
	luke.spr.play_anim("idle")
	luke.spr.set_facing(1 if b.position.x > luke.position.x else -1)
	Game.sfx("bark", 0.0)
	await get_tree().create_timer(0.5).timeout
	# o pingente brilha
	Game.sfx("power", 0.0)
	Game.sfx("absorb", 0.0)
	for k in range(3):
		load("res://src/fx.gd").spawn(self, "ring", luke.position + Vector2(0, -40), {"col": Color(0.6, 1, 0.8), "r": 300.0 + k * 140.0, "life": 0.9})
		await get_tree().create_timer(0.15).timeout
	Game.flash(Color(0.85, 1, 0.9, 0.95), 1.4)
	shake(14.0)
	b.spr.play_anim("tired")
	var tw6 := create_tween()
	tw6.tween_property(b, "position:x", b.position.x + 180.0 * signf(b.position.x - luke.position.x), 0.5)
	await get_tree().create_timer(0.8).timeout
	await say("baku_luz")
	frozen = true
	player.locked = true
	var tw7 := create_tween()
	tw7.tween_property(b, "modulate", Color(0, 0, 0, 0), 1.4)
	Game.sfx("baku_laugh", -6.0)
	await get_tree().create_timer(1.6).timeout
	no_death = false
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
	var z := clampf(vs.x / (arena_x1 - arena_x0), 0.85, 1.2)
	create_tween().tween_property(cam, "zoom", Vector2(z, z), 0.8)
	_arena_walls.append(_static_rect(arena_x0 - 100.0, GY - 3000.0, 100.0, 3000.0, 1))
	# respiro antes da tempestade: a música some, só o vento e as correntes
	Game.stop_music()
	Game.sfx("chains", -2.0)
	hud.boss = boss
	hud.boss_name = boss.display_name
	var ch: String = D["chefe"]
	var mortes: Dictionary = Game.data.get("mortes", {})
	var n_mortes := int(mortes.get(ch, 0))
	if not Game.seen("chefe_" + ch):
		frozen = true
		player.locked = true
		await get_tree().create_timer(1.4).timeout
		Game.sfx("impact", 0.0)
		Game.sfx("boss_effort", -2.0)
		shake(10.0)
		Game.mark("chefe_" + ch)
		await say("chefe_" + ch)
		frozen = false
		player.locked = false
	else:
		# recomeço rápido: sem repetir a conversa
		banner(boss.display_name)
		Game.sfx("impact", -2.0)
		await get_tree().create_timer(0.7).timeout
	if n_mortes >= 3 and n_mortes % 3 == 0 and LV_D().has("dica_" + ch):
		await say("dica_" + ch)
	Game.music("chefe", -7.0)
	boss.start()

func LV_D() -> Dictionary:
	return load("res://src/levels.gd").D

# terra já libertada: a arena está vazia; volta ao refúgio
func _leave_free_land() -> void:
	frozen = true
	player.locked = true
	banner("%s respira em paz... por ora." % D["nome"].split("— ")[-1])
	Game.sfx("victory", -10.0)
	await get_tree().create_timer(2.2).timeout
	Game.data["cp"] = {}
	Game.save()
	Game.goto("level", "vila")

# Luke late antes do golpe mais perigoso do chefe (sinal extra de leitura no celular)
func luke_alert() -> void:
	if luke == null or not is_instance_valid(luke):
		return
	Game.sfx("bark", -4.0)
	load("res://src/fx.gd").spawn(self, "text", luke.position + Vector2(0, -95), {"txt": "!", "col": Color(1, 0.85, 0.3), "life": 0.6})

# ---------------- altares de descanso ----------------
var _altar_tex: Texture2D
func _add_altar(x: float) -> void:
	var done := {"v": false}
	_interactables.append({"rect": Rect2(x - 120, GY - 220, 240, 220), "prompt": "ATACAR: descansar na lanterna", "cb": func(): _rest_at_altar(x, done), "pos": Vector2(x, GY - 210)})
	_altares.append(x)

var _altares: Array = []

func _rest_at_altar(x: float, done: Dictionary) -> void:
	Game.data["cp"] = {"fase": level_id, "x": x}
	Game.save()
	player.heal(99)
	Game.sfx("sino", -6.0, 0.0)
	load("res://src/fx.gd").spawn(self, "ring", Vector2(x, GY - 80), {"col": Color(1, 0.85, 0.5), "r": 120.0, "life": 0.6})
	if not done["v"]:
		done["v"] = true
		banner("Lanterna de descanso — a jornada foi gravada.")
	else:
		toast("Vigor restaurado.")

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
	if player.carmesim:
		await _carmesim_calm()
	await say("fim_" + D["chefe"])
	await _sussurro(D["chefe"])
	Game.data["vencidos"].append(D["chefe"])
	Game.data["cp"] = {}
	Game.save()
	Game.advance(level_id)

func _on_player_died() -> void:
	_dead = true
	frozen = true
	if _arena_on and D.has("chefe"):
		var m: Dictionary = Game.data.get("mortes", {})
		m[D["chefe"]] = int(m.get(D["chefe"], 0)) + 1
		Game.data["mortes"] = m
		Game.save()
	Game.stop_music()
	Game.sfx("loss", -4.0)
	var l := Game.label("VOCÊ CAIU", 54, Color(0.95, 0.2, 0.25))
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var vs := get_viewport().get_visible_rect().size
	l.position = Vector2(0, vs.y * 0.38)
	l.size = Vector2(vs.x, 70)
	l.modulate.a = 0.0
	_ui.add_child(l)
	create_tween().tween_property(l, "modulate:a", 1.0, 0.3)
	await get_tree().create_timer(0.9).timeout
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


# ================= v0.13 (DEC-026): profundidade, música que reage, emboscadas, sussurros, memória =================
func _build_foreground() -> void:
	var fg = load("res://src/foreground.gd").new()
	fg.level = self
	fg.GY = GY
	fg.largura = float(D["largura"])
	fg.theme = level_id if level_id in ["torii", "palacio", "vila"] else "ferreiros"
	add_child(fg)

func _exit_tree() -> void:
	Game.music_tension(1.0)

var _tension := 1.0
var _tension_want := 1.0
var _tension_scan := 0.0
func _update_tension(dt: float) -> void:
	_tension_scan -= dt
	if _tension_scan <= 0.0 and player:
		_tension_scan = 0.25
		var want := 0.0
		if D.get("hub", false) or D.get("memoria", false) or _arena_on or _amb_on:
			want = 1.0
		else:
			for f in get_tree().get_nodes_in_group("foes"):
				if f.get("dead"):
					continue
				var dv: Vector2 = f.global_position - player.global_position
				if absf(dv.x) < 760.0 and absf(dv.y) < 520.0:
					want = 1.0
					break
		_tension_want = want
	# abre rápido quando o perigo chega; abafa devagar quando passa
	_tension = move_toward(_tension, _tension_want, dt * (1.6 if _tension_want > _tension else 0.3))
	Game.music_tension(_tension)

# ---- emboscadas: pico de tensão no meio da fase (paredes de selo, ondas, depois respiro) ----
var _amb_on := false
var _amb_done := {}
var _amb_cur: Dictionary
var _amb_wave := 0
var _amb_foes: Array = []
var _amb_walls: Array = []
var _amb_x := Vector2.ZERO

func _check_ambush(px: float) -> void:
	if _amb_on or (D.has("chefe") and Game.data["vencidos"].has(D["chefe"])):
		return
	for a in D.get("emboscadas", []):
		if _amb_done.has(a["x"]):
			continue
		if px >= a["x"] and px < a["x1"]:
			_start_ambush(a)
			return

func _start_ambush(a: Dictionary) -> void:
	_amb_on = true
	_amb_done[a["x"]] = true
	_amb_cur = a
	_amb_wave = 0
	_amb_x = Vector2(a["x0"], a["x1"])
	_amb_walls.append(_static_rect(a["x0"] - 100.0, GY - 3000.0, 100.0, 3000.0, 1))
	_amb_walls.append(_static_rect(a["x1"], GY - 3000.0, 100.0, 3000.0, 1))
	_amb_drop = Time.get_ticks_msec() / 1000.0
	get_tree().create_timer(0.35).timeout.connect(func():
		for xx in [a["x0"], a["x1"]]:
			for k in range(4):
				load("res://src/fx.gd").spawn(self, "dust", Vector2(xx + randf_range(-50, 50), GY - 20.0), {"r": 80.0, "life": 0.6})
		Game.sfx("slam", -2.0)
		shake(10.0))
	banner("EMBOSCADA!")
	Game.sfx("impact", -2.0)
	Game.sfx("chains", -6.0)
	shake(8.0)
	luke_alert()
	await get_tree().create_timer(0.5).timeout
	_next_wave()

func _next_wave() -> void:
	var ondas: Array = _amb_cur["ondas"]
	if _amb_wave >= ondas.size():
		_end_ambush()
		return
	_amb_foes = []
	for f in ondas[_amb_wave]:
		var y: float = GY - (float(f[2]) if f.size() > 2 else 0.0) - 2.0
		var e = spawn_enemy(f[0], f[1], y, f[3] if f.size() > 3 else "")
		e.defeated.connect(_on_amb_foe_dead)
		_amb_foes.append(e)
		load("res://src/fxsprite.gd").play(self, "choque", Vector2(f[1], y), {"scale_px": 1.6, "tint": Color(1, 0.3, 0.25)})
	_amb_wave += 1

func _on_amb_foe_dead() -> void:
	await get_tree().process_frame
	for e in _amb_foes:
		if is_instance_valid(e) and not e.dead:
			return
	_amb_foes = []
	await get_tree().create_timer(0.7).timeout
	if _amb_on:
		_next_wave()

func _end_ambush() -> void:
	for w in _amb_walls:
		w.queue_free()
	_amb_walls.clear()
	_amb_on = false
	_amb_fall = Time.get_ticks_msec() / 1000.0
	Game.sfx("break", -2.0)
	Game.sfx("victory", -10.0)
	toast("Respira. O caminho está livre.")
	spawn_pickup("cura", player.global_position + Vector2(player.facing * 90.0, -60.0))
	spawn_pickup("ki", player.global_position + Vector2(player.facing * 150.0, -60.0))

var _amb_drop := 0.0
var _amb_fall := -1.0
func _draw_amb_walls() -> void:
	# barricadas de toras com talismãs das Sete Casas: caem do alto, fecham a passagem
	if not _amb_on and _amb_fall < 0.0:
		return
	var tex := prop("barricada")
	if tex == null:
		return
	var hh := 430.0
	var ww := hh * tex.get_width() / tex.get_height()
	var drop := clampf((Time.get_ticks_msec() / 1000.0 - _amb_drop) / 0.35, 0.0, 1.0)
	var yoff := -(1.0 - drop * drop) * 700.0
	var a := 1.0
	var tilt := 0.0
	if _amb_fall >= 0.0:
		var f := clampf((Time.get_ticks_msec() / 1000.0 - _amb_fall) / 0.6, 0.0, 1.0)
		a = 1.0 - f
		tilt = f * 0.5
		if f >= 1.0:
			_amb_fall = -1.0
	for side in [-1, 1]:
		var x: float = _amb_x.x - ww * 0.6 if side < 0 else _amb_x.y - ww * 0.4
		var base := Vector2(x + ww / 2.0, GY + 4.0)
		draw_set_transform(base, tilt * side, Vector2.ONE)
		draw_texture_rect(tex, Rect2(-ww / 2.0, -hh + yoff, ww, hh), false, Color(1, 1, 1, a))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

# ---- o vilão observa: sussurro do Shin-Oni depois de cada chefe (planta o final) ----
func _sussurro(ch: String) -> void:
	var key := "sussurro_" + ch
	if not LV_D().has(key) or Game.seen(key):
		return
	Game.mark(key)
	Game.save()
	var cr := ColorRect.new()
	cr.color = Color(0.22, 0.0, 0.03, 0.0)
	cr.set_anchors_preset(Control.PRESET_FULL_RECT)
	cr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ui.add_child(cr)
	var tw := create_tween()
	tw.tween_property(cr, "color:a", 0.6, 0.9)
	Game.sfx("evil_laugh", -12.0)
	shake(5.0)
	await tw.finished
	await say(key)
	var t2 := create_tween()
	t2.tween_property(cr, "color:a", 0.0, 0.6)
	await t2.finished
	cr.queue_free()

# ---- memória jogável: a noite do portão, depois do primeiro chefe (culpa real do Ren) ----
func _build_memory_filter() -> void:
	var l := CanvasLayer.new()
	l.layer = 2
	add_child(l)
	var cr := ColorRect.new()
	cr.set_anchors_preset(Control.PRESET_FULL_RECT)
	cr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var m := ShaderMaterial.new()
	m.shader = load("res://src/memoria.gdshader")
	cr.material = m
	l.add_child(cr)
	# vultos do povo daquela noite, transparentes, apontando para o ferreiro
	for i in range(9):
		var x := 500.0 + i * 300.0 + randf_range(-40, 40)
		var ks := _ald_list()
		_ghosts.append([x, _ald_tex(ks[i % ks.size()]) if not ks.is_empty() else null, i % 2 == 0])

var _ghosts: Array = []
func _draw_ghosts() -> void:
	for g in _ghosts:
		var t: Texture2D = g[1]
		if t == null:
			continue
		var hh := 136.0
		var ww := t.get_width() * hh / t.get_height()
		var a := 0.22 + 0.08 * sin(Time.get_ticks_msec() * 0.002 + g[0])
		var r := Rect2(g[0] - ww / 2.0, GY - hh, ww, hh)
		if g[2]:
			# espelhado: x -> 2*g0 - x
			draw_set_transform(Vector2(g[0] * 2.0, 0), 0.0, Vector2(-1, 1))
		draw_texture_rect(t, r, false, Color(0.75, 0.85, 1.0, a))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

const _VOZES := {
	"memoria_1": ["Foi ele! O ferreiro!", "Ele abriu o portão...", "Minha filha estava lá fora..."],
	"memoria_2": ["Os selos se romperam por causa dele.", "Herói? Ele soltou os demônios!", "Ren... por quê?"],
	"memoria_3": ["Salvaste-nos... e condenaste o mundo.", "As Casas mentem. Mas não mentem em tudo.", "Ouves a corrente rangendo, ferreiro?"],
}
func _whisper(id: String) -> void:
	var vs: Array = _VOZES.get(id, [])
	Game.sfx("chains", -14.0)
	for i in vs.size():
		var p := player.global_position + Vector2(randf_range(-260, 260), -230.0 - i * 46.0)
		load("res://src/fx.gd").spawn(self, "text", p, {"txt": vs[i], "col": Color(0.85, 0.9, 1.0, 0.9), "life": 2.6})
		await get_tree().create_timer(0.9).timeout

func _memory_gate() -> void:
	await say("memoria_porta")
	var gx: float = D["portao_x"]
	var done := {"v": false}
	_interactables.append({"rect": Rect2(gx - 260, GY - 300, 300, 300), "prompt": "ATACAR: romper o eixo-mestre", "pos": Vector2(gx - 120, GY - 250), "cb": func():
		if done["v"]:
			return
		done["v"] = true
		_memory_break()})

func _memory_break() -> void:
	frozen = true
	player.locked = true
	player.pose("finisher")
	Game.sfx("slash3", 0.0)
	Game.sfx("chains", 0.0)
	Game.sfx("impact", 0.0)
	Game.flash(Color(1, 0.15, 0.1, 0.85), 0.6)
	shake(20.0)
	_gate_open = true
	_gate_glow = 1.0
	# a lembrança inteira, em pintura: o eixo partido, o povo fugindo, os demônios surgindo
	var art := TextureRect.new()
	art.texture = load("res://assets/story/portao_eixo.jpg")
	art.set_anchors_preset(Control.PRESET_FULL_RECT)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	art.modulate.a = 0.0
	_ui.add_child(art)
	create_tween().tween_property(art, "modulate:a", 1.0, 0.5)
	await get_tree().create_timer(1.0).timeout
	Game.sfx("evil_laugh", -6.0)
	await say("memoria_fim")
	Game.advance("memoria")


# ---------------- aldeões no estilo do Ren, animados (v0.14) ----------------
const ALDEOES := ["erveira", "arroz_avental", "arroz_vermelho", "carregador", "idosa", "mae", "mendigo", "menino", "pescador", "velho_verde"]
func _ald_list() -> Array:
	var out: Array = []
	for k in ALDEOES:
		if ResourceLoader.exists("res://assets/sprites/ald_%s/ald_%s.json" % [k, k]) or FileAccess.file_exists("res://assets/sprites/ald_%s/ald_%s.json" % [k, k]):
			out.append(k)
	return out

func _villager(kind: String, pos: Vector2, facing_: int, anim := "idle", spd := 1.0) -> Node2D:
	var a = load("res://src/actor_sprite.gd").new()
	a.setup("ald_" + kind)
	a.set_facing(facing_)
	a.play_anim(anim, true, spd)
	var alvo := 100.0 if kind == "menino" else randf_range(132.0, 142.0)
	var fig := 112.0 if kind == "menino" else 147.0
	a.scale = Vector2.ONE * (alvo / fig) * (1.0 if kind != "menino" else 0.9)
	a.position = pos
	add_child(a)
	return a

# quadro parado do aldeão, recortado (para desenhar fantasmas)
func _ald_tex(kind: String) -> Texture2D:
	var p := "res://assets/sprites/ald_%s/idle_00.png" % kind
	if not ResourceLoader.exists(p):
		return null
	var t: Texture2D = load(p)
	var at := AtlasTexture.new()
	at.atlas = t
	at.region = Rect2(t.get_image().get_used_rect())
	return at
