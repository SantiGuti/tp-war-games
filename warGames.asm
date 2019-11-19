include macros.asm 
org 100h
inicializar_juego:
    call initJuego
    call jugar
    ;call guardarRanking
    call volverAJugar
ret 



proc initJuego
    printMap 
    mov game_over,0 
    mov base_urss_dest,0
    mov base_usa_dest,0
    mov cant_w_usa,40
    mov cant_w_urss, 54
    call pedirCoordBase
    call elegirTurno
    
  ret
endp  


proc jugar

ciclo_juego:
    cmp game_over,1
    je fin_juego 
    call informarPaisTurno
    call leerCoordenadas
    call disparar       
    call informarResultado
    printMap
    
    
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
    
    ciclo_coor_base_x_j1:
        printMsg pedirBaseXJug1,21
        call pedirInput 
        mov baseSecretaXJug1,al
        cmp al,33               ; se valida que la coordenada X ingresada para USA no sea mayor a 33
        jbe ciclo_coor_base_y_j1 
        printMsg msgCoorXInc,23
        jmp ciclo_coor_base_x_j1
    
    
    ciclo_coor_base_y_j1:
        printMsg pedirBaseYJug1,21
        call pedirInput
        mov baseSecretaYJug1,al
        cmp al,18                ; se valida que la coor Y ingresada no sea mayor a 18
        jbe ciclo_coor_base_x_j2 
        printMsg msgCoorYInc,23
        jmp ciclo_coor_base_y_j1
    
    
    ciclo_coor_base_x_j2:
        printMsg pedirBaseXJug2,21
        call pedirInput 
        mov baseSecretaXJug2,al
        cmp al,33               ; se valida que la coordenada X ingresada para URSS sea mayor a 33
        ja ciclo_coor_base_y_j2 
        printMsg msgCoorXInc,23
        jmp ciclo_coor_base_x_j2
    
    
    ciclo_coor_base_y_j2:
        printMsg pedirBaseYJug2,21
        call pedirInput
        mov baseSecretaYJug2,al
        cmp al,18              ; se valida que la coor Y ingresada no sea mayor a 18
        jbe fin_pedirCoordBase 
        printMsg msgCoorYInc,23
        jmp ciclo_coor_base_y_j2 
   
   fin_pedirCoordBase:         
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
    printMsg JuegaJug1,20
    ciclo_disparo_X_j1:
        printMsg pedirDisparoX,21
        call pedirInput 
        mov coordDisparoXJug1,al        
        cmp coordDisparoXJug1,71
        jbe ciclo_disparo_Y_j1
        printMsg msgCoorXInc,23
        jmp ciclo_disparo_X_j1
        
        
    ciclo_disparo_Y_j1:
        printMsg pedirDisparoY,21
        call pedirInput
        mov coordDisparoYJug1,al
        cmp coordDisparoYJug1,18
        jbe fin_leerCoordenadas  
        printMsg msgCoorYInc,23
        jmp ciclo_disparo_Y_j1
        
    dispJug2:
        printMsg JuegaJug2,20 
    ciclo_disparo_X_j2:
        printMsg pedirDisparoX,21
        call pedirInput 
        mov coordDisparoXJug2,al 
        cmp  coordDisparoXJug2,71
        jbe ciclo_disparo_Y_j2
        printMsg msgCoorXInc,23
        jmp ciclo_disparo_X_j2
        
    ciclo_disparo_Y_j2:
        printMsg pedirDisparoY,21
        call pedirInput
        mov coordDisparoYJug2,al   
        cmp coordDisparoYJug2,18
        jbe fin_leerCoordenadas  
        printMsg msgCoorYInc,23
        jmp ciclo_disparo_Y_j2
    
    fin_leerCoordenadas:                    
    ret
endp

proc disparar 
    
    xor bx,bx
    xor dx,dx
    xor cx,cx   
    ;Se evalua el jugador q realizao el disparo
    cmp quienJuega, 1 
    je jugoJug2
    
    jugoJug1:
    ;se mueven las coordenadas a los registros utilizados para actualizar el mapa
    mov cl,coordDisparoYJug1
    mov bl,coordDisparoXJug1
    call actualizarMapa
    jmp  fin_disparar
    
    jugoJug2:
    ;se mueven las coordenadas a los registros utilizados para actualizar el mapa
    mov cl,coordDisparoYJug2
    mov bl,coordDisparoXJug2
    call actualizarMapa
    jmp  fin_disparar
      
    
    fin_disparar:
    ret
endp 


