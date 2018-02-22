/**
 * Created by Piotr on 2017-03-24.
 */

import Jama.Matrix;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

class StworzXML {
    //Element root;
    private static double [] RIn = {1, 1, 1, 0.5247, 0.8816, 1.1086, 1.2479, 1.3417, 1.4057, 1.4499, 1.4854};
    private Document document;
    static Element root;
    private static int ILOSC_OPCJI;

    private static String[] tablicaOpcji;
    private static double PROG=0.1;

    void podajProg(){
        System.out.println("Podaj próg z jakim ma być sprawdzana spójność: ");
        Scanner scan = new Scanner(System.in);
        do {
            try {

                String s = scan.next();
                PROG = Double.parseDouble(s);
            } catch (Exception e) {
                System.out.println("Podałeś złą wartość. Spróbuj jeszcze raz");
                continue;
            }
        } while (PROG <= 0 );


    }



    StworzXML(int il_opcji) {
        ILOSC_OPCJI = il_opcji;
        document = DocumentHelper.createDocument();
        root = document.addElement("goal");
        root.addAttribute("name", "goal");
    }
    private static void pytajOPriorytetyKategorii(Element aktualny){
        Matrix matrix = new Matrix(aktualny.elements("kategoria").size(),aktualny.elements("kategoria").size(), 1);
        for (int i = 0; i < aktualny.elements("kategoria").size(); ++i) {

            Element doPorowanania;
            Element opcja = (Element) aktualny.elements("kategoria").get(i);
            for (int j = 0; j < aktualny.elements("kategoria").size(); ++j) {

                if (j > i) {
                    System.out.println("Porównaj \"" + ((Element) aktualny.elements("kategoria").get(i)).attribute("name").getValue() + "\" do \"" + ((Element) aktualny.elements("kategoria").get(j)).attribute("name").getValue() + "\"");
                    double wartosc = 0;
                    Scanner scan = new Scanner(System.in);
                    do {
                        try {

                            String s = scan.next();
                            wartosc = Double.parseDouble(s);
                        } catch (Exception e) {
                            System.out.println("Podałeś złą wartość. Spróbuj jeszcze raz");
                            continue;
                        }
                    } while (wartosc <= 0);

                    matrix.set(i, j, wartosc);

                    doPorowanania = opcja.addElement("porownanie");
                    doPorowanania.addAttribute("doczego", ((Element) aktualny.elements("kategoria").get(j)).attribute("name").getValue());
                    doPorowanania.addText("" + wartosc);

                    double wartoscOdwrotna = (double) 1 / wartosc;
                    matrix.set(j, i, wartoscOdwrotna);
                    System.out.println("Niespójność wynosi: "+ obliczNiespojnosc(matrix));
                    if(obliczNiespojnosc(matrix) > PROG) System.out.println("Niespójnność jest zbyt duża!");
                } else if (i > j) {

                    doPorowanania = opcja.addElement("porownanie");
                    doPorowanania.addAttribute("doczego", ((Element) aktualny.elements("kategoria").get(j)).attribute("name").getValue());
                    doPorowanania.addText("" + matrix.get(i, j));
                }
            }
        }
    }

    static void pytajOKategorie(Element aktualny) {
        System.out.println("Ile kategorii chcesz dodać w elemencie " + aktualny.attribute("name").getValue() + "? Jeśli podasz 0 to znaczy, że przystępujemy do porównań.");
        Scanner scanner = new Scanner(System.in);
        int ilosc_kat = -1;
        do {
            try {
                String s = scanner.next();
                ilosc_kat = Integer.parseInt(s);
            } catch (Exception e) {
                System.out.println("Podałeś błędną liczbę, spróbuj jeszcze raz.");
                continue;
            }
        } while (ilosc_kat < 0);
        if (ilosc_kat > 0) {
            for (int i = 0; i < ilosc_kat; ++i) {
                System.out.println("Podaj nazwę dla kategorii numer " + (i + 1));
                aktualny.addElement("kategoria").addAttribute("name", scanner.next());
            }

            pytajOPriorytetyKategorii(aktualny);

            for (int i = 0; i < aktualny.elements("kategoria").size(); ++i) {
                Element przegladany = (Element) aktualny.elements("kategoria").get(i);
                pytajOKategorie(przegladany);
            }

        } else tworzPorownania(aktualny);

    }

    private static void tworzPorownania(Element element) {
        System.out.println("Porównujemy względem kategorii: " + element.attribute("name").getValue());
        Matrix matrix = new Matrix(ILOSC_OPCJI, ILOSC_OPCJI, 1);
        for (int i = 0; i < ILOSC_OPCJI; ++i) {

            Element doPorowanania;
            Element opcja = element.addElement("opcja");
            opcja.addAttribute("name", tablicaOpcji[i]);
            for (int j = 0; j < ILOSC_OPCJI; ++j) {

                if (j > i) {
                    System.out.println("Porównaj \"" + tablicaOpcji[i] + "\" do \"" + tablicaOpcji[j] + "\"");
                    double wartosc = 0;
                    Scanner scan = new Scanner(System.in);
                    do {
                        try {

                            String s = scan.next();
                            wartosc = Double.parseDouble(s);
                        } catch (Exception e) {
                            System.out.println("Podałeś złą wartość. Spróbuj jeszcze raz");
                            continue;
                        }
                    } while (wartosc <= 0);

                    matrix.set(i, j, wartosc);

                    doPorowanania = opcja.addElement("porownanie");
                    doPorowanania.addAttribute("doczego", tablicaOpcji[j]);
                    doPorowanania.addText("" + wartosc);

                    double wartoscOdwrotna = (double) 1 / wartosc;
                    //System.out.println("Wartosc odwrotna: "+wart+", a wartosc orginalna: "+matrix.get(i,j));
                    matrix.set(j, i, wartoscOdwrotna);
                    System.out.println("Niespójność wynosi: "+ obliczNiespojnosc(matrix));
                    if(obliczNiespojnosc(matrix) > PROG) System.out.println("\nNiespójnność jest zbyt duża!\n");
                } else if (i > j) {

                    doPorowanania = opcja.addElement("porownanie");
                    doPorowanania.addAttribute("doczego", tablicaOpcji[j]);
                    doPorowanania.addText("" + matrix.get(i, j));
                }
            }
        }
    }


    static private double obliczNiespojnosc(Matrix matrix) {
        double max = 0;
        for (double d : matrix.eig().getRealEigenvalues()) {
            if (Math.abs(d) > max) max = Math.abs(d);        //wybieramy największą wartość własną
        }
        //System.out.println(max);
        if(matrix.getRowDimension() < RIn.length)
        return (max - matrix.getRowDimension())/((matrix.getRowDimension() - 1) * (RIn[ILOSC_OPCJI]) );
        else return (max - matrix.getRowDimension())/(matrix.getRowDimension() - 1);
    }

    void pytajOOpcje() {
        tablicaOpcji = new String[ILOSC_OPCJI];
        Scanner scanner = new Scanner(System.in);
        for (int i = 0; i < ILOSC_OPCJI; ++i) {
            System.out.println("Opcja numer " + (i + 1) + ":");
            tablicaOpcji[i] = scanner.next();
        }
    }

    void zapiszDoPliku(String path) throws IOException {
        OutputFormat format = OutputFormat.createPrettyPrint();
        FileWriter fw = new FileWriter(new File(path));
        XMLWriter writer = new XMLWriter(fw, format);
        writer.write(document);
        fw.flush();
        fw.close();
    }
}
