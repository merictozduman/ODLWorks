IF LENGTH(std_tel_no_s)<7 THEN
        
        dec_telefon_no1    := ''
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''

ELSE

IF lbl_tel_no='dddddddddd' and dahili_flag=0  THEN
		
		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''

ELSEIF	lbl_tel_no='dddddddddd' and dahili_flag=1  THEN

		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,8,3)	

 ELSEIF	 lbl_tel_no='xdddddddddd' THEN
		  
		 dec_telefon_no1   := SUBSTR(std_tel_no,2,10)
         dec_telefon_no2   := ''
         dec_telefon_no3   := ''
         dec_dahili_no     :=''
		
ELSEIF	lbl_tel_no='ddddddd'  THEN

		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''	

ELSEIF	 lbl_tel_no='ddd-ddddddd' THEN
		  
		 dec_telefon_no1   := SUBSTR(std_tel_no,1,3) || SUBSTR(std_tel_no,5,7)
         dec_telefon_no2   := ''
         dec_telefon_no3    := ''
         dec_dahili_no        :=''		
		 
		
ELSEIF	lbl_tel_no='ddddddddddd'  THEN
		
		IF dahili_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,8,4)
		
		ELSEIF hat_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		
		ELSE
		dec_telefon_no1    := ''
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ENDIF

ELSEIF	 lbl_tel_no='xddd-ddddddd' THEN
		  
		 dec_telefon_no1   := substr(std_tel_no,2,3) || substr(std_tel_no,6,7)
         dec_telefon_no2   := ''
         dec_telefon_no3   := ''
         dec_dahili_no     := ''	

 ELSEIF	 lbl_tel_no='ddddddddd' THEN
		 IF  hat_flag=1 THEN
		 dec_telefon_no1   := substr(std_tel_no,1,7)
         dec_telefon_no2   := ''
         dec_telefon_no3   := ''
         dec_dahili_no     := ''	
		 ELSE
		 dec_telefon_no1   := ''
         dec_telefon_no2   := ''
         dec_telefon_no3   := ''
         dec_dahili_no     := ''		
		 ENDIF
		 	
ELSEIF	lbl_tel_no='dddddddddddd'  THEN
		IF hat_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		
		ELSE 
		dec_telefon_no1    := ''
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''			
		ENDIF
	
ELSEIF	lbl_tel_no='dddddddddddddd' THEN
		IF dahili_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,11,4)	
		ELSE
		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := substr(std_tel_no,8,7)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''	
		ENDIF
		
ELSEIF	lbl_tel_no='ddddddddddddd' THEN
		IF dahili_flag=1 THEN 
		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,11,3)		
		ELSE
		dec_telefon_no1    := ''
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ENDIF

		
ELSEIF 	lbl_tel_no='xddddddddddddd'	THEN
		IF dahili_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,12,3)
		ELSE
		dec_telefon_no1    := ''
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''	
		ENDIF

ELSEIF	 lbl_tel_no='xddd-ddd-dd-dd' THEN
		  
		 dec_telefon_no1   := substr(std_tel_no,2,3)||substr(std_tel_no,6,3)||substr(std_tel_no,10,2)|| substr(std_tel_no,13,2) 
         dec_telefon_no2   := ''
         dec_telefon_no3   := ''
         dec_dahili_no     := ''			
		

ELSEIF 	lbl_tel_no='ddddddddddddddd' THEN
		IF dahili_flag=1 THEN 
		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,11,5)
		ELSE
		dec_telefon_no1    := ''
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ENDIF
		
ELSEIF	 lbl_tel_no='dddddddddd-dddddddddd' THEN
		  
		 dec_telefon_no1   := substr(std_tel_no,1,10)
         dec_telefon_no2   := substr(std_tel_no,12,10)
         dec_telefon_no3   := ''
         dec_dahili_no     := ''	
		
ELSEIF 	lbl_tel_no='dddddddd'	THEN
		IF dahili_flag=1 THEN 
		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,8,1)
		ELSEIF hat_flag=1 THEN 
		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ELSE
		dec_telefon_no1    := ''
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ENDIF 

ELSEIF 	lbl_tel_no='xddddddddddd'	THEN
		IF  hat_flag=1 THEN 
		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ELSE
		dec_telefon_no1    := ''
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ENDIF 
		
