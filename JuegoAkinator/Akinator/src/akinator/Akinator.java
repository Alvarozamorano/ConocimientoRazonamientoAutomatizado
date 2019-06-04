package akinator;

import java.net.DatagramSocket;
import java.net.SocketException;

/**
 *
 * Juan Casado Ballesteros Gabriel López Cuenca Álvaro Zamorano Ortega
 */
public class Akinator {

    private static final int puertoRecibir = 49260;

    public static void main(String[] args) throws SocketException {
        DatagramSocket socket = null;
        Interfaz interfaz;
        try {
            socket = new DatagramSocket(puertoRecibir);
        } catch (SocketException e) {
            System.out.println(e.toString());
        }
        Ejecutador ej = new Ejecutador();
        interfaz = new Interfaz(socket, ej);
        java.awt.EventQueue.invokeLater(() -> {
            interfaz.setVisible(true);
        });

        UDP udp = new UDP(socket, interfaz);
        udp.start();

        ej.start();

    }
}
