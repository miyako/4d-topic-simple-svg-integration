var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Clicked:K2:4)\
		 || (($event.code=On Mouse Move:K2:35) && (Is waiting mouse up:C1422))
		
		var $MOUSEX; $MOUSEY; $MOUSEB : Integer
		GET MOUSE:C468($MOUSEX; $MOUSEY; $MOUSEB)
		
		var $x; $y; $right; $bottom : Integer
		OBJECT GET COORDINATES:C663(*; $event.objectName; $x; $y; $right; $bottom)
		
		Form:C1466.thermo.value:=100*(($MOUSEX-$x)/($right-$x))
		Form:C1466.thermo.value:=Form:C1466.thermo.value<=0 ? 0 : Form:C1466.thermo.value
		Form:C1466.thermo.value:=Form:C1466.thermo.value>=100 ? 100 : Form:C1466.thermo.value
		
		SVG SET ATTRIBUTE:C1055(*; $event.objectName; "thermo"; "width"; String:C10(Form:C1466.thermo.value)+"px")
		SVG SET ATTRIBUTE:C1055(*; $event.objectName; "thermo"; "height"; "100px")
		SVG SET ATTRIBUTE:C1055(*; $event.objectName; "thermo"; "fill"; "red")
		
End case 