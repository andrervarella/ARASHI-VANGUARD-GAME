extends Node
# Autoload "Game": progresso, troca de cenas, sprites, sons e música.

const VERSION := "v0.7 · fases 1 e 2 · 16/11/2026"
const SAVE_PATH := "user://arashi_save.json"
var FONT_SERIF: Font = load("res://assets/fonts/DejaVuSerif-Bold.ttf")
var FONT_SANS: Font = load("res://assets/fonts/DejaVuSans-Bold.ttf")

const ITEMS := {
	"coracao": {"nome": "Coração de Brasa", "desc": "+3 de vida máxima.", "cor": Color(0.95, 0.35, 0.2)},
	"pena": {"nome": "Pena de Corvo", "desc": "Pulo duplo no ar.", "cor": Color(0.45, 0.4, 0.6)},
	"fio": {"nome": "Fio Temperado", "desc": "Golpes da katana causam +1 de dano.", "cor": Color(0.85, 0.85, 0.95)},
	"omamori": {"nome": "Omamori Vermelho", "desc": "Uma vez por fase, volta com metade da vida.", "cor": Color(0.9, 0.15, 0.2)},
	"sandalia": {"nome": "Sandálias do Vento", "desc": "Corre 15% mais rápido.", "cor": Color(0.5, 0.85, 0.75)},
	"sino": {"nome": "Sino do Templo", "desc": "A Ruptura enche 50% mais rápido.", "cor": Color(0.95, 0.8, 0.35)},
}

# Trio exclusivo de cada chefe: Força · Defesa · Técnica/Mobilidade (T-013, docs/10).
const TRIOS := {
	"baku": ["fio", "coracao", "sandalia"],
	"xui": ["sino", "omamori", "pena"],
}
const POWERS := {
	"": {"nome": "Ren", "desc": "Forma base.", "cor": Color(0.70, 0.05, 0.12), "custo": 0},
	"furia": {"nome": "Golpe da Fúria", "desc": "Investida em brasa que atravessa inimigos e quebra paredes rachadas. (poder de Baku)", "cor": Color(1.0, 0.42, 0.05), "custo": 40},
	"jade": {"nome": "Bocarra de Jade", "desc": "Escudo que engole projéteis e devolve vida. (poder de Xui)", "cor": Color(0.12, 0.78, 0.45), "custo": 30},
	"carmesim": {"nome": "Forma Carmesim", "desc": "Desperta o sangue da Lua Carmesim: golpes mais fortes e mais velocidade por 12 segundos. Exige a Ruptura cheia e deixa Ren ofegante ao terminar.", "cor": Color(0.95, 0.08, 0.15), "custo": 100},
}

var data := {}
var current: Node = null
var _fade: ColorRect
var _fade_layer: CanvasLayer
var _sfx_players: Array = []
var _music: AudioStreamPlayer
var _music_name := ""
var _amb: AudioStreamPlayer
var _frames_cache := {}
var _sfx_cache := {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_fade_layer = CanvasLayer.new()
	_fade_layer.layer = 100
	add_child(_fade_layer)
	_fade = ColorRect.new()
	_fade.color = Color(0, 0, 0, 1)
	_fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade_layer.add_child(_fade)
	for i in range(10):
		var p := AudioStreamPlayer.new()
		p.bus = "Master"
		add_child(p)
		_sfx_players.append(p)
	_music = AudioStreamPlayer.new()
	add_child(_music)
	_amb = AudioStreamPlayer.new()
	add_child(_amb)
	new_game()
	var a := OS.get_cmdline_user_args()
	var i := a.find("--shots")
	if i != -1:
		_shots(a[i + 1], a[i + 2].split(","))

# Teste: salva capturas de tela em quadros definidos (--shots pasta 60,200,400)
func _shots(dir: String, at: PackedStringArray) -> void:
	var frames := []
	for s in at:
		frames.append(int(s))
	var n := 0
	while not frames.is_empty():
		await get_tree().process_frame
		n += 1
		if n >= frames[0]:
			frames.pop_front()
			var img := get_viewport().get_texture().get_image()
			img.save_png("%s/shot_%04d.png" % [dir, n])
	get_tree().quit()

# ---------------- progresso ----------------
func new_game() -> void:
	data = {"etapa": "abertura", "vencidos": [], "itens": [], "poderes": [], "equipado": "", "vistos": []}

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save() -> void:
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(data))

func load_save() -> bool:
	if not has_save():
		return false
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var d = JSON.parse_string(f.get_as_text())
	if typeof(d) != TYPE_DICTIONARY:
		return false
	new_game()
	for k in d:
		data[k] = d[k]
	return true

