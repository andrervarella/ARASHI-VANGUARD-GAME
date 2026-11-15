extends Node2D
# Cena de teste: "Distrito da Forja" (provisório). Tudo montado por código.

const LEVEL_W := 3600.0
const GROUND_Y := 470.0

var player: CharacterBody2D
var hud: Control

func _solid(rect: Rect2, color: Color) -> void:
	var b := StaticBody2D.new()
	var cs := CollisionShape2D.new()
	var rs := RectangleShape2D.new()
	rs.size = rect.size
	cs.shape = rs
	cs.position = rect.position + rect.size / 2.0
	b.add_child(cs)
	add_child(b)
	var v := ColorRect.new()
	v.position = rect.position
	v.size = rect.size
	v.color = color
	add_child(v)

func _ready() -> void:
	# fundo (camada atrás de tudo): céu escuro + lua carmesim
	var bg_layer := CanvasLayer.new()
	bg_layer.layer = -10
	add_child(bg_layer)
	var bg := Control.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.set_script(preload("res://bg.gd"))
	bg_layer.add_child(bg)

	# chão e plataformas
	_solid(Rect2(-200, GROUND_Y, LEVEL_W + 400, 600), Color("24181c"))
	_solid(Rect2(-200, GROUND_Y, LEVEL_W + 400, 8), Color("4a2a30"))
	var plats := [
		Rect2(520, 380, 180, 18), Rect2(820, 310, 180, 18), Rect2(1150, 380, 220, 18),
		Rect2(1650, 330, 200, 18), Rect2(1950, 260, 180, 18), Rect2(2400, 360, 260, 18),
		Rect2(2900, 300, 200, 18)]
	for r in plats:
		_solid(r, Color("3b2a30"))
	# paredes de limite
	_solid(Rect2(-240, -400, 40, 1200), Color("000000"))
	_solid(Rect2(LEVEL_W + 200, -400, 40, 1200), Color("000000"))

	# decoração simples (postes de forja)
	var deco := Node2D.new()
	deco.set_script(preload("res://deco.gd"))
	add_child(deco)

	# bonecos de treino
	for x in [900.0, 1700.0, 2500.0, 3200.0]:
		var d := Node2D.new()
		d.set_script(preload("res://dummy.gd"))
		d.position = Vector2(x, GROUND_Y)
		add_child(d)

	# HUD de toque
	var hl := CanvasLayer.new()
	hl.layer = 10
	add_child(hl)
	hud = Control.new()
	hud.set_script(preload("res://hud.gd"))
	hl.add_child(hud)

	# jogador
	player = CharacterBody2D.new()
	player.set_script(preload("res://player.gd"))
	player.position = Vector2(200, GROUND_Y)
	player.set("ctl", hud)
	add_child(player)

	# Luke
	var luke := Node2D.new()
	luke.set_script(preload("res://luke.gd"))
	luke.position = Vector2(140, GROUND_Y)
	luke.set("target", player)
	add_child(luke)

	# câmera
	var cam := Camera2D.new()
	cam.position_smoothing_enabled = true
	cam.position_smoothing_speed = 7.0
	cam.limit_left = -200
	cam.limit_right = int(LEVEL_W + 200)
	cam.limit_bottom = int(GROUND_Y + 400)
	cam.offset = Vector2(0, -110)
	player.add_child(cam)
