property image : Picture
property value; _value : Integer
property color; _color : Text

Class constructor
	
	var $thermo : Picture
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/thermo.svg").platformPath; $thermo)
	
	This:C1470.image:=$thermo
	This:C1470._value:=0
	This:C1470._color:="none"
	
Function get color() : Text
	
	return This:C1470._color
	
Function get value() : Integer
	
	return This:C1470._value
	
Function set value($value : Integer) : cs:C1710.Thermo
	
	$value:=$value<=0 ? 0 : $value
	$value:=$value>=100 ? 100 : $value
	
	This:C1470._value:=$value
	
	$v:=$value\10
	
	$colors:=[\
		"#00FF00"; \
		"#33FF00"; \
		"#66FF00"; \
		"#99FF00"; \
		"#CCFF00"; \
		"#FFFF00"; \
		"#FFCC00"; \
		"#FF9900"; \
		"#FF6600"; \
		"#FF3300"; \
		"#FF0000"]  //.reverse()
	
	This:C1470._color:=$colors[$v]
	
Function drawSvgRect($objectName : Text; $id : Text; $vertical : Boolean) : cs:C1710.Thermo
	
	SVG SET ATTRIBUTE:C1055(*; $objectName; $id; "fill"; This:C1470.color)
	
	If ($vertical)
		SVG SET ATTRIBUTE:C1055(*; $objectName; $id; "width"; "100px")
		SVG SET ATTRIBUTE:C1055(*; $objectName; $id; "height"; String:C10(This:C1470.value)+"px")
		SVG SET ATTRIBUTE:C1055(*; $objectName; $id; "y"; String:C10(100-This:C1470.value)+"px")
	Else 
		SVG SET ATTRIBUTE:C1055(*; $objectName; $id; "width"; String:C10(This:C1470.value)+"px")
		SVG SET ATTRIBUTE:C1055(*; $objectName; $id; "height"; "100px")
	End if 
	
	return This:C1470