func has_item(k: String) -> bool:
	return data["itens"].has(k)

func hp_max() -> int:
	return 10 + (3 if has_item("coracao") else 0) + int(data.get("vida_extra", 0))

func seen(flag: String) -> bool:
	return data["vistos"].has(flag)

func mark(flag: String) -> void:
	if not seen(flag):
		data["vistos"].append(flag)

func cycle_power() -> String:
	var list: Array = [""] + data["poderes"]
	var i := list.find(data["equipado"])
	data["equipado"] = list[(i + 1) % list.size()]
	return data["equipado"]

# ---------------- cenas ----------------
var _going := false

func goto(kind: String, arg = null) -> void:
	# evita duas trocas de cena ao mesmo tempo (causava fase/chefe duplicados)
	if _going:
		return
	_going = true
	await fade_out()
	get_tree().paused = false
	Engine.time_scale = 1.0
	if current:
		current.queue_free()
		current = null
	for n in get_tree().get_nodes_in_group("cena"):
		n.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	var n: Node
	match kind:
		"title": n = load("res://src/title.gd").new()
		"story": n = load("res://src/story.gd").new(); n.set("story_id", arg)
		"level": n = load("res://src/level.gd").new(); n.set("level_id", arg)
		"reward": n = load("res://src/reward.gd").new(); n.set("boss", arg)
		_: n = load("res://src/title.gd").new()
	current = n
	n.add_to_group("cena")
	get_tree().root.add_child(n)
	_going = false
	fade_in()

# Para onde ir depois de cada etapa (roteiro das fases 1 e 2).
func advance(from: String) -> void:
	match from:
		"abertura": data["etapa"] = "ferreiros"; save(); goto("level", "ferreiros")
		"ferreiros": data["etapa"] = "cicatriz"; save(); goto("story", "cicatriz")
		"cicatriz": data["etapa"] = "vila_chegada"; save(); goto("story", "vila_chegada")
		"torii": goto("reward", "baku")
		"reward_baku": data["etapa"] = "vila"; data["cp"] = {}; save(); goto("level", "vila")
		"vila_chegada": data["etapa"] = "vila"; save(); goto("level", "vila")
		"palacio": goto("reward", "xui")
		"reward_xui": data["etapa"] = "dois_chefes"; save(); goto("story", "dois_chefes")
		"dois_chefes": data["etapa"] = "vila"; save(); goto("level", "vila")
		_: goto("level", "vila")

func continue_game() -> void:
	var e: String = data["etapa"]
	match e:
		"abertura", "cicatriz", "vila_chegada", "dois_chefes": goto("story", e)
		_: goto("level", e)

func fade_out(t := 0.35) -> void:
	_fade.mouse_filter = Control.MOUSE_FILTER_STOP
	var tw := create_tween()
	tw.tween_property(_fade, "color:a", 1.0, t)
	await tw.finished

func fade_in(t := 0.45) -> void:
	var tw := create_tween()
	tw.tween_property(_fade, "color:a", 0.0, t)
	await tw.finished
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE

func flash(col := Color(1, 1, 1, 0.8), t := 0.25) -> void:
	_fade.color = Color(col.r, col.g, col.b, col.a)
	var tw := create_tween()
	tw.tween_property(_fade, "color:a", 0.0, t)
	await tw.finished
	_fade.color = Color(0, 0, 0, 0)

# ---------------- sprites ----------------
# Devolve {"frames": SpriteFrames, "meta": {anim: {anchor, size}}}
func sprite_set(name: String) -> Dictionary:
	if _frames_cache.has(name):
		return _frames_cache[name]
	var base := "res://assets/sprites/%s/" % name
	var meta: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(base + name + ".json"))
	var sf := SpriteFrames.new()
	sf.remove_animation("default")
	for an in meta:
		sf.add_animation(an)
		sf.set_animation_speed(an, float(meta[an]["fps"]))
		sf.set_animation_loop(an, bool(meta[an]["loop"]))
		for fn in meta[an]["frames"]:
			sf.add_frame(an, load(base + fn))
	var r := {"frames": sf, "meta": meta}
	_frames_cache[name] = r
	return r

