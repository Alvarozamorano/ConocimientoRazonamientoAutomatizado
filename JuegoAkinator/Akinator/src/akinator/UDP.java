package akinator;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;

/**
 *
 * Juan Casado Ballesteros Gabriel López Cuenca Álvaro Zamorano Ortega
 */
public class UDP extends Thread {

    private final Interfaz interfaz;
    private final DatagramSocket socket;
    private String datosRecibidos = "";

    public UDP(DatagramSocket socket, Interfaz interfaz) {
        this.interfaz = interfaz;
        this.socket = socket;
    }

    @Override
    public void run() {
        boolean continuar = true;

        while (continuar) {
            int index = 0;
            boolean set = false;
            System.out.println("Started...");
            try {
                byte[] receiveData = new byte[1024];
                while (true) {
                    for (int i = 0; i < receiveData.length; i++) {
                        receiveData[i] = 0;
                    }
                    DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
                    socket.receive(receivePacket);
                    String sentence = new String(receivePacket.getData());
                    
                    //MOSTRAR LO QUE SE RECIBE
                    //System.out.println("Received: " + sentence);
                    
                    switch (sentence.charAt(0)) {
                        case '%'://Varios
                            index = 0;
                            colocarString(index, "");
                            datosRecibidos = "";
                            set = false;
                            break;
                        case '@'://Preguntas
                            index = 1;
                            colocarString(index, "");
                            datosRecibidos = "";
                            set = false;
                            break;
                        case '#'://Posibles lenguajes
                            index = 2;
                            colocarString(index, "");
                            datosRecibidos = "";
                            set = false;
                            break;
                        default:
                            set = true;
                    }
                    if (set) {
                        for (int i = 0; i < sentence.length(); i++) {
                            if (sentence.charAt(i) != 0) {
                                datosRecibidos += sentence.charAt(i);
                            }
                        }
                        colocarString(index, datosRecibidos);
                    }
                }
            } catch (IOException ex) {
                System.out.println(ex.toString());
            }
        }

    }

    private void colocarString(int index, String s) {
        switch (index) {
            case 0://Varios
                interfaz.escribirVarios(s);
                break;
            case 1://Preguntas
                interfaz.escribirPregunta(s);
                break;
            case 2://Posibles lenguajes
                interfaz.escribirPosibles(s);
                break;
        }
    }
}
