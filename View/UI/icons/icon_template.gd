extends Control

var quantity

func update(buff: Status):
	$Quantity.text = str(buff.quantity)
