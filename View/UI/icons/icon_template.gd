extends Control

var quantity

func update(status: Status, icon : Texture2D):
	$Quantity.text = str(status.quantity)
	$IconTexture.texture = icon
