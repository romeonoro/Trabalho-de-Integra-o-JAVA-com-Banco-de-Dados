/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import beans.Item;
import beans.Sala;
import beans.Usuario;
import conexao.Conexao;

/**
 *
 * @author guede
 */
public class ItemDAO {
       private Connection conn;

    public ItemDAO() {
        this.conn = new Conexao().getConexao();
    }

    public void inserir(Item item) {
        String sql = "INSERT INTO itens (nome, categoria, estado, id_sala, id_usuario) VALUES (?, ?, ?, ?, ?);";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, item.getNome());
            stmt.setString(2, item.getCategoria());
            stmt.setString(3, item.getEstado());
            stmt.setInt(4, item.getId_sala().getId());
            stmt.setInt(5, item.getId_usuario().getId());
            stmt.execute();
            System.out.println("Item inserido com sucesso!");
        } catch (SQLException ex) {
            System.out.println("Erro ao inserir item: " + ex.getMessage());
        }
    }

    public Item getItem(int id) {
        String sql = "SELECT * FROM itens WHERE id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Item item = new Item();
                item.setId(rs.getInt("id"));
                item.setNome(rs.getString("nome"));
                item.setCategoria(rs.getString("categoria"));
                item.setEstado(rs.getString("estado"));
                
                int idSala = rs.getInt("id_sala");
                SalaDAO sDAO = new SalaDAO();
                Sala s = sDAO.getSala(idSala);
                item.setId_sala(s);
            
                int idUsuario = rs.getInt("id_usuario");
                UsuarioDAO uDAO = new UsuarioDAO();
                Usuario u = uDAO.getUsuario(idUsuario);
                item.setId_usuario(u);
                
                return item;
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao obter item: " + ex.getMessage());
        }
        return null;
    }

    public List<Item> getItens() {
        String sql = "SELECT * FROM itens";
        List<Item> listaItens = new ArrayList<>();
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Item item = new Item();
                item.setId(rs.getInt("id"));
                item.setNome(rs.getString("nome"));
                item.setCategoria(rs.getString("categoria"));
                item.setEstado(rs.getString("estado"));
              
                
                UsuarioDAO uDAO = new UsuarioDAO();
                SalaDAO sDAO = new SalaDAO();
               
                Usuario u = uDAO.getUsuario(rs.getInt("id_usuario"));
                Sala s = sDAO.getSala(rs.getInt("id_sala"));
                item.setId_usuario(u);
                item.setId_sala(s);
                
                listaItens.add(item);
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao listar itens: " + ex.getMessage());
        }
        return listaItens;
    }

    public void editar(Item item) {
        String sql = "UPDATE itens SET nome = ?, categoria = ?, estado = ?, id_sala = ?, id_usuario = ? WHERE id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, item.getNome());
            stmt.setString(2, item.getCategoria());
            stmt.setString(3, item.getEstado());
            stmt.setInt(4, item.getId_sala().getId());
            stmt.setInt(5, item.getId_usuario().getId());
            stmt.setInt(6, item.getId());
            stmt.executeUpdate();
            System.out.println("Item atualizado com sucesso!");
        } catch (SQLException ex) {
            System.out.println("Erro ao atualizar item: " + ex.getMessage());
        }
    }

    public void excluir(int id) {
        String sql = "DELETE FROM itens WHERE id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            stmt.execute();
            System.out.println("Item excluído com sucesso!");
        } catch (SQLException ex) {
            System.out.println("Erro ao excluir item: " + ex.getMessage());
        }
    }
}
