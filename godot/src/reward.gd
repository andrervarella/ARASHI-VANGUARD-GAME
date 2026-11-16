extends CanvasLayer
# Tela de vitória: poder do chefe (troca a roupa do Ren) + escolha de 1 entre 3 itens.

var boss := "baku"
const POWER_OF := {"baku": "furia", "xui": "jade"}
const ART := {"baku": "baku2", "xui": "xui"}
const OUTFIT := {"furia": "A ira do demônio tinge as vestes de Ren com a cor da brasa.", "jade": "A fome do demônio tinge as vestes de Ren com o verde do jade."}

var _picked := false

func _ready() -> void:
	var bg := TextureRect.new()
	bg.texture = load("res://assets/story/%s.jpg" % ART.get(boss, "baku2"))
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.modulate = Color(0.35, 0.3, 0.33)
	add_child(bg)
	var p: String = POWER_OF[boss]
	if not Game.data["poderes"].has(p):
		Game.data["poderes"].append(p)
	Game.data["equipado"] = p
	Game.music("titulo", -12.0)
	var vs := get_viewport().get_visible_rect().size
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 12)
	root.position = Vector2(vs.x * 0.08, 24)
	root.custom_minimum_size = Vector2(vs.x * 0.84, 0)
	add_child(root)
	var t := Game.label("VITÓRIA!", 44, Color(1, 0.85, 0.5))
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(t)
	var info: Dictionary = Game.POWERS[p]
	var pc := PanelContainer.new()
	pc.add_theme_stylebox_override("panel", Game.panel_style(0.88, info["cor"]))
	var pl := Game.label("Novo poder: %s\n%s\n%s" % [info["nome"], info["desc"], OUTFIT[p]], 17, Color(0.98, 0.94, 0.88), false)
	pl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var hbp := HBoxContainer.new()
	hbp.add_theme_constant_override("separation", 14)
	var ipp := "res://assets/icons/%s.png" % p
	if ResourceLoader.exists(ipp):
		var tr := TextureRect.new()
		tr.texture = load(ipp)
		tr.custom_minimum_size = Vector2(80, 80)
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hbp.add_child(tr)
	pl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbp.add_child(pl)
	pc.add_child(hbp)
	root.add_child(pc)
	var sub := Game.label("Escolha 1 item (fica com você para sempre):", 19, Color(1, 0.9, 0.75))
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(sub)
	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 12)
	hb.alignment = BoxContainer.ALIGNMENT_CENTER
	root.add_child(hb)
	var pool := []
	for k in Game.ITEMS:
		if not Game.has_item(k):
			pool.append(k)
	pool.shuffle()
	for i in range(mini(3, pool.size())):
		var k: String = pool[i]
		var it: Dictionary = Game.ITEMS[k]
		var b := Game.button("%s\n%s" % [it["nome"], it["desc"]], func(): _pick(k), 15)
		b.custom_minimum_size = Vector2((vs.x * 0.84 - 30.0) / 3.0, 170)
		var ip := "res://assets/icons/%s.png" % k
		if ResourceLoader.exists(ip):
			b.icon = load(ip)
			b.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
			b.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		var sb: StyleBoxFlat = b.get_theme_stylebox("normal").duplicate()
		sb.border_color = it["cor"]
		b.add_theme_stylebox_override("normal", sb)
		hb.add_child(b)
	if pool.is_empty():
		hb.add_child(Game.button("CONTINUAR", func(): _pick("")))
	Game.sfx("powerup", -2.0)

func _pick(k: String) -> void:
	if _picked:
		return
	_picked = true
	if k != "":
		Game.data["itens"].append(k)
	Game.save()
	Game.advance("reward_" + boss)
