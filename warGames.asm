
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
    call initJuego
    ;call jugar
    ;call guardarRanking
ret 





proc initJuego
    call printMap
    call pedirCoordBase
    mov baseSecretaJug1, bl
    call pedirCoordBase
    mov baseSecretaJug2, bl
    ;call elegirTurno
    ;imprimir a quien le toca jugar
  ret
endp  
  

proc printMap
    mov ah,09
    mov dx,offset mapaArriba
    int 21h
    mov ah,09
    mov dx,offset mapaAbajo
    int 21h
  ret
endp

proc pedirCoordBase

  scanNumber:
    mov dl, 10
    mov bl, 0
    
    mov ah, 1
    int 21h
    
    cmp al, 13
    je exit
    
    mov ah, 0
    sub al, 48
    
    mov cl, al
    mov al, bl
    
    mul dl
    
    add al, cl
    mov bl, al
    
    jmp scanNumber
    
exit:        
  ret
endp     



mapaArriba db "00..........................WAR GAMES -1983...............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"08........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"09..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13,"$"

mapaAbajo db "10..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,"11..............:::++++:-............::+++:+:.............:--+--.-........",10,13,"12..............-+++++++++:...........+:+::+................--.....---....",10,13,"13................:++++++:...........-+::+::.:-................-++:-:.....",10,13,"14.................++::+-.............::++:..:...............++++++++-....",10,13,"15.................:++:-...............::-..................-+:--:++:.....",10,13,"16.................:+-............................................-.....--",10,13,"17.................:....................................................--",10,13,"18.......UNITED STATES.........................SOVIET UNION...............$"

baseSecretaJug1 db ?

baseSecretaJug2 db ? 