proc actualizarMapa 
    
    mov act_arriba,0
    mov act_abajo,0 
    mov act_der,0 
    mov act_izq,0 
        
    mov ax,76
    mul cx
    mov dx,bx
    mov bx,offset mapaArriba
    add bx,ax ;sumo las pos Y
    add bx,dx ;sumo las pos X
    add bx,2 ;me corro solo dos en caso de Y = 0
    cmp [bx],20h ;20h = espacio, si el disparo se realizo sobre un espacio se invalida
    je  fin_actualizarMapa

    ;se mueve espacio a las pos de la linea donde se realizo el disparo
    cmp [bx],57h ; 57h = W
    jne no_restar_w1
    cmp dx,30  ; Si el disparo se hizo en y <= 30 se resta W de USA, sino de URSS
    jae restar_urss1
    sub cant_w_usa,1
    jmp no_restar_w1
restar_urss1:
    sub cant_w_urss,1
no_restar_w1:
    mov [bx],20h 
     
    ;Evaluo si el proximo caracter es un salto de linea
    cmp [bx+1],0Ah 
    je no_act_der
    mov act_der,1
    cmp [bx+1],57h ; 57h = W
    jne no_restar_w2
    cmp dx,30
    jae restar_urss2
    sub cant_w_usa,1
    jmp no_restar_w2
restar_urss2:
    sub cant_w_urss,1
    
no_restar_w2:
    mov [bx+1],20h
    no_act_der:
    ;Evaluo si el disparo se hizo en X=0
    cmp dx,0
    je no_act_izq
    mov act_izq,1
    cmp [bx-1],57h ; 57h = W
    jne no_restar_w3
    cmp dx,30
    jae restar_urss3
    sub cant_w_usa,1
    jmp no_restar_w3
restar_urss3:
    sub cant_w_urss,1
no_restar_w3:
    mov [bx-1],20h
    no_act_izq:
    
    ;Evaluo si el disparo se hizo en Y=0
    cmp ax,0
    je no_act_arriba
    mov act_arriba,1
    cmp ax,760 ; 76*10 = 760 -- primer linea mapa abajo
    jne no_restar_arriba
    cmp [bx-1-76],57h ; 57h = W
    jne no_restar_w4
    cmp dx,30
    jae restar_urss4
    sub cant_w_usa,1
    jmp no_restar_w4
restar_urss4:
    sub cant_w_urss,1
no_restar_w4:
    mov [bx-1-76],20h; se resta 1 por el caracter $
    jmp no_act_arriba
    no_restar_arriba:
    cmp [bx-76],57h ; 57h = W
    jne no_restar_w5
    cmp dx,30
    jae restar_urss5
    sub cant_w_usa,1
    jmp no_restar_w5
restar_urss5:
    sub cant_w_urss,1
no_restar_w5:
    mov [bx-76],20h
    no_act_arriba:
    
    ;Evaluo si el disparo se hizo en Y=18, 76*18=1368 - ultima linea del mapa
    cmp ax,1368
    je  no_act_abajo
    mov act_abajo,1
    cmp ax,684 ; 76*9 = 684 -- ultimalinea mapa arriba
    jne no_sumar_abajo
    cmp [bx+1+76],57h ; 57h = W
    jne no_restar_w6
    cmp dx,30
    jae restar_urss6
    sub cant_w_usa,1
    jmp no_restar_w6
restar_urss6:
    sub cant_w_urss,1
no_restar_w6:
    mov [bx+1+76],20h; se suma 1 por el caracter $
    jmp no_act_abajo
    no_sumar_abajo:
    cmp [bx+76],57h ; 57h = W
    jne no_restar_w7
    cmp dx,30
    jae restar_urss7
    sub cant_w_usa,1
    jmp no_restar_w7
restar_urss7:
    sub cant_w_urss,1
no_restar_w7:
    mov [bx+76],20h
    no_act_abajo:
    
    ;Evaluo si se debe actualizar la esquina superior izquierda 
    mov ch,act_izq
    cmp ch,act_arriba
    jne no_act_esq_sup_izq
    cmp ax,760 ; 76*10 = 760 -- primer linea mapa abajo
    jne  no_restar_arriba_izq
    cmp [bx-76-2],57h ; 57h = W
    jne no_restar_w8
    cmp dx,30
    jae restar_urss8
    sub cant_w_usa,1
    jmp no_restar_w8
restar_urss8:
    sub cant_w_urss,1
no_restar_w8:
    mov [bx-76-2],20h
    jmp no_act_esq_sup_izq
    no_restar_arriba_izq:
    cmp [bx-76-1],57h ; 57h = W
    jne no_restar_w9
    cmp dx,30
    jae restar_urss9
    sub cant_w_usa,1
    jmp no_restar_w9