ELSEIF 	lbl_tel_no='xddddddd'	THEN

		dec_telefon_no1    := substr(std_tel_no,2,7)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		

ELSEIF 	lbl_tel_no='ddddddd-ddddddd'	THEN

		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := substr(std_tel_no,9,7)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''	
		
ELSEIF 	lbl_tel_no='dddddddddd-dd'	THEN	
		IF dahili_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,12,2)	
		ELSE
		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := substr(std_tel_no,1,8) || substr(std_tel_no,12,2)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		
		ENDIF
		
ELSEIF 	lbl_tel_no='xdddddddddddd'	THEN

		IF dahili_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,12,2)	
		ELSE
		dec_telefon_no1    := ''
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		
		ENDIF

ELSEIF 	lbl_tel_no='dddddddddd-dddd'	THEN

		IF substr(std_tel_no,1,1)<>'5'  THEN
		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,12,4)	
		ELSE
		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		
		ENDIF
		
ELSEIF 	lbl_tel_no='dddddddddd-ddd'	THEN

		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,12,3)	


ELSEIF 	lbl_tel_no='xdddddddddd-ddddddd'	THEN

		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := substr(std_tel_no,13,7)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		

ELSEIF 	lbl_tel_no='xdddddddddd-ddddddddddd'	THEN

		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := substr(std_tel_no,14,10)	
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		


ELSEIF 	lbl_tel_no='xdddddddddd-ddd' THEN	
		IF  hat_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := substr(std_tel_no,2,8) || substr(std_tel_no,13,2)	
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ELSE
		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,13,3)	
		ENDIF
		
ELSEIF 	lbl_tel_no = 'xdddddddddd-dddd' THEN

		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := ''	
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,13,4)		
		
ELSEIF 	lbl_tel_no = 'dddddddddd-ddddddd' THEN

		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := substr(std_tel_no,12,7)	
        dec_telefon_no3    := ''
        dec_dahili_no      := ''

ELSEIF 	lbl_tel_no='ddddddd-ddddddddddd' THEN

		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := substr(std_tel_no,10,10)	
        dec_telefon_no3    := ''
        dec_dahili_no      := ''


ELSEIF 	lbl_tel_no='dddddddddddddddddd' THEN
		IF substr(std_tel_no,8,1)='0' THEN
		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := substr(std_tel_no,9,10)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''	
		ELSE 
		dec_telefon_no1    := ''
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ENDIF
		
ELSEIF 	lbl_tel_no='xdddddddddd-dd' THEN
		IF dahili_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := ''	
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,13,2)	
		ELSEIF hat_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := ''	
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ELSE 
		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := substr(std_tel_no,2,8) || substr(std_tel_no,13,2)		
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ENDIF

ELSEIF 	lbl_tel_no='ddddddd-ddd' THEN

		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,9,3)

	
ELSEIF 	lbl_tel_no='ddd-ddd-dd-dd' THEN

		dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,3) || substr(std_tel_no,9,2) || substr(std_tel_no,12,2)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		
		
		
ELSEIF 	lbl_tel_no='ddddddd-dd' THEN
		IF dahili_flag=1  THEN
		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,9,2)		
		ELSEIF hat_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		
		ELSE
		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := substr(std_tel_no,1,5) || substr(std_tel_no,9,2)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		
		ENDIF
		
ELSEIF 	lbl_tel_no='ddddddd-dddddddddd' THEN
		IF dahili_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := substr(std_tel_no,9,7)
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,16,3)
		ELSE
		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := substr(std_tel_no,9,10)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ENDIF
		
ELSEIF 	lbl_tel_no='xddddddddddddddddd' THEN

		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := substr(std_tel_no,12,7)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		
ELSEIF 	lbl_tel_no='dddddddddddddddddddd' THEN

		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := substr(std_tel_no,11,10)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		

ELSEIF 	lbl_tel_no='ddd-dd-dd' THEN

		dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,2) || substr(std_tel_no,8,2)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''	
		
ELSEIF 	lbl_tel_no='dddddddddd-ddddddddddd' THEN

		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := substr(std_tel_no,13,10)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		

