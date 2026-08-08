extends Control

var orb_type = null

func init(orb_type):
	orb_type = CardUtils.magic_type.keys()[orb_type]
	%Type.text = orb_type
