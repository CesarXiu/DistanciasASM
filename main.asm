section .data
    ;----
    ;Define constants
    EXIT_SUCCESS    equ 0   ; successful operation
    SYS_exit        equ 60 ;call code for terminate
    ; ____________
    LF equ 10  ;line feed
    NULL equ 0 ;end of string
    TRUE equ 1
    FALSE equ 0

    STDIN equ 0  ; standard input
    STDOUT equ 1 ; standard output
    STDERR equ 2 ; standard error

    SYS_read equ 0 ; read
    SYS_write equ 1 ; write
    SYS_open equ 2 ; file open
    SYS_close equ 3 ; file close
    SYS_fork equ 57 ; fork
    SYS_creat equ 85 ; file open/create
    SYS_time equ 201 ; get time

    O_CREAT  equ 0x40
    O_TRUNC  equ 0x200
    O_APPEND equ 0x400

    O_RONLY equ 000000q ;read only
    O_WRONLY equ 000001q;write onle
    O_RDWR    equ 000002q;read and write

    S_IRUSR   equ 00400q 
    S_IWUSR  equ  00200q
    S_IXUSR  equ  00100q



    ;____________________
    ; Variables/constants for main
    BUFF_SIZE equ 255
    newline db LF,NULL
    header db LF,"Program to file READ example."
           db LF,LF,NULL

    filename db "matriz.txt",NULL ; it´s is the same used in the last program to file write.
    
    fileDesc dq 0
    matriz db 0,0,1,0,0,0,0,0
    tamanio db 3
    charRead dq 0
    errMsgOpen db "Error opening file",LF,NULL
    errMSgWrite db "Error reading from file",LF,NULL
    exito db "Si se Abrio el archivo",LF,LF,NULL
    paso db " El contenido del archivo es: ",LF,LF,NULL
    closef db LF," CERRANDO EL ARCHIVO ",LF,LF,NULL
    
    ;_______________ memory store

;*****************
section .bss
    readBuffer resb BUFF_SIZE ;Aqui se guarda lo que lee del archivo
;****************+
;Code Section
section .text
    global _start
    _start:
    ;---------------------
    ;Display header line ....
    mov rdi, header
    call printString

    ;---------
    ;attemp to open file 
    ; Use system service for file open
    ;Return:
    ;       if error -> eax<0
    ;       if success -> eax=file discriptor number
    ; The file descriptor is used for all subsequent file
    ; operations (read, write, close).
    openInputFile:
        mov rax,SYS_open  ;file open
        mov rdi,filename  ;file name str
        mov rsi, O_RONLY ;read only access
        syscall           ;call the kernel

        cmp rax,0         ;check for success
        jl errorOpen
        
        mov qword[fileDesc],rax ; save descritor file

        mov rdi, exito
        call printString
        

        ;--------------------
        ;Read from file.
        ;For this example, we know that the file has only 1 line 
        ;predifined string containing a URL

        ;System Service -Read
        ;Returns;
        ; if error-> rax<0
        ; if success ->rax=count of characters actually read
        
        mov rax, SYS_read
        mov rdi, qword[fileDesc]
        mov rsi, readBuffer
        mov rdx, BUFF_SIZE
        syscall
       
        cmp rax,0
        jl errorOnRead

        ;-------------------
        ;Print mess 
        mov qword[charRead], rax
        mov rdi, paso
        call printString
        ; Print the buffer
        ; add the null for print string
        mov rsi,readBuffer
        mov byte[rsi+rax], NULL
        ;---CONVERTIR LA MATRIZ A ENTEROS
        mov rdi, readBuffer ;Lugan donde tenemos almacenada la lectura como string
        mov rsi, matriz ;Lugar donde se guarda la matriz como enteros
        mov rdx, 0 ;Limpiamos la variable
        mov dl, byte[tamanio] ;Elementos en la matriz
        call generarMatriz ;Funcion para que generemos la matriz
        bpoint:
        mov rdi, readBuffer
        call printString


        ;----------
        ;Print mess 
        mov rdi, closef
        call printString
        ;Close the file
        ;System Service -close
        mov rax, SYS_close
        mov rdi, qword[fileDesc]
        syscall
        jmp last
    

    errorOpen:
        mov rdi, errMsgOpen
        call printString
        jmp last

    errorOnRead:
        mov rdi,errMSgWrite
        call printString
        jmp last 


    last:
        mov rax, SYS_exit ; Call code for exit
        mov rdi, EXIT_SUCCESS ; Exit program with success
        syscall
