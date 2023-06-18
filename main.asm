;Proyecto Final - Assembly Language
;CESAR ANOTNIO XIU DE LA CRUZ - 20390693
;NEFTALI ALEXANDRO SANCHEZ JIMENEZ - 20390669
;JORGE ALDEBARAN BRICEÑO SIERRA - 20390508
;**************
%macro toChar 2                 ;Macro para convertir enteros a char
    push rax                    ;Prevencion
    push rbx                    ;Prevencion
    push rcx                    ;Prevencion
    push rdx                    ;Prevencion
    push rdi                    ;Prevencion
    mov rax, qword[%1]          ;Movemos el valor del entero a rax
    mov rcx,0                   ;Iniciamos el valor de rcx a 0
    mov rbx,10                  ;El valor de rbx iniciado en 10
    %%divideLoop:               ;Loop de division
        mov rdx, 0              ;
        div rbx                 ;Dividimos el valor entero entre 10
        push rdx                ;Guardamos el residuo en la pila
        inc rcx                 ;Incrementamos rcx
        cmp rax, 0              ;Comparamos el resultado con 0 
        jne %%divideLoop        ;Si cumple con la condicion sigue el loop
    mov rbx, %2 	            ;Ahora movemos la direccion a rbx
    mov rdi, 0                  ;De igual manera inicia rdi a 0
    %%popLoop:
        pop rax                 ;Sacamos los valores que subimos a pila
        add al,48               ;Agregamos el valor de 48 o 0 en ASCII para convertir
        mov byte[rbx+rdi], al   ;Guardamos en la direccion proporcionada
        inc rdi                 ;Aumentamos el rdi
        loop %%popLoop
    mov byte[rbx+rdi],0x0       ;Ahora agregamos el valor de NULL al final de la cadena
    pop rdi                    ;Prevencion
    pop rdx                    ;Prevencion
    pop rcx                    ;Prevencion
    pop rbx                    ;Prevencion
    pop rax                    ;Prevencion
%endmacro
;Some basic data declaratons
section .data
    ;---- data.calcMahalanobis
    sumaMedias dd 0             ;La suma de las medias en el metodo
    media dw 0                  ;Valor de media
    n dw 0.0                    ;Numero de elementos
    suma dw 0.0                 ;Valores de la sumatoria
    Zero dq 0.0                 ;Valor de 0 para efectos de comparacion
    auxiliar dq 0.0             ;Auxiliar en la conversion a flotante
    decremento dw 1             ;Decremento utilizado en n
    elementos db 2              ;Elementos en vectoress
    errorSemipos db LF,"No cumple con la siguiente validacion: SEMIPOSITIVIDAD",NULL
    ;-------------------------
    mess db "Programa que lee una cadena de caracteres.", LF, NULL
    messERR db "Excede el numero de caracteres. OVERFLOW", LF, NULL
    precision dq 10000          ;Precision en decimal
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
    ;Matriz db 0,0,0,0,0,0,0,0,0,0
    x db 0                              ;Valor en x1
    y db 0                              ;Valor en y1
    x2 db 0                             ;Valor en x2
    y2 db 0                             ;Valor en y2
    resEuclidianEntero dq 0             ;Donde se guardara la parte entera para Euclidian
    resEuclidianResiduo dq 0            ;Donde se guardara la parte residual para Euclidian
    resManhattanEntero dq 0             ;Donde se guardara la parte entera para Manhattan
    resManhattanResiduo dq 0            ;Donde se guardara la parte residual para Manhattan
    resMahalanobisEntero dq 0           ;Donde se guardara la parte entera para Mahalanobis 
    resMahalanobisResiduo dq 0          ;Donde se guardara la parte residual para Mahalanobis
    value1 db 0                         ;Valor de X en matriz
    value2 db 0                         ;Valor de Y en matriz
    opcionElegida db 0                  ;Primera opcion para el metodo
    BUFF_SIZE equ 255                   ;Tamaño del buffer de texto
    newline db LF,NULL
    ;header db LF,"Program to file READ example."
           db LF,LF,NULL
    filename db "matriz.txt",NULL ; itÂ´s is the same used in the last program to file write.
    fileDesc dq 0
    errMsgOpen db "Error opening file",LF,NULL
    errMSgWrite db "Error reading from file",LF,NULL
    exito db "OP",LF,LF,NULL
    paso db "Matriz disponible: ",LF,LF,NULL
    closef db LF,"CERRANDO EL ARCHIVO...",LF,LF,NULL
    opciones db LF,"1.- Euclidiana",LF,"2.- Manhatan",LF,"3.- Mahalanobis",LF,"4.- Salir",LF, NULL
    menu db "Que distancia desea calcular? ", NULL
    primerX db LF,"Primero vector (Valor en X):",LF,NULL
    segundoX db LF,"Primero vector (Valor en Y):",LF,NULL
    vector1 db 0,0
    primerY db LF,"Segundo vector (Valor en X):",LF,NULL
    segundoY db LF,"Segundo vector (Valor en Y):",LF,NULL
    dot db ".",NULL
    vector2 db 0,0
    strX db "x: ",NULL
    strY db "y: ",NULL
    valor db LF,"Resultado de distancia: ", NULL
    ;_______________ memory store
;*****************
section .bss
    readBuffer resb BUFF_SIZE ;Buffer donde se guarda la matriz
    chr resb 1
    inline resb 3 ;Cadena de 10 bist
    stringEntero resb 8
    stringResiduo resb 8
    resta resb 255
    Matriz resb 100
;****************+
;Code Section
section .text
    global _start
    _start:
    ;---------------------
    ;Display header line ....
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
        mov rax, SYS_read           ;Valor para lectura
        mov rdi, qword[fileDesc]    ;Donde se gaurdara la direccion del archivo
        mov rsi, readBuffer         ;Lugar donde se guardaran los datos leidos
        mov rdx, BUFF_SIZE          ;Numero de bytes que se leeran
        syscall                     ;Llamada al sistema
        cmp rax,0                   ;Tiene el numero de bytes leidos
        jl errorOnRead              ;Si es negativo es un error en la escritura
        mov rbx, rax                ;Guardamos el numero de bits leidos
        ;-------------------
        ;Print mess 
        mov rdi, paso               ;Impresion en pantalla, solo para efectos visuales
        call printString            ;Impresion
        ; Print the buffer
        ; add the null for print string
        mov rsi,readBuffer          ;Direccion donde se guardaron los char
        mov byte[rsi+rbx], NULL     ;Se agrega un NULL al final de la cadena
        mov rdi, readBuffer         ;Impresion en pantalla, solo para efectos visuales         
        call printString
        ;----------
        mov rdi, readBuffer ;Lugar donde tenemos la matriz como texto
        mov rsi, Matriz ;Matriz donde la queremos guardar
        call crear_matriz
        epa:
        ;call procesarMatriz ;Convertir archivo a matriz variable
        mov rdi, newline               ;Impresion en pantalla, solo para efectos visuales
        call printString
        ;--------------------------------------------------------- MENU
        mov rdi, opciones ;Despliega opciones
        call printString
        mov rdi, opcionElegida  ;Donde guardamos la opcion elegida
        call readString         ;Impresion
        mov bl, byte[opcionElegida] ;Valor leido
        sub bl, '0'                 ;Restamos para convertir en el valor real
        mov byte[opcionElegida], bl ;Movemos a una variable local
        cmp bl, 4                   ;Comparamos el valor con las opciones
        jge last ;Si es 3 o cualquier numero mayor a 3, se sale
        cmp bl, 1 ;Si es mayor a 1 (Cualquier eleccion entre 1 - 3)
        jge leerVectores ;Para la lectura por teclado de los datos
        jmp last ;Validacion de algun otro error
        leerVectores: ;Lee los vectores que estaremos usando
            mov rdi, primerX               ;Impresion en pantalla, solo para efectos visuales
            call printString
            ;-----------Primer Vector-----------------------------------
            ;Valor en X
            mov rdi, strX               ;Impresion en pantalla, solo para efectos visuales
            call printString
            mov rdi, x                  ;Donde sera guardado el valor leido
            call readString             ;Lee el valor en X
            mov bl, byte[x]             ;Pasanos el valor que se ingreso
            sub bl, '0'                 ;Convierte a entero
            mov byte[x], bl             ;Se guarda la posicion elegida
            mov rdi, strY               ;Impresion en pantalla, solo para efectos visuales
            call printString
            mov rdi, y                                    ;Donde sera guardado el valor leido
            call readString ;Lee el valor en X
            mov bl, byte[y] ;Pasanos el valor que se ingreso
            sub bl, '0' ;Convierte a entero
            mov byte[y], bl ;Se guarda la posicion elegida
            mov rdi, x          ;Necesario para la funcion, valor de x
            mov rsi, y          ;Necesario para la funcion, valor de y
            mov rdx, value1     ;Necesario para la funcion, valor donde guardar
            mov rcx, Matriz     ;Necesario para la funcion, Matriz donde buscara los datos
            call coords ;Saca el valor de las coordenadas seleccionadas
            mov al, byte[value1]    ;Movemos el valor que obtuvimos de la funcion a al
            mov byte[vector1],al    ;Valor en X, lo guardamos en vector 
            ;----------------------------------------------------------
            mov rdi, segundoX
            call printString
            ;----------Valor en Y---------------------------------
                mov rdi, strX          ;Unicamete para efectos de impresion en pantalla
                call printString
                mov rdi, x2                  ;Donde sera guardado el valor leido
                call readString ;Lee el valor en X
                mov bl, byte[x2] ;Pasanos el valor que se ingreso
                sub bl, '0' ;Convierte a entero
                mov byte[x2], bl ;Se guarda la posicion elegida
                mov rdi, strY          ;Unicamete para efectos de impresion en pantalla
                call printString
                mov rdi, y2                  ;Donde sera guardado el valor leido
                call readString ;Lee el valor en X
                mov bl, byte[y2] ;Pasanos el valor que se ingreso
                sub bl, '0' ;Convierte a entero
                mov byte[y2], bl ;Se guarda la posicion elegida
                mov rdi, x2         ;VALORES NECESARIOS, LOS MISMOS EXPLICADOS
                mov rsi, y2         ;EN LA ANTERIOR FUNCION
                mov rdx, value2
                mov rcx, Matriz
                call coords ;Saca el valor de las coordenadas seleccionadas
                mov al, byte[value2]
                mov byte[vector1+1],al ;Valor en Y
            ;----------------------------------------------------------
            ;-------------------------segundo vector
            mov rdi, primerY          ;Unicamete para efectos de impresion en pantalla
            call printString
            ;-----------Primer Vector-----------------------------------
            ;Valor en X
            mov rdi, strX          ;Unicamete para efectos de impresion en pantalla
            call printString
            mov rdi, x                  ;Donde sera guardado el valor leido
            call readString ;Lee el valor en X
            mov bl, byte[x] ;Pasanos el valor que se ingreso
            sub bl, '0' ;Convierte a entero
            mov byte[x], bl ;Se guarda la posicion elegida
            mov rdi, strY          ;Unicamete para efectos de impresion en pantalla
            call printString
            mov rdi, y                   ;Donde sera guardado el valor leido
            call readString ;Lee el valor en X
            mov bl, byte[y] ;Pasanos el valor que se ingreso
            sub bl, '0' ;Convierte a entero
            mov byte[y], bl ;Se guarda la posicion elegida
            mov rdi, x         ;VALORES NECESARIOS, LOS MISMOS EXPLICADOS ANTERIORMENTE
            mov rsi, y
            mov rdx, value1
            mov rcx, Matriz
            call coords ;Saca el valor de las coordenadas seleccionadas
            mov al, byte[value1]
            mov byte[vector2],al ;Valor en X 
            ;----------------------------------------------------------
            mov rdi, segundoY          ;Unicamete para efectos de impresion en pantalla
            call printString
            ;----------Valor en Y---------------------------------
            mov rdi, strX          ;Unicamete para efectos de impresion en pantalla
            call printString
            mov rdi, x2                   ;Donde sera guardado el valor leido
            call readString ;Lee el valor en X
            mov bl, byte[x2] ;Pasanos el valor que se ingreso
            sub bl, '0' ;Convierte a entero
            mov byte[x2], bl ;Se guarda la posicion elegida
            mov rdi, strY          ;Unicamete para efectos de impresion en pantalla
            call printString
            mov rdi, y2                   ;Donde sera guardado el valor leido
            call readString ;Lee el valor en X
            mov bl, byte[y2] ;Pasanos el valor que se ingreso
            sub bl, '0' ;Convierte a entero
            mov byte[y2], bl ;Se guarda la posicion elegida
            mov rdi, x2         ;VALORES NECESARIOS, LOS MISMOS EXPLICADOS ANTERIORMENTE
            mov rsi, y2
            mov rdx, value2
            mov rcx, Matriz
            call coords ;Saca el valor de las coordenadas seleccionadas
            mov al, byte[value2]
            mov byte[vector2+1],al ;Valor en Y
        mov bl, byte[opcionElegida] ;Tomamos ahora el byte de la opcion seleccionado al inicio
        cmp bl, 2                   ;Comparamos el valor con 2
        jg mahalanobis              ;Si es mayor (3) va a mahalanobis
        je manhattan                ;Si es menor (1) va a manhattan
        euclidian:
            ;Se hace la llamada a la funcion que lo calcula
            mov rdi, vector1 ;Valor vector 1
            mov rsi, vector2 ;Valor vector 2
            mov rdx, resEuclidianEntero ;Donde se guardara la parte entera
            mov rcx, resEuclidianResiduo ;Donde se guardara la parte del residuo
            call calcEuclidian ;Funcion que lo calcula
            toChar resEuclidianEntero, stringEntero ;Macro que lo convierte a texto
            toChar resEuclidianResiduo, stringResiduo ;Macro que lo convierte a texto
            jmp imprimirResultado
        manhattan:
            ;Se hace la llamada a la funcion que lo calcula
            mov rdi, vector1 ;Valor vector 1
            mov rsi, vector2 ;Valor vector 2
            mov rdx, resManhattanEntero ;Donde se guardara la parte entera
            mov rcx, resManhattanResiduo ;Donde se guardara la parte del residuo
            call calcManhattan ;Funcion que lo calcula
            toChar resManhattanEntero, stringEntero ;Macro que lo convierte a texto
            toChar resManhattanResiduo, stringResiduo ;Macro que lo convierte a texto
            jmp imprimirResultado
        mahalanobis:
            ;Se hace la llamada a la funcion que lo calcula
            mov rdi, vector1 ;Valor vector 1
            mov rsi, vector2 ;Valor vector 2
            mov rdx, elementos  ;Numero de elementos en los vectores
            call calcMahalanobis ;Funcion que lo calcula
            cmp rax, 0 ;Segun el valor retornado
            jl errorMaha
            toChar resMahalanobisEntero, stringEntero ;Macro que lo convierte a texto
            toChar resMahalanobisResiduo, stringResiduo ;Macro que lo convierte a texto
            jmp imprimirResultado
        imprimirResultado:
        mov rdi, valor          ;Unicamete para efectos de impresion en pantalla
        call printString
        mov rdi, stringEntero   ;Valor de la parte entera del resultado
        call printString
        mov rdi, dot            ;Punto: .
        call printString
        mov rdi, stringResiduo  ;Valor de la parte del residuo
        call printString
        jmp cerrarArchivo       ;Brinca hasta cerrar el archivo
        ;----------
        ;Print mess
        cerrarArchivo:                     ;Cerramos el archivo
        mov rdi, closef                    ;Mensaje de el cierre del archivo
        call printString                   ;Imprime
        ;Close the file
        ;System Service -close
        mov rax, SYS_close                  ;Valor para cerrar el archivo
        mov rdi, qword[fileDesc]            ;Direccion donde se abrio el archivo
        syscall                             ;Llamada al sistema
        jmp last
    errorOpen:
        mov rdi, errMsgOpen                 ;Error al abrir el archivo
        call printString                    ;Imprime
        jmp last                            ;Termina
    errorOnRead:
        mov rdi,errMSgWrite                 ;Mensaje de error en la escritura
        call printString                    ;Imprime
        jmp cerrarArchivo                   ;Cierra el archivo 
    errorMaha:                              ;Error en mahalanobis
        mov rdi, errorSemipos               ;Error de semipositividad
        call printString                    ;Imprime
        jmp cerrarArchivo                   ;Cierra el archivo
    last:
        mov rax, SYS_exit                   ; Call code for exit
        mov rdi, EXIT_SUCCESS               ; Exit program with success
        syscall
