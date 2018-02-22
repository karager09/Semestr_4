# char* fun(char* buf, char* a, char* b);

#nie do końca zrozumiałem jak ma się zachowywać ta funkcja, jeśli napisy nie są równej długości. w swojej implementacji kopiuję znaki do bufora dotąd, aż w którymkolwiek z napisów źródłowych napotkam nullterminator. zachęcam jednak do zmiany programu tak, aby zaimplementować również inne możliwości.

#nagłówki takie jak zawsze
	.text
	.type fun, @function
	.globl fun
	
fun:
	push %rdi #tak jak w poprzednim zadaniu, chcę zachować pierwotną wartość pierwszego argumentu
	
begin:
	cmp $0,(%rsi) #sprawdzam czy w pierwszym napisie źródłowym nie ma jeszcze nullterminatora, jeśli jest do kończę
	jz end
	cmp $0,(%rdx) #jak wyżej
	jz end
	mov (%rsi),%r8 #nie można kopiować bezpośrednio ze wskaźnika do wskaźnika. najpierw kopiuję sobie do jakiegoś rejestru pomocniczego, a potem z tego rejestru do docelowej pamięci
	mov %r8,(%rdi)
	inc %rsi #zwiększam drugi argument aby wskazywało na kolejny znak
	inc %rdi #bufor też
	mov (%rdx),%r8 #jak wyżej, tutaj kopiujemy z drugiego napisu do bufora
	mov %r8,(%rdi)
	inc %rdx #zwiększamy trzeci argument i bufor
	inc %rdi
	jmp begin #wracamy do początku
	
end:
	movb $0,(%rdi) #standardowo na koniec dorzucam nullterminator
	pop %rax #odzyskuję pierwotną wartość pierwszego argumentu i wkładam ją do rax
	ret
