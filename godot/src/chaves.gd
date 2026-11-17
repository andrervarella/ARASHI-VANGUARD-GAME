extends Node2D
# Molho de chaves do carcereiro (desenhado à mão): argola de ferro com três chaves
func _process(_dt: float) -> void:
	queue_redraw()

func _draw() -> void:
	var s := sin(Time.get_ticks_msec() * 0.006) * 0.15
	draw_set_transform(Vector2.ZERO, s, Vector2.ONE)
	draw_arc(Vector2.ZERO, 9.0, 0, TAU, 16, Color(0.55, 0.5, 0.45), 3.0)
	for k in range(3):
		var a := 1.2 + k * 0.45
		var p := Vector2(cos(a), sin(a)) * 9.0
		var d := Vector2(cos(a), sin(a))
		draw_line(p, p + d * 20.0, Color(0.75, 0.6, 0.3), 3.0)
		draw_rect(Rect2(p + d * 16.0 - Vector2(3, 3), Vector2(6, 6)), Color(0.75, 0.6, 0.3))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