;+++++++++++++++++++
;Generic function to display a string to the screen
;String must be NULL terminated
;+++++++++++++++++++
global printString                          ;Funcion que imprime caracteres
printString:
    push rbx                                ;epilogue
    ;Count characters in string
    mov rbx, rdi                            ;Direccion del rdi a rbx
    mov rdx, 0                              ;Limpieamos el registro 
    countStrLoop:
        cmp byte[rbx], NULL                 ;Comparamos si el valor es null, osea el fin de la cadena
        je countStrDone                     ;Si es asi termina de leer
        inc rdx                             ;Aumentamos rdx
        inc rbx                             ;Aumentamos rbx
        jmp countStrLoop                    ;Sigue leyendo
    countStrDone:
        cmp rdx,0                           ;Si termina de leer compara el rdx con 0
        je prtDone                          ;Si es igual termina la impresion
    ;------------
    ;Call OS to output string.
    mov rax, SYS_write                  ;System codo for write()
    mov rsi,rdi                         ;Address of chars to write
    mov rdi,STDOUT                      ; standard out
    syscall
    ;--------
    ;String printed, return to calling routine---prologue
    prtDone:
          pop rbx                           ;prologue
          ret                               ;Retorno
;+++++++++++++++++++
global procesarMatriz
    ;rdi = Texto
    ;rsi = Matriz
    procesarMatriz:
        push rbx ;Epiloge
        push r12 ;Epilogu
        mov rdx, 0
        ;-- Primero ciclo, recorre todo
        mov rcx, 100 ;Numero de elementos en el arreglo
        mov rdx, 0 ;Contador del arreglo de la matriz
        mov r12, 0 ;Contador
        mainLoop:
            mov al, byte[rdi+rdx] ;Caracter guardado en Al
            inc rdx ;Contador que recorre el texto
            cmp al, 47 ;Menor a 0
            jl mainLoop ;Si es un espacio sigue con el siguiente elemento
            cmp al, 58 ;Mayor a 9
            jge mainLoop ;Si es un espacio sigue con el siguiente elemento
            sub al, '0' ;Se resta el valor de 0 en ASCII para convertir a valor entero
            mov byte[rsi+r12], al ;Se guarda el valor como entero en la matriz de resultado
            inc r12 ;Siguiente elemento en la matriz de resultado
        loop mainLoop
        xd:
        pop r12 ;Prologe
        pop rbx ;Prologe
    ret
global readString                       ;Esta funcion lee por teclado
    readString: 
    push rax                            ;Epilogo
    push rbx                            ;Epilogo
    push r12                            ;Epilogo
    push r13                            ;Epilogo
    mov r13, rdi                        ;Direccion de donde se guardara lo leido
    ;Leer el string
        mov rbx, inline                 ;Se guardara aqui lo leido
        mov r12, 0                      ;Contador de caracteres
        readChars:
            mov rax, SYS_read           ;Valor para interrupcion de lectura
            mov rdi, STDIN              ;Valor de donde se leera
            lea rsi, byte[chr]          ;Donde se ira guardando los caracteres leidos
            mov rdx, 1                  ;Numero de caracteres que se leeran
            syscall                     ;Llamada a la interrupcion del sistema
            mov al, byte[chr]           ;Se mueve el char leido a Al
            cmp al, LF                  ;Lo comparamos con un salto de linea
            je readDone                 ;Si es un salto de linea terminamos de leer
            inc r12                     ;Incrementamos el numero de caracter de no ser un LF
            cmp r12, 2                  ;Lo comparamos con el numero de caracetres a ingresar (2)
            jae errStr                  ;Si se pasa es un overflow
            mov byte[rbx], al           ;De no ser asi el valor leido guarda en rbx
            inc rbx                     ;Incrementamos este mismo
            jmp readChars               ;Volvemos a la lectura de caracteres
        readDone:                       ;Termino de leer
            mov byte[rbx], NULL         ;Una vez terminado se agrega un null al final de la cadena leida
            mov rbx, inline             ;Movemos la direccion a rbx donde guardamos
            mov dl, byte[rbx]           ;Leemos un byte
            mov byte[r13], dl           ;Lo movemos a donde se guardara lo leido, ya con un null puesto
            jmp endRead                 ;Terminada la lectura
        errStr:                         ;De haber un error en lectura
                mov rdi, messERR        ;Mensaje de error
                mov rbx, rdi            ;Se mueve a rbx la direccion donde guardamos el mensaje de error
                mov rdx, 0              ;Limpiamos con 0 el registro
                countChars:             ;
                    cmp byte[rbx],NULL  ;Verificamos si es el fin de cadena
                    je countDone        ;Termina de leer el mensaje
                    inc rdx             ;Aumentamos rdx
                    inc rbx             ;Aumentamos rbx
                    jmp countChars      ;Seguimos en la lectura
                countDone:              ;Termina de leer el mensaje
                    cmp rdx, 0          ;Comparamos el valor en rdx
                    je prtDone          ;Si es igual a 0 terminamos la lectura
                ;Llamada a sistema para imprimir
                mov rax, SYS_write          ;Valor de la llamada al sistema para escribir
                mov rsi, rdi                ;Direccion de donde escribirlo
                mov rdi, STDOUT             ;File descriptor de donde escribir
                syscall                     ;Llamada al sistema
            mov rax, SYS_exit               ; Call code for exit
            mov rdi, EXIT_SUCCESS           ; Exit program with success
            syscall                         ;Llamada al sistema
            jmp endRead                     ;Se termino de leer
    endRead:
    pop r13                                 ;Prologo
    pop r12                                 ;Prologo
    pop rbx                                 ;Prologo
    pop rax                                 ;Prologo
    ret                                     ;Return
