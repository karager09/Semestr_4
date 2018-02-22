# int max_ind(int a, int b, int c, int d);

# w tym przykładzie mógłbym przechowywać numer argumentu o największej wartości w jakimś rejestrze, np w r8, ale postanowiłem użyć zmiennych lokalnych aby pokazać jak się ich używa

#nagłówki jak zawsze
	.text
	.type max_ind, @function
	.globl max_ind
	
max_ind:
#jeśli używamy zmiennych lokalnych, to zawsze musimy napisać te 2 linijki poniżej, oraz te 2 które są tuż przed ret na końcu
	push %rbp #rbp to wskaźnik bazowy stosu, wskazuje nam na bieżącą ramkę. musimy zapamiętać na stosie ramkę od funkcji która nas wywołała, a potem na końcu ustawić to tak jak było, w przeciwnym wypadku rozpierdolimy stos
	mov %rsp,%rbp #rsp to wskaźnik bieżący stosu. miejsce, na które obecnie wskazuje będzie miejscem gdzie zaczyna się nasza ramka stosu
	
	sub $8,%rsp #alokowanie zmiennej o rozmiarze 8 bajtów (rejestr przesuwa sie w dół, czyli im więcej danych na stosie, tym niższa wartość wskaźnika. dlatego odejmujemy)
	
	movq $1,-8(%rbp) #na początek zakładamy że największa wartość jest w pierwszym argumencie, więc kopiujemy 1 do zmiennej. dlaczego movq a nie mov? nasza zmienna ma 8 bajtów, ale 1 zmieści się nawet na jednym. dlatego musimy mu powiedzieć ile bajtów w tej zmiennej ma być ustawione. chcemy ustawić wszystkie, więc q (całe 8)
	
	cmp %rdi,%rsi #podobnie jak w zad1, z tą różnicą, że tutaj równość jest osobnym przypadkiem, bo wtedy musimy zwrócić 0
	je ifzero
	jl compare2
	movq $2,-8(%rbp) #kopiujemy 2 do zmiennej, a poza tym do rdi kopiujemy wartość która jest większa, dzięki temu będziemy porównywać kolejne wartości z BIEŻĄCĄ wartością maksymalną, która zawsze będzie w rdi
	mov %rsi,%rdi
compare2:
	cmp %rdi,%rdx #jak wyżej
	je ifzero
	jl compare3
	movq $3,-8(%rbp)
	mov %rdx,%rdi
compare3:
	cmp %rdi,%rcx #jak wyżej
	je ifzero
	jl end #nie ma już kolejnej zmiennej do porównania, więc zamiast tego idziemy prosto do end
	movq $4,-8(%rbp)
	jmp end
	
ifzero:
	movq $0,-8(%rbp)
end:
	mov -8(%rbp),%rax #przenosimy wartość z naszej zmiennej lokalnej do rax, aby zwrócić wartosć
	mov %rbp,%rsp #zwalniamy miejsce, które zajęliśmy na zmienne lokalne (czyli po prostu przesuwamy bieżący wskaźnik stosu na to samo miejsce, na które wskazuje wskaźnik ramki)
	pop %rbp #ustawiamy z powrotem wskaźnik bazowy stosu tak jak było, aby nie rozpierdolić czyjegoś programu
	ret
