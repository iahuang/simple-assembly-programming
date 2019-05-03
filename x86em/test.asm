(__TEXT,__text) section
_dylan:
pushl   %ebp
movl    %esp, %ebp
popl    %ebp
retl
nopw    %cs:_dylan(%eax,%eax)
_main:
pushl   %ebp
movl    %esp, %ebp
subl    $0x8, %esp
calll   0x1b
popl    %eax
movl    $_dylan, -0x4(%ebp)
movl    %eax, -0x8(%ebp)
calll   _dylan
movl    -0x8(%ebp), %eax
movl    _x-27(%eax), %eax
addl    $0x8, %esp
popl    %ebp
retl