global coords                               ;Esta funcion encuentra el valor en la matriz segun las coordenadas
    coords:             
        ;rdi = X ;1
        ;rsi = Y ;1
        ;rdx = Resultado
        ;rcx = Matriz
        push rax                            ;Epilogo
        push rbx                            ;Epilogo
        push r12                            ;Epilogo
        push r13                            ;Epilogo
            mov r13, rdx                    ;Movemos la direccion donde se guarda el resultado a r13
            mov rdx, 0                      ;Inicializamos el valor en 0
            mov al, byte[rsi]               ;Tomamos el valor en Y
            mov bl, byte[rdi]               ;Tomamos el valor en X
            mov rdx, 10                     ;Usaremos este valor para calcular la posicion en la matriz
            mul dl                          ;Se multiplica Y*10 para obtener la primera posicion en la fila indicada
            mov dl, 0                       ;Limpiamos el valor de dl 
            add al, bl                      ;Ahora sumamos el valor de Y mas X, calculando asi los bits a recorrer en la matriz
            mov r12, rax                    ;Movemos el valor de la suma a un registro r12
            mov rax, 0                      ;Limpiamos el registro A
            mov al, byte[rcx+r12]           ;Ahora movemos al registro A el valor que ubicamos en la matriz, dado la suma anterior
            mov byte[r13], al               ;Ahora guardamos el valor que buscamos a la variable de regreso
        pop r13                             ;Prologo
        pop r12                             ;Prologo
        pop rbx                             ;Prologo
        pop rax                             ;Prologo
    ret                                     ;Return
global calcEuclidian
    calcEuclidian:
        ;rdi = vector 1
        ;rsi = vector 2
        ;rdx = entero
        ;rcx = residuo
        push r12                            ;Resta de X
        push r13                            ;Resta de Y
        push rbx                            ;Valores en los vectores
        push rax                            ;Resta de X
        push r14                            ;Ubicacion del residuo
        mov r14, rcx                        ;Pasamos la direccion de residuo a r14
        mov rcx, rdx                        ;Ahora la ubicacion de entero a rcx
        mov rdx, 0                          ;Limpia rdx (inicializar a 0)
        mov rax, 0                          ;Limpia rax (inicializar a 0)
        mov rbx, 0                          ;Limpia rbx (inicializar a 0)

        mov bl, byte[rdi]                   ;Comenzamos tomando el primer valor x del primer vector
        mov al, byte[rsi]                   ;Ahora hacemos lo mismo con el segundo vector
        sub al, bl                          ;Restamos los valores de ambos, se guardan en ax  

        mov dl, al                          ;Guardamos el valor de la resta en dl, para hacer la potencia
        imul al                             ;Multiplicamos el mismo valor, para efectos de potencia
        mov r12, rax                        ;Ahora guardamos este valor de potencia a r12

        mov bl, byte[rdi+1]                 ;Ahora hacemos lo mismo, pero tomamos los valores en Y
        mov al, byte[rsi+1]                 ;Hacemos lo mismo con el segundo vector
        sub al, bl                          ;Resta de Y, se guarda en al  

        mov dl, al                          ;Guardamos la resta anterior en dl, para potenciacion
        imul al                             ;Multiplicamos al*bl donde al = bl, lo mismo que al^2
        mov r13, rax                        ;Lo mandamos a r13
        add r12, r13                        ;Y ahora para manejar el numero a r12

        mov qword[resEuclidianEntero], r12  ;Guardamos dicho valor en una variable
        movsx eax, word[resEuclidianEntero] ;Lo movemos como floante a el registro eax
        cvtsi2sd xmm0, eax                  ;Ahora convertimos el registro a otro de punto flotante
        sqrtsd xmm0, xmm0                   ;Hacemos la raiz, se guarda en xmm0
        mov rax, 0                  
        cvttsd2si eax, xmm0                 ;Tomamos la parte entera 
        mov qword[resEuclidianEntero], rax  ;Devuelve el valor de la parte entera
        cvtsi2sd xmm1, rax                  ;Lo convertimos a flotante para seguir manipulando el numero 
        subsd xmm0, xmm1                    ;Se resta la parte entera para obtener el decimal
        movsx eax, word[precision]          ;Aqui se guarda la precision, de cuantos 0
        cvtsi2sd xmm2, eax                  ; Aqui se establece cuantos 0 vamos a usar (en impresion)
        mulsd xmm0, xmm2                    ; Se multiplica residuo por los decimales
        cvttsd2si ebx, xmm0                 ; Guardamos el residuo en un entero para efectos de impresion
        mov qword[resEuclidianResiduo], rbx ;Guardamos de la misma manera el residuo en una varibale 

        pop r14                             ;Prologo
        pop rax                             ;Prologo
        pop rbx                             ;Prologo
        pop r13                             ;Prologo
        pop r12                             ;Prologo
        ret                                 ;Return
global calcManhattan                ;Calculo de las distancias manhattan
    calcManhattan:
        ;rdi = vector 1
        ;rsi = vector 2
        ;rdx = entero
        push rbx                    ;Epilogo
        push rax                    ;Epilogo
            mov bl, byte[rsi]       ;Tomamos el primer valor del vector 2 al registro bl
            mov al, byte[rdi]       ;Tomamos el primer valor del vector 1 al registro al
            sub al, bl              ;Resta de los primeros valores (x)
            mov cl, al              ;Lo guardamos en el registro cl
            cmp cl, 0               ;Comparamos el valor con 0
            jge notNeg1             ;Si es mayor a 0 entonces no es negativo
            neg cl                  ;Si es negativo lo convertimos a positivo
            notNeg1:                ;Si no es negativo
            mov bl, byte[rsi+1]     ;Continuamos con el segundo valor del vector 2
            mov al, byte[rdi+1]     ;Continuamos con el segundo valor del vector 1
            sub al, bl              ;Resta de los valores en Y
            cmp al, 0               ;Nuevamente comparamos con 0
            jge notNeg2             ;Si es mayor no es negativo
            neg al                  ;Negamos de ser negativo, para convertir a positivo
            notNeg2:                ;Si no es negativo
            add al, cl              ;Sumamos ambas restas que hicimos antes
            mov qword[rdx], rax     ;Ahora movemos el valor de la suma a rdx, el puntero para imrprimir el resultado
        pop rax                     ;Prologo
        pop rbx                     ;Prologo
        ret                         ;Retorna
