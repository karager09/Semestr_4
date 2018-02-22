import java.util.Scanner;

/**
 * Created by Piotr on 2017-04-26.
 */
public class ProgramowanieLiniowe {
    static int ILOSC_ZMIENNYCH; //zmienna przechowujaca ilosca zmiennych decyzyjnych
    static String[] nazwyZmiennych; //tablica stringów przechowująca nazwy kolejnych zmiennych decyzyjnych
    static int ILOSC_WARUNKOW = -1;
    static double ograniczenia[][];
    static double wielomiany[][][];
    static double funkcjaCelu[][];
    static double najlepszyWektor[];
    static int ILOSC_PROBEK; //zmieniamy później na ilosc probek= x * ilosc zmiennych
    static double Epsilon=0.01;
    static double ZMNIEJSZANIE=0.5; //ile razy zmniejszamy promien
    static boolean czyMaksymalizujemy;

    static void podajIloscZmiennych(){
        System.out.println("Podaj ilość zmiennych:");

        while(ILOSC_ZMIENNYCH < 1) {
            Scanner scann=new Scanner(System.in);
            try {
                ILOSC_ZMIENNYCH = scann.nextInt();
            } catch (Exception e) {
                System.out.println("Podałeś złą wartość. Spróbuj jeszcze raz.");
                continue;
            }
        }

        nazwyZmiennych = new String[ILOSC_ZMIENNYCH];

        for(int i = 0; i < ILOSC_ZMIENNYCH; i++){
            System.out.println("Podaj nazwę zmiennej numer "+ (i+1) +":");
            String nazwa="";
            while(nazwa.equals("")) {
                Scanner scanner=new Scanner(System.in);
                try {
                     nazwa = scanner.nextLine();
                } catch (Exception e) {
                    System.out.println("Podałeś złą wartość. Spróbuj jeszcze raz.");
                    continue;
                }
            }
            nazwyZmiennych[i] = nazwa;
        }

        ILOSC_PROBEK =6000 + 500 * ILOSC_ZMIENNYCH * ILOSC_ZMIENNYCH;
    }


    static void podajOgraniczenia(){
        ograniczenia = new double[ILOSC_ZMIENNYCH][2];

        for( int i = 0; i < ILOSC_ZMIENNYCH; ++i ){
            System.out.println("Podaj ograniczenie dolne dla "+nazwyZmiennych[i]);
            Scanner scanner=new Scanner(System.in);
            while(true){
                try {
                    ograniczenia[i][0] = scanner.nextDouble();

                }catch(Exception e){
                    scanner.nextLine();
                    continue;
                }

                break;
            }
            System.out.println("Podaj ograniczenie górne dla "+nazwyZmiennych[i]);
            while(true) {
                try {
                    ograniczenia[i][1] = scanner.nextDouble();
                    if(ograniczenia[i][0] > ograniczenia[i][1]){
                        System.out.println("Ograniczenie górne jest mniejsze od dolnego. Podaj górne jeszcze raz.");
                        continue;
                    }

                }catch(Exception e) {
                    scanner.nextLine();
                    continue;
                }

                break;
            }
        }
    }


    static void pytajOMaksymalizacje(){

        System.out.println("Chcesz maksymalizować czy minimalizować funkcje? (Podaj \"min\" albo \"max\")");
        Scanner scanner=new Scanner(System.in);
        String odpowiedz = "min";
        do{
            try {
                odpowiedz = scanner.nextLine();

            }catch(Exception e){
                continue;
            }

        }while((!odpowiedz.equals("min"))&&(!odpowiedz.equals("max")));

        if(odpowiedz.equals("max")) czyMaksymalizujemy = true; else czyMaksymalizujemy = false;


    }


     static void podajIloscWarunkow(){
         System.out.println("Podaj ilość warunków:");
        while(ILOSC_WARUNKOW < 0) {
            Scanner scann=new Scanner(System.in);
            try {
                ILOSC_WARUNKOW = scann.nextInt();

            } catch (Exception e) {
                scann.nextLine();
                System.out.println("Podałeś złą wartość. Spróbuj jeszcze raz.");
                continue;
            }
        }

    }


