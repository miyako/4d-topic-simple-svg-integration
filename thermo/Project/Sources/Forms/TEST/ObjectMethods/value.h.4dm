var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Clicked:K2:4)\
		 || ($event.code=On Data Change:K2:15)
		
		Form:C1466.thermo.drawSvgRect("thermo"; "thermo")
		Form:C1466.thermo.drawSvgRect("thermv"; "thermo"; True:C214)
		
End case 