global calcMahalanobis
        calcMahalanobis:
            ;rdi = vector 1
            ;rsi = vector 2
            ;rdx = Numero de elementos en los vectores
            push r12                                ;Epilogo
            push rcx                                ;Epilogo
            mov r12, 0                              ;Para evitar basura en el registro
            mov rax, 0                              ;Para evitar basura en el registro
            mov rcx, 0                              ;Para evitar basura en el registro
            mov cl, byte[rdx]                       ;Cargamos el numero de elementos para el loop
            mov word[n], cx                         ;De la misma manera lo guardamos en una variable
            restaEntreVectores:                     ;Comenzamos haciendo las restas entre valores
                mov bl, byte[rdi+r12]               ;Cargamos un valor del vector 1
                mov al, byte[rsi+r12]               ;Cargamos un valor del vector 2
                sub al, bl                          ;Restamos ambos valores 
                mov word[resta+r12*2], ax           ;Guardamos el valor de la resta en una variable
                inc r12                             ;Incrementamos el apuntador
            loop restaEntreVectores                 ;
            mov rax, 0                              ;Para evitar basura en el registro
            mov rbx, 0                              ;Para evitar basura en el registro
            ;-------------- AQUI YA TENEMOS EL VALOR DE LAS RESTAS SEGUN LOS ELEMENTOS DE LOS VECTORES
            desviacion1:                            ;Calcular la desviacion estandar del primer vector
                mov rax, 0                          ;Para evitar basura en el registro
                mov rbx, 0                          ;Para evitar basura en el registro
                ;----------------Comenzamos calculando la media del vector: u
                mov rcx, r12                        ;Colocamos el numero de elemmentos en RCX para usar loops
                dec rcx                             ;Hacemos uno menos, dado a que es por operaciones y no elementos
                mov r12, 1                          ;Nuestro contador comienza en 1 porque el primer elemento  lo tomamos antes
                mov al, byte[rdi]                   ;Tomamos el primer elemento del vector dado, para la primera suma
                loopSuma1:                      ;Loop donde se llevata a cabo la suma de los elementos
                    mov bl, byte[rdi+r12]           ;Tomamos otro elemento, pero en este caso, se comienza por el segundo elemento
                    add al, bl                      ;Se realiza la suma de los elementos y se guarda progresivamente en el registro A
                    inc r12                         ;Incrementamos el indice de donde se lee el elemento en el registro bl
                loop loopSuma1                  ;Segun las vueltas necesarias sigue en el loop
                mov rdx, r12                        ;Guardamos en rdx el numero de elementos
                ;---------------Ahora despues de la suma, lo dividimos para sacar la media
                mov word[suma], ax                  ;Cargamos el valor del registro A es donde teniamos guardado la suma de los elementos a una variable
                mov rax, 0                          ;Para evitar basura en el registro
                movsx ebx, word[n]                  ;Movemos como flotante el valor de N al registro ebx
                cvtsi2sd xmm0, ebx                  ;Lo cargamos ahora a un registro de punto flotante
                movsx eax, word[suma]               ;Cargamos el valor de la suma como flotante
                cvtsi2sd xmm1, eax                  ;Ahora cargamos a un registro de punto flotante el valor de la suma
                divsd xmm1, xmm0                    ;Realizamos la division, el resultado se guarda en xmm
                ;---------------Cuadrado de la distancia a la media: |x-u|^2
                mov r12, 0                          ;Para evitar basura en el registro
                mov rdx, 0                          ;Para evitar basura en el registro
                mov cl, byte[n]                     ;Cargamos el numero de elementos por vector al registro cl
                ;---------------Comenzamos con la resta de las diferencias (|x-u|)
                sumaDiferencias:                ;Loop para la resta de x - u (media)
                mov dl, byte[rdi+r12]               ;Movemos un valor del vector (x) al registro dl
                mov qword[auxiliar], rdx               ;Ahora lo cargamos a una variable para manejarlo mas facilmente
                movsx edx, word[auxiliar]              ;Movemos el valor, ahora como flotante pero al registro edx
                cvtsi2sd xmm0, edx                  ;Cargamos ahora si a un registro flotante
                subsd xmm0, xmm1                    ;Restamos a el valor (x) el promedio antes calculado (u)
                ucomisd xmm0, qword[Zero]           ;Comparamos el resultado de la resta con 0 y si es negativo lo convertimos a positivo
                jae notNegM                          ;Si es mayor que 0 sigue a la potenciacion
                xorps xmm2, xmm2                    ; xmm2 = 0.0
                subps xmm2, xmm0                    ; xmm2 = -xmm0
                movaps xmm0, xmm2                   ; xmm0 = xmm2 (cambia el signo de xmm0)
                notNegM:                         ;Si es positivo
                mulsd xmm0, xmm0                    ;Multiplicamos el mismo resultado por el, para efectos de potencia
                addsd xmm3, xmm0                    ;Vamos guardando la sumatoria en otro registro
                inc r12                             ;Incrementamos el indice para en la siguiente vuelta tomar otro valor (x)
                loop sumaDiferencias                ;Si quedan saltos vuelve a tomar otro elemento y hacer el mismo proceso
                ;---------------Ahora dividimos la suma entre el numero de elementos (suma(x-u)^2)/n
                wtf:
                mov edx, 0
                movsx eax, word[n]                  ;Cargamos el valor de elementos a un registro como flotante
                cvtsi2sd xmm0, eax                  ;Lo convertimos a un registro flotante
                movsx edx, word[decremento]
                cvtsi2sd xmm12, edx       ;Cargar el valor a decrementar en xmm12
                subsd xmm0, xmm12                   ; Decrementar xmm0 por xmm12
                divsd xmm3, xmm0                    ;Ahora dividimos el valor de la sumatoria de las diferencias entre el numero de elementos
                ;---------------Finalmente calculamos la raiz para obtener la desviacion
                sqrtsd xmm0, xmm3                   ;Guardamos el valor de la desviacion estandar en xmm0
                ;---------------Fin de la primera desviacion estandar
            desviacion2:                            ;Calcular la desviacion estandar del primer vector
                mov r12, 0                          ;Para evitar basura en el registro
                mov rax, 0                          ;Para evitar basura en el registro
                mov rbx, 0                          ;Para evitar basura en el registro
                mov rcx, 0 
                ;----------------Comenzamos calculando la media del vector: u
                mov cl, byte[n]                        ;Colocamos el numero de elemmentos en RCX para usar loops
                dec rcx                             ;Hacemos uno menos, dado a que es por operaciones y no elementos
                mov r12, 1                          ;Nuestro contador comienza en 1 porque el primer elemento  lo tomamos antes
                mov al, byte[rsi]                   ;Tomamos el primer elemento del vector dado, para la primera suma
                loopSuma2:                      ;Loop donde se llevata a cabo la suma de los elementos
                    mov bl, byte[rsi+r12]           ;Tomamos otro elemento, pero en este caso, se comienza por el segundo elemento
                    add al, bl                      ;Se realiza la suma de los elementos y se guarda progresivamente en el registro A
                    inc r12                         ;Incrementamos el indice de donde se lee el elemento en el registro bl
                loop loopSuma2                  ;Segun las vueltas necesarias sigue en el loop
                mov rdx, r12                        ;Guardamos en rdx el numero de elementos
                ;---------------Ahora despues de la suma, lo dividimos para sacar la media
                mov word[suma], ax                  ;Cargamos el valor del registro A es donde teniamos guardado la suma de los elementos a una variable
                mov rax, 0                          ;Para evitar basura en el registro
                movsx ebx, word[n]                  ;Movemos como flotante el valor de N al registro ebx
                cvtsi2sd xmm4, ebx                  ;Lo cargamos ahora a un registro de punto flotante
                movsx eax, word[suma]               ;Cargamos el valor de la suma como flotante
                cvtsi2sd xmm5, eax                  ;Ahora cargamos a un registro de punto flotante el valor de la suma
                divsd xmm5, xmm4                    ;Realizamos la division, el resultado se guarda en xmm
                ;---------------Cuadrado de la distancia a la media: |x-u|^2
                mov r12, 0                          ;Para evitar basura en el registro
                mov rdx, 0                          ;Para evitar basura en el registro
                mov cl, byte[n]                     ;Cargamos el numero de elementos por vector al registro cl
                ;---------------Comenzamos con la resta de las diferencias (|x-u|)
                sumaDiferencias2:                ;Loop para la resta de x - u (media)
                mov dl, byte[rsi+r12]               ;Movemos un valor del vector (x) al registro dl
                mov qword[auxiliar], rdx               ;Ahora lo cargamos a una variable para manejarlo mas facilmente
                movsx edx, word[auxiliar]              ;Movemos el valor, ahora como flotante pero al registro edx
                cvtsi2sd xmm4, edx                  ;Cargamos ahora si a un registro flotante
                subsd xmm4, xmm5                    ;Restamos a el valor (x) el promedio antes calculado (u)
                ucomisd xmm4, qword[Zero]           ;Comparamos el resultado de la resta con 0 y si es negativo lo convertimos a positivo
                jae notNegM2                         ;Si es mayor que 0 sigue a la potenciacion
                xorps xmm6, xmm6                    ; xmm6 = 0.0
                subps xmm6, xmm4                    ; xmm6 = -xmm4
                movaps xmm4, xmm6                   ; xmm4 = xmm6 (cambia el signo de xmm4)
                notNegM2:                         ;Si es positivo
                mulsd xmm4, xmm4                    ;Multiplicamos el mismo resultado por el, para efectos de potencia
                addsd xmm7, xmm4                    ;Vamos guardando la sumatoria en otro registro
                inc r12                             ;Incrementamos el indice para en la siguiente vuelta tomar otro valor (x)
                loop sumaDiferencias2               ;Si quedan saltos vuelve a tomar otro elemento y hacer el mismo proceso
                ;---------------Ahora dividimos la suma entre el numero de elementos (suma(x-u)^2)/n
                movsx eax, word[n]                  ;Cargamos el valor de elementos a un registro como flotante
                cvtsi2sd xmm4, eax                  ;Lo convertimos a un registro flotante
                subsd xmm4, xmm12                   ;Decrementar xmm4 por xmm12
                divsd xmm7, xmm4                    ;Ahora dividimos el valor de la sumatoria de las diferencias entre el numero de elementos
                ;---------------Finalmente calculamos la raiz para obtener la desviacion
                sqrtsd xmm4, xmm7                   ;Guardamos el valor de la desviacion estandar en xmm4
                ;---------------Fin de la primera desviacion estandar
            ;Ahora, una vez que tenemos las varianzas, calculamos la distancia de mahalanobis
            ;xmm0 = desviacion 1
            ;xmm4 = desviacion 2
            Division:                               ;Ahora hacemos la division para el proceso de mahalobis
                mov rax, 0                          ;Para evitar basura en el registro
                mov rbx, 0                          ;Para evitar basura en el registro
                mov rcx, 0                          ;Para evitar basura en el registro
                mov rdx, 0                          ;Para evitar basura en el registro
                ;Cargamos al registro xmm8 el valor de la primera resta, que calculamos al inicio
                movsx eax, word[resta]              ;Pasamos el primer valor de la resta que hicimos al inicio
                cvtsi2sd xmm8, eax                  ;Lo convertimos y pasamos a un registro flotante
                divsd xmm8, xmm0                    ;Dividimos el valor de la resta entre la primera desviacion
                ;Cargamos al registro xmm9 el valor de la segunda resta, que calculamos al inicio
                movsx ebx, word[resta+2]            ;Pasamos el segundo valor de la resta que hicimos al inicio
                cvtsi2sd xmm9, ebx                  ;De la misma manera lo convertimos a punto flotante
                divsd xmm9, xmm4                    ;Hacemos otra division, ahora con la segunda desviacion
            Potencia:                               ;Seguimos con la potencia del resultado
                mulsd xmm8, xmm8                    ;Multiplicamos el resultado de la division por el mismo, para potenciacion
                mulsd xmm9, xmm9                    ;Multiplicamos el resultado de la division por el mismo, para potenciacion
                addsd xmm8, xmm9                    ;Sumamos ambas potencias en el registro xmm8
            Raiz:                                   ;Procedemos como ultimo paso a calcular la raiz
                sqrtsd xmm8, xmm8                   ;Hacemos la raiz cuadrada y lo guardamos en el mismo registro flotante
            ResultadoFinal:                         ;Ahora con el resultado calculamos las partes para regresar e imprimir
                cvttsd2si eax, xmm8                 ;Tomamos la parte entera del resultado 
                mov qword[resMahalanobisEntero], rax;Devolvemos en una variable el valor del entero
                cvtsi2sd xmm10, rax                 ;Lo convertimos a flotante para seguir manipulando el numero 
                subsd xmm8, xmm10                   ;Se resta la parte entera para obtener el residuo
                movsx eax, word[precision]          ;El valor de precision indica cuantos 0 tendremos, ej: 1000 = 4 ceros
                cvtsi2sd xmm11, eax                 ;Aqui se establece cuantos 0 vamos a usar (en impresion)
                mulsd xmm8, xmm11                   ;Se multiplica residuo por los decimales, asi convertimos 0.1234 a 1234.0
                cvttsd2si ebx, xmm8                 ;Guardamos como entero ahora para efectos de impresion en pantalla
                mov qword[resMahalanobisResiduo], rbx;Guardamos dicho valor en la variable
            ;Validaciones requeridas por el metodo
            ;La distancia entre dos puntos de las mismas coordenadas es cero, y si tienen coordenadas distintas la  
            ;distancia es positiva, pero nunca negativa.
            semipositividad: 
                ucomisd xmm4, qword[Zero]           ;Comparamos el valor final para verificar esta propiedad
                jae final                           ;Si es positivo es todo correcto
                mov rax, -1                         ;Si es negativo enviamos la respuesta por rax
                jmp endF                            ;Va al final
    final:                                          ;Terminamos el programa
    mov rax, 0                                      ;Se envia un valor positivo
    endF:                                           ;Final 
    pop rcx                                         ;Prologo
    pop r12                                         ;Prologo
    ret                                             ;Retorno
; Función que elimina los 32 [Espacios], los 10 [LF] y vuelve todo decimal
; global newMatriz
global crear_matriz
    crear_matriz:
        push rbp               ;Epilogo
        mov rbp, rsp
        bucle_lectura:
            mov al, byte [rdi] ; Leer un byte del primer espacio reservado
            cmp al, 0          ; Comprobar si el valor leído es cero
            je etiqueta_salida ; Salir del bucle si el valor es cero
            cmp al, 32         ; Comprobar si el valor es un espacio (32)
            je etiqueta_salto  ; Saltar al siguiente carácter si es un espacio
            cmp al, 10         ;Proyecto Final - Assembly Language
;CESAR ANOTNIO XIU DE LA CRUZ - 20390693
;NEFTALI ALEXANDRO SANCHEZ JIMENEZ - 20390669
;JORGE ALDEBARAN BRICEÑO SIERRA - 20390508
;**************
%macro toChar 2                 ;Macro para convertir enteros a char
    push rax                    ;Prevencion
    push rbx                    ;Prevencion
    push rcx                    ;Prevencion
    push rdx                    ;Prevencion
    push rdi                    ;Prevencion
    mov rax, qword[%1]          ;Movemos el valor del entero a rax
    mov rcx,0                   ;Iniciamos el valor de rcx a 0
    mov rbx,10                  ;El valor de rbx iniciado en 10
    %%divideLoop:               ;Loop de division
        mov rdx, 0              ;
        div rbx                 ;Dividimos el valor entero entre 10
        push rdx                ;Guardamos el residuo en la pila
        inc rcx                 ;Incrementamos rcx
        cmp rax, 0               ;Comparamos el resultado con 0 
        jne %%divideLoop        ;Si cumple con la condicion sigue el loop
    mov rbx, %2 	            ;Ahora movemos la direccion a rbx
    mov rdi, 0                  ;De igual manera inicia rdi a 0
    %%popLoop:
        pop rax                 ;Sacamos los valores que subimos a pila
        add al,48               ;Agregamos el valor de 48 o 0 en ASCII para convertir
        mov byte[rbx+rdi], al   ;Guardamos en la direccion proporcionada
        inc rdi                 ;Aumentamos el rdi
        loop %%popLoop
    mov byte[rbx+rdi],0x0       ;Ahora agregamos el valor de NULL al final de la cadena
    pop rdi                    ;Prevencion
    pop rdx                    ;Prevencion
    pop rcx                    ;Prevencion
    pop rbx                    ;Prevencion
    pop rax                    ;Prevencion
