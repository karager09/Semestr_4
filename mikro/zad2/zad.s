# char* generate_str(char* s, int c, int n, int inc);

#nagłówki jak zawsze
	.text
	.type generate_str, @function
	.globl generate_str
	
generate_str:
	push %rdi #funkcja ma w zasadzie zwracać to samo, co podajemy jej jako pierwszy argument. ponieważ będziemy zwiększać ten wskaźnik który jest pierwszym argumentem, to najpierw wrzucamy sobie to na stos aby potem łatwo odzyskać jego pierwotną wartość
	
begin:
	mov %rsi,(%rdi) #kopiujemy drugi argument do MIEJSCA W PAMIĘCI wskazywanego przez rdi. nawiasy to takie jakby wyłuskanie zmiennej ze wskaźnika. np w C, jeśli mamy int* a, to napiszemy *a = 5
	inc %rdi #zwiększamy wskaźnik tak, aby wskazywał na kolejny element
	dec %rdx #zmniejszamy licznik
	cmp $0,%rcx #sprawdzamy czy mamy wyświetlać takie same znaki, czy zwiększać je o 1
	je next
	inc %rsi #zwiększamy o jeden znak z którego budujemy napis
	
next:
	cmp $0,%rdx #sprawdzamy czy licznik jest jeszcze większy od 0, jeśli tak to skaczemy z powrotem do begin
	jg begin
	movb $0,(%rdi) #kopiujemy na koniec jeszcze jeden bajt do naszego napisu, bajt ma wartość 0. to oczywiście nullterminator, bez którego nie będzie wiadomo gdzie się skończył nasz napis
	
	pop %rax #zwracamy wartość przez rax, chcemy zwrócić wskaźnik do naszego napisu. na początku wrzuciliśmy go na stos, więc teraz zdejmujemy
	ret
