.align 2
.thumb

string:
  .ascii "expand 32-byte k"

.equ	x0	,  0*4
.equ	x1	,  1*4
.equ	x2	,  2*4
.equ	x3	,  3*4
.equ	x4	,  4*4
.equ	x5	,  5*4
.equ	x6	,  6*4
.equ	x7	,  7*4
.equ	x8	,  8*4
.equ	x9	,  9*4
.equ	x10	,  10*4
.equ	x11	,  11*4
.equ	x12	,  12*4
.equ	x13	,  13*4
.equ	x14 ,  14*4
.equ	x15 ,  15*4

.macro QUARTERROUND a b c d     @r7

    add \a,\b
    eor \d,\a
    mov r7,\d
    lsl \d,#16
    lsr r7,#16
    orr \d,r7
    
    add \c,\d
    eor \b,\c
    mov r7,\b
    lsl \b,#12
    lsr r7,#20
    orr \b,r7

    add \a,\b
    eor \d,\a
    mov r7,\d
    lsl \d,#8
    lsr r7,#24
    orr \d,r7

    add \c,\d
    eor \b,\c
    mov r7,\b
    lsl \b,#7
    lsr r7,#25
    orr \b,r7
    

.endm



@----------------------------------------------------------------------------
@
@ static int crypto_core_chacha20(unsigned char *out,const unsigned char *in,const unsigned char *k,
@                                   const unsigned char *c)


