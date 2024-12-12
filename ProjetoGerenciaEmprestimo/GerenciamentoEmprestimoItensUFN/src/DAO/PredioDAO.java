/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import beans.Predio;
import conexao.Conexao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author guede
 */
public class PredioDAO {
      private Connection conn;

    public PredioDAO() {
        this.conn = new Conexao().getConexao();
    }

    public void inserir(Predio predio) {
        String sql = "INSERT INTO predios (nome) VALUES (?);";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, predio.getNome());
            stmt.execute();
            System.out.println("Prédio inserido com sucesso!");
        } catch (SQLException ex) {
            System.out.println("Erro ao inserir prédio: " + ex.getMessage());
        }
    }

    public Predio getPredio(int id) {
        String sql = "SELECT * FROM predios WHERE id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Predio predio = new Predio();
                predio.setId(rs.getInt("id"));
                predio.setNome(rs.getString("nome"));
                return predio;
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao obter prédio: " + ex.getMessage());
        }
        return null;
    }

    public List<Predio> getPredios() {
        String sql = "SELECT * FROM predios";
        List<Predio> listaPredios = new ArrayList<>();
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Predio predio = new Predio();
                predio.setId(rs.getInt("id"));
                predio.setNome(rs.getString("nome"));
                listaPredios.add(predio);
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao listar prédios: " + ex.getMessage());
        }
        return listaPredios;
    }

    public void editar(Predio predio) {
        String sql = "UPDATE predios SET nome = ? WHERE id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, predio.getNome());
            stmt.setInt(2, predio.getId());
            stmt.executeUpdate();
            System.out.println("Prédio atualizado com sucesso!");
        } catch (SQLException ex) {
            System.out.println("Erro ao atualizar prédio: " + ex.getMessage());
        }
    }

    public void excluir(int id) {
        String sql = "DELETE FROM predios WHERE id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            stmt.execute();
            System.out.println("Prédio excluído com sucesso!");
        } catch (SQLException ex) {
            System.out.println("Erro ao excluir prédio: " + ex.getMessage());
        }
    }
}