restar_urss9:
    sub cant_w_urss,1
no_restar_w9:
    mov [bx-76-1],20h
    no_act_esq_sup_izq:
    
    ;Evaluo si se debe actualizar la esquina superior derecha 
    mov ch,act_der
    cmp ch,act_arriba
    jne no_act_esq_sup_der
    cmp ax,760 ; 76*10 = 760 -- primer linea mapa abajo
    jne  no_restar_arriba_der
    cmp [bx-76],57h ; 57h = W
    jne no_restar_w10
    cmp dx,30
    jae restar_urss10
    sub cant_w_usa,1
    jmp no_restar_w10
restar_urss10:
    sub cant_w_urss,1
no_restar_w10:
    mov [bx-76],20h
    jmp no_act_esq_sup_der
    no_restar_arriba_der:
    cmp [bx-76+1],57h ; 57h = W
    jne no_restar_w11
    cmp dx,30
    jae restar_urss11
    sub cant_w_usa,1
    jmp no_restar_w11
restar_urss11:
    sub cant_w_urss,1
no_restar_w11:
    mov [bx-76+1],20h
    no_act_esq_sup_der:    
    
    ;Evaluo si se debe actualizar la esquina inferior izquierda
    cmp act_abajo,1
    jne fin_actualizarMapa
    cmp dx,0
    je no_act_esq_inf_izq 
    cmp ax,684 ; 76*9 = 684 -- ultima linea mapa arriba
    jne no_sumar_abajo_izq
    cmp [bx+76],57h ; 57h = W
    jne no_restar_w12
    cmp dx,30
    jae restar_urss12
    sub cant_w_usa,1
    jmp no_restar_w12
restar_urss12:
    sub cant_w_urss,1
no_restar_w12:
    mov [bx+76],20h
    jmp no_act_esq_inf_izq
    no_sumar_abajo_izq:
    cmp [bx+76-1],57h ; 57h = W
    jne no_restar_w13
    cmp dx,30
    jae restar_urss13
    sub cant_w_usa,1
    jmp no_restar_w13
restar_urss13:
    sub cant_w_urss,1
no_restar_w13:
    mov [bx+76-1],20h
    no_act_esq_inf_izq:
   
    ;Evaluo si se debe actualizar la esquina inferior derecha
    cmp [bx+1],0Ah
    je fin_actualizarMapa 
    cmp ax,684 ; 76*9 = 684 -- ultima linea mapa arriba
    jne no_sumar_abajo_der
    cmp [bx+76+2],57h ; 57h = W
    jne no_restar_w14
    cmp dx,30
    jae restar_urss14
    sub cant_w_usa,1
    jmp no_restar_w14
restar_urss14:
    sub cant_w_urss,1
no_restar_w14:
    mov [bx+76+2],20h
    jmp fin_actualizarMapa
    no_sumar_abajo_der:
    cmp [bx+76+1],57h ; 57h = W
    jne no_restar_w15
    cmp dx,30
    jae restar_urss15
    sub cant_w_usa,1
    jmp no_restar_w15
restar_urss15:
    sub cant_w_urss,1
no_restar_w15:
    mov [bx+76+1],20h       
        
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

proc informarResultado
    
        
    mov bx,offset mapaArriba    
    call verificarBases
    
base_usa:   
    cmp base_usa_dest,1
    jne base_urss
    mov game_over,1
    jmp fin_informarResultado 

base_urss:
    cmp base_urss_dest,1
    jne verificar_w_usa
    mov game_over,1
    jmp fin_informarResultado
 
verificar_w_usa:
    cmp  cant_w_usa,0
    jne  verificar_w_urss 
    mov game_over,1
    jmp fin_informarResultado 
    
verificar_w_urss:
    cmp  cant_w_urss,0
    jne  fin_informarResultado 
    mov game_over,1
     

fin_informarResultado:
    ret
endp  

proc verificarBases
    
    xor cx,cx
    ;Se evalua el jugador q realizao el disparo
    ;Si jugo USA se evalua la base de URSS
    ;Si jugo URSS se evalua la base de USA
    cmp quienJuega, 1 
    je jugo_urss
jugo_usa:
    mov al,coordDisparoXJug1
    mov ah,coordDisparoYJug1
    jmp verificar_base_usa
jugo_urss:    
    mov al,coordDisparoXJug2
    mov ah,coordDisparoYJug2

verificar_base_usa:     
    cmp al,baseSecretaXJug1
    jne comp_usa_X_men_1
    mov cl,1
    jmp comp_usa_Y 