asm_crypto_core_chacha20:
    push {r4-r7,lr}




    mov r14,r0
    ldr r4,[r3]
    ldr r5,[r3,#4]
    ldr r6,[r3,#8]
    ldr r7,[r3,#12]
    stm r0,{r4,r5,r6,r7}


    ldr r4,[r1]
    ldr r5,[r1,#4]
    ldr r6,[r1,#8]
    ldr r7,[r1,#12]
    stm r0,{r4,r5,r6,r7}
    ldr r4,[r1,#16]
    ldr r5,[r1,#20]
    ldr r6,[r1,#24]
    ldr r7,[r1,#28]
    stm r0,{r4,r5,r6,r7}


    ldr r4,[r2,#8]
    ldr r5,[r2,#12]
    ldr r6,[r2]
    ldr r7,[r2,#4]
    stm r0,{r4,r5,r6,r7}

    mov r11,r3
    mov r12,r1
    mov r8,r2
    mov r5,#9 
    mov r0,r14
    
round_loop:
    
    ldr r1,[r0,#x0]
    ldr r2,[r0,#x4]
    ldr r3,[r0,#x8]
    ldr r4,[r0,#x12]
    QUARTERROUND r1,r2,r3,r4
    str r1,[r0,#x0]
    str r2,[r0,#x4]
    str r3,[r0,#x8]
    str r4,[r0,#x12]

    ldr r1,[r0,#x1]
    ldr r2,[r0,#x5]
    ldr r3,[r0,#x9]
    ldr r4,[r0,#x13]
    QUARTERROUND r1,r2,r3,r4
    str r1,[r0,#x1]
    str r2,[r0,#x5]
    str r3,[r0,#x9]
    str r4,[r0,#x13]

    ldr r1,[r0,#x2]
    ldr r2,[r0,#x6]
    ldr r3,[r0,#x10]
    ldr r4,[r0,#x14]
    QUARTERROUND r1,r2,r3,r4
    str r1,[r0,#x2]
    str r2,[r0,#x6]
    str r3,[r0,#x10]
    str r4,[r0,#x14]

    ldr r1,[r0,#x3]
    ldr r2,[r0,#x7]
    ldr r3,[r0,#x11]
    ldr r4,[r0,#x15]
    QUARTERROUND r1,r2,r3,r4
    str r1,[r0,#x3]
    str r2,[r0,#x7]
    str r3,[r0,#x11]
    str r4,[r0,#x15]

    ldr r1,[r0,#x0]
    ldr r2,[r0,#x5]
    ldr r3,[r0,#x10]
    ldr r4,[r0,#x15]
    QUARTERROUND r1,r2,r3,r4
    str r1,[r0,#x0]
    str r2,[r0,#x5]
    str r3,[r0,#x10]
    str r4,[r0,#x15]



    ldr r1,[r0,#x1]
    ldr r2,[r0,#x6]
    ldr r3,[r0,#x11]
    ldr r4,[r0,#x12]
    QUARTERROUND r1,r2,r3,r4
    str r1,[r0,#x1]
    str r2,[r0,#x6]
    str r3,[r0,#x11]
    str r4,[r0,#x12]



    ldr r1,[r0,#x2]
    ldr r2,[r0,#x7]
    ldr r3,[r0,#x8]
    ldr r4,[r0,#x13]
    QUARTERROUND r1,r2,r3,r4
    str r1,[r0,#x2]
    str r2,[r0,#x7]
    str r3,[r0,#x8]
    str r4,[r0,#x13]


    ldr r1,[r0,#x3]
    ldr r2,[r0,#x4]
    ldr r3,[r0,#x9]
    ldr r4,[r0,#x14]
    QUARTERROUND r1,r2,r3,r4
    str r1,[r0,#x3]
    str r2,[r0,#x4]
    str r3,[r0,#x9]
    str r4,[r0,#x14]

    sub r5,#1
    beq end
    bal round_loop
end:
     ldr r1,[r0,#x0]
    ldr r2,[r0,#x4]
    ldr r3,[r0,#x8]
    ldr r4,[r0,#x12]
    QUARTERROUND r1,r2,r3,r4
    str r1,[r0,#x0]
    str r2,[r0,#x4]
    str r3,[r0,#x8]
    str r4,[r0,#x12]

    ldr r1,[r0,#x1]
    ldr r2,[r0,#x5]
    ldr r3,[r0,#x9]
    ldr r4,[r0,#x13]
    QUARTERROUND r1,r2,r3,r4
    str r1,[r0,#x1]
    str r2,[r0,#x5]
    str r3,[r0,#x9]
    str r4,[r0,#x13]

    ldr r1,[r0,#x2]
    ldr r2,[r0,#x6]
    ldr r3,[r0,#x10]
    ldr r4,[r0,#x14]
    QUARTERROUND r1,r2,r3,r4
    str r1,[r0,#x2]
    str r2,[r0,#x6]
    str r3,[r0,#x10]
    str r4,[r0,#x14]

    ldr r1,[r0,#x3]
    ldr r2,[r0,#x7]
    ldr r3,[r0,#x11]
    ldr r4,[r0,#x15]
    QUARTERROUND r1,r2,r3,r4
    str r1,[r0,#x3]
    str r2,[r0,#x7]
    str r3,[r0,#x11]
    str r4,[r0,#x15]

    ldr r1,[r0,#x0]
    ldr r2,[r0,#x5]
    ldr r3,[r0,#x10]
    ldr r4,[r0,#x15]
    QUARTERROUND r1,r2,r3,r4
    mov r5,r11
    ldr r5,[r5]
    add r1,r5
    str r1,[r0,#x0]
    mov r6,r12
    ldr r5,[r6,#4]
    add r2,r5
    str r2,[r0,#x5]
    ldr r5,[r6,#24]
    add r3,r5
    str r3,[r0,#x10]
    mov r5,r8
    ldr r5,[r5,#4]
    add r4,r5
    str r4,[r0,#x15]



    ldr r1,[r0,#x1]
    ldr r2,[r0,#x6]
    ldr r3,[r0,#x11]
    ldr r4,[r0,#x12]
    QUARTERROUND r1,r2,r3,r4
    mov r5,r11
    ldr r5,[r5,#4]
    add r1,r5
    str r1,[r0,#x1]
    mov r6,r12
    ldr r5,[r6,#8]
    add r2,r5
    str r2,[r0,#x6]
    ldr r5,[r6,#28]
    add r3,r5
    str r3,[r0,#x11]
    mov r5,r8
    ldr r5,[r5,#8]
    add r4,r5
    str r4,[r0,#x12]



    ldr r1,[r0,#x2]
    ldr r2,[r0,#x7]
    ldr r3,[r0,#x8]
    ldr r4,[r0,#x13]
    QUARTERROUND r1,r2,r3,r4
    mov r5,r11
    ldr r5,[r5,#8]
    add r1,r5
    str r1,[r0,#x2]
    mov r6,r12
    ldr r5,[r6,#12]
    add r2,r5
    str r2,[r0,#x7]
    ldr r5,[r6,#16]
    add r3,r5
    str r3,[r0,#x8]
    mov r5,r8
    ldr r5,[r5,#12]
    add r4,r5
    str r4,[r0,#x13]


    ldr r1,[r0,#x3]
    ldr r2,[r0,#x4]
    ldr r3,[r0,#x9]
    ldr r4,[r0,#x14]
    QUARTERROUND r1,r2,r3,r4
    mov r5,r11
    ldr r5,[r5,#12]
    add r1,r5
    str r1,[r0,#x3]
    mov r6,r12
    ldr r5,[r6]
    add r2,r5
    str r2,[r0,#x4]
    ldr r5,[r6,#20]
    add r3,r5
    str r3,[r0,#x9]
    mov r5,r8
    ldr r5,[r5]
    add r4,r5
    str r4,[r0,#x14]
        

    


    pop {r4-r7,pc}
    bx lr
try:
    push {lr}

    pop {pc}




@----------------------------------------------------------------------------
@
@ void asm_csc_for(unsigned char *in, const unsigned char *n)
@    


.global	asm_csc_for;
.type	asm_csc_for, %function
asm_csc_for:
    push {r4-r7,lr}
    
    
    ldm r1!,{r3,r4}
    stm r0!,{r3,r4}
    eor r3,r3
    eor r4,r4
    stm r0!,{r3,r4}
    


    pop {r4-r7,pc}
    bx lr



@----------------------------------------------------------------------------
@
@ void asm_crypto_core(unsigned char *out, unsigned char *k,unsigned char *in)
@    

.global	asm_crypto_core;
.type	asm_crypto_core, %function
asm_crypto_core:
    push {r4-r7,lr}
    mov r4,r8
    mov r5,r11
    mov r6,r12
    mov r7,r14
    push {r4-r7}

    ldr r3, =string
    bl asm_crypto_core_chacha20
    
    pop {r4-r7}
    mov r8,r4
    mov r11,r5
    mov r12,r6
    mov r14,r7
    pop {r4-r7,pc}
    bx lr









