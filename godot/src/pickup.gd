extends Node2D
# Orbe: cura (+2 vida), ki (+35 poder), vida (+1 vida máxima, segredo).

var kind := "cura"
var level: Node
var _t := 0.0
var base_y := 0.0

func _ready() -> void:
	base_y = position.y
	z_index = 5

func _process(dt: float) -> void:
	_t += dt
	position.y = base_y + sin(_t * 3.0) * 6.0
	queue_redraw()
	var p = level.player if level else null
	if p and p.state != "dead" and p.hurt_rect().grow(20).has_point(global_position):
		match kind:
			"cura": p.heal(2); level.toast("+2 vida")
			"ki": p.ki = minf(100.0, p.ki + 35.0); level.toast("+ poder")
			"vida":
				Game.data["vida_extra"] = int(Game.data.get("vida_extra", 0)) + 1
				p.heal(99)
				level.toast("Fragmento de selo: +1 de vida máxima!")
		Game.sfx("pickup", -4.0)
		load("res://src/fx.gd").spawn(level, "ring", global_position, {"col": _col(), "r": 50.0, "life": 0.3})
		queue_free()

func _col() -> Color:
	return {"cura": Color(1, 0.25, 0.3), "ki": Color(1, 0.8, 0.25), "vida": Color(1, 0.5, 0.9)}[kind]

func _draw() -> void:
	var c := _col()
	var r := 16.0 if kind != "vida" else 22.0
	draw_circle(Vector2.ZERO, r * 1.8, Color(c.r, c.g, c.b, 0.18 + 0.08 * sin(_t * 6.0)))
	draw_circle(Vector2.ZERO, r, c)
	draw_circle(Vector2(-r * 0.3, -r * 0.3), r * 0.35, Color(1, 1, 1, 0.7))
	draw_arc(Vector2.ZERO, r + 3.0, 0, TAU, 24, Color(0.9, 0.75, 0.4), 2.0)
