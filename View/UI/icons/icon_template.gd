extends Control

var quantity

func set_icon(icon : Texture2D):
	$IconTexture.texture = icon
	
func set_stacks(stacks):
	$Quantity.text = str(stacks)
