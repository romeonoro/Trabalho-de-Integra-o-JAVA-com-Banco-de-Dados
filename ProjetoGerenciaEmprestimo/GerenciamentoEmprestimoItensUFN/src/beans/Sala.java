/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package beans;

/**
 *
 * @author mathe
 */
public class Sala {
    
    private int id;
    private String nome;
    private Predio id_predio;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public Predio getId_predio() {
        return id_predio;
    }

    public void setId_predio(Predio id_predio) {
        this.id_predio = id_predio;
    }
    
    @Override
    public String toString() {
        return this.id + " - " + this.nome;
    }
    
    
}
