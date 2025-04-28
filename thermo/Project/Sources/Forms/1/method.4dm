var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		var $image : Picture
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/thermo.svg").platformPath; $image)
		Form:C1466.thermo:={image: $image}
		
End case 