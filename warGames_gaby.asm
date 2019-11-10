include macros.asm 
org 100h
    call initJuego
    call jugar
    ;call guardarRanking
ret 



proc initJuego
    ;call printMap
    call pedirCoordBase
    call elegirTurno
    
  ret
endp  

proc jugar
    ;call printMap
    call informarPaisTurno
    call leerCoordenadas
    ;call disparar
    ;call informarResultado
    ;call actualizarSiguienteTurno
ret
endp

;proc print ;Para el flujo del programa para imprimir algo
;    mov ah, 09
;    int 21h
;    ret
;endp

;proc clearScreen ;Limpia todos los print que van quedando
;    mov ah, 0x00
;    mov al, 0x03 
;    int 0x10
;    ret
;endp


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
     
;proc printMap ;Imprime el mapa del juego
;    mov dx,offset mapaArriba
;   call print
;    mov dx,offset mapaAbajo
;    call print
;  ret
;endp

proc pedirCoordBase ;Pide las coordenadas de la base secreta
    printMap
    
    printMsg pedirBaseXJug1
    call pedirInput 
    mov baseSecretaXJug1,al
    
    printMsg pedirBaseYJug1
    call pedirInput
    mov baseSecretaYJug1,al
    
    printMsg pedirBaseXJug2
    call pedirInput 
    mov baseSecretaXJug2,al
    
    printMsg pedirBaseYJug2
    call pedirInput
    mov baseSecretaYJug2,al 
    
   
;    mov bl, 0
;    mov bh, 0
;    mov dx, offset pedirBaseXJug1
;    printMap 
;    printMsg pedirBaseXJug1
;    while:
;        cmp bl, 2
;        je selector
;        call leerDatoYPasarADec
;        inc bl
;        jmp while
;        
;    selector:
;        cmp bh, 0
;        je caso1
;        cmp bh, 1
;        je caso2
;        cmp bh, 2
;        je caso3
;        cmp bh, 3
;        je caso4
;                    
;    caso1:
;        mov al, auxiliarCoord
;        mov auxiliarCoord, 0
;        mov baseSecretaXJug1, al
;        inc bh
;        mov bl, 0
;        ;mov dx, offset pedirBaseYJug1 
;        printMsg pedirBaseYJug1
;        jmp while
;    caso2:
;        mov al, auxiliarCoord
;        mov auxiliarCoord, 0
;        mov baseSecretaYJug1, al
;        inc bh
;        mov bl, 0
;        ;mov dx, offset pedirBaseXJug2
;        printMsg pedirBaseXJug2
;        jmp while
;    caso3:
;        mov al, auxiliarCoord
;        mov auxiliarCoord, 0
;        mov baseSecretaXJug2, al
;        inc bh
;        mov bl, 0
;        ;mov dx, offset pedirBaseYJug2
;        printMsg pedirBaseYJug2
;        jmp while
;    caso4:
;        mov al, auxiliarCoord
;        mov auxiliarCoord, 0
;        mov baseSecretaYJug2, al
;        ;call clearScreen
;        jmp exit
;exit:        
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
        ;mov dx, offset JuegaJug1
        mov bh, 2
        mov quienJuega, bh
        jmp salir
    
    Juega2:
        ;mov dx, offset JuegaJug2
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
        ;mov bl, 0
        ;mov dx, offset pedirDisparoXJug1        
        ;jmp while2 
        printTurno JuegaJug1
        printMsg pedirDisparoXJug1
        call pedirInput 
        mov coordDisparoXJug1,al
        
        printMsg pedirDisparoYJug1
        call pedirInput
        mov coordDisparoYJug1,al
        
    dispJug2:
        ;mov bl, 0
        ;mov dx, offset pedirDisparoXJug2
        ;jmp while2
        printTurno JuegaJug2
        printMsg pedirDisparoXJug2
        call pedirInput 
        mov coordDisparoXJug2,al
        
        printMsg pedirDisparoYJug2
        call pedirInput
        mov coordDisparoYJug2,al
         
        