# ---------------- áudio ----------------
func sfx(name: String, vol_db := 0.0, pitch_var := 0.06) -> void:
	var s: AudioStream = _sfx_cache.get(name)
	if s == null:
		var p := "res://assets/sfx/%s.ogg" % name
		if not ResourceLoader.exists(p):
			return
		s = load(p)
		_sfx_cache[name] = s
	for p in _sfx_players:
		if not p.playing:
			p.stream = s
			p.volume_db = vol_db
			p.pitch_scale = 1.0 + randf_range(-pitch_var, pitch_var)
			p.play()
			return

var _music_cache := {}
var _music_loading := {}

func music(name: String, vol_db := -8.0) -> void:
	if name == _music_name:
		return
	_music_name = name
	var st: AudioStream = _music_cache.get(name)
	if st == null:
		for ext in ["ogg", "mp3"]:
			var p := "res://assets/music/%s.%s" % [name, ext]
			if ResourceLoader.exists(p):
				st = load(p)
				break
	if st == null and OS.has_feature("web"):
		# No link jogável, as músicas (biblioteca PixelLab do dono) são baixadas no deploy
		# para /music/<nome>.mp3 e carregadas aqui sob demanda.
		_fetch_music(name, vol_db)
		return
	if st == null:
		_music.stop()
		return
	_play_music(st, vol_db)

func _play_music(st: AudioStream, vol_db: float) -> void:
	if st is AudioStreamMP3 or st is AudioStreamOggVorbis:
		st.loop = true
	_music.stream = st
	_music.volume_db = -40.0
	_music.play()
	create_tween().tween_property(_music, "volume_db", vol_db, 1.2)

func _fetch_music(name: String, vol_db: float) -> void:
	if _music_loading.has(name):
		return
	_music_loading[name] = true
	var req := HTTPRequest.new()
	add_child(req)
	var base := ""
	var loc = JavaScriptBridge.eval("window.location.href.replace(/[^/]*$/, '')", true)
	if typeof(loc) == TYPE_STRING:
		base = loc
	req.request_completed.connect(func(result, code, _h, body: PackedByteArray):
		req.queue_free()
		_music_loading.erase(name)
		if result != HTTPRequest.RESULT_SUCCESS or code != 200 or body.size() < 1000:
			return
		var mp := AudioStreamMP3.new()
		mp.data = body
		_music_cache[name] = mp
		if _music_name == name:
			_play_music(mp, vol_db))
	req.request(base + "music/%s.mp3" % name)

func stop_music() -> void:
	_music_name = ""
	var tw := create_tween()
	tw.tween_property(_music, "volume_db", -40.0, 0.8)
	tw.tween_callback(_music.stop)

func ambience(name: String, vol_db := -16.0) -> void:
	if name == "":
		_amb.stop()
		return
	var p := "res://assets/sfx/%s.ogg" % name
	if not ResourceLoader.exists(p):
		return
	var st: AudioStreamOggVorbis = load(p)
	st.loop = true
	_amb.stream = st
	_amb.volume_db = vol_db
	_amb.play()

# ---------------- utilidades de interface ----------------
func panel_style(alpha := 0.82, border := Color(0.78, 0.6, 0.3)) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.07, 0.03, 0.05, alpha)
	sb.border_color = border
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(6)
	sb.shadow_color = Color(0, 0, 0, 0.5)
	sb.shadow_size = 6
	sb.content_margin_left = 18
	sb.content_margin_right = 18
	sb.content_margin_top = 10
	sb.content_margin_bottom = 10
	return sb

func button(text: String, cb: Callable, size := 22) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_override("font", FONT_SERIF)
	b.add_theme_font_size_override("font_size", size)
	b.add_theme_color_override("font_color", Color(0.97, 0.9, 0.78))
	b.add_theme_color_override("font_hover_color", Color(1, 1, 1))
	b.add_theme_color_override("font_pressed_color", Color(1, 0.85, 0.6))
	var n := panel_style(0.78, Color(0.75, 0.55, 0.25))
	var h := panel_style(0.9, Color(1.0, 0.8, 0.4))
	h.bg_color = Color(0.45, 0.04, 0.09, 0.92)
	var p := h.duplicate()
	p.bg_color = Color(0.62, 0.06, 0.12, 0.95)
	b.add_theme_stylebox_override("normal", n)
	b.add_theme_stylebox_override("hover", h)
	b.add_theme_stylebox_override("pressed", p)
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	b.pressed.connect(func():
		sfx("ui_ok", -4.0)
		cb.call())
	return b

# ---------------- utilidades de texto ----------------
func label(text: String, size: int, col := Color.WHITE, serif := true) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_override("font", FONT_SERIF if serif else FONT_SANS)
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	l.add_theme_constant_override("outline_size", max(4, size / 5))
	return l
