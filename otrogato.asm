;Proyecto Final
;Cesar Antonio Xiu de la Cruz - 20390693
;**************
;Some basic data declaratons
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
    ;__________________
    ; Variables/constants for main
    matrix db 0,0,0,0,0,0,0,0,0
    BUFF_SIZE equ 255
    newline db LF,NULL
    header db LF,"Program to file READ example."
           db LF,LF,NULL
    filename db "matriz.txt",NULL ; itÂ´s is the same used in the last program to file write.
    fileDesc dq 0
    errMsgOpen db "Error opening file",LF,NULL
    errMSgWrite db "Error reading from file",LF,NULL
    exito db "Si se Abrio el archivo",LF,LF,NULL
    paso db " El contenido del archivo es: ",LF,LF,NULL
    closef db LF," CERRANDO EL ARCHIVO ",LF,LF,NULL
    ;_______________ memory store
;*****************
section .bss
    readBuffer resb BUFF_SIZE
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
    ; The file descriptor is use for all subsequent file
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
        mov rdi, paso
        call printString
        ; Print the buffer
        ; add the null for print string
        mov rsi,readBuffer
        mov byte[rsi+rax], NULL
        mov rdi, readBuffer
        call printString
        ;----------
        mov rdi, readBuffer ;Lugar donde tenemos la matriz como texto
        mov rsi, matrix ;Matriz donde la queremos guardar
        bpoint:
        call procesarMatriz
        lstpoint:
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
global procesarMatriz
    ;rdi = Texto
    ;rsi = Matriz
    procesarMatriz:
        push rbx ;Epiloge
        push r12 ;Epilogue
        ;-- Primero ciclo, recorre todo
        mov rcx, 9 ;Numero de elementos en el arreglo
        mov rdx, 0 ;Contador del arreglo de la matriz
        mov r12, 0 ;Contador
        mainLoop:
            mov al, byte[rdi+rdx] ;8
            inc rdx
            cmp al, 0x20
            je mainLoop
            sub al, '0'
            mov byte[rsi+r12], al ;8
            inc r12
        loop mainLoop
        pop rbx ;Prologe
        pop r12 ;Prologe
    ret