ELSEIF 	lbl_tel_no='xddddddddddddddddddddd' THEN

		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := substr(std_tel_no,13,10)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''	
		
ELSEIF 	lbl_tel_no='ddd-ddddddd-ddd' THEN

		dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,7)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,13,3)	

ELSEIF 	lbl_tel_no='ddddddd-ddddddd-dddddddddd'  THEN

		dec_telefon_no1    := substr(std_tel_no,1,7) 
        dec_telefon_no2    := substr(std_tel_no,9,7)
        dec_telefon_no3    := substr(std_tel_no,17,10)
        dec_dahili_no      := ''			

ELSEIF 	lbl_tel_no='xdd-ddddddd' THEN

		dec_telefon_no1    := substr(std_tel_no,5,7) 
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		

ELSEIF 	lbl_tel_no='xdddddddddddddd' THEN
		IF substr(std_tel_no,2,1)='5' THEN
		dec_telefon_no1    := substr(std_tel_no,2,10) 
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ELSE
		dec_telefon_no1    := substr(std_tel_no,2,10) 
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,12,4)
		ENDIF
		
ELSEIF 	lbl_tel_no='ddd-ddddddd-dddd' THEN

		dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,7) 
        dec_telefon_no2    := ''
        dec_telefon_no3    := '' 
        dec_dahili_no      := substr(std_tel_no,13,4) 	
		
ELSEIF 	lbl_tel_no='xdddddddddd-ddddddd-ddddddd' THEN

		dec_telefon_no1    := substr(std_tel_no,2,10) 
        dec_telefon_no2    := substr(std_tel_no,13,7) 
        dec_telefon_no3    := substr(std_tel_no,21,7) 
        dec_dahili_no      := ''	

ELSEIF 	lbl_tel_no='ddddddddddddddddddddd' THEN
		IF substr(std_tel_no,11,1)<>'0' and dahili_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := substr(std_tel_no,11,7)
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,18,4)		
		ELSEIF substr(std_tel_no,8,1)='0' and dahili_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := substr(std_tel_no,8,10)
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,18,4)	
		ELSEIF	substr(std_tel_no,11,1)='0' THEN
		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := substr(std_tel_no,12,10)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ELSE 
		dec_telefon_no1    := ''
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ENDIF		
		
ELSEIF 	lbl_tel_no='ddddddd-ddddddd-ddddddddddd' THEN

		dec_telefon_no1    := substr(std_tel_no,1,7) 
        dec_telefon_no2    := substr(std_tel_no,9,7) 
        dec_telefon_no3    := substr(std_tel_no,18,10) 
        dec_dahili_no      := ''			

ELSEIF 	lbl_tel_no='dddddddddd-d' THEN
		IF hat_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,1,10) 
        dec_telefon_no2    := '' 
        dec_telefon_no3    := ''
        dec_dahili_no      := ''	
		ELSE
		dec_telefon_no1    := substr(std_tel_no,1,10) 
        dec_telefon_no2    := substr(std_tel_no,1,9) || substr(std_tel_no,12,1)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		
		ENDIF
		
ELSEIF 	lbl_tel_no='ddd-ddddddd-ddddd' THEN

		dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,7) 
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''

ELSEIF 	lbl_tel_no='dddddddddd-ddddd' THEN

		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		

ELSEIF 	lbl_tel_no='ddd-ddd-dddd' THEN

		dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,3) || substr(std_tel_no,9,4) 
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		

ELSEIF 	lbl_tel_no='xddd-ddddddd-ddd' THEN

		dec_telefon_no1    := substr(std_tel_no,2,3) || substr(std_tel_no,6,7) 
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,14,3)
					
ELSEIF 	lbl_tel_no='xddd-ddddddd-ddddddd' THEN
		dec_telefon_no1    := substr(std_tel_no,2,3) || substr(std_tel_no,6,7)
        dec_telefon_no2    := substr(std_tel_no,14,7)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		
		
		
ELSEIF 	lbl_tel_no='xdddddddddd-dddddddddd' and dahili_flag=0 THEN

		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := substr(std_tel_no,13,10)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		

