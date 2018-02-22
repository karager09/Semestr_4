import org.w3c.dom.*;
import javax.xml.parsers.*;
import java.io.*;
import java.util.*;


public class Oblicz {
	
	static ArrayList<String> opcje;
	
	static double [] multiply(double [] wektor, double liczba){
		for(int i = 0; i <wektor.length; ++i){
			wektor[i]*=liczba;
		}
		return wektor;
	}
	
	
	public static double[] zrobWektorPorownan(Node root){
		
		
			//System.out.println(root.getNodeName());
			NodeList nodeList = root.getChildNodes();
			int iloscPorownan = 0;
			for (int temp = 0; temp < nodeList.getLength(); temp++) {
				if(nodeList.item(temp).getNodeName().equals("porownanie"))
	            ++iloscPorownan;
			}
		//System.out.println(iloscPorownan);
		double [] wektorPorownan = new double[iloscPorownan+1];
		int aktualnaPozycja = 0;
		for (int temp = 0; temp < nodeList.getLength(); temp++) {
			Node n = nodeList.item(temp);
			if(n.getNodeName().equals("porownanie"))
			{
				wektorPorownan[aktualnaPozycja] = Double.parseDouble(n.getTextContent());
				++aktualnaPozycja;
			}
		}
		wektorPorownan[iloscPorownan] = 1;//zeby bylo prownanie do niego samego tez
		
		return wektorPorownan;
	}

	
	
	
	public static double[] obliczWektorPriorytetow(Node root){
		if(root!=null){
			NodeList nList = root.getChildNodes();
			
			int iloscDzieci = 0;
			for (int temp = 0; temp < nList.getLength(); temp++) {
				if(nList.item(temp).getNodeType() == Node.ELEMENT_NODE && !nList.item(temp).getNodeName().equals("porownanie"))
	            ++iloscDzieci;
			}// sprawdza ile dzieci ma node, nie bierze pod uwagê porownan
			
			 //if(iloscDzieci == 0) return zrobWektorPorownan(root);// jesli nie ma dzieci, a tylko porowania to zwraca wektor porownan
			
			double[][] macierz = new double[iloscDzieci][];
			
			
			int licznik = 0;
			for (int temp = 0; temp < nList.getLength(); temp++){
				Node nNode = nList.item(temp);
				if (nNode.getNodeType() == Node.ELEMENT_NODE && !nList.item(temp).getNodeName().equals("porownanie")){ //robimy to tylko dla elementow
					//Element eElement = (Element) nNode;
					//System.out.println(nNode.getAttributes().item(0).getNodeValue());
					if(opcje.contains(nNode.getAttributes().item(0).getNodeValue())){
						macierz[opcje.indexOf(nNode.getAttributes().item(0).getNodeValue())]=zrobWektorPorownan(nNode);
	
					}
					else{
					macierz[licznik]=zrobWektorPorownan(nNode);}
					++licznik;
				}
			}//wstawia wektory porownan kazdego z dzieci do macierzy
			
			double [] wektorWaznosci = obliczWektorNaPodstawieMacierzy(macierz);// na podst macierzy oblicza wektor waznosci
			if(((Element)root).getElementsByTagName("kryterium").getLength()==0) return wektorWaznosci;
			
			/*for(double d:wektorWaznosci)System.out.println(d);
			System.out.println("+++++");*/
			
			
			double [][] wektorDlaKazdegoDziecka = new double[iloscDzieci][]; //macierz porownan
			licznik=0;
			
			for (int temp = 0; temp < nList.getLength(); temp++){
				Node nNode = nList.item(temp);
				if (nNode.getNodeType() == Node.ELEMENT_NODE && !nNode.getNodeName().equals("porownanie")){ //robimy to tylko dla elementow
					wektorDlaKazdegoDziecka[licznik]=obliczWektorPriorytetow(nNode);//multiply(obliczWektorPriorytetow(nNode),wektorWaznosci[licznik]);
					//for(double d: wektorDlaKazdegoDziecka[licznik])System.out.println(d);
					//System.out.println();
					++licznik;
				}
			}
			
			//for(double d:wektorDlaKazdegoDziecka[0])System.out.println(d);
			//System.out.println("+++++");
			
			double [] wektorWynikowy = new double[wektorDlaKazdegoDziecka[0].length];
			for(int i = 0;i < wektorWynikowy.length; ++i) wektorWynikowy[i] = 0;
			
			for(int i = 0; i < iloscDzieci; ++i){
				for(int j=0; j<wektorWynikowy.length; ++j){
					wektorWynikowy[j] += wektorDlaKazdegoDziecka[i][j]*wektorWaznosci[i];
				}
			}
			return wektorWynikowy;
			
		}else return null;
			
	}
	
	public static double[] obliczWektorNaPodstawieMacierzy(double[][] macierz){
		double [] iloczynZPierwiastkiem = new double[macierz.length];
		for(int i = 0; i < macierz.length; ++i){
			iloczynZPierwiastkiem[i]=1;
			for(int j = 0; j < macierz[i].length; ++j){
				iloczynZPierwiastkiem[i]*=macierz[i][j];
			}

			iloczynZPierwiastkiem[i] = Math.pow(iloczynZPierwiastkiem[i],(double)1/macierz[i].length);
			
		}
		double suma = 0;
		for( int k = 0; k < iloczynZPierwiastkiem.length;++k){
			suma += iloczynZPierwiastkiem[k];
		}
		
		for( int l = 0; l < iloczynZPierwiastkiem.length;++l){
			iloczynZPierwiastkiem[l] = iloczynZPierwiastkiem[l]/suma;
		}
		return iloczynZPierwiastkiem;
	}
	

	public static void main(String[] args) throws Exception {

		
		DocumentBuilderFactory factory =
				DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();

		
		File file=new File("D:\\PIOTR\\Desktop\\Studia\\Badania\\Tworzenie1.xml");
		Document document=builder.parse(file);
		
		document.normalize();
		Element root=document.getDocumentElement();
		root.normalize();
		
		opcje= new ArrayList<String>();
		NodeList listaOpcji= root.getElementsByTagName("opcja");
		
		int licznik = 0;
		for(int temp = 0; temp < listaOpcji.getLength(); ++temp){
			String opc = listaOpcji.item(temp).getAttributes().item(0).getNodeValue();
			if(!opcje.contains(opc)) opcje.add(opc);
		}
		//System.out.println(opcje);
		
		
		double [] wekt = obliczWektorPriorytetow(root);
		
		for(int i = 0; i < wekt.length; ++i){
			System.out.println(opcje.get(i)+":\t"+wekt[i]);
			
			
		}
		
		/*NodeList nList = document.getElementsByTagName("kryterium");
		for (int temp = 0; temp < nList.getLength(); temp++) {
         Node nNode = nList.item(temp);
            System.out.println("\nElement :" 
               + nNode.getNodeName());
            
            System.out.println("Nazwa kryterium : " 
                    + ((Element)nNode).getAttribute("name"));
            double[] tab = zrobWektorPorownan(nNode);
            for(double d:tab){
            	System.out.println(d);
            }
            
		}*/
	}
}