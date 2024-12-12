/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import beans.Usuario;
import conexao.Conexao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author guede
 */
public class UsuarioDAO {
    
    private Connection conn;

    public UsuarioDAO() {
        // Inicializar a conexão com o banco de dados
        this.conn = new Conexao().getConexao();
    }

    // inserir um usuário
    public void inserir(Usuario usuario) {
        String sql = "INSERT INTO usuarios (nome, matricula, contato) VALUES (?, ?, ?);";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, usuario.getNome());
            stmt.setString(2, usuario.getMatricula());
            stmt.setString(3, usuario.getContato());
            stmt.execute();
            System.out.println("Usuário inserido com sucesso!");
        } catch (SQLException ex) {
            System.out.println("Erro ao inserir usuário: " + ex.getMessage());
        }
    }

    // obter um usuário pelo ID
    public Usuario getUsuario(int id) {
        String sql = "SELECT * FROM usuarios WHERE id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setId(rs.getInt("id"));
                usuario.setNome(rs.getString("nome"));
                usuario.setMatricula(rs.getString("matricula"));
                usuario.setContato(rs.getString("contato"));
                return usuario;
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao obter usuário: " + ex.getMessage());
        }
        return null;
    }

    // listar todos os usuários
    public List<Usuario> getUsuarios() {
        String sql = "SELECT * FROM usuarios";
        List<Usuario> listaUsuarios = new ArrayList<>();
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setId(rs.getInt("id"));
                usuario.setNome(rs.getString("nome"));
                usuario.setMatricula(rs.getString("matricula"));
                usuario.setContato(rs.getString("contato"));
                listaUsuarios.add(usuario);
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao listar usuários: " + ex.getMessage());
        }
        return listaUsuarios;
    }

    // atualizar um usuário
    public void editar(Usuario usuario) {
        String sql = "UPDATE usuarios SET nome = ?, matricula = ?, contato = ? WHERE id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, usuario.getNome());
            stmt.setString(2, usuario.getMatricula());
            stmt.setString(3, usuario.getContato());
            stmt.setInt(4, usuario.getId());
            stmt.executeUpdate();
            System.out.println("Usuário atualizado com sucesso!");
        } catch (SQLException ex) {
            System.out.println("Erro ao atualizar usuário: " + ex.getMessage());
        }
    }

    // excluir um usuário pelo ID
    public void excluir(int id) {
        String sql = "DELETE FROM usuarios WHERE id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            stmt.execute();
            System.out.println("Usuário excluído com sucesso!");
        } catch (SQLException ex) {
            System.out.println("Erro ao excluir usuário: " + ex.getMessage());
        }
    }
}
