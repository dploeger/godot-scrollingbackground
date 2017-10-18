tool
extends Node

# Private properties

var _texture = null setget _private, _private
var _speed_x = -1 setget _private, _private
var _speed_y = 0 setget _private, _private
var _scale = 1 setget _private, _private
var _screen_size setget _private, _private
var _texture_size setget _private, _private
var _modulate setget _private, _private

func _private(value = null):
	print("Invalid access to private variable!")
	return value

# Public properties

var texture setget set_texture, get_texture
var speed_x setget set_speed_x, get_speed_x
var speed_y setget set_speed_y, get_speed_y
var scale setget set_scale, get_scale
var modulate setget set_modulate, get_modulate

# Setters/Getters

func set_texture(texture): 
	_texture = texture
	if not has_node("Background"):
		_refresh_child()
	else:
		_update_texture()

func get_texture(): return _texture

func set_speed_x(speed): _speed_x = speed
func get_speed_x(): return _speed_x

func set_speed_y(speed): _speed_y = speed
func get_speed_y(): return _speed_y

func set_scale(scale): _scale = scale
	if not has_node("Background"):
		_refresh_child()
	else:
		_update_texture()

func get_scale(): return _scale

func set_modulate(modulate): 
	_modulate = modulate
	if not has_node("Background"):
		_refresh_child()
	else:
		_update_modulate()
		
func get_modulate(): return _modulate

# Property descriptor for the editor

func _get_property_list():
	return [
		{usage = PROPERTY_USAGE_CATEGORY, type = TYPE_NIL, name = "ScrollingBackground"},
		{type = TYPE_OBJECT, name = "texture", hint = PROPERTY_HINT_RESOURCE_TYPE, hint_string = "ImageTexture"},
		{type = TYPE_INT, name = "speed_x"},
		{type = TYPE_INT, name = "speed_y"},
		{type = TYPE_REAL, name = "scale"},
		{type = TYPE_COLOR, name = "modulate"}
	]

# Initialise node, once we're ready

func _ready():
	_refresh_child()
	set_fixed_process(true)

# Update the Background node based on settings

func _refresh_child():
	
	if _texture == null:
		# Texture not set, return early
		return
	
	if get_viewport() == null:
		# We don't yet have a viewport.
		return
	
	if not has_node("Background"):
		var spriteNode = Sprite.new()
		spriteNode.set_name("Background")
		add_child(spriteNode)
		
	_screen_size = get_viewport().get_rect().size
	
	_update_modulate()
	
	_update_texture()
	
	var spriteNode = get_node("Background")
	
	var current_position = spriteNode.get_pos()
	current_position.x = 0 - _texture_size.get_width() * _scale
	current_position.y = 0 - _texture_size.get_height() * _scale
	spriteNode.set_pos(current_position)

func _update_modulate():
	if _modulate != null:
		var spriteNode = get_node("Background")
		spriteNode.set_modulate(_modulate)

func _update_texture():
	var spriteNode = get_node("Background")
	
	spriteNode.set_texture(_texture)
	_texture_size = _texture.get_data()
	_texture.flags = _texture.flags | ImageTexture.FLAG_REPEAT

	var region_rect = Rect2(
		0,
		0,
		(_screen_size.width + _texture_size.get_width() * 2) / _scale,
		(_screen_size.height + _texture_size.get_height() * 2) / _scale
	)

	spriteNode.set_region_rect(
		region_rect
	)
	spriteNode.set_region(true)
	spriteNode.set_centered(false)
	spriteNode.set_scale(Vector2(_scale, _scale))
	
# Update the position according to speed and reset
# accordingly, so it looks like as if the background is 
# continously scrolling

func _fixed_process(delta):
	
	if _texture == null:
		# Texture not set. Returning early
		return
	
	var spriteNode = get_node("Background")
	
	var current_position = spriteNode.get_pos()
	
	current_position.x = current_position.x + _speed_x
	current_position.y = current_position.y + _speed_y
	
	if (
		current_position.x < 0 - _texture_size.get_width() * _scale * 2 ||
		current_position.x > 0
	):
		current_position.x = 0 - _texture_size.get_width() * _scale
	
	if (
		current_position.y < 0 - _texture_size.get_height() * _scale * 2||
		current_position.y > 0
	):
		current_position.y = 0 - _texture_size.get_height() * _scale
	
	spriteNode.set_pos(current_position)

