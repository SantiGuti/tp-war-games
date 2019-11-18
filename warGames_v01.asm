
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
    call initJuego
    call jugar
    ;call guardarRanking
ret 



proc initJuego
    call printMap
    call pedirCoordBase
    call elegirTurno
  ret
endp  

proc jugar
    call printMap
    call informarPaisTurno
    call leerCoordenadas
    ;call disparar
    ;call informarResultado
    ;call actualizarSiguienteTurno
ret
endp

proc print ;Para el flujo del programa para imprimir algo
    mov ah, 09
    int 21h
    ret
endp

proc clearScreen ;Limpia todos los print que van quedando
    mov ah, 0x00
    mov al, 0x03 
    int 0x10
    ret
endp


proc leerDatoYPasarADec
     mov ah, 7
     int 21h ;Para el flujo del programa para recibir un dato por teclado
     sub al, 48
     mov cl, al
     mov al, auxiliarCoord ;auxiliarCoord la primera vez vale 0, la segunda guarda el primer dato pasado que se multiplica por diez 
     mov dl, 10
     mul dl
     add al, cl
     mov auxiliarCoord, al ;Lo pasa de ASCII a Dec restando y multiplicando y lo guarda en auxiliarCoord 
     ret
endp
     
proc printMap ;Imprime el mapa del juego
    mov dx,offset mapaArriba
    call print
    mov dx,offset mapaAbajo
    call print
  ret
endp

proc pedirCoordBase ;Pide las coordenadas de la base secreta
    
    mov bl, 0
    mov bh, 0
    mov dx, offset pedirBaseXJug1
    call print
    while:
        cmp bl, 2
        je selector
        call leerDatoYPasarADec
        inc bl
        jmp while
        
    selector:
        cmp bh, 0
        je caso1
        cmp bh, 1
        je caso2
        cmp bh, 2
        je caso3
        cmp bh, 3
        je caso4
                    
    caso1:
        mov al, auxiliarCoord
        mov auxiliarCoord, 0
        mov baseSecretaXJug1, al
        inc bh
        mov bl, 0
        mov dx, offset pedirBaseYJug1
        call print
        jmp while
    caso2:
        mov al, auxiliarCoord
        mov auxiliarCoord, 0
        mov baseSecretaYJug1, al
        inc bh
        mov bl, 0
        mov dx, offset pedirBaseXJug2
        call print
        jmp while
    caso3:
        mov al, auxiliarCoord
        mov auxiliarCoord, 0
        mov baseSecretaXJug2, al
        inc bh
        mov bl, 0
        mov dx, offset pedirBaseYJug2
        call print
        jmp while
    caso4:
        mov al, auxiliarCoord
        mov auxiliarCoord, 0
        mov baseSecretaYJug2, al
        call clearScreen
        jmp exit
exit:        
   ret
endp


proc elegirTurno
   mov ah, 00h ;interrupcion para obtener la hora del sistema
   int 1ah ;cx:dx ahora tienen los ticks del reloj desde la medianoche      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 10    
   div  cx       ;aca dx contiene el resto de la division - desde 0 a 9
   
   cmp dx, 4
   jbe jug1
   cmp dx, 5
   jae jug2
   
   jug1:
        mov quienJuega, 1
        jmp leave
   
   jug2:
        mov quienJuega, 2
        jmp leave


leave:    
    ret
endp

proc informarPaisTurno ;Muestra por pantalla de quien es el turno
    mov bh, quienJuega
    cmp bh, 1
    je Juega1
    jmp Juega2
    
    Juega1:
        mov dx, offset JuegaJug1
        call print
        mov bh, 2
        mov quienJuega, bh
        jmp salir
    
    Juega2:
        mov dx, offset JuegaJug2
        call print
        mov bh, 1
        mov quienJuega, bh
        jmp salir
    
salir:
    ret
endp

