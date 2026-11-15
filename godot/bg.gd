extends Control
func _draw() -> void:
	var s := size
	draw_rect(Rect2(Vector2.ZERO, s), Color("0d0a14"))
	for i in range(12):
		var y := s.y * float(i) / 12.0
		draw_rect(Rect2(0, y, s.x, s.y / 12.0 + 1), Color("0d0a14").lerp(Color("2a0f1c"), float(i) / 12.0))
	draw_circle(Vector2(s.x * 0.72, s.y * 0.28), 70.0, Color("b3162b"))
	draw_circle(Vector2(s.x * 0.72, s.y * 0.28), 84.0, Color(0.7, 0.09, 0.17, 0.18))
	var pts := PackedVector2Array([Vector2(0, s.y)])
	for i in range(0, 17):
		pts.append(Vector2(s.x * float(i) / 16.0, s.y * 0.62 - 40.0 * absf(sin(float(i) * 1.7)) - 20.0))
	pts.append(Vector2(s.x, s.y))
	draw_colored_polygon(pts, Color("140c14"))
