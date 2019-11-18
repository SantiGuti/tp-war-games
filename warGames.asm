include macros.asm 
org 100h
    call initJuego
    call jugar
    ;call guardarRanking
ret 



proc initJuego
    printMap
    call pedirCoordBase
    call elegirTurno
    
  ret
endp  

proc jugar

ciclo_juego:
    printMap 
    call informarPaisTurno
    call leerCoordenadas
    call disparar
    ;call informarResultado
    ;call actualizarSiguienteTurno
    jmp ciclo_juego
    
fin_juego:
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

proc pedirCoordBase ;Pide las coordenadas de la base secreta
    mov visualizarInput,0
    
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
        mov bh, 2
        mov quienJuega, bh
        jmp salir
    
    Juega2:
        mov bh, 1
        mov quienJuega, bh
        jmp salir
    
salir:
    ret
endp

proc leerCoordenadas ;Pide las coordenadas del disparo
    mov bh, 0
    mov visualizarInput,1
    cmp quienJuega, 1 ;Los saltos estan al reves aproposito ya que quienJuega se le suma 1 justo despues de avisar de quien es el turno
    je dispJug2
    
    dispJug1:
        printTurno JuegaJug1
        printMsg pedirDisparoXJug1
        call pedirInput 
        mov coordDisparoXJug1,al
        
        printMsg pedirDisparoYJug1
        call pedirInput
        mov coordDisparoYJug1,al
        jmp fin_leerCoordenadas
        
    dispJug2:
        printTurno JuegaJug2
        printMsg pedirDisparoXJug2
        call pedirInput 
        mov coordDisparoXJug2,al
        
        printMsg pedirDisparoYJug2
        call pedirInput
        mov coordDisparoYJug2,al
    
    fin_leerCoordenadas:                    
    ret
endp

proc disparar 
    
    xor bx,bx
    xor dx,dx   
    ;Se evalua el jugador q realizao el disparo
    cmp quienJuega, 1 
    je jugoJug2
    
    ;se verifica que las coordenadas ingresadas sean validas
    jugoJug1:
    cmp  coordDisparoXJug1,71
    ja  coorInvalida
    cmp  coordDisparoYJug1,18
    ja  coorInvalida
    ;se mueven las coordenadas a los registros utilizados para actualizar el mapa
    mov dl,coordDisparoYJug1
    mov bl,coordDisparoXJug1
    call actualizarMapa
    jmp  fin_disparar
    jugoJug2:
    cmp  coordDisparoXJug2,71
    ja  coorInvalida
    cmp  coordDisparoYJug2,18
    ja  coorInvalida
    ;se mueven las coordenadas a los registros utilizados para actualizar el mapa
    mov dl,coordDisparoYJug2
    mov bl,coordDisparoXJug2
    call actualizarMapa
    jmp  fin_disparar
    
    coorInvalida:
    
    
    fin_disparar:
    ret
endp 