proc leerCoordenadas ;Pide las coordenadas del disparo de X jugador
    mov bh, 0
    cmp quienJuega, 1 ;Los saltos estan al reves aproposito ya que quienJuega se le suma 1 justo despues de avisar de quien es el turno
    je dispJug2
    
    dispJug1:
        mov bl, 0
        mov dx, offset pedirDisparoXJug1
        call print
        jmp while2 
        
    dispJug2:
        mov bl, 0
        mov dx, offset pedirDisparoXJug2
        call print
        jmp while2 
        
    while2:
         cmp bl, 2
         je asignador
         call leerDatoYPasarADec
         inc bl
         jmp while2
         
    asignador:
        cmp quienJuega, 1
        je asignJug2
        jmp asignJug1
        
    asignJug1:
        cmp bh, 1
        je segundoCasoCoordYJug1
        
        primerCasoCoordXJug1:
            mov al, auxiliarCoord
            mov auxiliarCoord, 0
            mov coordDisparoXJug1, al
            inc bh
            mov bl, 0
            mov dx, offset pedirDisparoYJug1
            call print
            jmp while2
            
        segundoCasoCoordYJug1:              
            mov al, auxiliarCoord
            mov auxiliarCoord, 0
            mov coordDisparoYJug1, al
            jmp exit2
            
    asignJug2:
        cmp bh, 1
        je segundoCasoCoordYJug2
        
        primerCasoCoordXJug2:
            mov al, auxiliarCoord
            mov auxiliarCoord, 0
            mov coordDisparoXJug2, al
            inc bh
            mov bl, 0
            mov dx, offset pedirDisparoYJug2
            call print
            jmp while2
            
        segundoCasoCoordYJug2:              
            mov al, auxiliarCoord
            mov auxiliarCoord, 0
            mov coordDisparoYJug2, al
            jmp exit2            

exit2:                
    ret
endp
    
 

mapaArriba db "00..........................WAR GAMES -1983...............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"08........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"09..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13,"$"

mapaAbajo db "10..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,"11..............:::++++:-............::+++:+:.............:--+--.-........",10,13,"12..............-+++++++++:...........+:+::+................--.....---....",10,13,"13................:++++++:...........-+::+::.:-................-++:-:.....",10,13,"14.................++::+-.............::++:..:...............++++++++-....",10,13,"15.................:++:-...............::-..................-+:--:++:.....",10,13,"16.................:+-............................................-.....--",10,13,"17.................:....................................................--",10,13,"18.......UNITED STATES.........................SOVIET UNION...............$"

auxiliarCoord db ?

baseSecretaXJug1 db ?

baseSecretaYJug1 db ?

baseSecretaXJug2 db ?

baseSecretaYJug2 db ?

quienJuega db ?

pedirBaseXJug1 db 10,13,"Jugador 1 Ingrese coordenada X de Base Secreta: $"

pedirBaseYJug1 db 10,13,"Jugador 1 Ingrese coordenada Y de Base Secreta: $"

pedirBaseXJug2 db 10,13,"Jugador 2 Ingrese coordenada X de Base Secreta: $"

pedirBaseYJug2 db 10,13,"Jugador 2 Ingrese coordenada Y de Base Secreta: $"

JuegaJug1 db 10,13,"Turno del Jugador 1$"

JuegaJug2 db 10,13,"Turno del Jugador 2$"

pedirDisparoXJug1 db 10,13,"Jugador 1 Ingrese coordenada X de su proximo ataque: $"

pedirDisparoYJug1 db 10,13,"Jugador 1 Ingrese coordenada Y de su proximo ataque: $"

pedirDisparoXJug2 db 10,13,"Jugador 2 Ingrese coordenada X de su proximo ataque: $"

pedirDisparoYJug2 db 10,13,"Jugador 2 Ingrese coordenada Y de su proximo ataque: $" 

coordDisparoXJug1 db ?

coordDisparoYJug1 db ?

coordDisparoXJug2 db ?

coordDisparoYJug2 db ?