;+++++++++++++++++++
;Generic function to display a string to the screen
;String must be NULL terminated
;
global printString
printString:
    ;epilogue
    push rbx
    ;Count characters in string
    mov rbx, rdi
    mov rdx, 0
    countStrLoop:
        cmp byte[rbx],NULL
        je countStrDone
        inc rdx
        inc rbx
        jmp countStrLoop

    countStrDone:
        cmp rdx,0
        je prtDone
    ;------------
    ;Call OS to output string.
    mov rax, SYS_write ;System codo for write()
    mov rsi,rdi        ;Address of chars to write
    mov rdi,STDOUT     ; standard out
                        ; RDX=count to write, set above
    syscall
    ;--------
    ;String printed, return to calling routine---prologue
    prtDone:
          pop rbx
          ret
;+++++++++++++++++++
section .data
    n db -1 ;Lo usaremos como contador de filas
    m db 0 ;Lo usaremos como contador de elementos
    k db 0 ;Lo usaremos como contador
    element db 0,0,0 ;Para un numero de maximo 3 elementos y no debe de ser superior a 255 (byte)
global generarMatriz
    generarMatriz:
        ;rdi = Direccion de los caracteres leidos
        ;rsi = direccion de la matriz donde se guardaran los numeros
        ;rdx = Numero de elementos en la matriz
        ;epilogue
        push rbx ;Aqui usaremos la direccion de los caracteres
        push r12 ;Lo usaremos como contador general de elemento por elemento (Recorre toda la matriz)
        push r13 ;Manejo
        push r14 ;Se guarda la suma
        ;----------------------------------------------------------
        mov rax, 0
        mov rbx, rdi ;Cargamos la direccion de donde comenzaremos a leer
        mov eax, edx
        mul edx
        mov rcx, rax ;Elementos en la matriz
        mov rax, 0
        mov rdx, 0
        mov r12, -1 ;Para recorrer toda la matriz
        elementos:
            mov byte[m], -1 ;Elementos
            inc byte[n]
            cadena:
            inc r12
            mov al, byte[rbx+r12*8] ;Elemento leido
            cmp al, 0
                je calculoCadena ;Si es un espacio en blanco termina
            sub al, '0' ;Lo convertimos a entero
            inc byte[m] ;Control de elementos
            mov r13, m
            mov byte[element+r13*8], al
                jmp cadena
            prev:
                jmp elementos
            calculoCadena:
                cmp byte[m], 0 ;1
                je fin
                sumaElementos:
                    inc byte[k]
                    mov al, byte[m]   ; Cargar el exponente en el registro al
                    mov bl, 10   ; Cargar la base en el registro bx
                    ; Bucle para calcular la potencia
                    power_loop:
                        dec al   ; Decrementar el exponente
                        cmp al, 0   ; Comprobar si el exponente es igual a cero
                        je done   ; Si es cero, terminar
                        mul bl   ; Multiplicar el resultado parcial (ax) por la base (bx)
                        jmp power_loop   ; Volver al inicio del bucle
                    done:
                    mov r13, k
                    mov dl, al
                    mov al, byte[element+r13*8]
                    mul dl 
                    mov byte[element+r13*8], al
                    dec byte[m]
                    cmp byte[m], -1
                    jl sumaElementos
                        mov al, byte[element]
                        add al, byte[element+8] 
                        add al, byte[element+16]
                    jmp fin
            ElementoUnico:
            mov al, byte[element] ;Elemento unico
            fin:
            mov r13, n
            mov byte[rsi+r13*8], al ;Sube a la matriz
        loop prev
        ;--------
        ;return to calling routine---prologue
        funcDone:
            pop r13
            pop r12
            pop rbx
            ret
    ;+++++++++++++++++++