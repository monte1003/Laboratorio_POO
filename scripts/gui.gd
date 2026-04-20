extends CanvasLayer

func _ready()-> void:
	
	Global.update_heart.connect(update_heart)
	$Label_Heart.text = "0"
	
func update_heart() -> void:
	$Label_Heart.text = str(Global.heart)