proc actualizarMapa 
    
    mov act_arriba,0
    mov act_abajo,0 
    mov act_der,0 
    mov act_izq,0 
        
    mov ax,76
    mul dx

    mov dx,bx
    mov bx,offset mapaArriba
    add bx,ax ;sumo las pos Y
    add bx,dx ;sumo las pos X
    cmp ax,0
    je  sumar_2
    add bx,3  ;me corro 3 caracteres por los numeros de coordenadas
    jmp fin_sumar
    sumar_2:
    add bx,2 ;me corro solo dos en caso de Y = 0
    fin_sumar:
    mov cl,[bx]
    cmp cl,espacio 
    je  fin_actualizarMapa
    
    mov cl,espacio
    ;se mueve espacio a las pos de la linea donde se realizo el disparo
    mov [bx],cl 
     
    ;Evaluo si el proximo caracter es un salto de linea
    cmp [bx+1],0Ah 
    je no_act_der
    mov act_der,1
    mov [bx+1],cl
    no_act_der:
    ;Evaluo si el disparo se hizo en X=0
    cmp dx,0
    je no_act_izq
    mov act_izq,1
    mov [bx-1],cl
    no_act_izq:
    
    ;Evaluo si el disparo se hizo en Y=0
    cmp ax,0
    je no_act_arriba
    mov act_arriba,1
    cmp ax,760 ; 76*10 = 760 -- primer linea mapa abajo
    jne no_restar_arriba
    mov [bx-1-76],cl; se resta 1 por el caracter $
    jmp no_act_arriba
    no_restar_arriba:
    mov [bx-76],cl
    no_act_arriba:
    
    ;Evaluo si el disparo se hizo en Y=18, 76*18=1368 - ultima linea del mapa
    cmp ax,1368
    je  no_act_abajo
    mov act_abajo,1
    cmp ax,684 ; 76*9 = 684 -- ultimalinea mapa arriba
    jne no_sumar_abajo
    mov [bx+1+76],cl; se suma 1 por el caracter $
    jmp no_act_abajo
    no_sumar_abajo:
    mov [bx+76],cl
    no_act_abajo:
    
    ;Evaluo si se debe actualizar la esquina superior izquierda 
    mov ch,act_izq
    cmp ch,act_arriba
    jne no_act_esq_sup_izq
    cmp ax,760 ; 76*10 = 760 -- primer linea mapa abajo
    jne  no_restar_arriba_izq
    mov [bx-76-2],cl
    jmp no_act_esq_sup_izq
    no_restar_arriba_izq:
    mov [bx-76-1],cl
    no_act_esq_sup_izq:
    
    ;Evaluo si se debe actualizar la esquina superior derecha 
    mov ch,act_der
    cmp ch,act_arriba
    jne no_act_esq_sup_der
    cmp ax,760 ; 76*10 = 760 -- primer linea mapa abajo
    jne  no_restar_arriba_der
    mov [bx-76],cl
    jmp no_act_esq_sup_der
    no_restar_arriba_der:
    mov [bx-76+1],cl
    no_act_esq_sup_der:    
    
    ;Evaluo si se debe actualizar la esquina inferior izquierda
    cmp act_abajo,1
    jne fin_actualizarMapa
    cmp dx,0
    je no_act_esq_inf_izq 
    cmp ax,684 ; 76*9 = 684 -- ultima linea mapa arriba
    jne no_sumar_abajo_izq
    mov [bx+76],cl
    jmp no_act_esq_inf_izq
    no_sumar_abajo_izq:
    mov [bx+76-1],cl
    no_act_esq_inf_izq:
   
    ;Evaluo si se debe actualizar la esquina inferior derecha
    cmp [bx+1],0Ah
    je fin_actualizarMapa 
    cmp ax,684 ; 76*9 = 684 -- ultima linea mapa arriba
    jne no_sumar_abajo_der
    mov [bx+76+2],cl
    jmp fin_actualizarMapa
    no_sumar_abajo_der:
    mov [bx+76+1],cl       
    
    
    fin_actualizarMapa:
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
        
        cmp cantInput,2
        je  ciclo_input    
        cmp visualizarInput,0
        je  no_visualizar
        
    visualizar:
        mov ah,02h
        mov dl,al
        int 21h

    no_visualizar:    
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
        
        cmp visualizarInput,0
        je  solo_borrar
        cmp cantInput,0
        je  ciclo_input      
        mov ah, 02h         ; Se muestra el caracter
        mov dl, 08h         ; Se utiliza caracter backspace para mover el cursor hacia atras 
        int 21h        
        mov dl, 20h         ; Se muestra un espacio para limpiar el caracter anterior 
        int 21h 
        mov dl, 08h         ; Se utiliza caracter backspace para mover el cursor hacia atras 
        int 21h 

    solo_borrar:            
        cmp cantInput, 1
        je borrarDec
    borrarUni:
        cmp cantInput,0
        je  sin_accion
        mov inputUni,0
        add cantInput,-1
        mov al,08
    sin_accion:
        jmp ciclo_input
        
    borrarDec:
        mov inputDec,0
        add cantInput,-1
        mov al,08
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



mapaArriba db "00..........................WAR GAMES -1983...............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"07.......:*=+:=*=..............-+++++:::::-:+::++++++:+++++++++...........",10,13,"08........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"09..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13,"$"

mapaAbajo db "10..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,"11..............:::++++:-............::+++:+:.............:--+--.-........",10,13,"12..............-+++++++++:...........+:+::+................--.....---....",10,13,"13................:++++++:...........-+::+::.:-................-++:-:.....",10,13,"14.................++::+-.............::++:..:...............++++++++-....",10,13,"15.................:++:-...............::-..................-+:--:++:.....",10,13,"16.................:+-............................................-.....--",10,13,"17.................:....................................................--",10,13,"18.......UNITED STATES.........................SOVIET UNION...............",10,13,"--0....5....10...15...20...25...30...35...40...45...50...55...60...65...70$"

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

visualizarInput db ?

cleanline db "                                                           $" 

w db "W"

espacio db " "  

act_arriba db ?
act_abajo db ?
act_der db ?
act_izq db ?