%endmacro
;Some basic data declaratons
section .data
    ;---- data.calcMahalanobis
    sumaMedias dd 0             ;La suma de las medias en el metodo
    media dw 0                  ;Valor de media
    n dw 0.0                    ;Numero de elementos
    suma dw 0.0                 ;Valores de la sumatoria
    Zero dq 0.0                 ;Valor de 0 para efectos de comparacion
    auxiliar dq 0.0             ;Auxiliar en la conversion a flotante
    decremento dw 1             ;Decremento utilizado en n
    elementos db 2              ;Elementos en vectoress
    errorSemipos db LF,"No cumple con la siguiente validacion: SEMIPOSITIVIDAD",NULL
    ;-------------------------
    mess db "Programa que lee una cadena de caracteres.", LF, NULL
    messERR db "Excede el numero de caracteres. OVERFLOW", LF, NULL
    precision dq 10000          ;Precision en decimal
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
    ;Matriz db 0,0,0,0,0,0,0,0,0,0
    x db 0                              ;Valor en x1
    y db 0                              ;Valor en y1
    x2 db 0                             ;Valor en x2
    y2 db 0                             ;Valor en y2
    resEuclidianEntero dq 0             ;Donde se guardara la parte entera para Euclidian
    resEuclidianResiduo dq 0            ;Donde se guardara la parte residual para Euclidian
    resManhattanEntero dq 0             ;Donde se guardara la parte entera para Manhattan
    resManhattanResiduo dq 0            ;Donde se guardara la parte residual para Manhattan
    resMahalanobisEntero dq 0           ;Donde se guardara la parte entera para Mahalanobis 
    resMahalanobisResiduo dq 0          ;Donde se guardara la parte residual para Mahalanobis
    value1 db 0                         ;Valor de X en matriz
    value2 db 0                         ;Valor de Y en matriz
    opcionElegida db 0                  ;Primera opcion para el metodo
    BUFF_SIZE equ 255                   ;Tamaño del buffer de texto
    BYTES_LEIDOS dq 0
    newline db LF,NULL
    ;header db LF,"Program to file READ example."
           db LF,LF,NULL
    filename db "matriz.txt",NULL ; itÂ´s is the same used in the last program to file write.
    fileDesc dq 0
    errMsgOpen db "Error opening file",LF,NULL
    errMSgWrite db "Error reading from file",LF,NULL
    exito db "OP",LF,LF,NULL
    paso db "Matriz disponible: ",LF,LF,NULL
    closef db LF,"CERRANDO EL ARCHIVO...",LF,LF,NULL
    opciones db LF,"1.- Euclidiana",LF,"2.- Manhatan",LF,"3.- Mahalanobis",LF,"4.- Salir",LF, NULL
    menu db "Que distancia desea calcular? ", NULL
    primerX db LF,"Primero vector (Valor en X):",LF,NULL
    segundoX db LF,"Primero vector (Valor en Y):",LF,NULL
    vector1 db 0,0
    primerY db LF,"Segundo vector (Valor en X):",LF,NULL
    segundoY db LF,"Segundo vector (Valor en Y):",LF,NULL
    dot db ".",NULL
    vector2 db 0,0
    strX db "x: ",NULL
    strY db "y: ",NULL
    valor db LF,"Resultado de distancia: ", NULL
    ;_______________ memory store
;*****************
section .bss
    readBuffer resb BUFF_SIZE ;Buffer donde se guarda la matriz
    chr resb 1
    inline resb 3 ;Cadena de 10 bist
    stringEntero resb 8
    stringResiduo resb 8
    resta resb 255
    Matriz resb 100
;****************+
;Code Section
section .text
    global _start
    _start:
    ;---------------------
    ;Display header line ....
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
        mov rax, SYS_read           ;Valor para lectura
        mov rdi, qword[fileDesc]    ;Donde se gaurdara la direccion del archivo
        mov rsi, readBuffer         ;Lugar donde se guardaran los datos leidos
        mov rdx, BUFF_SIZE          ;Numero de bytes que se leeran
        syscall                     ;Llamada al sistema
        cmp rax,0                   ;Tiene el numero de bytes leidos
        jl errorOnRead              ;Si es negativo es un error en la escritura
        mov rbx, rax                ;Guardamos el numero de bits leidos
        mov qword[BYTES_LEIDOS], rbx
        ;-------------------
        ;Print mess 
        mov rdi, paso               ;Impresion en pantalla, solo para efectos visuales
        call printString            ;Impresion
        ; Print the buffer
        ; add the null for print string
        mov rsi,readBuffer          ;Direccion donde se guardaron los char
        mov byte[rsi+rbx], NULL     ;Se agrega un NULL al final de la cadena
        mov rdi, readBuffer         ;Impresion en pantalla, solo para efectos visuales         
        call printString
        ;----------
        mov rdi, readBuffer ;Lugar donde tenemos la matriz como texto
        mov rsi, Matriz ;Matriz donde la queremos guardar
        mov rdx, BYTES_LEIDOS
        call crear_matriz
        ;call procesarMatriz ;Convertir archivo a matriz variable
        mov rdi, newline               ;Impresion en pantalla, solo para efectos visuales
        call printString
        ;--------------------------------------------------------- MENU
        mov rdi, opciones ;Despliega opciones
        call printString
        mov rdi, opcionElegida  ;Donde guardamos la opcion elegida
        call readString         ;Impresion
        mov bl, byte[opcionElegida] ;Valor leido
        sub bl, '0'                 ;Restamos para convertir en el valor real
        mov byte[opcionElegida], bl ;Movemos a una variable local
        cmp bl, 4                   ;Comparamos el valor con las opciones
        jge last ;Si es 3 o cualquier numero mayor a 3, se sale
        cmp bl, 1 ;Si es mayor a 1 (Cualquier eleccion entre 1 - 3)
        jge leerVectores ;Para la lectura por teclado de los datos
        jmp last ;Validacion de algun otro error
        leerVectores: ;Lee los vectores que estaremos usando
            mov rdi, primerX               ;Impresion en pantalla, solo para efectos visuales
            call printString
            ;-----------Primer Vector-----------------------------------
            ;Valor en X
            mov rdi, strX               ;Impresion en pantalla, solo para efectos visuales
            call printString
            mov rdi, x                  ;Donde sera guardado el valor leido
            call readString             ;Lee el valor en X
            mov bl, byte[x]             ;Pasanos el valor que se ingreso
            sub bl, '0'                 ;Convierte a entero
            mov byte[x], bl             ;Se guarda la posicion elegida
            mov rdi, strY               ;Impresion en pantalla, solo para efectos visuales
            call printString
            mov rdi, y                                    ;Donde sera guardado el valor leido
            call readString ;Lee el valor en X
            mov bl, byte[y] ;Pasanos el valor que se ingreso
            sub bl, '0' ;Convierte a entero
            mov byte[y], bl ;Se guarda la posicion elegida
            mov rdi, x          ;Necesario para la funcion, valor de x
            mov rsi, y          ;Necesario para la funcion, valor de y
            mov rdx, value1     ;Necesario para la funcion, valor donde guardar
            mov rcx, Matriz     ;Necesario para la funcion, Matriz donde buscara los datos
            call coords ;Saca el valor de las coordenadas seleccionadas
            mov al, byte[value1]    ;Movemos el valor que obtuvimos de la funcion a al
            mov byte[vector1],al    ;Valor en X, lo guardamos en vector 
            ;----------------------------------------------------------
            mov rdi, segundoX
            call printString
            ;----------Valor en Y---------------------------------
                mov rdi, strX          ;Unicamete para efectos de impresion en pantalla
                call printString
                mov rdi, x2                  ;Donde sera guardado el valor leido
                call readString ;Lee el valor en X
                mov bl, byte[x2] ;Pasanos el valor que se ingreso
                sub bl, '0' ;Convierte a entero
                mov byte[x2], bl ;Se guarda la posicion elegida
                mov rdi, strY          ;Unicamete para efectos de impresion en pantalla
                call printString
                mov rdi, y2                  ;Donde sera guardado el valor leido
                call readString ;Lee el valor en X
                mov bl, byte[y2] ;Pasanos el valor que se ingreso
                sub bl, '0' ;Convierte a entero
                mov byte[y2], bl ;Se guarda la posicion elegida
                mov rdi, x2         ;VALORES NECESARIOS, LOS MISMOS EXPLICADOS
                mov rsi, y2         ;EN LA ANTERIOR FUNCION
                mov rdx, value2
                mov rcx, Matriz
                call coords ;Saca el valor de las coordenadas seleccionadas
                mov al, byte[value2]
                mov byte[vector1+1],al ;Valor en Y
            ;----------------------------------------------------------
            ;-------------------------segundo vector
            mov rdi, primerY          ;Unicamete para efectos de impresion en pantalla
            call printString
            ;-----------Primer Vector-----------------------------------
            ;Valor en X
            mov rdi, strX          ;Unicamete para efectos de impresion en pantalla
            call printString
            mov rdi, x                  ;Donde sera guardado el valor leido
            call readString ;Lee el valor en X
            mov bl, byte[x] ;Pasanos el valor que se ingreso
            sub bl, '0' ;Convierte a entero
            mov byte[x], bl ;Se guarda la posicion elegida
            mov rdi, strY          ;Unicamete para efectos de impresion en pantalla
            call printString
            mov rdi, y                   ;Donde sera guardado el valor leido
            call readString ;Lee el valor en X
            mov bl, byte[y] ;Pasanos el valor que se ingreso
            sub bl, '0' ;Convierte a entero
            mov byte[y], bl ;Se guarda la posicion elegida
            mov rdi, x         ;VALORES NECESARIOS, LOS MISMOS EXPLICADOS ANTERIORMENTE
            mov rsi, y
            mov rdx, value1
            mov rcx, Matriz
            call coords ;Saca el valor de las coordenadas seleccionadas
            mov al, byte[value1]
            mov byte[vector2],al ;Valor en X 
            ;----------------------------------------------------------
            mov rdi, segundoY          ;Unicamete para efectos de impresion en pantalla
            call printString
            ;----------Valor en Y---------------------------------
            mov rdi, strX          ;Unicamete para efectos de impresion en pantalla
            call printString
            mov rdi, x2                   ;Donde sera guardado el valor leido
            call readString ;Lee el valor en X
            mov bl, byte[x2] ;Pasanos el valor que se ingreso
            sub bl, '0' ;Convierte a entero
            mov byte[x2], bl ;Se guarda la posicion elegida
            mov rdi, strY          ;Unicamete para efectos de impresion en pantalla
            call printString
            mov rdi, y2                   ;Donde sera guardado el valor leido
            call readString ;Lee el valor en X
            mov bl, byte[y2] ;Pasanos el valor que se ingreso
            sub bl, '0' ;Convierte a entero
            mov byte[y2], bl ;Se guarda la posicion elegida
            mov rdi, x2         ;VALORES NECESARIOS, LOS MISMOS EXPLICADOS ANTERIORMENTE
            mov rsi, y2
            mov rdx, value2
            mov rcx, Matriz
            call coords ;Saca el valor de las coordenadas seleccionadas
            mov al, byte[value2]
            mov byte[vector2+1],al ;Valor en Y
        mov bl, byte[opcionElegida] ;Tomamos ahora el byte de la opcion seleccionado al inicio
        cmp bl, 2                   ;Comparamos el valor con 2
        jg mahalanobis              ;Si es mayor (3) va a mahalanobis
        je manhattan                ;Si es menor (1) va a manhattan
        euclidian:
            ;Se hace la llamada a la funcion que lo calcula
            mov rdi, vector1 ;Valor vector 1
            mov rsi, vector2 ;Valor vector 2
            mov rdx, resEuclidianEntero ;Donde se guardara la parte entera
            mov rcx, resEuclidianResiduo ;Donde se guardara la parte del residuo
            call calcEuclidian ;Funcion que lo calcula
            toChar resEuclidianEntero, stringEntero ;Macro que lo convierte a texto
            toChar resEuclidianResiduo, stringResiduo ;Macro que lo convierte a texto
            jmp imprimirResultado
        manhattan:
            ;Se hace la llamada a la funcion que lo calcula
            mov rdi, vector1 ;Valor vector 1
            mov rsi, vector2 ;Valor vector 2
            mov rdx, resManhattanEntero ;Donde se guardara la parte entera
            mov rcx, resManhattanResiduo ;Donde se guardara la parte del residuo
            call calcManhattan ;Funcion que lo calcula
            toChar resManhattanEntero, stringEntero ;Macro que lo convierte a texto
            toChar resManhattanResiduo, stringResiduo ;Macro que lo convierte a texto
            jmp imprimirResultado
        mahalanobis:
            ;Se hace la llamada a la funcion que lo calcula
            mov rdi, vector1 ;Valor vector 1
            mov rsi, vector2 ;Valor vector 2
            mov rdx, elementos  ;Numero de elementos en los vectores
            call calcMahalanobis ;Funcion que lo calcula
            cmp rax, 0 ;Segun el valor retornado
            jl errorMaha
            toChar resMahalanobisEntero, stringEntero ;Macro que lo convierte a texto
            toChar resMahalanobisResiduo, stringResiduo ;Macro que lo convierte a texto
            jmp imprimirResultado
        imprimirResultado:
        mov rdi, valor          ;Unicamete para efectos de impresion en pantalla
        call printString
        mov rdi, stringEntero   ;Valor de la parte entera del resultado
        call printString
        mov rdi, dot            ;Punto: .
        call printString
        mov rdi, stringResiduo  ;Valor de la parte del residuo
        call printString
        jmp cerrarArchivo       ;Brinca hasta cerrar el archivo
        ;----------
        ;Print mess
        cerrarArchivo:                     ;Cerramos el archivo
        mov rdi, closef                    ;Mensaje de el cierre del archivo
        call printString                   ;Imprime
        ;Close the file
        ;System Service -close
        mov rax, SYS_close                  ;Valor para cerrar el archivo
        mov rdi, qword[fileDesc]            ;Direccion donde se abrio el archivo
        syscall                             ;Llamada al sistema
        jmp last
    errorOpen:
        mov rdi, errMsgOpen                 ;Error al abrir el archivo
        call printString                    ;Imprime
        jmp last                            ;Termina
    errorOnRead:
        mov rdi,errMSgWrite                 ;Mensaje de error en la escritura
        call printString                    ;Imprime
        jmp cerrarArchivo                   ;Cierra el archivo 
    errorMaha:                              ;Error en mahalanobis
        mov rdi, errorSemipos               ;Error de semipositividad
        call printString                    ;Imprime
        jmp cerrarArchivo                   ;Cierra el archivo
    last:
        mov rax, SYS_exit                   ; Call code for exit
        mov rdi, EXIT_SUCCESS               ; Exit program with success
        syscall
