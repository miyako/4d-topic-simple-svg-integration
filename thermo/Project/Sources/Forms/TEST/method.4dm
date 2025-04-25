var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		Form:C1466.thermo:=cs:C1710.Thermo.new()
		
End case 