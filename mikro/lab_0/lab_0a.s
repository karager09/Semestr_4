#----------------------------------------------------------------
# Program lab_0a.s - Asemblery Laboratorium IS II rok
#----------------------------------------------------------------
#
#  To compile: as -o lab_0a.o lab_0a.s
#  To link:    ld -o lab_0a lab_0a.o
#  To run:     ./lab_0a
#
#----------------------------------------------------------------

	.data # po tym są dane, stałe są gdzie indziej
	
dummy:				# some data
	.byte	0x00 #rezerwujemy miejsce na 1 bajta i ewentualnie dajemy wartość początkową

	.text #skonczył się obszar danych, teraz jest obszar kodu, od tego momentu instrukcje
	.global _start		# entry point, symbol globalny ma być, widoczny w module- plik źródłowy
	
_start: #etykieta kodu, tu przekaazujemy sterowanie po załadowaniu kodu do pamięci
	JMP	_start #instrukcja procesora/rozkazu, skok bezwarunkowy
