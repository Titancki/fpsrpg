@tool
extends Control

enum SOCKET {WEAPON, OFFHAND, BODYARMOUR, HELMET, BELT, TROUSSERS, BOOTS, INVENTORY}
@export var base_color : Color = Color(255,255,255)
@export var show_amount : bool = true
@export var socket_is : SOCKET

var item : ItemResource
var is_hovering : bool = false
var player_data

signal on_update_amount
signal on_update_icon


# Called when the node enters the scene tree for the first time.
func _ready():
	get_theme_stylebox("normal").modulate_color = base_color
	get_theme_stylebox("hover").modulate_color = base_color
	get_theme_stylebox("pressed").modulate_color = base_color
	get_theme_stylebox("disabled").modulate_color = base_color
	get_theme_stylebox("focus").modulate_color = base_color
	player_data = load("res://Saves/player_data.tres")
	
	if !show_amount:
		$ItemIcon/ItemAmount.hide()
	
	on_update_amount.connect(update_amount)
	on_update_icon.connect(update_icon)

func _process(_delta):
	if is_hovering:
		self.scale.x = 1.05
		self.scale.y = 1.05
	else:
		self.scale.x = 1
		self.scale.y = 1

	if item:
		self.set_tooltip_text(item.item_name)

	if socket_is == SOCKET.WEAPON:
		if player_data.weapon_equiped && player_data.weapon_equiped != item:
			update_icon(player_data.weapon_equiped.item_icon_texture)
			item = player_data.weapon_equiped
		elif !player_data.weapon_equiped && player_data.weapon_equiped != item:
			update_icon(null)
	elif socket_is == SOCKET.OFFHAND:
		if player_data.offhand_equiped && player_data.offhand_equiped != item:
			update_icon(player_data.offhand_equiped.item_icon_texture)
			item = player_data.offhand_equiped
		elif !player_data.offhand_equiped && player_data.offhand_equiped != item:
			update_icon(null)
	elif socket_is == SOCKET.BODYARMOUR: 
		if player_data.bodyarmour_equiped && player_data.bodyarmour_equiped != item:
			update_icon(player_data.bodyarmour_equiped.item_icon_texture)
			item = player_data.bodyarmour_equiped
		elif !player_data.bodyarmour_equiped && player_data.bodyarmour_equiped != item:
			update_icon(null)
	elif socket_is == SOCKET.HELMET && player_data.helmet_equiped != item: 
		if player_data.helmet_equiped:
			update_icon(player_data.helmet_equiped.item_icon_texture)
			item = player_data.helmet_equiped
		elif !player_data.helmet_equiped && player_data.helmet_equiped != item:
			update_icon(null)
	elif socket_is == SOCKET.BELT && player_data.belt_equiped != item: 
		if player_data.belt_equiped:
			update_icon(player_data.belt_equiped.item_icon_texture)
			item = player_data.belt_equiped
		elif !player_data.belt_equiped && player_data.belt_equiped != item:
			update_icon(null)
	elif socket_is == SOCKET.TROUSSERS && player_data.troussers_equiped != item:
		if player_data.troussers_equiped:
			update_icon(player_data.troussers_equiped.item_icon_texture)
			item = player_data.trousers_equiped
		elif !player_data.troussers_equiped && player_data.troussers_equiped != item:
			update_icon(null)
	elif socket_is == SOCKET.BOOTS && player_data.boots_equiped != item:
		if player_data.boots_equiped:
			update_icon(player_data.boots_equiped.item_icon_texture)
			item = player_data.boots_equiped
		elif !player_data.boots_equiped && player_data.boots_equiped != item:
			update_icon(null)
	
func update_amount(amount : int):
	$ItemIcon/ItemAmount.text = str(amount)

func update_icon(icon: Texture2D):
	var new_texture = StyleBoxTexture.new()
	new_texture.set_texture(icon)
	$ItemIcon.add_theme_stylebox_override("panel", new_texture)

func _on_mouse_entered():
	is_hovering = true


func _on_mouse_exited():
	is_hovering = false


func _on_button_down():
	if item && socket_is == SOCKET.INVENTORY:
		if item.is_belt(): player_data.belt_equiped = item
		if item.is_body_armour(): player_data.bodyarmour_equiped = item
		if item.is_boots(): player_data.boots_equiped = item
		if item.is_helmet(): player_data.helmet_equiped = item
		if item.is_troussers(): player_data.troussers_equiped = item
		if item.is_belt(): player_data.belt_equiped = item
		if item.is_weapon(): player_data.weapon_equiped = item
		if item.is_offhand(): player_data.offhand_equiped = item
		player_data.save()
	elif item && socket_is != SOCKET.INVENTORY:
		if item.is_belt(): player_data.belt_equiped = null
		if item.is_body_armour(): player_data.bodyarmour_equiped = null
		if item.is_boots(): player_data.boots_equiped = null
		if item.is_helmet(): player_data.helmet_equiped = null
		if item.is_troussers(): player_data.troussers_equiped = null
		if item.is_belt(): player_data.belt_equiped = null
		if item.is_weapon(): player_data.weapon_equiped = null
		if item.is_offhand(): player_data.offhand_equiped = null
		player_data.save()
