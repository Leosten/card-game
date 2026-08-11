extends Control

var quantity

func set_icon(icon : Texture2D):
	$IconTexture.texture = icon
	
func set_stacks(status: Status):
	$Quantity.text = str(status.stacks)