;+++++++++++++++++++
;Generic function to display a string to the screen
;String must be NULL terminated
;+++++++++++++++++++
global printString                          ;Funcion que imprime caracteres
printString:
    push rbx                                ;epilogue
    ;Count characters in string
    mov rbx, rdi                            ;Direccion del rdi a rbx
    mov rdx, 0                              ;Limpieamos el registro 
    countStrLoop:
        cmp byte[rbx], NULL                 ;Comparamos si el valor es null, osea el fin de la cadena
        je countStrDone                     ;Si es asi termina de leer
        inc rdx                             ;Aumentamos rdx
        inc rbx                             ;Aumentamos rbx
        jmp countStrLoop                    ;Sigue leyendo
    countStrDone:
        cmp rdx,0                           ;Si termina de leer compara el rdx con 0
        je prtDone                          ;Si es igual termina la impresion
    ;------------
    ;Call OS to output string.
    mov rax, SYS_write                  ;System codo for write()
    mov rsi,rdi                         ;Address of chars to write
    mov rdi,STDOUT                      ; standard out
    syscall
    ;--------
    ;String printed, return to calling routine---prologue
    prtDone:
          pop rbx                           ;prologue
          ret                               ;Retorno
;+++++++++++++++++++
global readString                       ;Esta funcion lee por teclado
    readString: 
    push rax                            ;Epilogo
    push rbx                            ;Epilogo
    push r12                            ;Epilogo
    push r13                            ;Epilogo
    mov r13, rdi                        ;Direccion de donde se guardara lo leido
    ;Leer el string
        mov rbx, inline                 ;Se guardara aqui lo leido
        mov r12, 0                      ;Contador de caracteres
        readChars:
            mov rax, SYS_read           ;Valor para interrupcion de lectura
            mov rdi, STDIN              ;Valor de donde se leera
            lea rsi, byte[chr]          ;Donde se ira guardando los caracteres leidos
            mov rdx, 1                  ;Numero de caracteres que se leeran
            syscall                     ;Llamada a la interrupcion del sistema
            mov al, byte[chr]           ;Se mueve el char leido a Al
            cmp al, LF                  ;Lo comparamos con un salto de linea
            je readDone                 ;Si es un salto de linea terminamos de leer
            inc r12                     ;Incrementamos el numero de caracter de no ser un LF
            cmp r12, 2                  ;Lo comparamos con el numero de caracetres a ingresar (2)
            jae errStr                  ;Si se pasa es un overflow
            mov byte[rbx], al           ;De no ser asi el valor leido guarda en rbx
            inc rbx                     ;Incrementamos este mismo
            jmp readChars               ;Volvemos a la lectura de caracteres
        readDone:                       ;Termino de leer
            mov byte[rbx], NULL         ;Una vez terminado se agrega un null al final de la cadena leida
            mov rbx, inline             ;Movemos la direccion a rbx donde guardamos
            mov dl, byte[rbx]           ;Leemos un byte
            mov byte[r13], dl           ;Lo movemos a donde se guardara lo leido, ya con un null puesto
            jmp endRead                 ;Terminada la lectura
        errStr:                         ;De haber un error en lectura
                mov rdi, messERR        ;Mensaje de error
                mov rbx, rdi            ;Se mueve a rbx la direccion donde guardamos el mensaje de error
                mov rdx, 0              ;Limpiamos con 0 el registro
                countChars:             ;
                    cmp byte[rbx],NULL  ;Verificamos si es el fin de cadena
                    je countDone        ;Termina de leer el mensaje
                    inc rdx             ;Aumentamos rdx
                    inc rbx             ;Aumentamos rbx
                    jmp countChars      ;Seguimos en la lectura
                countDone:              ;Termina de leer el mensaje
                    cmp rdx, 0          ;Comparamos el valor en rdx
                    je prtDone          ;Si es igual a 0 terminamos la lectura
                ;Llamada a sistema para imprimir
                mov rax, SYS_write          ;Valor de la llamada al sistema para escribir
                mov rsi, rdi                ;Direccion de donde escribirlo
                mov rdi, STDOUT             ;File descriptor de donde escribir
                syscall                     ;Llamada al sistema
            mov rax, SYS_exit               ; Call code for exit
            mov rdi, EXIT_SUCCESS           ; Exit program with success
            syscall                         ;Llamada al sistema
            jmp endRead                     ;Se termino de leer
    endRead:
    pop r13                                 ;Prologo
    pop r12                                 ;Prologo
    pop rbx                                 ;Prologo
    pop rax                                 ;Prologo
    ret                                     ;Return
global coords                               ;Esta funcion encuentra el valor en la matriz segun las coordenadas
    coords:             
        ;rdi = X ;1
        ;rsi = Y ;1
        ;rdx = Resultado
        ;rcx = Matriz
        push rax                            ;Epilogo
        push rbx                            ;Epilogo
        push r12                            ;Epilogo
        push r13                            ;Epilogo
            mov r13, rdx                    ;Movemos la direccion donde se guarda el resultado a r13
            mov rdx, 0                      ;Inicializamos el valor en 0
            mov al, byte[rsi]               ;Tomamos el valor en Y
            mov bl, byte[rdi]               ;Tomamos el valor en X
            mov rdx, 10                     ;Usaremos este valor para calcular la posicion en la matriz
            mul dl                          ;Se multiplica Y*10 para obtener la primera posicion en la fila indicada
            mov dl, 0                       ;Limpiamos el valor de dl 
            add al, bl                      ;Ahora sumamos el valor de Y mas X, calculando asi los bits a recorrer en la matriz
            mov r12, rax                    ;Movemos el valor de la suma a un registro r12
            mov rax, 0                      ;Limpiamos el registro A
            mov al, byte[rcx+r12]           ;Ahora movemos al registro A el valor que ubicamos en la matriz, dado la suma anterior
            mov byte[r13], al               ;Ahora guardamos el valor que buscamos a la variable de regreso
        pop r13                             ;Prologo
        pop r12                             ;Prologo
        pop rbx                             ;Prologo
        pop rax                             ;Prologo
    ret                                     ;Return
