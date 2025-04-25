var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Data Change:K2:15)
		
	: ($event.code=On Clicked:K2:4)\
		 || (($event.code=On Mouse Move:K2:35) && (Is waiting mouse up:C1422))
		
		var $MOUSEX; $MOUSEY; $MOUSEB : Integer
		MOUSE POSITION:C468($MOUSEX; $MOUSEY; $MOUSEB)
		
		var $x; $y; $right; $bottom : Integer
		OBJECT GET COORDINATES:C663(*; $event.objectName; $x; $y; $right; $bottom)
		
		Form:C1466.thermo.value:=100*(($MOUSEX-$x)/($right-$x))
		
		Form:C1466.thermo.drawSvgRect("thermo"; "thermo")
		Form:C1466.thermo.drawSvgRect("thermv"; "thermo"; True:C214)
		
End case 