ELSEIF 	lbl_tel_no='dddddddddd-dd-dd'	 THEN

		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := substr(std_tel_no,1,8) || substr(std_tel_no,12,2)
        dec_telefon_no3    := substr(std_tel_no,1,8) || substr(std_tel_no,15,2)
        dec_dahili_no      := ''	

ELSEIF 	lbl_tel_no='xddd-ddddddd-dddd'  THEN
		dec_telefon_no1    := substr(std_tel_no,2,3) || substr(std_tel_no,6,7)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,14,4)	
	
ELSEIF 	lbl_tel_no='xdddddddddd-ddddd'   THEN
		IF substr(std_tel_no,2,1)<>'5' THEN
		dec_telefon_no1    := substr(std_tel_no,2,10) 
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,13,5)	
		ELSE
		dec_telefon_no1    := substr(std_tel_no,2,10) 
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''			
		ENDIF
	
ELSEIF 	lbl_tel_no='xdddddddddd-d'	 THEN
		IF dahili_flag=1    THEN
		dec_telefon_no1    := substr(std_tel_no,2,10) 
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,13,1) 	
		ELSEIF hat_flag=1	THEN
		dec_telefon_no1    := substr(std_tel_no,2,10) 
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''	
		ELSE
		dec_telefon_no1    := substr(std_tel_no,2,10) 
        dec_telefon_no2    := substr(std_tel_no,2,9) || substr(std_tel_no,13,1) 
        dec_telefon_no3    := ''
        dec_dahili_no      := ''	
		ENDIF
		
ELSEIF 	lbl_tel_no='xddd-ddddddd-dd'	 THEN

		dec_telefon_no1    := substr(std_tel_no,2,3) || substr(std_tel_no,6,7)
        dec_telefon_no2    := substr(std_tel_no,2,3) || substr(std_tel_no,6,5) || substr(std_tel_no,14,2) 
        dec_telefon_no3    := ''
        dec_dahili_no      := ''			
					
ELSEIF 	lbl_tel_no='ddd-ddddddd-dd'	 THEN
		IF hat_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,7)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''
		ELSEIF dahili_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,7)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,13,2) 
		ELSE
		dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,7)
        dec_telefon_no2    := substr(std_tel_no,1,3) || substr(std_tel_no,5,5) || substr(std_tel_no,13,2) 
        dec_telefon_no3    := ''
        dec_dahili_no      := ''			
		ENDIF
		
ELSEIF 	lbl_tel_no='x-ddd-ddd-dddd'	 THEN

		dec_telefon_no1    := substr(std_tel_no,3,3) || substr(std_tel_no,7,3) || substr(std_tel_no,11,4)
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		
		
ELSEIF 	lbl_tel_no='xdddddddddddddddddddd'	  THEN
		IF dahili_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := substr(std_tel_no,12,7)
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,19,3)	
		ELSE
		dec_telefon_no1    := substr(std_tel_no,2,10)
        dec_telefon_no2    := substr(std_tel_no,12,7)
        dec_telefon_no3    := ''
        dec_dahili_no      := ''		
		ENDIF
		
ELSEIF 	lbl_tel_no='dddddddddd-ddddddd-dddddddddd'		 THEN

		dec_telefon_no1    := substr(std_tel_no,1,10)
        dec_telefon_no2    := substr(std_tel_no,12,7)
        dec_telefon_no3    := substr(std_tel_no,20,10)
        dec_dahili_no      := ''

ELSEIF 	lbl_tel_no='ddd-ddddddd-ddddddd' THEN

		dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,7)
        dec_telefon_no2    := substr(std_tel_no,13,7)	
        dec_telefon_no3    := ''
        dec_dahili_no      := ''	

ELSEIF 	lbl_tel_no='dddddddddd-ddddddd-ddddddd'   THEN
		dec_telefon_no1    := substr(std_tel_no,1,10) 
        dec_telefon_no2    := substr(std_tel_no,12,7)
        dec_telefon_no3    := substr(std_tel_no,20,7)	
        dec_dahili_no      := ''			

ELSEIF 	lbl_tel_no= 'xdddddddddd-dd-dd'	  THEN
		dec_telefon_no1    := substr(std_tel_no,2,10) 
        dec_telefon_no2    := substr(std_tel_no,2,8) || substr(std_tel_no,13,2)
        dec_telefon_no3    := substr(std_tel_no,2,8) || substr(std_tel_no,16,2)	
        dec_dahili_no      := ''	