;    while2:
;         cmp bl, 2
;         je asignador
;         call leerDatoYPasarADec
;         inc bl
;         jmp while2
;         
;    asignador:
;        cmp quienJuega, 1
;        je asignJug2
;        jmp asignJug1
;        
;    asignJug1:
;        cmp bh, 1
;        je segundoCasoCoordYJug1
;        
;        primerCasoCoordXJug1:
;            mov al, auxiliarCoord
;            mov auxiliarCoord, 0
;            mov coordDisparoXJug1, al
;            inc bh
;            mov bl, 0
;            ;mov dx, offset pedirDisparoYJug1
;            printMsg pedirDisparoYJug1
;            jmp while2
;            
;        segundoCasoCoordYJug1:              
;            mov al, auxiliarCoord
;            mov auxiliarCoord, 0
;            mov coordDisparoYJug1, al
;            jmp exit2
;            
;    asignJug2:
;        cmp bh, 1
;        je segundoCasoCoordYJug2
;        
;        primerCasoCoordXJug2:
;            mov al, auxiliarCoord
;            mov auxiliarCoord, 0
;            mov coordDisparoXJug2, al
;            inc bh
;            mov bl, 0
;            ;mov dx, offset pedirDisparoYJug2
;            printMsg pedirDisparoYJug2
;            jmp while2
;            
;        segundoCasoCoordYJug2:              
;            mov al, auxiliarCoord
;            mov auxiliarCoord, 0
;            mov coordDisparoYJug2, al
;            jmp exit2            ;

;exit2:                
    ret
endp

;Evalua y procesa el input de la coornedad ingresadas por el jugador y guarda el resultado en al
;Se debe precionar enter para guardar la coordenada
;Se debe precionar backspace para eliminar el ultimo input 
proc pedirInput 
    
    mov cantInput,0
    mov inputDec,0
    mov inputUni,0
    ciclo_input:
        mov ah,7
        int 21h
        cmp al,13 ;evaluo si se presiono enter
        je  guardarCoor
        cmp al,08 ;evaluo si se presiono backspace
        je  borrarInput
        
        cmp cantInput, 2 ;si ya se ingresaron dos numeros, las unicas opciones disponibles son enter o backspace 
        je ciclo_input
        
        sub al,48
        cmp cantInput,0
        je decimal
    unidad:
        mov inputUni, al
        add cantInput,1
        jmp ciclo_input 
        
    decimal:
        mov inputDec,al
        add cantInput,1
        jmp ciclo_input    
    
    borrarInput:
        cmp cantInput, 1
        je borrarDec
    borrarUni:
        cmp cantInput,0
        je  sin_accion
        mov inputUni,0
        add cantInput,-1
    sin_accion:
        jmp ciclo_input
        
    borrarDec:
        mov inputDec,0
        add cantInput,-1
        jmp ciclo_input
        
    
    guardarCoor:
        mov al,inputDec
        cmp cantInput,2
        je  guardarConDec
        jmp fin_input
    guardarConDec:
        mov bl,10
        mul bl
        add al,inputUni
    
    fin_input:
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

pedirBaseXJug1 db "Jugador 1 Ingrese coordenada X de Base Secreta: $"

pedirBaseYJug1 db "Jugador 1 Ingrese coordenada Y de Base Secreta: $"

pedirBaseXJug2 db "Jugador 2 Ingrese coordenada X de Base Secreta: $"

pedirBaseYJug2 db "Jugador 2 Ingrese coordenada Y de Base Secreta: $"

JuegaJug1 db "Turno del Jugador 1$"

JuegaJug2 db "Turno del Jugador 2$"

pedirDisparoXJug1 db "Jugador 1 Ingrese coordenada X de su proximo ataque: $"

pedirDisparoYJug1 db "Jugador 1 Ingrese coordenada Y de su proximo ataque: $"

pedirDisparoXJug2 db "Jugador 2 Ingrese coordenada X de su proximo ataque: $"

pedirDisparoYJug2 db "Jugador 2 Ingrese coordenada Y de su proximo ataque: $" 

coordDisparoXJug1 db ?

coordDisparoYJug1 db ?

coordDisparoXJug2 db ?

coordDisparoYJug2 db ?  

inputDec db ?

inputUni db ?

cantInput db ?

cleanline db "                                                           $"