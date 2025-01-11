@tool
extends Control

func _draw() -> void:
	draw_circle(Vector2.ZERO, 2, Color.BLACK)
	
	draw_line(Vector2(16, 0), Vector2(32, 0), Color.BLACK, 4.0, false)
	draw_line(Vector2(-16, 0), Vector2(-32, 0), Color.BLACK, 4.0, false)
	draw_line(Vector2(0, 16), Vector2(0, 32), Color.BLACK, 4.0, false)
	draw_line(Vector2(0, -16), Vector2(0, -32), Color.BLACK, 4.0, false)
