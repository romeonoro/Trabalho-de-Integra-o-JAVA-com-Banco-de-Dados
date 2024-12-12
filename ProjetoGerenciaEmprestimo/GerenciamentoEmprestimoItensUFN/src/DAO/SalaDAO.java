/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import beans.Predio;
import beans.Sala;
import conexao.Conexao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author guede
 */
public class SalaDAO {
     private Connection conn;

    public SalaDAO() {
        this.conn = new Conexao().getConexao();
    }

    public void inserir(Sala sala) {
        String sql = "INSERT INTO salas (nome, id_predio) VALUES (?, ?);";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, sala.getNome());
            stmt.setInt(2, sala.getId_predio().getId());
            stmt.execute();
            System.out.println("Sala inserida com sucesso!");
        } catch (SQLException ex) {
            System.out.println("Erro ao inserir sala: " + ex.getMessage());
        }
    }

    public Sala getSala(int id) {
        String sql = "SELECT * FROM salas WHERE id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Sala sala = new Sala();
                sala.setId(rs.getInt("id"));
                sala.setNome(rs.getString("nome"));               
                
                int idPredio = rs.getInt("id_predio");
                PredioDAO pDAO = new PredioDAO();
                Predio p = pDAO.getPredio(idPredio);
                sala.setId_predio(p);
                
                
                return sala;
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao obter sala: " + ex.getMessage());
        }
        return null;
    }

    public List<Sala> getSalas() { 
        String sql = "SELECT * FROM salas";
        List<Sala> listaSalas = new ArrayList<>();
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Sala sala = new Sala();
                sala.setId(rs.getInt("id"));
                sala.setNome(rs.getString("nome"));
                                                             
                PredioDAO pDAO = new PredioDAO();              
                Predio p = pDAO.getPredio(rs.getInt("id_predio"));
                sala.setId_predio(p);
                   
                listaSalas.add(sala);
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao listar salas: " + ex.getMessage());
        }
        return listaSalas;
    }

    public void editar(Sala sala) {
        String sql = "UPDATE salas SET nome = ?, id_predio = ? WHERE id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, sala.getNome());
            stmt.setInt(2, sala.getId_predio().getId());
            stmt.setInt(3, sala.getId());
            stmt.executeUpdate();
            System.out.println("Sala atualizada com sucesso!");
        } catch (SQLException ex) {
            System.out.println("Erro ao atualizar sala: " + ex.getMessage());
        }
    }

    public void excluir(int id) {
        String sql = "DELETE FROM salas WHERE id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            stmt.execute();
            System.out.println("Sala excluída com sucesso!");
        } catch (SQLException ex) {
            System.out.println("Erro ao excluir sala: " + ex.getMessage());
        }
    }
}
