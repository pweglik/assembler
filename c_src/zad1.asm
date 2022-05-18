; 1 
; 1 # 1 "zad1.c"
; 1 # 6 "/usr/lib/bcc/include/asm/types.h"
; 6 	
; 7 
; 8 
; 9 typedef unsigned char __u8;
;BCC_EOS
; 10 typedef unsigned char * __pu8;
;BCC_EOS
; 11 # 17
; 17 typedef unsigned short __u16;
;BCC_EOS
; 18 typedef unsigned short * __pu16;
;BCC_EOS
; 19 typedef short __s16;
;BCC_EOS
; 20 typedef short * __ps16;
;BCC_EOS
; 21 
; 22 typedef unsigned long __u32;
;BCC_EOS
; 23 typedef unsigned long * __pu32;
;BCC_EOS
; 24 typedef long __s32;
;BCC_EOS
; 25 typedef long * __ps32;
;BCC_EOS
; 26 
; 27 
; 28 
; 29 typedef unsigned int __uint;
;BCC_EOS
; 30 typedef int __sint;
;BCC_EOS
; 31 typedef unsigned int * __puint;
;BCC_EOS
; 32 typedef int * __psint;
;BCC_EOS
; 33 # 6 "/usr/lib/bcc/include/linuxmt/types.h"
; 6 typedef __u32 off_t;
;BCC_EOS
; 7 typedef __u16 pid_t;
;BCC_EOS
; 8 typedef __u16 uid_t;
;BCC_EOS
; 9 typedef __u16 gid_t;
;BCC_EOS
; 10 typedef __u32 time_t;
;BCC_EOS
; 11 typedef __u16 umode_t;
;BCC_EOS
; 12 typedef __u16 nlink_t;
;BCC_EOS
; 13 typedef __u16 mode_t;
;BCC_EOS
; 14 typedef __u32 loff_t;
;BCC_EOS
; 15 typedef __u32 speed_t;
;BCC_EOS
; 16 typedef __u16 size_t;
;BCC_EOS
; 17 
; 18 typedef __u16 dev_t;
;BCC_EOS
; 19 typedef __uint ino_t;
;BCC_EOS
; 20 typedef __u32 tcflag_t;
;BCC_EOS
; 21 typedef __u8  cc_t;
;BCC_EOS
; 22 
; 23 typedef int   ptrdiff_t;
;BCC_EOS
; 24 # 41 "/usr/lib/bcc/include/stdio.h"
; 41 struct __stdio_file {
; 42   unsigned char *bufpos;   
;BCC_EOS
; 43   unsigned char *bufread;  
;BCC_EOS
; 44   unsigned char *bufwrite; 
;BCC_EOS
; 45   unsigned char *bufstart; 
;BCC_EOS
; 46   unsigned char *bufend;
;BCC_EOS
; 47    
; 48 
; 49   int fd; 
;BCC_EOS
; 50   int mode;
;BCC_EOS
; 51 
; 52   char unbuf[8];	   
;BCC_EOS
; 53 
; 54   struct __stdio_file * next;
;BCC_EOS
; 55 };
;BCC_EOS
; 56 # 62
; 62 typedef struct __stdio_file FILE;
;BCC_EOS
; 63 # 70
; 70 extern FILE stdin[1];
;BCC_EOS
; 71 extern FILE stdout[1];
;BCC_EOS
; 72 extern FILE stderr[1];
;BCC_EOS
; 73 # 102
; 102 extern int setvbuf () ;
;BCC_EOS
; 103 
; 104 
; 105 
; 106 extern void setbuffer () ;
;BCC_EOS
; 107 
; 108 extern int fgetc () ;
;BCC_EOS
; 109 extern int fputc () ;
;BCC_EOS
; 110 
; 111 extern int fclose () ;
;BCC_EOS
; 112 extern int fflush () ;
;BCC_EOS
; 113 extern char *fgets () ;
;BCC_EOS
; 114 
; 115 extern FILE *fopen () ;
;BCC_EOS
; 116 extern FILE *fdopen () ;
;BCC_EOS
; 117 extern FILE *freopen  () ;
;BCC_EOS
; 118 # 123
; 123 extern int fputs () ;
;BCC_EOS
; 124 extern int puts () ;
;BCC_EOS
; 125 
; 126 extern int printf () ;
;BCC_EOS
; 127 extern int fprintf () ;
;BCC_EOS
; 128 extern int sprintf () ;
;BCC_EOS
; 129 # 3 "zad1.c"
; 3 int main()
; 4 {
export	_main
_main:
; 5     short a = 0;
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
; Debug: eq int = const 0 to short a = [S+8-8] (used reg = )
xor	ax,ax
mov	-6[bp],ax
;BCC_EOS
; 6     short b = 0;
dec	sp
dec	sp
; Debug: eq int = const 0 to short b = [S+$A-$A] (used reg = )
xor	ax,ax
mov	-8[bp],ax
;BCC_EOS
; 7     short sol = 0;
dec	sp
dec	sp
; Debug: eq int = const 0 to short sol = [S+$C-$C] (used reg = )
xor	ax,ax
mov	-$A[bp],ax
;BCC_EOS
; 8     int i = 0;
dec	sp
dec	sp
; Debug: eq int = const 0 to int i = [S+$E-$E] (used reg = )
xor	ax,ax
mov	-$C[bp],ax
;BCC_EOS
; 9     int j = 0;
dec	sp
dec	sp
; Debug: eq int = const 0 to int j = [S+$10-$10] (used reg = )
xor	ax,ax
mov	-$E[bp],ax
;BCC_EOS
; 10 
; 11 
; 12     if(scanf("%hd", &a) < 0)
; Debug: list * short a = S+$10-8 (used reg = )
lea	bx,-6[bp]
push	bx
; Debug: list * char = .2+0 (used reg = )
mov	bx,#.2
push	bx
; Debug: func () int = scanf+0 (used reg = )
call	_scanf
add	sp,*4
; Debug: lt int = const 0 to int = ax+0 (used reg = )
test	ax,ax
jge 	.1
.3:
; 13     {
; 14         printf("ERROR LOADING A");
; Debug: list * char = .4+0 (used reg = )
mov	bx,#.4
push	bx
; Debug: func () int = printf+0 (used reg = )
call	_printf
inc	sp
inc	sp
;BCC_EOS
; 15     }
; 16     if(a < -10 || a > 10)
.1:
; Debug: lt int = const -$A to short a = [S+$10-8] (used reg = )
mov	ax,-6[bp]
cmp	ax,*-$A
jl  	.6
.7:
; Debug: gt int = const $A to short a = [S+$10-8] (used reg = )
mov	ax,-6[bp]
cmp	ax,*$A
jle 	.5
.6:
; 17     {
; 18         printf("A OUT OF RANGE");
; Debug: list * char = .8+0 (used reg = )
mov	bx,#.8
push	bx
; Debug: func () int = printf+0 (used reg = )
call	_printf
inc	sp
inc	sp
;BCC_EOS
; 19     }
; 20 
; 21     if(scanf("%hd", &b) < 0)
.5:
; Debug: list * short b = S+$10-$A (used reg = )
lea	bx,-8[bp]
push	bx
; Debug: list * char = .A+0 (used reg = )
mov	bx,#.A
push	bx
; Debug: func () int = scanf+0 (used reg = )
call	_scanf
add	sp,*4
; Debug: lt int = const 0 to int = ax+0 (used reg = )
test	ax,ax
jge 	.9
.B:
; 22     {
; 23         printf("ERROR LOADING B");
; Debug: list * char = .C+0 (used reg = )
mov	bx,#.C
push	bx
; Debug: func () int = printf+0 (used reg = )
call	_printf
inc	sp
inc	sp
;BCC_EOS
; 24     }
; 25     if(b < -10 || b > 10)
.9:
; Debug: lt int = const -$A to short b = [S+$10-$A] (used reg = )
mov	ax,-8[bp]
cmp	ax,*-$A
jl  	.E
.F:
; Debug: gt int = const $A to short b = [S+$10-$A] (used reg = )
mov	ax,-8[bp]
cmp	ax,*$A
jle 	.D
.E:
; 26     {
; 27         printf("B OUT OF RANGE");
; Debug: list * char = .10+0 (used reg = )
mov	bx,#.10
push	bx
; Debug: func () int = printf+0 (used reg = )
call	_printf
inc	sp
inc	sp
;BCC_EOS
; 28     }
; 29 
; 30     
; 31     sol = -1 * b/a;
.D:
; Debug: mul short b = [S+$10-$A] to int = const -1 (used reg = )
; Debug: expression subtree swapping
mov	ax,-8[bp]
mov	cx,*-1
imul	cx
; Debug: div short a = [S+$10-8] to int = ax+0 (used reg = )
mov	bx,-6[bp]
cwd
idiv	bx
; Debug: eq int = ax+0 to short sol = [S+$10-$C] (used reg = )
mov	-$A[bp],ax
;BCC_EOS
; 32     printf(
; 32 "root: %d, y axis intersec: %d\n", sol, b);
; Debug: list short b = [S+$10-$A] (used reg = )
push	-8[bp]
; Debug: list short sol = [S+$12-$C] (used reg = )
push	-$A[bp]
; Debug: list * char = .11+0 (used reg = )
mov	bx,#.11
push	bx
; Debug: func () int = printf+0 (used reg = )
call	_printf
add	sp,*6
;BCC_EOS
; 33 
; 34 
; 35     
; 36     while(i < 20)
; 37     {
br 	.13
.14:
; 38         while(j < 20)
; 39         {
jmp .16
.17:
; 40             char disp = ' ';
dec	sp
; Debug: eq int = const $20 to char disp = [S+$11-$11] (used reg = )
mov	al,*$20
mov	-$F[bp],al
;BCC_EOS
; 41             if(i == 10)
dec	sp
; Debug: logeq int = const $A to int i = [S+$12-$E] (used reg = )
mov	ax,-$C[bp]
cmp	ax,*$A
jne 	.18
.19:
; 42             {
; 43                 disp = '#';
; Debug: eq int = const $23 to char disp = [S+$12-$11] (used reg = )
mov	al,*$23
mov	-$F[bp],al
;BCC_EOS
; 44             }
; 45             if(j == 10)
.18:
; Debug: logeq int = const $A to int j = [S+$12-$10] (used reg = )
mov	ax,-$E[bp]
cmp	ax,*$A
jne 	.1A
.1B:
; 46             {
; 47                 disp = '#';
; Debug: eq int = const $23 to char disp = [S+$12-$11] (used reg = )
mov	al,*$23
mov	-$F[bp],al
;BCC_EOS
; 48             }
; 49             if((j-10) * a + b == 10 - i) 
.1A:
; Debug: sub int i = [S+$12-$E] to int = const $A (used reg = )
mov	ax,*$A
sub	ax,-$C[bp]
push	ax
; Debug: sub int = const $A to int j = [S+$14-$10] (used reg = )
mov	ax,-$E[bp]
; Debug: mul short a = [S+$14-8] to int = ax-$A (used reg = )
add	ax,*-$A
mov	cx,-6[bp]
imul	cx
; Debug: add short b = [S+$14-$A] to int = ax+0 (used reg = )
add	ax,-8[bp]
; Debug: logeq int (temp) = [S+$14-$14] to int = ax+0 (used reg = )
cmp	ax,-$12[bp]
lea	sp,-$10[bp]
jne 	.1C
.1D:
; 50             {
; 51                 disp = '*';
; Debug: eq int = const $2A to char disp = [S+$12-$11] (used reg = )
mov	al,*$2A
mov	-$F[bp],al
;BCC_EOS
; 52             }
; 53             printf("%c", disp);
.1C:
; Debug: list char disp = [S+$12-$11] (used reg = )
mov	al,-$F[bp]
xor	ah,ah
push	ax
; Debug: list * char = .1E+0 (used reg = )
mov	bx,#.1E
push	bx
; Debug: func () int = printf+0 (used reg = )
call	_printf
add	sp,*4
;BCC_EOS
; 54             j++;
; Debug: postinc int j = [S+$12-$10] (used reg = )
mov	ax,-$E[bp]
inc	ax
mov	-$E[bp],ax
;BCC_EOS
; 55         }
inc	sp
inc	sp
; 56         printf("\n");
.16:
; Debug: lt int = const $14 to int j = [S+$10-$10] (used reg = )
mov	ax,-$E[bp]
cmp	ax,*$14
jl 	.17
.1F:
.15:
; Debug: list * char = .20+0 (used reg = )
mov	bx,#.20
push	bx
; Debug: func () int = printf+0 (used reg = )
call	_printf
inc	sp
inc	sp
;BCC_EOS
; 57         i++;
; Debug: postinc int i = [S+$10-$E] (used reg = )
mov	ax,-$C[bp]
inc	ax
mov	-$C[bp],ax
;BCC_EOS
; 58         j = 0;
; Debug: eq int = const 0 to int j = [S+$10-$10] (used reg = )
xor	ax,ax
mov	-$E[bp],ax
;BCC_EOS
; 59     }
; 60     return 1;}
.13:
; Debug: lt int = const $14 to int i = [S+$10-$E] (used reg = )
mov	ax,-$C[bp]
cmp	ax,*$14
blt 	.14
.21:
.12:
mov	ax,*1
add	sp,*$A
pop	si
pop	di
pop	bp
ret
;BCC_EOS
; 61 
; Register BX used in function main
.data
.20:
.22:
.byte	$A
.byte	0
.1E:
.23:
.ascii	"%c"
.byte	0
.11:
.24:
.ascii	"root: %d, y axis intersec: %d"
.byte	$A
.byte	0
.10:
.25:
.ascii	"B OUT OF RANGE"
.byte	0
.C:
.26:
.ascii	"ERROR LOADING B"
.byte	0
.A:
.27:
.ascii	"%hd"
.byte	0
.8:
.28:
.ascii	"A OUT OF RANGE"
.byte	0
.4:
.29:
.ascii	"ERROR LOADING A"
.byte	0
.2:
.2A:
.ascii	"%hd"
.byte	0
.bss

; 0 errors detected
