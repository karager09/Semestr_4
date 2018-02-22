# Piotr Karaś
#zostały zrealizowane wszystkie wyznaczone punkty
#count, pos, i zwracana wartość są poprawne


.type fun,@function
.global fun

fun:

      PUSH %rbp
      PUSH %rbx
      MOV %rsp,%rbp	#zapamietujemy wskaznik na górę stosu
      MOVQ %rdi, -8(%rbp)	#long a,	zapamiętujemy zmienne i wkaźniki które przekazaliśmy do funkcji na stosie
      MOVQ %rsi, -16(%rbp)	# int b
      MOVQ %rdx, -24(%rbp)	#w rdx  wskaxnik na pos
      MOVQ %rcx, -32(%rbp)	#w rcx wskaźnik na count

      
      XOR %rax, %rax	#zerujemy rejest rax i rdx
      XOR %rdx, %rdx	
      MOV $0,%cl	# w cl bedzie licznik petli, liczy od 0 do 63
      
      
      
      
petla:
      
      XOR %rbx,%rbx	#zerujemy rbx
      ADD $1,%rbx	#dodajemy jedynke do %rbx
      SHL %cl, %rbx	#przesuwamy ja o licznik petli %cl
      
      AND %rdi, %rbx	#w %rbx pojawia sie liczba, jak jest != 0 to znaczy ze na miejscu równym %cl mamy 1, inaczej 0
      
      CMP $0, %rbx
      JZ jest_zero	#liczba na danej pozycji jest zerem, wiec nic nie robimy, iterujemy dalej
      
      INCL %eax		#w eax zliczamy ilosc wystąpień jedynek
      
      MOVSX %cl, %edx 	#w edx zapamietujemy najwieksza aktualna pozycję
      
      
      
      
jest_zero:
      
      
      
      INCB %cl		#inkrementujemy iterator
      
      CMPB $63, %cl	#sprawdzamy czy jest osiagniety war pętli, jak nie to wychodzimy
      JBE petla

      
      
      #koniec petli
      
      MOVQ -32(%rbp), %rcx 	#pobieramy licznik z powrotem
      MOVL %eax, (%rcx)		#pod adres count wstawiamy liczbe która zliczliśmy za pomocą eax
      
      MOVL %edx, %eax		#przenosimy %edx czyli "pos" do eax
      MOV  -24(%rbp), %rdx	#pobieramy adres pos
      MOVL %eax,(%rdx)		# i pod niego wstawiamy wyliczoną wartość
      
      
      #obliczylismy i wstawilismy gdzie trzeba obliczone count i pos
      # teraz bedziemy zajmowac sie zwracaniem odpowiedniej wartosci w rejestrze rax
      
      
      
      
      # w r8 wynik dodawan
      #w rax wynik mnozen
      
      #będziemy przechodzić pętlę jeszcze raz, tym razem dokonujemy mnożenia i dodawania a zwracamy na końcu argument w zależności od b
      
      XOR %rax, %rax	#zerujemy rejest rax i rdx, tak jak wczesniej
      XOR %rdx, %rdx	
      MOV $0,%cl
      
      MOV $0,%r8	#ustawiamy waartosci poczatkowe dla rejestrów
      MOVQ $1,%rax	
      
petla2:
      
      XOR %rbx,%rbx	#zerujemy rbx
      ADD $1,%rbx	#dodajemy jedynke do %rbx
      SHL %cl, %rbx	#przesuwamy ja o licznik petli %cl
      
      AND %rdi, %rbx	#w %rbx pojawia sie liczba, jak jest != 0 to znaczy ze na miejscu równym %cl mamy 1, inaczej 0
      
      CMP $0, %rbx	#jak zero to nic nie robimy i przechodzimy pętle następny raz
      JZ jest_zero2
      
      
      XOR %rdx, %rdx
      MOVSX %cl, %rdx
      ADD $1, %rdx	#mamy liczbe (i+1)
      
      ADD %rdx,%r8	#dokonujemy sumowania
      
      MUL %rdx		#dokonujemy mnozenia
      
      
jest_zero2:
      
      INCB %cl		#inkrementujemy iterator
      
      CMPB $63, %cl	#sprawdzamy czy jest osiagniety war pętli, jak nie to wychodzimy
      JBE petla2
      
      #koniec petli
      
	# w zalezności od b ustawiamy rejest rax
      
      CMP $1,%rsi
      JNZ b_nie_jeden
      
      MOVQ %r8,%rax
      JMP koniec
b_nie_jeden:

      CMP $2,%rsi
      JZ koniec
      
b_nie_dwa:

      XOR %rax,%rax
      
koniec:      
      
      POP %rbx
      POP %rbp	#pobieramy to co wcześniej wrzuciliśmy na stos


RET
