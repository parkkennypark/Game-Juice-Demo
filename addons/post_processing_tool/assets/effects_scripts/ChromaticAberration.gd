@tool
extends Control

# warning-ignore:unused_argument
func _physics_process(delta):
	$BackBufferCopy/ColorRect.size = size
	main()

func main():
	var properties = []
	var node = $BackBufferCopy/ColorRect
	
	# inspactore exports 
	properties.append(
		{name = "Chromatc Aberration",
		type = TYPE_NIL,
		hint_string = "chromatc_aberration_",
		usage = PROPERTY_USAGE_GROUP})
	properties.append(
		{name = "chromatc_aberration_show",
		type = TYPE_BOOL,
		usage = PROPERTY_USAGE_DEFAULT})
	
	node.visible = get_parent().chromatc_aberration_show
	
	properties.append(
		{name = "chromatc_aberration_strength",
		type = TYPE_FLOAT,
		usage = PROPERTY_USAGE_DEFAULT})
	
	# main values setup for effect
	node.material.set_shader_parameter("strength", get_parent().chromatc_aberration_strength)
	
	return properties