comp_usa_X_men_1:
    dec al
    cmp al,baseSecretaXJug1
    jne comp_usa_X_mas_1
    mov cl, 1
    jmp comp_usa_Y
    
comp_usa_X_mas_1:
    add al,2
    cmp al,baseSecretaXJug1
    jne comp_usa_Y
    mov cl, 1
        
comp_usa_Y:
    cmp ah,baseSecretaYJug1
    jne comp_usa_Y_men_1
    mov ch, 1
    jmp comparar_flags_usa 

comp_usa_Y_men_1:
    dec ah
    cmp ah,baseSecretaYJug1
    jne comp_usa_Y_mas_1
    mov ch, 1
    jmp comparar_flags_usa
    
comp_usa_Y_mas_1:
    add ah,2
    cmp ah,baseSecretaYJug1
    jne fin_verificarBases
    mov ch, 1

comparar_flags_usa:
    cmp ch,1
    jne verificar_base_urss
    cmp cl,1
    jne verificar_base_urss 
    mov base_usa_dest,1         


verificar_base_urss:
    xor cx,cx 
    cmp al,baseSecretaXJug2
    jne comp_urss_X_men_1
    mov cl,1
    jmp comp_urss_Y 

comp_urss_X_men_1:
    dec al
    cmp al,baseSecretaXJug2
    jne comp_urss_X_mas_1
    mov cl, 1
    jmp comp_urss_Y
    
comp_urss_X_mas_1:
    add al,2
    cmp al,baseSecretaXJug2
    jne comp_urss_Y
    mov cl, 1
        
comp_urss_Y:
    cmp ah,baseSecretaYJug2
    jne comp_urss_Y_men_1
    mov ch, 1
    jmp comparar_flags_urss 

comp_urss_Y_men_1:
    dec ah
    cmp ah,baseSecretaYJug2
    jne comp_urss_Y_mas_1
    mov ch, 1
    jmp comparar_flags_urss
    
comp_urss_Y_mas_1:
    add ah,2
    cmp ah,baseSecretaYJug2
    jne fin_verificarBases
    mov ch, 1

comparar_flags_urss:
    cmp ch, 1 
    jne fin_verificarBases
    cmp cl,1 
    jne fin_verificarBases
    mov base_urss_dest,1
      
    
fin_verificarBases:
    ret
endp


proc volverAJugar  

    mov visualizarInput,1
    
    cmp base_usa_dest,1
    jne check_base_urss
    cmp base_urss_dest,1
    jne check_base_usa
    printMsg empate,23
    jmp ciclo_volver_a_jugar
    
    
 check_base_usa:
    cmp base_usa_dest,1
    jne check_base_urss
    printMsg ganoURSSb,23
    jmp ciclo_volver_a_jugar 

check_base_urss:
    cmp base_urss_dest,1
    jne check_w_usa
    printMsg ganoUSAb,23
    jmp ciclo_volver_a_jugar
 
check_w_usa:
    cmp  cant_w_usa,0
    jne  check_w_urss 
    printMsg ganoURSSw,23
    jmp fin_informarResultado 
    
check_w_urss:
    cmp  cant_w_urss,0
    jne  ciclo_volver_a_jugar 
    printMsg ganoUSAw,23
     
ciclo_volver_a_jugar:      
    printMsg msgVolverAJugar,21
    call pedirInput
    cmp al, 1Eh ; Se evalua si se presiono N (menos 48)
    je  fin_volverAJugar
    cmp al, 3Eh ; Se evalua si se presiono n (menos 48)
    je  fin_volverAJugar
    cmp al, 29h ; Se evalua si se presiono Y (menos 48)
    je  volver_a_jugar
    cmp al, 49h ; Se evalua si se presiono y (menos 48)
    je  volver_a_jugar
    printMsg opcionInvalida,23
    jmp ciclo_volver_a_jugar
     
volver_a_jugar: 
    printMsg msgLoadMap,23   
    call cargarMapa
    jmp inicializar_juego
    
fin_volverAJugar:
    ret
endp  

proc cargarMapa
    
    mov si,0
cargar_mapa_arriba:
    mov bx,offset mapaArriba_inicial
    mov al,[bx+si]
    mov bx,offset mapaArriba
    mov [bx+si],al 
    inc si
    cmp al,24h; 24h = $
    je cargar_mapa_abajo
    jmp cargar_mapa_arriba    

cargar_mapa_abajo:    
    mov si,0
