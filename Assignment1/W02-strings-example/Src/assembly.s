.syntax unified
.thumb

.global main


.data
@ define variables

string_buffer: .asciz "hello ALEX!" @ Define a null-terminated string
@ascii_string: .asciz "Put your name here !\0" @ Define a null-terminated string
byte_array: .byte 0, 1, 2, 3, 4, 5, 6
word_array: .word 0x00, 0x40, 0x80, 0xc0, 0x10, 0x14, 0xffffffff

.equ state, 0x02 @state 为1转换大写为0转换小写


.text
@ define text


@ this is the entry function called from the startup file
main:

 @LDR R0, =ascii_string  @ the address of the string
 LDR R1, =string_buffer  @ the address of the string
 LDR R2, =0x00
 LDR R4, = state @ counter to the current place in the string

Check_loop:
    LDRB R3, [R0, R2]    @ 读取字符串中的当前字符
    CMP R3, #65
    BLT skip_function     @ R3 < 65，跳过转换

    CMP R3, #90
    BLE check_state_lower @ 65 ≤ R3 ≤ 90，转换小写

    CMP R3, #97
    BLT skip_function     @ R3 < 97，跳过转换（非小写）

    CMP R3, #122
    BLE check_state_upper @ 97 ≤ R3 ≤ 122，转换大写

skip_function:
    STRB R3, [R1, R2]    @ 直接存储原字符
 B Continue_loop

check_state_lower:
    CMP R4, #0
    BEQ Lowercase_function @ state = 0，转换为小写
    B skip_function      @ 否则不转换，直接存储

check_state_upper:
    CMP R4, #0
    BEQ skip_function @ state = 0，转换为小写
    B Uppercase_function

Continue_loop:
    ADD R2, #1           @ 处理下一个字符
    B Check_loop         @ 继续循环

end_loop:
    BX LR                @ 结束，返回上一级调用函数

Lowercase_function:
    ADD R3, R3, #0x20    @ 大写字母变小写
    B store_and_continue

Uppercase_function:
    SUB R3, R3, #0x20    @ 小写字母变大写
    B store_and_continue

store_and_continue:
    STRB R3, [R1, R2]    @ 存储转换后的字符
    ADD R2, #1           @ 处理下一个字符
    B Check_loop
