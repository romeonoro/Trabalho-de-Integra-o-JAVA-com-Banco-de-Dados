/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package conexao;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;

/**
 *
 * @author guede
 */
public class Main {
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        int porta = 12345; // Use uma constante para a porta

        try (ServerSocket servidorSocket = new ServerSocket(porta)) {
            System.out.println("Servidor aguardando conexões na porta " + porta);

            while (true) {
                try {
                    Socket clienteSocket = servidorSocket.accept();
                    System.out.println("Conexão aceita de " + clienteSocket.getInetAddress());
                      
                    
                    ObjectOutputStream out = new ObjectOutputStream(clienteSocket.getOutputStream());
                    ObjectInputStream in = new ObjectInputStream(clienteSocket.getInputStream());

                   

                } catch (IOException ex) {
                    System.out.println("Erro ao aceitar conexão do cliente: " + ex.getMessage());
                }
            }
        } catch (IOException ex) {
            System.out.println("Erro ao criar o ServerSocket: " + ex.getMessage());
        }
    }
}