ciclo_mapa_abajo:
    mov bx,offset mapaAbajo_inicial
    mov al,[bx+si]
    mov bx,offset mapaAbajo
    mov [bx+si],al 
    inc si
    cmp al,24h; 24h = $
    jne ciclo_mapa_abajo
    
    ret
endp


mapaArriba db "00..........................WAR GAMES -1983...............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"07.......:*=+:=*=..............-+++++:::::-:+::++++++:+++++++++...........",10,13,"08........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"09..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13,"$"

mapaAbajo  db "10..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,"11..............:::++++:-............::+++:+:.............:--+--.-........",10,13,"12..............-+++++++++:...........+:+::+................--.....---....",10,13,"13................:++++++:...........-+::+::.:-................-++:-:.....",10,13,"14.................++::+-.............::++:..:...............++++++++-....",10,13,"15.................:++:-...............::-..................-+:--:++:.....",10,13,"16.................:+-............................................-.....--",10,13,"17.................:....................................................--",10,13,"18.......UNITED STATES.........................SOVIET UNION...............",10,13,"--0....5....10...15...20...25...30...35...40...45...50...55...60...65...70$"

mapaArriba_inicial db "00..........................WAR GAMES -1983...............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"07.......:*=+:=*=..............-+++++:::::-:+::++++++:+++++++++...........",10,13,"08........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"09..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13,"$"

mapaAbajo_inicial db "10..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,"11..............:::++++:-............::+++:+:.............:--+--.-........",10,13,"12..............-+++++++++:...........+:+::+................--.....---....",10,13,"13................:++++++:...........-+::+::.:-................-++:-:.....",10,13,"14.................++::+-.............::++:..:...............++++++++-....",10,13,"15.................:++:-...............::-..................-+:--:++:.....",10,13,"16.................:+-............................................-.....--",10,13,"17.................:....................................................--",10,13,"18.......UNITED STATES.........................SOVIET UNION...............",10,13,"--0....5....10...15...20...25...30...35...40...45...50...55...60...65...70$"

auxiliarCoord db ?

baseSecretaXJug1 db ?

baseSecretaYJug1 db ?

baseSecretaXJug2 db ?

baseSecretaYJug2 db ?

quienJuega db ?

pedirBaseXJug1 db "UNITED STATES Ingrese coordenada X de Base Secreta: $"

pedirBaseYJug1 db "UNITED STATES Ingrese coordenada Y de Base Secreta: $"

pedirBaseXJug2 db "SOVIET UNION Ingrese coordenada X de Base Secreta: $"

pedirBaseYJug2 db "SOVIET UNION Ingrese coordenada Y de Base Secreta: $"

JuegaJug1 db "Turno de UNITED STATES$"

JuegaJug2 db "Turno de SOVIET UNION$"

pedirDisparoX db "Ingrese coordenada X de su proximo ataque: $"

pedirDisparoY db "Ingrese coordenada Y de su proximo ataque: $" 

msgCoorXInc db "Valor de coordenada X fuera de rango. Ingrese un nuevo valor$" 

msgCoorYInc db "Valor de coordenada Y fuera de rango. Ingrese un nuevo valor$"

ganoURSSw db "UNITED STATES fue destruido gana SOVIET UNION!!$"

ganoUSAw db "SOVIET UNION fue destruido gana UNITED STATES!!$" 

ganoURSSb db "Base Secreta de UNITED STATES fue destruida gana SOVIET UNION!!$"

ganoUSAb db "Base Secreta de SOVIET UNION fue destruida gana UNITED STATES!!$" 

empate db "Empate!! La base secreta de ambos paises fue destruida$"

opcionInvalida db "La opcion elegida no es valida. Valores posibles Y, y, N, n$" 

msgVolverAJugar db "Desean jugar nuevamente (Y/N) ? $"  

msgLoadMap db "Recargado mapa....$"

coordDisparoXJug1 db ?

coordDisparoYJug1 db ?

coordDisparoXJug2 db ?

coordDisparoYJug2 db ?  

inputDec db ?

inputUni db ?

cantInput db ?

visualizarInput db ?

cleanline db "                                                                  $" 

act_arriba db ?

act_abajo db ?

act_der db ?

act_izq db ?

cant_w_usa db ?

cant_w_urss db ? 

game_over db ?   

base_urss_dest db ?

base_usa_dest db ?  

usa_w_L2 db 5,6,7,8,9,10,11,13,14,15,0

usa_w_L3 db 8,9,10,11,12,13,14,15,19,20,0

usa_w_L4 db 8,9,10,11,12,13,16,17,18,0

usa_w_L5 db 7,8,9,10,11,12,13,14,15,0

usa_w_l6 db 10,11,0

