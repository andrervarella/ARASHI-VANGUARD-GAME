extends Node2D
# Projétil inimigo: brasa (arco), vapor (lento), onda no chão, comida caindo.

var level: Node
var vel := Vector2.ZERO
var grav := 0.0
var radius := 18.0
var dmg := 1
var kind := "ember"
var col := Color(1, 0.45, 0.1)
var life := 4.0
var ground_wave := false
var _t := 0.0
var absorbable := true

func _ready() -> void:
	add_to_group("enemy_shot")
	z_index = 15

func _physics_process(dt: float) -> void:
	if level and level.frozen:
		return
	_t += dt
	life -= dt
	vel.y += grav * dt
	position += vel * dt
	if life <= 0.0:
		queue_free()
		return
	if not ground_wave and level and position.y > level.ground_at(position.x) - radius * 0.5:
		load("res://src/fxsprite.gd").play(level, "acerto", position, {"scale_px": 1.6})
		queue_free()
		return
	var p = level.player if level else null
	if p and p.state != "dead":
		if absorbable and p.absorbs(position):
			load("res://src/fx.gd").spawn(level, "ring", position, {"r": 40.0, "col": Color(0.3, 1, 0.6), "life": 0.25})
			queue_free()
			return
		var r := Rect2(position - Vector2(radius, radius), Vector2(radius, radius) * 2.0)
		if ground_wave:
			r = Rect2(position + Vector2(-radius, -60), Vector2(radius * 2.0, 60))
		if r.intersects(p.hurt_rect()):
			p.take_damage(dmg, position.x - signf(vel.x) * 10.0, null, ground_wave)
			queue_free()
			return
	queue_redraw()

func _draw() -> void:
	var FS = load("res://src/fxsprite.gd")
	match kind:
		"ember":
			draw_set_transform(Vector2.ZERO, vel.angle(), Vector2.ONE)
			FS.draw_sheet(self, "brasa_oni", _frame("brasa_oni"), Vector2.ZERO, 1.6, false)
		"vapor":
			draw_set_transform(Vector2.ZERO, vel.angle(), Vector2.ONE)
			FS.draw_sheet(self, "vapor", _frame("vapor"), Vector2.ZERO, 2.2, false)
		"wave":
			FS.draw_sheet(self, "onda_brasa", _frame("onda_brasa"), Vector2.ZERO, 2.4, vel.x < 0.0, col)
		"food":
			draw_circle(Vector2.ZERO, radius, col)
			draw_circle(Vector2(-radius * 0.3, -radius * 0.3), radius * 0.35, Color(1, 1, 1, 0.5))
			draw_line(Vector2(0, -radius), Vector2(4, -radius - 8), Color(0.3, 0.5, 0.2), 3.0)

func _frame(name: String) -> Rect2:
	var m: Array = load("res://src/fxsprite.gd").SHEETS[name]
	var n := int(_t * float(m[4])) % int(m[3])
	return Rect2((n % int(m[2])) * m[0], (n / int(m[2])) * m[1], m[0], m[1])
