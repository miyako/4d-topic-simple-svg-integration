# 4d-topic-simple-svg-integration
How to use interactive SVG on a form

This tutorial explains how to

* display an SVG on a form
* make the SVG respond to mouse events
* make the SVG respond to data change events
 
## Setup

* create a text file and save as `thermo.svg`

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<svg
	xmlns="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	width="101px"
	height="101px">
	
	<g transform="translate=(0.5,0.5)">
		<rect
		id="thermo"
		fill="none"
		fill-opacity="1"
		width="0"
		height="100"
		rx="0"
		ry="0"
		x="0"
		y="0"
		stroke="none"
		stroke-width="1"
		shape-rendering="crispEdges"/>
		<rect
		id="border"
		fill="none"
		fill-opacity="none"
		width="100"
		height="100"
		rx="0"
		ry="0"
		x="0"
		y="0"
		stroke="white"
		stroke-width="1"
		vector-effect="non-scaling-stroke"
		shape-rendering="crispEdges"/>
	</g>
</svg>
```

  * the image is a `101x101` square
  * it is a `100x100` square surrounded by a `1px` border
  * the square and its border is shifted by `0.5,0.5`
  * this is because [the SVG grid](https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorials/SVG_from_scratch/Positions#the_grid) cuts through the middle of screen pixels
  * the `shape-rendering` attribute `crispEdges` tells the renderer to prioritise crisp edges over accuracy and anti-aliasing
  * the `vector-effect` attribute `non-scaling-stroke` tell the renderer not to increase the line width when scaling
  * the `rect` object has an `id` attribute `thermo`. this name can be used by the 4D command `SVG SET ATTRIBUTE` when the picture is displayed on a form

* place the SVG file in /RESOURCES/
* create a form
* create an input object and set its expression type to "picture"
* set the picture format to "scaling"
* disable drag, disable drop
* disable horizontal resize, disable vertical resize
* disable contextual menu
* set fill to "none"
* set border style to "none"
* set data source to `Form.thermo.image`
* implement form event "On Load"

```4d
var $event : Object
$event:=FORM Event

Case of 
	: ($event.code=On Load)
		
		var $image : Picture
		READ PICTURE FILE(File("/RESOURCES/thermo.svg").platformPath; $image)
		Form.thermo:={image: $image}
		
End case 
```

<img src="https://github.com/user-attachments/assets/16a02a17-878d-4a0b-a985-398d4f5732bf" width=200 height=auto />

## Respond to Mouse Click 

* implement form event "On Clicked" in the object method

```4d
var $event : Object
$event:=FORM Event

Case of 
	: ($event.code=On Clicked)
		
		var $MOUSEX; $MOUSEY; $MOUSEB : Integer
		GET MOUSE($MOUSEX; $MOUSEY; $MOUSEB)
		
		var $x; $y; $right; $bottom : Integer
		OBJECT GET COORDINATES(*; $event.objectName; $x; $y; $right; $bottom)
		
		Form.thermo.value:=100*(($MOUSEX-$x)/($right-$x))
		
		SVG SET ATTRIBUTE(*; $event.objectName; "thermo"; "width"; String(Form.thermo.value)+"px")
		SVG SET ATTRIBUTE(*; $event.objectName; "thermo"; "height"; "100px")
		SVG SET ATTRIBUTE(*; $event.objectName; "thermo"; "fill"; "red")
		
End case 
```

> [!NOTE]
> [`GET MOUSE`/`MOUSE POSITION`](https://developer.4d.com/docs/commands/mouse-position) can be substituted by the system variables `MOUSEX` and `MOUSEY` which return the local mouse coordinates when referenced in the context of a mouse event generated inside a picture object

## Respond to Mouse Move 

* add the form event "On Mouse Move" to the object method for "On Clicked"

```4d
	: ($event.code=On Clicked)\
		 || ($event.code=On Mouse Move)
```

* add `Is waiting mouse up` to the object method for "On Clicked"

```4d
	: ($event.code=On Clicked)\
		 || (($event.code=On Mouse Move) && (Is waiting mouse up))
```

<img src="https://github.com/user-attachments/assets/5f51d504-666b-46d6-908f-7ef0eecb0aac" width=200 height=auto />

> [!NOTE]
> [`Is waiting mouse up`](https://developer.4d.com/docs/commands/is-waiting-mouse-up) can only be used in the context of an object method. also `FORM Event.objectName` is `Null` when a mouse event is handled in a form method

* create an input object and set its expression type to "integer"
* set data source to `Form.thermo.value`
* notice the value can go over `100` or under `0`

<img src="https://github.com/user-attachments/assets/c6d703f6-c304-4af7-8e72-af9c6eb50ce5" width=200 height=auto />

* add code to set boundaries

```4d
Form.thermo.value:=Form.thermo.value<=0 ? 0 : Form.thermo.value
Form.thermo.value:=Form.thermo.value>=100 ? 100 : Form.thermo.value
```

## Respond to Data Change

* implement form event "On Data Change" on the integer input object
* in the example below, "Image" is the object name of the picture input

```4d
var $event : Object
$event:=FORM Event

Case of 
	: ($event.code=On Data Change)
		
		Form.thermo.value:=Num(Form.thermo.value)
		Form.thermo.value:=Form.thermo.value<=0 ? 0 : Form.thermo.value
		Form.thermo.value:=Form.thermo.value>=100 ? 100 : Form.thermo.value
		
		SVG SET ATTRIBUTE(*; "Image"; "thermo"; "width"; String(Form.thermo.value)+"px")
		SVG SET ATTRIBUTE(*; "Image"; "thermo"; "height"; "100px")
		SVG SET ATTRIBUTE(*; "Image"; "thermo"; "fill"; "red")
		
End case 
```

## Class Implementation

* the sample project includes a form that applies the same principle for SVG manipulation but in a class
* boundaries are defined in the setter function for `value`
* the setter for `value` assigns a temperature colour from green to red
* the `drawSvgRect` function supports vertical rendering
* a native thermometer object is placed on the form for comparison

<img src="https://github.com/user-attachments/assets/f6f3d6ed-f747-4468-bea3-d6a482e523a1" width=400 height=auto />

```4d
property image : Picture
property value; _value : Integer
property color; _color : Text

Class constructor
	
	var $thermo : Picture
	READ PICTURE FILE(File("/RESOURCES/thermo.svg").platformPath; $thermo)
	
	This.image:=$thermo
	This._value:=0
	This._color:="none"
	
Function get color() : Text
	
	return This._color
	
Function get value() : Integer
	
	return This._value
	
Function set value($value : Integer) : cs.Thermo
	
	$value:=$value<=0 ? 0 : $value
	$value:=$value>=100 ? 100 : $value
	
	This._value:=$value
	
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
	
	This._color:=$colors[$v]
	
Function drawSvgRect($objectName : Text; $id : Text; $vertical : Boolean) : cs.Thermo
	
	SVG SET ATTRIBUTE(*; $objectName; $id; "fill"; This.color)
	
	If ($vertical)
		SVG SET ATTRIBUTE(*; $objectName; $id; "width"; "100px")
		SVG SET ATTRIBUTE(*; $objectName; $id; "height"; String(This.value)+"px")
		SVG SET ATTRIBUTE(*; $objectName; $id; "y"; String(100-This.value)+"px")
	Else 
		SVG SET ATTRIBUTE(*; $objectName; $id; "width"; String(This.value)+"px")
		SVG SET ATTRIBUTE(*; $objectName; $id; "height"; "100px")
	End if 
	
	return This
```
