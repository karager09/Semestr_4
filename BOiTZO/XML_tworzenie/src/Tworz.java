import java.io.IOException;
import java.util.Scanner;
/**
 * Created by Piotr on 2017-03-24.
 */

public class Tworz {

    private static int podaj_ilość_opcji(){
        int iloscOpcji=0;
        do{
            System.out.println("Podaj ilość opcji:\n ");
            Scanner scan = new Scanner(System.in);
            String next = scan.next();
            try {
                iloscOpcji = Integer.parseInt(next);
            }catch(Exception e){System.out.println("Podałeś niepoprawną wartość! Spróbuj jeszcze raz:");}
            // System.out.println(ILOSC_OPCJI);
        }while(iloscOpcji < 1);

        return iloscOpcji;
    }

    public static void main(String [] args){

        StworzXML xml = new StworzXML(podaj_ilość_opcji());
        try {
            //double[][] cos = {{1,2},{0.5,1}};
            //System.out.println(xml.obliczNiespojnosc(new Matrix(cos)));
            xml.podajProg();
            xml.pytajOOpcje();
            xml.pytajOKategorie(xml.root);
            xml.zapiszDoPliku("D:\\PIOTR\\Desktop\\Studia\\Badania\\Tworzenie2.xml");

    } catch (IOException e) {
        e.printStackTrace();
    }
    }
}