    static void podajWielomian(double [][] wielomian){
        Scanner scanner = new Scanner(System.in);
        for(int i = 0; i < ILOSC_ZMIENNYCH; ++i){
            //System.out.println("Podaj wyrazy dla "+i+" zmiennej decyzyjnej, "+nazwyZmiennych[i]);
            int iloscWyrazen;

            while(true) {
                System.out.println("Ile wyrażeń jest dla " + (i+1) + " zmiennej decyzyjnej, czyli " + nazwyZmiennych[i] + "?");
                try {
                    iloscWyrazen = scanner.nextInt();
                } catch (Exception e) {
                    scanner.nextLine();
                    continue;
                }
                break;
                }

            wielomian[i] = new double [iloscWyrazen*2];
            for(int j = 0; j < iloscWyrazen; ++j ){
                    System.out.println("Podaj "+(j+1)+" wyraz wolny dla "+(i+1)+" zmiennej, czyli "+nazwyZmiennych[i]);
                    while(true) {
                        try {
                            wielomian[i][j*2] = scanner.nextDouble();
                        } catch (Exception e) {
                            scanner.nextLine();
                            continue;
                        }
                        break;
                    }

                    System.out.println("Podaj "+ (j+1) +" stopień wyrażenia dla "+ (i+1) + " zmiennej, czyli "+nazwyZmiennych[i]);

                    while(true) {
                        try {
                            wielomian[i][j*2+1] = scanner.nextInt();
                            if(wielomian[i][j*2+1] < 0) continue;
                        } catch (Exception e) {
                            scanner.nextLine();
                            continue;
                        }
                        break;
                    }
            }

        }

        wielomian[ILOSC_ZMIENNYCH] = new double[2];
        scanner = new Scanner(System.in);
         while(true) {
            System.out.println("Podaj znak ograniczenia ( opcje : <, <=, >=, > ):");
            try {
                String znakOgraniczenia = scanner.nextLine();
                switch (znakOgraniczenia){
                    case "<":wielomian[ILOSC_ZMIENNYCH][0]=1;break;
                    case "<=":wielomian[ILOSC_ZMIENNYCH][0]=2; break;
                    case ">=":wielomian[ILOSC_ZMIENNYCH][0]=3; break;
                    case ">":wielomian[ILOSC_ZMIENNYCH][0]=4; break;
                    default: continue;
                }
            } catch (Exception e) {
                scanner.nextLine();
                continue;
            }
            break;
        }

        while(true) {
            System.out.println("Podaj wyraz wolny:");
            try {
                wielomian[ILOSC_ZMIENNYCH][1] = scanner.nextDouble();
            } catch (Exception e) {
                scanner.nextLine();
                continue;
            }
            break;
        }
    }


    static void podajWielomiany(){
         wielomiany = new double[ILOSC_WARUNKOW][][];

         for(int i = 0; i < ILOSC_WARUNKOW; ++i){
            System.out.println("Podaj ograniczenie numer "+(i+1));
            wielomiany[i] = new double[ILOSC_ZMIENNYCH+1][];
            podajWielomian(wielomiany[i]);

         }
    }

    static void podajFunkcjeCelu(){
        funkcjaCelu = new double [ILOSC_ZMIENNYCH][];
        Scanner scanner = new Scanner(System.in);
        int iloscWyrazen;

        for(int i = 0; i < ILOSC_ZMIENNYCH; ++i) {
            System.out.println("Podaj funkcje celu: ");
            while (true) {
                System.out.println("Ile wyrażeń jest dla " + (i + 1) + " zmiennej decyzyjnej, czyli " + nazwyZmiennych[i] + "?");
                try {
                    iloscWyrazen = scanner.nextInt();
                } catch (Exception e) {
                    scanner.nextLine();
                    continue;
                }
                break;
            }

            funkcjaCelu[i] = new double[iloscWyrazen * 2];
            for (int j = 0; j < iloscWyrazen; ++j) {
                System.out.println("Podaj " + (j + 1) + " wyraz wolny dla " + (i + 1) + " zmiennej, czyli " + nazwyZmiennych[i]);
                while (true) {
                    try {
                        funkcjaCelu[i][j * 2] = scanner.nextDouble();
                    } catch (Exception e) {
                        scanner.nextLine();
                        continue;
                    }
                    break;
                }

                System.out.println("Podaj " + (j + 1) + " stopień wyrażenia dla " + (i + 1) + " zmiennej, czyli " + nazwyZmiennych[i]);

                while (true) {
                    try {
                        funkcjaCelu[i][j * 2 + 1] = scanner.nextInt();
                        if (funkcjaCelu[i][j * 2 + 1] < 0) continue;
                    } catch (Exception e) {
                        scanner.nextLine();
                        continue;
                    }
                    break;
                }
            }
        }
    }



    static double [] losujWektor(){
        //Random random = new Random();
        double [] wektorLosowy = new double[ILOSC_ZMIENNYCH];
        for( int i = 0; i < ILOSC_ZMIENNYCH; ++i)
            wektorLosowy[i]= (ograniczenia[i][1]-ograniczenia[i][0]) * Math.random() + ograniczenia[i][0];

        return wektorLosowy;
    }


