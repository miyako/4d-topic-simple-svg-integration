var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Data Change:K2:15)
		
		Form:C1466.thermo.value:=Num:C11(Form:C1466.thermo.value)
		Form:C1466.thermo.value:=Form:C1466.thermo.value<=0 ? 0 : Form:C1466.thermo.value
		Form:C1466.thermo.value:=Form:C1466.thermo.value>=100 ? 100 : Form:C1466.thermo.value
		
		SVG SET ATTRIBUTE:C1055(*; "Image"; "thermo"; "width"; String:C10(Form:C1466.thermo.value)+"px")
		SVG SET ATTRIBUTE:C1055(*; "Image"; "thermo"; "height"; "100px")
		SVG SET ATTRIBUTE:C1055(*; "Image"; "thermo"; "fill"; "red")
		
End case 