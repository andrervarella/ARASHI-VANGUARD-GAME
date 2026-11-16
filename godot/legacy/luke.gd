extends Node2D
# Luke — seguidor provisório (cores e forma de teste, NÃO é o design da ficha).
var target: Node2D
var vel := Vector2.ZERO
var t := 0.0
var facing := 1
var moving := false

func _process(dt: float) -> void:
	t += dt
	if target == null:
		return
	var goal := target.global_position + Vector2(-60.0 * target.facing, 0)
	var dx := goal.x - global_position.x
	if absf(dx) > 8.0:
		facing = 1 if dx > 0 else -1
	var step := clampf(dx, -1, 1) * minf(absf(dx) * 4.0, 300.0) * dt
	moving = absf(step) > 0.5
	global_position.x += step
	global_position.y = target.global_position.y
	queue_redraw()

func _draw() -> void:
	var f := float(facing)
	var run := sin(t * 18.0) * 3.0 if moving else 0.0
	var body := Color("c9a56a")
	draw_colored_polygon(PackedVector2Array([Vector2(-16 * f, -22), Vector2(16 * f, -22), Vector2(14 * f, -8), Vector2(-14 * f, -8)]), body)
	draw_circle(Vector2(18 * f, -26), 9.0, body)
	draw_colored_polygon(PackedVector2Array([Vector2(14 * f, -34), Vector2(20 * f, -44), Vector2(24 * f, -32)]), Color("8f6e3d"))
	draw_circle(Vector2(21 * f, -27), 1.6, Color.BLACK)
	draw_line(Vector2(-16 * f, -20), Vector2(-26 * f, -30 + sin(t * 10.0) * 5.0), body, 4.0)
	draw_line(Vector2(-10 * f, -8), Vector2(-10 * f, run), body, 4.0)
	draw_line(Vector2(10 * f, -8), Vector2(10 * f, -run), body, 4.0)
	draw_rect(Rect2(6 * f - 3, -24, 6, 6), Color("a3182a"))