    static boolean sprawdzCzySpelniaWarunki(double [] wektor){
        for(int numerWarunku = 0; numerWarunku < ILOSC_WARUNKOW; numerWarunku++){

            double suma = 0;
            for(int zmienna = 0; zmienna < wielomiany[numerWarunku].length-1; ++zmienna){
                for(int wyrazenia = 0; wyrazenia < wielomiany[numerWarunku][zmienna].length; wyrazenia+=2){
                    suma += wielomiany[numerWarunku][zmienna][wyrazenia]*(Math.pow(wektor[zmienna], wielomiany[numerWarunku][zmienna][wyrazenia+1]));
                }
            }

            if((wielomiany[numerWarunku][ILOSC_ZMIENNYCH][0]==1)&&(wielomiany[numerWarunku][ILOSC_ZMIENNYCH][1] <= suma)) return false;
            if((wielomiany[numerWarunku][ILOSC_ZMIENNYCH][0]==2)&&(wielomiany[numerWarunku][ILOSC_ZMIENNYCH][1] < suma)) return false;
            if((wielomiany[numerWarunku][ILOSC_ZMIENNYCH][0]==3)&&(wielomiany[numerWarunku][ILOSC_ZMIENNYCH][1] > suma)) return false;
            if((wielomiany[numerWarunku][ILOSC_ZMIENNYCH][0]==4)&&(wielomiany[numerWarunku][ILOSC_ZMIENNYCH][1] >= suma)) return false;

        }
        return true;
    }


    static double obliczFunkcjeCelu(double [] wektor){
        double suma = 0;

        for(int zmienna = 0; zmienna < ILOSC_ZMIENNYCH; ++zmienna){
            for(int wyrazenia = 0; wyrazenia < funkcjaCelu[zmienna].length; wyrazenia+=2){
                suma += funkcjaCelu[zmienna][wyrazenia]*(Math.pow(wektor[zmienna], funkcjaCelu[zmienna][wyrazenia+1]));
            }
        }
    return suma;
    }


    static void obliczNajlepszy(){
        boolean czyKonczyc = true;                      //warunek stopu
        for(int i = 0; i < ILOSC_ZMIENNYCH; ++i)
            if(ograniczenia[i][1]-ograniczenia[i][0]>Epsilon) czyKonczyc = false;
        if(czyKonczyc) return;




        double wektor[];
        double najwiekszaFunkcjaCelu;
        if(najlepszyWektor==null) {
            do{
                wektor = losujWektor();
            }while(!sprawdzCzySpelniaWarunki(wektor));

            najlepszyWektor = wektor;
            najwiekszaFunkcjaCelu = obliczFunkcjeCelu(najlepszyWektor);
        } else najwiekszaFunkcjaCelu = obliczFunkcjeCelu(najlepszyWektor);

        for(int i = 0; i < ILOSC_PROBEK; ++i){
            wektor = losujWektor();
            if(sprawdzCzySpelniaWarunki(wektor)){
                if(czyMaksymalizujemy && najwiekszaFunkcjaCelu < obliczFunkcjeCelu(wektor)){
                    najlepszyWektor = wektor;
                    najwiekszaFunkcjaCelu = obliczFunkcjeCelu(najlepszyWektor);
                }

                if((!czyMaksymalizujemy) && najwiekszaFunkcjaCelu > obliczFunkcjeCelu(wektor)){
                    najlepszyWektor = wektor;
                    najwiekszaFunkcjaCelu = obliczFunkcjeCelu(najlepszyWektor);
                }

            }
        }

        for(int i = 0; i < ILOSC_ZMIENNYCH; ++i){
            double roznica = ograniczenia[i][1] - ograniczenia[i][0];
            if(ograniczenia[i][0] < najlepszyWektor[i] - roznica * ZMNIEJSZANIE*0.5) ograniczenia[i][0] = najlepszyWektor[i] - roznica * ZMNIEJSZANIE*0.5;
            if(ograniczenia[i][1] > najlepszyWektor[i] + roznica * ZMNIEJSZANIE*0.5) ograniczenia[i][1] = najlepszyWektor[i] + roznica * ZMNIEJSZANIE*0.5;
        }

        obliczNajlepszy();

    }



    public static void main(String [] args){
        podajIloscZmiennych();
        pytajOMaksymalizacje();
        podajOgraniczenia();
        podajIloscWarunkow();
        podajWielomiany();
        podajFunkcjeCelu();

        obliczNajlepszy();
        System.out.println();
        System.out.println("Maksymalna funkcja celu wynosi: " + obliczFunkcjeCelu(najlepszyWektor));
        System.out.println("Wektor maksymalizujący funkcje celu to:");
        for(int i=0; i< najlepszyWektor.length;++i)
            System.out.println(nazwyZmiennych[i]+": "+najlepszyWektor[i]);

        /*double [] wektor = losujWektor();
        System.out.println(obliczFunkcjeCelu(wektor));
        for(int i=0; i< wektor.length;++i)
        System.out.println(wektor[i]);*/
        /*for(int j = 0; j < funkcjaCelu.length; ++j){
            for(int k = 0; k< funkcjaCelu[j].length; ++k)
                System.out.println(funkcjaCelu[j][k]+", ");
            System.out.println();
        }*/

        /*for(int i =0 ; i<wielomiany.length; ++i){
            for(int j = 0; j < wielomiany[i].length; ++j){
                for(int k = 0; k< wielomiany[i][j].length; ++k)
                    System.out.println(wielomiany[i][j][k]+", ");
                System.out.println();
            }
            System.out.println();
        }*/

        return;
    }

}