global calcEuclidian
    calcEuclidian:
        ;rdi = vector 1
        ;rsi = vector 2
        ;rdx = entero
        ;rcx = residuo
        push r12                            ;Resta de X
        push r13                            ;Resta de Y
        push rbx                            ;Valores en los vectores
        push rax                            ;Resta de X
        push r14                            ;Ubicacion del residuo
        mov r14, rcx                        ;Pasamos la direccion de residuo a r14
        mov rcx, rdx                        ;Ahora la ubicacion de entero a rcx
        mov rdx, 0                          ;Limpia rdx (inicializar a 0)
        mov rax, 0                          ;Limpia rax (inicializar a 0)
        mov rbx, 0                          ;Limpia rbx (inicializar a 0)

        mov bl, byte[rdi]                   ;Comenzamos tomando el primer valor x del primer vector
        mov al, byte[rsi]                   ;Ahora hacemos lo mismo con el segundo vector
        sub al, bl                          ;Restamos los valores de ambos, se guardan en ax  

        mov dl, al                          ;Guardamos el valor de la resta en dl, para hacer la potencia
        imul al                             ;Multiplicamos el mismo valor, para efectos de potencia
        mov r12, rax                        ;Ahora guardamos este valor de potencia a r12

        mov bl, byte[rdi+1]                 ;Ahora hacemos lo mismo, pero tomamos los valores en Y
        mov al, byte[rsi+1]                 ;Hacemos lo mismo con el segundo vector
        sub al, bl                          ;Resta de Y, se guarda en al  

        mov dl, al                          ;Guardamos la resta anterior en dl, para potenciacion
        imul al                             ;Multiplicamos al*bl donde al = bl, lo mismo que al^2
        mov r13, rax                        ;Lo mandamos a r13
        add r12, r13                        ;Y ahora para manejar el numero a r12

        mov qword[resEuclidianEntero], r12  ;Guardamos dicho valor en una variable
        movsx eax, word[resEuclidianEntero] ;Lo movemos como floante a el registro eax
        cvtsi2sd xmm0, eax                  ;Ahora convertimos el registro a otro de punto flotante
        sqrtsd xmm0, xmm0                   ;Hacemos la raiz, se guarda en xmm0
        mov rax, 0                  
        cvttsd2si eax, xmm0                 ;Tomamos la parte entera 
        mov qword[resEuclidianEntero], rax  ;Devuelve el valor de la parte entera
        cvtsi2sd xmm1, rax                  ;Lo convertimos a flotante para seguir manipulando el numero 
        subsd xmm0, xmm1                    ;Se resta la parte entera para obtener el decimal
        movsx eax, word[precision]          ;Aqui se guarda la precision, de cuantos 0
        cvtsi2sd xmm2, eax                  ; Aqui se establece cuantos 0 vamos a usar (en impresion)
        mulsd xmm0, xmm2                    ; Se multiplica residuo por los decimales
        cvttsd2si ebx, xmm0                 ; Guardamos el residuo en un entero para efectos de impresion
        mov qword[resEuclidianResiduo], rbx ;Guardamos de la misma manera el residuo en una varibale 

        pop r14                             ;Prologo
        pop rax                             ;Prologo
        pop rbx                             ;Prologo
        pop r13                             ;Prologo
        pop r12                             ;Prologo
        ret                                 ;Return
global calcManhattan                ;Calculo de las distancias manhattan
    calcManhattan:
        ;rdi = vector 1
        ;rsi = vector 2
        ;rdx = entero
        push rbx                    ;Epilogo
        push rax                    ;Epilogo
            mov bl, byte[rsi]       ;Tomamos el primer valor del vector 2 al registro bl
            mov al, byte[rdi]       ;Tomamos el primer valor del vector 1 al registro al
            sub al, bl              ;Resta de los primeros valores (x)
            mov cl, al              ;Lo guardamos en el registro cl
            cmp cl, 0               ;Comparamos el valor con 0
            jge notNeg1             ;Si es mayor a 0 entonces no es negativo
            neg cl                  ;Si es negativo lo convertimos a positivo
            notNeg1:                ;Si no es negativo
            mov bl, byte[rsi+1]     ;Continuamos con el segundo valor del vector 2
            mov al, byte[rdi+1]     ;Continuamos con el segundo valor del vector 1
            sub al, bl              ;Resta de los valores en Y
            cmp al, 0               ;Nuevamente comparamos con 0
            jge notNeg2             ;Si es mayor no es negativo
            neg al                  ;Negamos de ser negativo, para convertir a positivo
            notNeg2:                ;Si no es negativo
            add al, cl              ;Sumamos ambas restas que hicimos antes
            mov qword[rdx], rax     ;Ahora movemos el valor de la suma a rdx, el puntero para imrprimir el resultado
        pop rax                     ;Prologo
        pop rbx                     ;Prologo
        ret                         ;Retorna
global calcMahalanobis
        calcMahalanobis:
            ;rdi = vector 1
            ;rsi = vector 2
            ;rdx = Numero de elementos en los vectores
            push r12                                ;Epilogo
            push rcx                                ;Epilogo
            mov r12, 0                              ;Para evitar basura en el registro
            mov rax, 0                              ;Para evitar basura en el registro
            mov rcx, 0                              ;Para evitar basura en el registro
            mov cl, byte[rdx]                       ;Cargamos el numero de elementos para el loop
            mov word[n], cx                         ;De la misma manera lo guardamos en una variable
            restaEntreVectores:                     ;Comenzamos haciendo las restas entre valores
                mov bl, byte[rdi+r12]               ;Cargamos un valor del vector 1
                mov al, byte[rsi+r12]               ;Cargamos un valor del vector 2
                sub al, bl                          ;Restamos ambos valores 
                mov word[resta+r12*2], ax           ;Guardamos el valor de la resta en una variable
                inc r12                             ;Incrementamos el apuntador
            loop restaEntreVectores                 ;
            mov rax, 0                              ;Para evitar basura en el registro
            mov rbx, 0                              ;Para evitar basura en el registro
            ;-------------- AQUI YA TENEMOS EL VALOR DE LAS RESTAS SEGUN LOS ELEMENTOS DE LOS VECTORES
            desviacion1:                            ;Calcular la desviacion estandar del primer vector
                mov rax, 0                          ;Para evitar basura en el registro
                mov rbx, 0                          ;Para evitar basura en el registro
                ;----------------Comenzamos calculando la media del vector: u
                mov rcx, r12                        ;Colocamos el numero de elemmentos en RCX para usar loops
                dec rcx                             ;Hacemos uno menos, dado a que es por operaciones y no elementos
                mov r12, 1                          ;Nuestro contador comienza en 1 porque el primer elemento  lo tomamos antes
                mov al, byte[rdi]                   ;Tomamos el primer elemento del vector dado, para la primera suma
                loopSuma1:                      ;Loop donde se llevata a cabo la suma de los elementos
                    mov bl, byte[rdi+r12]           ;Tomamos otro elemento, pero en este caso, se comienza por el segundo elemento
                    add al, bl                      ;Se realiza la suma de los elementos y se guarda progresivamente en el registro A
                    inc r12                         ;Incrementamos el indice de donde se lee el elemento en el registro bl
                loop loopSuma1                  ;Segun las vueltas necesarias sigue en el loop
                mov rdx, r12                        ;Guardamos en rdx el numero de elementos
                ;---------------Ahora despues de la suma, lo dividimos para sacar la media
                mov word[suma], ax                  ;Cargamos el valor del registro A es donde teniamos guardado la suma de los elementos a una variable
                mov rax, 0                          ;Para evitar basura en el registro
                movsx ebx, word[n]                  ;Movemos como flotante el valor de N al registro ebx
                cvtsi2sd xmm0, ebx                  ;Lo cargamos ahora a un registro de punto flotante
                movsx eax, word[suma]               ;Cargamos el valor de la suma como flotante
                cvtsi2sd xmm1, eax                  ;Ahora cargamos a un registro de punto flotante el valor de la suma
                divsd xmm1, xmm0                    ;Realizamos la division, el resultado se guarda en xmm
                ;---------------Cuadrado de la distancia a la media: |x-u|^2
                mov r12, 0                          ;Para evitar basura en el registro
                mov rdx, 0                          ;Para evitar basura en el registro
                mov cl, byte[n]                     ;Cargamos el numero de elementos por vector al registro cl
                ;---------------Comenzamos con la resta de las diferencias (|x-u|)
                sumaDiferencias:                ;Loop para la resta de x - u (media)
                mov dl, byte[rdi+r12]               ;Movemos un valor del vector (x) al registro dl
                mov qword[auxiliar], rdx               ;Ahora lo cargamos a una variable para manejarlo mas facilmente
                movsx edx, word[auxiliar]              ;Movemos el valor, ahora como flotante pero al registro edx
                cvtsi2sd xmm0, edx                  ;Cargamos ahora si a un registro flotante
                subsd xmm0, xmm1                    ;Restamos a el valor (x) el promedio antes calculado (u)
                ucomisd xmm0, qword[Zero]           ;Comparamos el resultado de la resta con 0 y si es negativo lo convertimos a positivo
                jae notNegM                          ;Si es mayor que 0 sigue a la potenciacion
                xorps xmm2, xmm2                    ; xmm2 = 0.0
                subps xmm2, xmm0                    ; xmm2 = -xmm0
                movaps xmm0, xmm2                   ; xmm0 = xmm2 (cambia el signo de xmm0)
                notNegM:                         ;Si es positivo
                mulsd xmm0, xmm0                    ;Multiplicamos el mismo resultado por el, para efectos de potencia
                addsd xmm3, xmm0                    ;Vamos guardando la sumatoria en otro registro
                inc r12                             ;Incrementamos el indice para en la siguiente vuelta tomar otro valor (x)
                loop sumaDiferencias                ;Si quedan saltos vuelve a tomar otro elemento y hacer el mismo proceso
                ;---------------Ahora dividimos la suma entre el numero de elementos (suma(x-u)^2)/n
                wtf:
                mov edx, 0
                movsx eax, word[n]                  ;Cargamos el valor de elementos a un registro como flotante
                cvtsi2sd xmm0, eax                  ;Lo convertimos a un registro flotante
                movsx edx, word[decremento]
                cvtsi2sd xmm12, edx       ;Cargar el valor a decrementar en xmm12
                subsd xmm0, xmm12                   ; Decrementar xmm0 por xmm12
                divsd xmm3, xmm0                    ;Ahora dividimos el valor de la sumatoria de las diferencias entre el numero de elementos
                ;---------------Finalmente calculamos la raiz para obtener la desviacion
                sqrtsd xmm0, xmm3                   ;Guardamos el valor de la desviacion estandar en xmm0
                ;---------------Fin de la primera desviacion estandar
            desviacion2:                            ;Calcular la desviacion estandar del primer vector
                mov r12, 0                          ;Para evitar basura en el registro
                mov rax, 0                          ;Para evitar basura en el registro
                mov rbx, 0                          ;Para evitar basura en el registro
                mov rcx, 0 
                ;----------------Comenzamos calculando la media del vector: u
                mov cl, byte[n]                        ;Colocamos el numero de elemmentos en RCX para usar loops
                dec rcx                             ;Hacemos uno menos, dado a que es por operaciones y no elementos
                mov r12, 1                          ;Nuestro contador comienza en 1 porque el primer elemento  lo tomamos antes
                mov al, byte[rsi]                   ;Tomamos el primer elemento del vector dado, para la primera suma
                loopSuma2:                      ;Loop donde se llevata a cabo la suma de los elementos
                    mov bl, byte[rsi+r12]           ;Tomamos otro elemento, pero en este caso, se comienza por el segundo elemento
                    add al, bl                      ;Se realiza la suma de los elementos y se guarda progresivamente en el registro A
                    inc r12                         ;Incrementamos el indice de donde se lee el elemento en el registro bl
                loop loopSuma2                  ;Segun las vueltas necesarias sigue en el loop
                mov rdx, r12                        ;Guardamos en rdx el numero de elementos
                ;---------------Ahora despues de la suma, lo dividimos para sacar la media
                mov word[suma], ax                  ;Cargamos el valor del registro A es donde teniamos guardado la suma de los elementos a una variable
                mov rax, 0                          ;Para evitar basura en el registro
                movsx ebx, word[n]                  ;Movemos como flotante el valor de N al registro ebx
                cvtsi2sd xmm4, ebx                  ;Lo cargamos ahora a un registro de punto flotante
                movsx eax, word[suma]               ;Cargamos el valor de la suma como flotante
                cvtsi2sd xmm5, eax                  ;Ahora cargamos a un registro de punto flotante el valor de la suma
                divsd xmm5, xmm4                    ;Realizamos la division, el resultado se guarda en xmm
                ;---------------Cuadrado de la distancia a la media: |x-u|^2
                mov r12, 0                          ;Para evitar basura en el registro
                mov rdx, 0                          ;Para evitar basura en el registro
                mov cl, byte[n]                     ;Cargamos el numero de elementos por vector al registro cl
                ;---------------Comenzamos con la resta de las diferencias (|x-u|)
                sumaDiferencias2:                ;Loop para la resta de x - u (media)
                mov dl, byte[rsi+r12]               ;Movemos un valor del vector (x) al registro dl
                mov qword[auxiliar], rdx               ;Ahora lo cargamos a una variable para manejarlo mas facilmente
                movsx edx, word[auxiliar]              ;Movemos el valor, ahora como flotante pero al registro edx
                cvtsi2sd xmm4, edx                  ;Cargamos ahora si a un registro flotante
                subsd xmm4, xmm5                    ;Restamos a el valor (x) el promedio antes calculado (u)
                ucomisd xmm4, qword[Zero]           ;Comparamos el resultado de la resta con 0 y si es negativo lo convertimos a positivo
                jae notNegM2                         ;Si es mayor que 0 sigue a la potenciacion
                xorps xmm6, xmm6                    ; xmm6 = 0.0
                subps xmm6, xmm4                    ; xmm6 = -xmm4
                movaps xmm4, xmm6                   ; xmm4 = xmm6 (cambia el signo de xmm4)
                notNegM2:                         ;Si es positivo
                mulsd xmm4, xmm4                    ;Multiplicamos el mismo resultado por el, para efectos de potencia
                addsd xmm7, xmm4                    ;Vamos guardando la sumatoria en otro registro
                inc r12                             ;Incrementamos el indice para en la siguiente vuelta tomar otro valor (x)
                loop sumaDiferencias2               ;Si quedan saltos vuelve a tomar otro elemento y hacer el mismo proceso
                ;---------------Ahora dividimos la suma entre el numero de elementos (suma(x-u)^2)/n
                movsx eax, word[n]                  ;Cargamos el valor de elementos a un registro como flotante
                cvtsi2sd xmm4, eax                  ;Lo convertimos a un registro flotante
                subsd xmm4, xmm12                   ;Decrementar xmm4 por xmm12
                divsd xmm7, xmm4                    ;Ahora dividimos el valor de la sumatoria de las diferencias entre el numero de elementos
                ;---------------Finalmente calculamos la raiz para obtener la desviacion
                sqrtsd xmm4, xmm7                   ;Guardamos el valor de la desviacion estandar en xmm4
                ;---------------Fin de la primera desviacion estandar
            ;Ahora, una vez que tenemos las varianzas, calculamos la distancia de mahalanobis
            ;xmm0 = desviacion 1
            ;xmm4 = desviacion 2
            Division:                               ;Ahora hacemos la division para el proceso de mahalobis
                mov rax, 0                          ;Para evitar basura en el registro
                mov rbx, 0                          ;Para evitar basura en el registro
                mov rcx, 0                          ;Para evitar basura en el registro
                mov rdx, 0                          ;Para evitar basura en el registro
                ;Cargamos al registro xmm8 el valor de la primera resta, que calculamos al inicio
                movsx eax, word[resta]              ;Pasamos el primer valor de la resta que hicimos al inicio
                cvtsi2sd xmm8, eax                  ;Lo convertimos y pasamos a un registro flotante
                divsd xmm8, xmm0                    ;Dividimos el valor de la resta entre la primera desviacion
                ;Cargamos al registro xmm9 el valor de la segunda resta, que calculamos al inicio
                movsx ebx, word[resta+2]            ;Pasamos el segundo valor de la resta que hicimos al inicio
                cvtsi2sd xmm9, ebx                  ;De la misma manera lo convertimos a punto flotante
                divsd xmm9, xmm4                    ;Hacemos otra division, ahora con la segunda desviacion
            Potencia:                               ;Seguimos con la potencia del resultado
                mulsd xmm8, xmm8                    ;Multiplicamos el resultado de la division por el mismo, para potenciacion
                mulsd xmm9, xmm9                    ;Multiplicamos el resultado de la division por el mismo, para potenciacion
                addsd xmm8, xmm9                    ;Sumamos ambas potencias en el registro xmm8
            Raiz:                                   ;Procedemos como ultimo paso a calcular la raiz
                sqrtsd xmm8, xmm8                   ;Hacemos la raiz cuadrada y lo guardamos en el mismo registro flotante
            ResultadoFinal:                         ;Ahora con el resultado calculamos las partes para regresar e imprimir
                cvttsd2si eax, xmm8                 ;Tomamos la parte entera del resultado 
                mov qword[resMahalanobisEntero], rax;Devolvemos en una variable el valor del entero
                cvtsi2sd xmm10, rax                 ;Lo convertimos a flotante para seguir manipulando el numero 
                subsd xmm8, xmm10                   ;Se resta la parte entera para obtener el residuo
                movsx eax, word[precision]          ;El valor de precision indica cuantos 0 tendremos, ej: 1000 = 4 ceros
                cvtsi2sd xmm11, eax                 ;Aqui se establece cuantos 0 vamos a usar (en impresion)
                mulsd xmm8, xmm11                   ;Se multiplica residuo por los decimales, asi convertimos 0.1234 a 1234.0
                cvttsd2si ebx, xmm8                 ;Guardamos como entero ahora para efectos de impresion en pantalla
                mov qword[resMahalanobisResiduo], rbx;Guardamos dicho valor en la variable
            ;Validaciones requeridas por el metodo
            ;La distancia entre dos puntos de las mismas coordenadas es cero, y si tienen coordenadas distintas la  
            ;distancia es positiva, pero nunca negativa.
            semipositividad: 
                ucomisd xmm4, qword[Zero]           ;Comparamos el valor final para verificar esta propiedad
                jae final                           ;Si es positivo es todo correcto
                mov rax, -1                         ;Si es negativo enviamos la respuesta por rax
                jmp endF                            ;Va al final
    final:                                          ;Terminamos el programa
    mov rax, 0                                      ;Se envia un valor positivo
    endF:                                           ;Final 
    pop rcx                                         ;Prologo
    pop r12                                         ;Prologo
    ret                                             ;Retorno
