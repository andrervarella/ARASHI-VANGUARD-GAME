extends Node2D
# Postes/lanternas decorativas e placa do protótipo.
func _draw() -> void:
	for x in range(300, 3600, 420):
		draw_rect(Rect2(x, 470 - 150, 8, 150), Color("1a1015"))
		draw_circle(Vector2(x + 4, 470 - 158), 10.0, Color("ff6a2a"))
		draw_circle(Vector2(x + 4, 470 - 158), 26.0, Color(1.0, 0.4, 0.15, 0.12))
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(345, 420), "Ataque os bonecos de treino", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color(1, 1, 1, 0.45))