ELSEIF lbl_tel_no= 'xddd-ddd-dddd'	  THEN
		dec_telefon_no1    := substr(std_tel_no,2,3) || substr(std_tel_no,6,3)  || substr(std_tel_no,10,4) 
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''	
		
ELSEIF lbl_tel_no= 'xdddddddddd-ddddddddddd-ddddddddddd' THEN
		dec_telefon_no1    := substr(std_tel_no,2,10) 
        dec_telefon_no2    := substr(std_tel_no,14,10) 
        dec_telefon_no3    := substr(std_tel_no,26,10) 
        dec_dahili_no      := ''	

ELSEIF 	lbl_tel_no='ddddddd-dd-dd'  THEN
		IF dahili_flag=1 THEN
		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := substr(std_tel_no,1,5) || substr(std_tel_no,9,2)
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,12,2)	
		ELSE
		dec_telefon_no1    := substr(std_tel_no,1,7)
        dec_telefon_no2    := substr(std_tel_no,1,5) || substr(std_tel_no,9,2)
        dec_telefon_no3    := substr(std_tel_no,1,5) || substr(std_tel_no,12,2)
        dec_dahili_no      := ''		
		ENDIF		
ELSEIF lbl_tel_no='xdddddddddd-dd-ddd' THEN
	   	dec_telefon_no1    := substr(std_tel_no,2,10) 
        dec_telefon_no2    := substr(std_tel_no,2,8) || substr(std_tel_no,13,2) 
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,16,3) 	
		
ELSEIF lbl_tel_no='dddddddddd-ddddddd-ddddddddddd'		THEN
		dec_telefon_no1    := substr(std_tel_no,1,10) 
        dec_telefon_no2    := substr(std_tel_no,12,7) 
        dec_telefon_no3    := substr(std_tel_no,21,10) 
        dec_dahili_no      := ''

ELSEIF lbl_tel_no='xdddddddddd-ddddddd-dddd'		THEN
		dec_telefon_no1    := substr(std_tel_no,2,10) 
        dec_telefon_no2    := substr(std_tel_no,13,7) 
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,21,4) 

ELSEIF lbl_tel_no='ddd-dddddddddd'		THEN
		dec_telefon_no1    := substr(std_tel_no,1,3)  || substr(std_tel_no,5,7) 
        dec_telefon_no2    := '' 
        dec_telefon_no3    := ''
        dec_dahili_no      := substr(std_tel_no,12,3) 	
		
ELSEIF lbl_tel_no='ddddddddddddddddd' THEN 
		IF lbl_alan_kodu1='cep' THEN

		dec_telefon_no1    := SUBSTR(std_tel_no,1,10)
		dec_telefon_no2    := SUBSTR(std_tel_no,11,7)
		dec_telefon_no3    := ''
		dec_dahili_no      := ''
		
		ELSEIF lbl_alan_kodu2='cep' THEN

		dec_telefon_no1	   := SUBSTR(std_tel_no,1,7)
		dec_telefon_no2    := SUBSTR(std_tel_no,8,10)
		dec_telefon_no3    := ''
		dec_dahili_no      := ''
		
		ELSEIF lbl_alan_kodu1='ev' THEN
 
		dec_telefon_no1	   :=SUBSTR(std_tel_no,1,10)
		dec_telefon_no2    :=SUBSTR(std_tel_no,11,7)
		dec_telefon_no3    := ''
		dec_dahili_no      := ''
		
		ELSEIF lbl_alan_kodu2='ev' THEN

		dec_telefon_no1	   := SUBSTR(std_tel_no,1,7)
		dec_telefon_no2    := SUBSTR(std_tel_no,8,10)
		dec_telefon_no3    := ''
		dec_dahili_no      := ''
		
		ELSE
		dec_telefon_no1	   := ''
		dec_telefon_no2    := ''
		dec_telefon_no3    := ''
		dec_dahili_no      := ''            
		ENDIF

		
		
ELSE	
 
		dec_telefon_no1    := ''
        dec_telefon_no2    := ''
        dec_telefon_no3    := ''
        dec_dahili_no      := ''	
         
ENDIF
 
ENDIF		

		
		