; Función que elimina los 32 [Espacios], los 10 [LF] y vuelve todo decimal
; global newMatriz
global crear_matriz
    crear_matriz:
    ;rdx = Bytes leidos, fin de cadena
    ;rdi = Texto
    ;rsi = Matriz
        push rbp               ;Epilogo
        push r12               ;Epilogo
        push r13               ;Epilogo
        push r14               ;Epilogo
        mov r13, qword[rdx]     ;Bytes leidos, para comenzar por el final
        dec r13                 ;Restamos 1 elemento del tamaño
        mov r14, 99             ;Dado que el ciclo comienza en este numero al inverso y cuenta el 0 (Numero de elementos en el arreglo)
        mov rbp, rsp            
        prev:
            mov r12,0           ;Contador de elementos que van en un solo byte leidos
        bucle_lectura:
            mov al, byte [rdi+r13] ; Leer un byte del primer espacio reservado
            cmp r13, 0          ; Comprobar si el contador de bytes leidos llego a 0
            je etiqueta_salida  ; Salir del bucle si llego a 0
            cmp al, 32          ; Comprobar si el valor es un espacio (32)
            je etiqueta_salto   ; Saltar al siguiente carácter si es un espacio
            cmp al, 10          ; Comprobar si el valor es un salto de línea (10)
            je etiqueta_salto   ; Saltar al siguiente carácter si es un salto de línea

            sub al, 48         ; Restar 48 para convertir el valor ASCII a decimal
            mov bl, al         ; Lo movemos a otro registro por que utilizaremos al
            
            cmp r12, 1          ;Para saber cuantos elementos hemos leido
            jl zzero            ;Un elemento
            je first            ;Dos elementos
            second:             ;Tres elementos
            mov al, 10          ;Hacemos una potencia de 10
            mul al              ;Igual manera se pudo poner el 100 al inicio y evitar la multiplicacion
            mul bl              ;Multiplicamos el elemento por 100, para que tenga asu valor real
            jmp zzero           ;Va al final
            first:              ;Un elemento
            mov al, 10          ;Lo multiplicaremos por 10 para que tenga su valor correcto
            mul bl              ;Si valia 2 ahora valdra 20 y tendra sentido en la sumatoria final 
            jmp zzero           ;Final
            zzero:              ;Si es solo un elemeneto 
            push rax            ;Se sube a la pila 

            inc r12             ;Incrementamos el contador de elementos
            dec r13             ;Decrementamos el puntero para leer en reversa
            jmp bucle_lectura   ;Sigue leyendo
        etiqueta_salto:         ;Si terminamos de leer un byte (1 o 3 digitos)
            mov rcx, 0          ;Iniciamos en 0 el valor
            loopPopX:           ;Ciclo para sacar los elementos
                pop rax         ;Sacamos el primer elemento en la pila
                add cl, al      ;Vamos sumando sus valores en la siguiente variable
                dec r12         ;Decrementamos el contador del elemento que estamos
                cmp r12, 0      ;Si ya no hay mas elementos por sacar y sumar termina
            jg loopPopX 
            mov byte[rsi+r14], cl ; Guardar el valor convertido en el segundo espacio reservado
            dec r13             ;Decremental el puntero de lectura a la inversa
            dec r14             ;Decrementa la posicion del byte donde escribira en el segundo espacio reservado
            jmp prev            ; Volver al inicio del bucle
        etiqueta_salida:
            mov byte[rsi+101], 0  ; Colocar un byte cero al final del segundo espacio reservado
        ; Prologo
        pop r14                 ;Prologo
        pop r13                 ;Prologo
        pop r12                 ;Prologo
        pop rbp                 ;Prologo
    ret; Comprobar si el valor es un salto de línea (10)
            je etiqueta_salto  ; Saltar al siguiente carácter si es un salto de línea
            sub al, 48         ; Restar 48 para convertir el valor ASCII a decimal
            mov byte [rsi], al ; Guardar el valor convertido en el segundo espacio reservado
            inc rsi            ; Incrementar la dirección de memoria del segundo espacio reservado
        etiqueta_salto:
            inc rdi            ; Incrementar la dirección de memoria del primer espacio reservado
            jmp bucle_lectura  ; Volver al inicio del bucle
        etiqueta_salida:
            mov byte [rsi], 0  ; Colocar un byte cero al final del segundo espacio reservado
            ; Prologo
        pop rbp
    ret