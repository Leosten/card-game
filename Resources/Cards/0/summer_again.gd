extends CardData

func _init():
	actions = [CardUtils.action_type.BUFFS]
	buffs = [CardStatus.new(StatusUtils.names.FORESIGHT, 1)]
	allowed_targets = [CardUtils.targets.SELF]

func upgrade():
	shield = shield_upgrade
	actions.append(CardUtils.action_type.SHIELD)
	description += ' and shield for [color={shield_color}]{shield}[/color]';
	
