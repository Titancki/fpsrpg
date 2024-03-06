extends Resource
class_name ItemResource

@export_category("Information")
@export var item_icon_texture : Texture2D
@export var item_name : String
## [codeblock]
## Miscelanious | 1000-1999
## Weapons      | 2000-2999
## OffHand      | 3000-3999
## Helmet       | 4000-4999
## BodyArmour   | 5000-5999
## Troussers    | 6000-6999
## Belt         | 7000-7999
## Boots        | 8000-8999
## [/codeblock]
@export var item_id : int
@export_multiline var item_description : String

func is_misc() -> bool:
	if str(item_id).begins_with("1"):
		return true
	return false

func is_weapon() -> bool:
	if str(item_id).begins_with("2"):
		return true
	return false

func is_offhand() -> bool:
	if str(item_id).begins_with("3"):
		return true
	return false

func is_helmet() -> bool:
	if str(item_id).begins_with("4"):
		return true
	return false

func is_body_armour() -> bool:
	if str(item_id).begins_with("5"):
		return true
	return false

func is_troussers() -> bool:
	if str(item_id).begins_with("6"):
		return true
	return false

func is_belt() -> bool:
	if str(item_id).begins_with("7"):
		return true
	return false

func is_boots() -> bool:
	if str(item_id).begins_with("8"):
		return true
	return false
