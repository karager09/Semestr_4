#long long max_1_ind(long long *tab, long long n, long long *even_count, long long *neg_count);

#normalne nagłówki, jak wszędzie
	.text
	.type max_1_ind, @function
	.globl max_1_ind
	
max_1_ind:
	push %rbp #stworzymy sobie pare zmiennych lokalnych bo mogłoby nam braknąć rejestrów XD
	mov %rsp,%rbp
	
	sub $8,%rsp
	movq $0,-8(%rbp) #pozycja ostatniego elementu który miał najwięcej jedynek, na początku zakładamy że jest to element zerowy
	
	sub $8,%rsp
	movq $0,-16(%rbp) #liczba jedynek w elemencie który miał najwięcej jedynek, na początku zakładamy że miał ich 0
	
	movq $0,(%rdx) #zakładamy że 0 liczb jest parzystych
	movq $0,(%rcx) #zakładamy że 0 liczb jest ujemnych
	
	push %rsi #wrzucamy na stos liczbę elementów w tablicy. będzie nam potrzebna na końcu, ale w międzyczasie wykorzystamy to w pętli (będziemy zmniejszać)
	
begin:
	jmp isParity #idziemy do fragmentu sprawdzającego parzystość
afterParity:
	cmp $0,%rax #sprawdzamy czy zwróciło 0
	jne beforeNegative #jeśli nie to znaczy że nieparzysta i nic tu nie zmienimy
	incq (%rdx) #liczba jest parzysta, więc zwiększamy o 1 nasz licznik liczb parzystych, UWAGA to jest wskaźnik, więc potrzebny jest sufiks q w instrukcji, inaczej procesor nie wie ile bajtów zajmuje ta liczba którą należy zwiększyć
beforeNegative:
	cmp $0,(%rdi) #tutaj nie ma wielkiej filozofii
	jge beforeOnes
	incq (%rcx) #jak wyżej, zwiększamy licznik elementów ujemnych
beforeOnes:
	jmp countOnes #idziemy do fragmentu który policzy nam jedynki
afterOnes:
	cmp -16(%rbp),%rax #sprawdzamy czy wartość, którą obliczyliśmy przed chwilą jest większa od tej, którą mamy już w zmiennej
	jle bottom #jak mniejsza lub równa to skaczemy do bottom
	movq %rax,-16(%rbp) #kopiujemy z rax (czyli obliczona ilośc jedynek) do zmiennej lokalnej
	movq %rsi,-8(%rbp) #do drugiej zmiennej lokalnej zapisujemy przy jakim stanie licznika znaleźliśmy ten max
bottom:
	add $8,%rdi #zwiększamy wskaźnik do tablicy z liczbami o 8. dlaczego o 8 a nie o 1 tak jak w poprzednich zadaniach? otóż wcześniej na ogół działaliśmy na literkach, a char zajmuje po 1 bajcie. tutaj mamy long long, które zajmują 8 bajtów, dlatego musimy zwiększyć o 8 aby wskazywało na kolejną liczbę
	dec %rsi #zmniejszamy licznik pętli o 1
	cmp $0,%rsi #jeśli licznik pętli >0 to lecimy od nowa
	jg begin
	
end:
	pop %rsi #zdejmujemy ze stosu ten licznik pętli, czyli znowu ma taką samą wartość jak na początku
	movq -8(%rbp),%rax #kopiujemy indeks przy którym znaleźliśmy max do rax
	sub %rax,%rsi #odejmujemy od początkowego licznika pętli indeks, przy którym znaleźliśmy max
	mov %rsi,%rax #będziemy zwracać wartość przez rax, więc kopiujemy tam wynik
	
	mov %rbp,%rsp #sprzątamy stos i zwracamy
	pop %rbp
	ret
	
	

#działanie tego fragmentu kodu opiera się na założeniu, że jeśli liczba jest parzysta, to najmłodszy bit=0
isParity:
	mov (%rdi),%r8 #kopiujemy z tablicy liczb do pomocniczego rejestru r8
	
	and $0x01,%r8b # AND logiczny wartości 0x01 z najmłodszymi 8 bitami rejestru r8 (oznaczamy je jako r8b)
	xor %rax,%rax #chcemy zapisać jeden malutki bit do rax, więc aby nic nam nie zepsuło wyniku, musimy najpierw wyzerować ten rejestr
	mov %r8b,%al #kopiujemy wynik z r8b do al, czyli 8 najmłodszych bitów rejestru rax
	jmp afterParity #wracamy do "głównej" pętli
	
countOnes:
	movq $0,%r11 #tutaj będziemy liczyć ile jest jedynek w liczbie
	mov $64,%r9 #long long to 8 bajtów czyli 64 bity, czyli będziemy musieli 64 razy przesuwać po jednym bicie w lewo
	movq (%rdi),%r10 #do rejestru pomocniczego r10 zapisujemy wartość z naszej tablicy. UWAGA, SUFIKS!
loop:
	and $0x01,%r10b #jak przy parzystości
	xor %rax,%rax
	mov %r10b,%al
	cmp $1,%al #jeśli jedynka to zwiększymy licznik jedynek
	jne nextStep
	inc %r11
nextStep:
	shr $1,%r10 #przesuwamy w prawo o jeden to co jest w rejestrze r10, więc w następnej iteracji będziemy się zajmować już kolejnym bitem
	dec %r9 #zmniejszamy licznik pętli
	cmp $0,%r9 #sprawdzamy czy >0
	jg loop
	mov %r11,%rax #wynik liczenia zapisujemy do rax
	jmp afterOnes
