

macro printMap
   mov ah, 0x00
   mov al, 0x03 
   int 0x10 
   mov ah, 09
   mov dx,offset mapaArriba 
   int 21h
   mov ah, 09
   mov dx,offset mapaAbajo 
   int 21h  
endm
    

macro printMsg mensaje, fila 
   ;limpio la linea  
   mov dl,0 ;especifico la pos X en pantalla
   mov dh,fila;especifico la pos Y en pantalla
   mov ah,2
   mov bh,0
   int 10h
   mov ah, 09
   mov dx,offset cleanline 
   int 21h 
   
   ;reubico el cursor en pantalla
   mov dl,0 ;especifico la pos X en pantalla
   mov dh,fila;especifico la pos Y en pantalla
   mov ah,2
   mov bh,0
   int 10h 
   
   ;imprimo el mensaje
   mov ah, 09
   mov dx,offset mensaje 
   int 21h
endm   


    
