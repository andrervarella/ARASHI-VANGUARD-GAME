extends Node2D
# Primeiro plano em paralaxe (DEC-026): silhuetas escuras que passam na frente da câmera,
# mais rápido que o mundo, para dar profundidade. Finas e espaçadas para não esconder o jogo.

var level: Node
var theme := "ferreiros"
var largura := 6000.0
var GY := 900.0
const K := 0.35
const SIL := Color(0.03, 0.02, 0.04, 0.93)

func _ready() -> void:
	z_index = 23

func _process(_dt: float) -> void:
	if level and level.cam:
		position.x = -level.cam.get_screen_center_position().x * K

func _glow(c: Vector2, r: float, col: Color) -> void:
	for i in range(6):
		var f := 1.0 - i / 6.0
		draw_circle(c, r * (0.4 + f * 1.6), Color(col.r, col.g, col.b, 0.05 + 0.03 * (1.0 - f)))
	draw_circle(c, r * 0.45, Color(col.r, col.g, col.b, 0.85))

func _draw() -> void:
	var n := int(largura * (1.0 + K) / 1300.0) + 2
	for i in range(n):
		var x := 700.0 + i * 1300.0 + (i % 3) * 140.0
		match theme:
			"torii": _bamboo(x, i)
			"palacio": _pillar(x, i)
			"vila": _pine(x, i)
			_: _post(x, i)
	_grass()

func _post(x: float, i: int) -> void:
	# poste de madeira com lanterna de papel acesa
	draw_rect(Rect2(x - 11, GY - 1500, 22, 1700), SIL)
	draw_line(Vector2(x + 10, GY - 1500), Vector2(x + 10, GY + 200), Color(0.45, 0.2, 0.1, 0.5), 2.0)
	draw_rect(Rect2(x - 70, GY - 760, 150, 18), SIL)
	draw_line(Vector2(x + 60, GY - 742), Vector2(x + 60, GY - 690), SIL, 3.0)
	if i % 2 == 0:
		_glow(Vector2(x + 60, GY - 655), 26.0, Color(1, 0.55, 0.2))
		draw_rect(Rect2(x + 44, GY - 690, 32, 66), Color(0.55, 0.18, 0.08, 0.95))

func _bamboo(x: float, i: int) -> void:
	for k in range(3):
		var bx := x + k * 34.0 - 30.0
		var lean := (k - 1) * 0.04
		var top := Vector2(bx + lean * 1600.0, GY - 1600)
		draw_line(Vector2(bx, GY + 200), top, SIL, 18.0 - k * 3.0)
		for s in range(1, 9):
			var p := Vector2(bx, GY + 200).lerp(top, s / 9.0)
			draw_line(p + Vector2(-11, 0), p + Vector2(11, 0), Color(0.08, 0.06, 0.08, 0.95), 3.0)
		for s in range(3):
			var p2 := Vector2(bx, GY + 200).lerp(top, 0.55 + s * 0.12)
			draw_colored_polygon(PackedVector2Array([p2, p2 + Vector2(70 * (1 if s % 2 == 0 else -1), -18), p2 + Vector2(60 * (1 if s % 2 == 0 else -1), 6)]), SIL)
	if i % 2 == 1:
		# corda sagrada com papéis
		draw_line(Vector2(x - 60, GY - 860), Vector2(x + 90, GY - 830), SIL, 6.0)
		for z in range(3):
			var zx := x - 30 + z * 45
			draw_polyline(PackedVector2Array([Vector2(zx, GY - 850), Vector2(zx + 12, GY - 820), Vector2(zx - 4, GY - 800), Vector2(zx + 8, GY - 780)]), Color(0.85, 0.82, 0.75, 0.55), 5.0)

func _pillar(x: float, i: int) -> void:
	draw_rect(Rect2(x - 18, GY - 1600, 36, 1800), SIL)
	draw_line(Vector2(x + 17, GY - 1600), Vector2(x + 17, GY + 200), Color(0.6, 0.45, 0.15, 0.45), 2.0)
	for b in [GY - 300, GY - 900]:
		draw_rect(Rect2(x - 21, b, 42, 12), Color(0.45, 0.33, 0.1, 0.9))
	if i % 2 == 0:
		# estandarte de seda pendurado
		draw_colored_polygon(PackedVector2Array([Vector2(x + 26, GY - 1100), Vector2(x + 110, GY - 1100), Vector2(x + 104, GY - 560), Vector2(x + 68, GY - 600), Vector2(x + 30, GY - 560)]), Color(0.32, 0.03, 0.06, 0.92))
		draw_line(Vector2(x + 20, GY - 1100), Vector2(x + 116, GY - 1100), Color(0.5, 0.38, 0.12), 6.0)

func _pine(x: float, _i: int) -> void:
	draw_rect(Rect2(x - 14, GY - 1500, 28, 1700), SIL)
	for k in range(5):
		var y := GY - 1300 + k * 160
		var wdt := 90.0 + k * 22.0
		draw_colored_polygon(PackedVector2Array([Vector2(x, y - 120), Vector2(x + wdt, y + 20), Vector2(x - wdt, y + 20)]), SIL)

func _grass() -> void:
	# capim / entulho escuro na beira de baixo da tela (tufos em triângulos simples)
	var w := largura * (1.0 + K) + 1400.0
	var col := Color(0.02, 0.015, 0.03, 0.9)
	draw_rect(Rect2(-200, GY + 122, w + 200, 400), col)
	var x := -200.0
	var k := 0
	while x < w:
		var hgt := 30.0 + 14.0 * sin(k * 1.7) + 8.0 * sin(k * 0.6)
		draw_colored_polygon(PackedVector2Array([Vector2(x, GY + 124), Vector2(x + 18, GY + 128 - hgt), Vector2(x + 38, GY + 124)]), col)
		x += 38.0
		k += 1
