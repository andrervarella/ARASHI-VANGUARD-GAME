extends CanvasLayer
# Tela-título: arte oficial da capa, pétalas caindo e menu.

var _bg: TextureRect
var _t := 0.0
var _menu: HBoxContainer
var _creditos: Control
var _press: Label
var _started := false

func _ready() -> void:
	Game.preload_remote_sfx()
	# fundo: a mesma arte ampliada e escurecida preenche as sobras da tela larga
	var back := TextureRect.new()
	back.texture = load("res://assets/ui/title.jpg")
	back.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	back.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	back.set_anchors_preset(Control.PRESET_FULL_RECT)
	back.modulate = Color(0.25, 0.2, 0.25)
	add_child(back)
	# a arte inteira, sem cortar nada
	_bg = TextureRect.new()
	_bg.texture = load("res://assets/ui/title.jpg")
	_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_bg.pivot_offset = Vector2(480, 270)
	add_child(_bg)
	var shade := ColorRect.new()
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0, 0, 0, 0)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	# pétalas
	var pet := CPUParticles2D.new()
	pet.amount = 40
	pet.lifetime = 7.0
	pet.preprocess = 7.0
	pet.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	pet.emission_rect_extents = Vector2(700, 10)
	pet.position = Vector2(480, -20)
	pet.direction = Vector2(0.4, 1)
	pet.spread = 25
	pet.gravity = Vector2(10, 30)
	pet.initial_velocity_min = 30
	pet.initial_velocity_max = 70
	pet.angular_velocity_min = -120
	pet.angular_velocity_max = 120
	pet.scale_amount_min = 3
	pet.scale_amount_max = 6
	pet.color = Color(0.85, 0.08, 0.15, 0.9)
	add_child(pet)
	# menu
	_menu = HBoxContainer.new()
	_menu.add_theme_constant_override("separation", 10)
	_menu.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(_menu)
	if Game.has_save():
		_menu.add_child(Game.button("CONTINUAR", _on_continue, 18))
	_menu.add_child(Game.button("NOVO JOGO", _on_new, 18))
	_menu.add_child(Game.button("CRÉDITOS", _on_credits, 15))
	var ver := Game.label(Game.VERSION, 13, Color(1, 1, 1, 0.55), false)
	ver.position = Vector2(12, 8)
	add_child(ver)
	Game.music("titulo", -6.0)
	Game.ambience("amb_rain", -22.0)
	get_viewport().size_changed.connect(_layout)
	_layout()
	# PRESS START: o navegador só libera o som depois do primeiro toque
	_menu.modulate.a = 0.0
	_menu.visible = false
	_press = Game.label("TOQUE PARA COMEÇAR", 22, Color(1, 0.9, 0.75), false)
	_press.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(_press)
	_layout()

func _input(e: InputEvent) -> void:
	if _started:
		return
	if (e is InputEventScreenTouch and e.pressed) or (e is InputEventMouseButton and e.pressed) or (e is InputEventKey and e.pressed):
		_started = true
		get_viewport().set_input_as_handled()
		Game.sfx("ui_ok", -4.0)
		Game.music_restart("titulo", -6.0)
		_press.visible = false
		_menu.visible = true
		create_tween().tween_property(_menu, "modulate:a", 1.0, 0.6)

func _layout() -> void:
	var vs := get_viewport().get_visible_rect().size
	_bg.pivot_offset = vs / 2.0
	_menu.reset_size()
	_menu.position = Vector2((vs.x - _menu.size.x) / 2.0, vs.y - _menu.size.y - 18.0)
	if _press:
		_press.size = Vector2(vs.x, 40)
		_press.position = Vector2(0, vs.y - 58.0)

func _process(dt: float) -> void:
	_t += dt
	if _press and _press.visible:
		_press.modulate.a = 0.55 + 0.45 * sin(_t * 3.0)
	_bg.scale = Vector2.ONE * (1.0 + 0.01 * sin(_t * 0.15))

func _on_new() -> void:
	Game.new_game()
	Game.ambience("")
	Game.stop_music()
	Game.goto("story", "abertura")

func _on_continue() -> void:
	Game.load_save()
	Game.ambience("")
	Game.continue_game()

func _on_credits() -> void:
	if _creditos:
		_creditos.queue_free()
		_creditos = null
		return
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", Game.panel_style(0.92))
	var l := Game.label("ARASHI VANGUARD\nDireção criativa: André Varela\nCódigo e montagem: Claude (Anthropic)\nSprites e cenários: PixelLab (a partir das artes oficiais)\nEfeitos sonoros: Oculus Audio Pack 1 — Meta, CC BY 4.0\nFontes: DejaVu\n\nToque para fechar", 16, Color(0.97, 0.92, 0.85), false)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	p.add_child(l)
	add_child(p)
	var vs := get_viewport().get_visible_rect().size
	p.reset_size()
	p.position = (vs - p.size) / 2.0
	p.gui_input.connect(func(e):
		if e is InputEventMouseButton and e.pressed or e is InputEventScreenTouch and e.pressed:
			_on_credits())
	_creditos = p
