extends CanvasLayer
# Caixa de diálogo estilo RPG/luta: retrato, nome e texto digitado. Toque para avançar.

signal finished

const NAMES := {"ren": "Ren Arashi", "baku": "Baku", "xui": "Xui", "luke": "Luke", "tetsu": "Mestre Tetsu"}
const COLORS := {"ren": Color(0.95, 0.3, 0.3), "baku": Color(1, 0.45, 0.2), "xui": Color(0.7, 0.85, 0.35), "luke": Color(0.95, 0.85, 0.6), "tetsu": Color(0.6, 0.75, 1.0)}

var _lines: Array = []
var _i := 0
var _panel: PanelContainer
var _name: Label
var _text: Label
var _portrait: TextureRect
var _frame: Panel
var _tw: Tween
var _cool := 0.0

func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	_frame = Panel.new()
	var fs := Game.panel_style(0.95, Color(0.85, 0.65, 0.3))
	fs.set_border_width_all(3)
	_frame.add_theme_stylebox_override("panel", fs)
	add_child(_frame)
	_portrait = TextureRect.new()
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_frame.add_child(_portrait)
	_panel = PanelContainer.new()
	_panel.add_theme_stylebox_override("panel", Game.panel_style(0.88))
	add_child(_panel)
	var vb := VBoxContainer.new()
	_panel.add_child(vb)
	_name = Game.label("", 20, Color.WHITE)
	vb.add_child(_name)
	_text = Game.label("", 21, Color(0.97, 0.94, 0.88), false)
	_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_text.custom_minimum_size = Vector2(100, 64)
	vb.add_child(_text)
	var more := Game.label("▼", 14, Color(1, 0.85, 0.5, 0.8), false)
	more.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	vb.add_child(more)
	visible = false
	get_viewport().size_changed.connect(_layout)

func _layout() -> void:
	var vs := get_viewport().get_visible_rect().size
	var ph := 128.0
	_frame.position = Vector2(vs.x * 0.06, vs.y - 186.0 - 24.0)
	_frame.size = Vector2(ph, ph)
	_portrait.position = Vector2(4, 4)
	_portrait.size = Vector2(ph - 8, ph - 8)
	_panel.position = Vector2(vs.x * 0.06 + ph + 10.0, vs.y - 186.0)
	_panel.size = Vector2(vs.x * 0.88 - ph - 10.0, 150)

func say(lines: Array) -> void:
	_lines = lines
	_i = 0
	visible = true
	_layout()
	_show()

func _show() -> void:
	var l: Array = _lines[_i]
	var who: String = l[0]
	_name.text = NAMES.get(who, who)
	_name.add_theme_color_override("font_color", COLORS.get(who, Color.WHITE))
	var p := "res://assets/portraits/%s.jpg" % who
	_portrait.texture = load(p) if ResourceLoader.exists(p) else null
	_frame.visible = _portrait.texture != null
	_text.text = l[1]
	_text.visible_ratio = 0.0
	if _tw:
		_tw.kill()
	_tw = create_tween()
	_tw.tween_property(_text, "visible_ratio", 1.0, maxf(0.4, String(l[1]).length() / 45.0))
	_cool = 0.15
	if who == "luke":
		Game.sfx("bark", -6.0)
	elif who in ["baku"]:
		Game.sfx("baku_laugh", -14.0)

func _process(dt: float) -> void:
	_cool -= dt

func _input(e: InputEvent) -> void:
	if not visible or _cool > 0.0:
		return
	var tap: bool = (e is InputEventScreenTouch and e.pressed) or (e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT and not DisplayServer.is_touchscreen_available()) or (e is InputEventKey and e.pressed and not e.echo and e.keycode in [KEY_SPACE, KEY_ENTER, KEY_J, KEY_X])
	if not tap:
		return
	get_viewport().set_input_as_handled()
	if _text.visible_ratio < 1.0:
		if _tw:
			_tw.kill()
		_text.visible_ratio = 1.0
		_cool = 0.12
		return
	_i += 1
	if _i >= _lines.size():
		visible = false
		finished.emit()
	else:
		_show()
