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
> [`GET MOUSE`/`MOUSE POSITION`](https://developer.4d.com/docs/commands/mouse-position) returns local coordinates when called in the context of a mouse event that was generated inside a picture object

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

## Bidirectional

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
