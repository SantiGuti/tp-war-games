
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
    mov bl, 0
    mov bh, 0
    while:
        cmp bl, 2
        je selector
        mov ah, 7
        int 21h
        sub al, 48
        mov cl, al
        mov al, auxiliarCoord
        mov dl, 10
        mul dl
        add al, cl
        mov auxiliarCoord, al
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
        jmp while
    caso2:
        mov al, auxiliarCoord
        mov auxiliarCoord, 0
        mov baseSecretaYJug1, al
        inc bh
        mov bl, 0
        jmp while
    caso3:
        mov al, auxiliarCoord
        mov auxiliarCoord, 0
        mov baseSecretaXJug2, al
        inc bh
        mov bl, 0
        jmp while
    caso4:
        mov al, auxiliarCoord
        mov auxiliarCoord, 0
        mov baseSecretaYJug2, al
        jmp exit
exit:        
   ret
endp     



mapaArriba db "00..........................WAR GAMES -1983...............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"08........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"09..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13,"$"

mapaAbajo db "10..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,"11..............:::++++:-............::+++:+:.............:--+--.-........",10,13,"12..............-+++++++++:...........+:+::+................--.....---....",10,13,"13................:++++++:...........-+::+::.:-................-++:-:.....",10,13,"14.................++::+-.............::++:..:...............++++++++-....",10,13,"15.................:++:-...............::-..................-+:--:++:.....",10,13,"16.................:+-............................................-.....--",10,13,"17.................:....................................................--",10,13,"18.......UNITED STATES.........................SOVIET UNION...............$"

auxiliarCoord db ?

baseSecretaXJug1 db ?

baseSecretaYJug1 db ?

baseSecretaXJug2 db ?

baseSecretaYJug2 db ? 




