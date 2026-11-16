extends CanvasLayer
# Storyboard: quadros com movimento lento de câmera, faixas de cinema e legenda por código.

var story_id := "abertura"
var _slides: Array = []
var _i := -1
var _img: TextureRect
var _img2: TextureRect
var _sub: Label
var _center: Label
var _timer := 0.0
var _dur := 4.0
var _typing: Tween
var _busy := false
var _video: VideoStreamPlayer
var _bars: Array = []
var _subbg: TextureRect

func _ready() -> void:
	var st: Dictionary = load("res://src/stories.gd").S.get(story_id, {})
	_slides = st.get("quadros", [])
	Game.music(st.get("musica", "titulo"), -10.0)
	var bg := ColorRect.new()
	bg.color = Color.BLACK
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	_img2 = _make_img()
	_img = _make_img()
	# faixas de cinema
	for k in range(2):
		var bar := ColorRect.new()
		bar.color = Color.BLACK
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(bar)
		_bars.append(bar)
	_subbg = TextureRect.new()
	var gt := GradientTexture2D.new()
	gt.fill_from = Vector2(0, 0)
	gt.fill_to = Vector2(0, 1)
	var gr := Gradient.new()
	gr.set_color(0, Color(0, 0, 0, 0))
	gr.set_color(1, Color(0, 0, 0, 0.85))
	gt.gradient = gr
	_subbg.texture = gt
	_subbg.stretch_mode = TextureRect.STRETCH_SCALE
	_subbg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_subbg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_subbg)
	_sub = Game.label("", 24, Color(0.98, 0.95, 0.9))
	_sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_sub.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	_sub.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(_sub)
	_center = Game.label("", 34, Color(0.98, 0.92, 0.85))
	_center.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_center.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_center.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(_center)
	var skip := Game.button("PULAR ▶▶", _finish, 15)
	skip.position = Vector2(12, 12)
	add_child(skip)
	var hint := Game.label("toque para avançar", 13, Color(1, 1, 1, 0.45), false)
	hint.name = "hint"
	add_child(hint)
	get_viewport().size_changed.connect(_layout)
	_layout()
	_next()

func _make_img() -> TextureRect:
	var t := TextureRect.new()
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	t.set_anchors_preset(Control.PRESET_FULL_RECT)
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(t)
	return t

func _layout() -> void:
	var vs := get_viewport().get_visible_rect().size
	_bars[0].position = Vector2.ZERO
	_bars[0].size = Vector2(vs.x, 62)
	_bars[1].position = Vector2(0, vs.y - 62)
	_bars[1].size = Vector2(vs.x, 62)
	_subbg.position = Vector2(0, vs.y - 62 - 150)
	_subbg.size = Vector2(vs.x, 150)
	_sub.position = Vector2(vs.x * 0.08, vs.y - 62 - 96)
	_sub.size = Vector2(vs.x * 0.84, 90)
	_center.position = Vector2(vs.x * 0.1, 0)
	_center.size = Vector2(vs.x * 0.8, vs.y)
	var h: Label = get_node("hint")
	h.position = Vector2(vs.x - 170, vs.y - 40)
	_img.pivot_offset = vs / 2.0
	_img2.pivot_offset = vs / 2.0

func _next() -> void:
	_i += 1
	if _i >= _slides.size():
		_finish()
		return
	var s: Dictionary = _slides[_i]
	if s.has("video") and ResourceLoader.exists("res://assets/video/%s.ogv" % s["video"]):
		_play_video(s)
		return
	_dur = float(s.get("dur", 4.0))
	_timer = 0.0
	# troca com fusão
	_img2.texture = _img.texture
	_img2.scale = _img.scale
	_img2.position = _img.position
	_img2.modulate = _img.modulate
	var ip := "res://assets/story/%s.png" % s["img"]
	if not ResourceLoader.exists(ip):
		ip = "res://assets/story/%s.jpg" % s["img"]
	_img.texture = load(ip)
	_img.modulate.a = 0.0
	var dim: bool = s.get("texto_tela", false) or s.get("titulo", false)
	var target_mod := Color(0.42, 0.38, 0.42, 1) if dim else Color(1, 1, 1, 1)
	var tw := create_tween()
	tw.tween_property(_img, "modulate", target_mod, 0.8)
	# Ken Burns: zoom lento e pan alternado
	var dir := 1.0 if _i % 2 == 0 else -1.0
	_img.scale = Vector2.ONE * 1.04
	_img.position = Vector2(-18.0 * dir, 0)
	var kb := create_tween().set_parallel(true)
	kb.tween_property(_img, "scale", Vector2.ONE * 1.14, _dur + 1.0).set_trans(Tween.TRANS_SINE)
	kb.tween_property(_img, "position", Vector2(18.0 * dir, -6.0), _dur + 1.0).set_trans(Tween.TRANS_SINE)
	var txt: String = s["txt"]
	_subbg.visible = not dim
	if dim:
		_sub.text = ""
		_center.text = txt
		_center.visible_ratio = 0.0
		_type(_center, txt)
	else:
		_center.text = ""
		_sub.text = txt
		_sub.visible_ratio = 0.0
		_type(_sub, txt)

func _type(l: Label, txt: String) -> void:
	if _typing:
		_typing.kill()
	_typing = create_tween()
	_typing.tween_property(l, "visible_ratio", 1.0, max(0.6, txt.length() / 38.0)).set_delay(0.35)

func _play_video(s: Dictionary) -> void:
	_video = VideoStreamPlayer.new()
	_video.stream = load("res://assets/video/%s.ogv" % s["video"])
	_video.expand = true
	_video.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_video)
	move_child(_video, 2)
	_sub.text = s["txt"]
	_sub.visible_ratio = 1.0
	_video.finished.connect(func():
		_video.queue_free()
		_video = null
		_next())
	_video.play()
	_dur = 999.0

func _process(dt: float) -> void:
	_timer += dt
	if _timer > _dur + 0.5 and not _busy:
		_next()

func _input(e: InputEvent) -> void:
	var tap: bool = (e is InputEventScreenTouch and e.pressed) or (e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT) or (e is InputEventKey and e.pressed and not e.echo and e.keycode in [KEY_SPACE, KEY_ENTER, KEY_J, KEY_X])
	if not tap:
		return
	if e is InputEventScreenTouch or e is InputEventMouseButton:
		if e.position.y < 70 and e.position.x < 200:
			return   # botão PULAR
	if _video:
		_video.stop()
		_video.queue_free()
		_video = null
		_next()
		return
	var l: Label = _center if _center.text != "" else _sub
	if l.visible_ratio < 1.0:
		if _typing:
			_typing.kill()
		l.visible_ratio = 1.0
	else:
		_next()

func _finish() -> void:
	if _busy:
		return
	_busy = true
	set_process_input(false)
	Game.advance(story_id)
