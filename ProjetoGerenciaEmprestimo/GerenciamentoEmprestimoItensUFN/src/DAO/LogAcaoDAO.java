/*
 
Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template*/
package DAO;

import beans.LogAcao;
import conexao.Conexao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 
@author guede*/
public class LogAcaoDAO {
      private Connection conn;

    public LogAcaoDAO() {
        this.conn = new Conexao().getConexao();
    }

    public List<LogAcao> getLogAcao() {
        String sql = "SELECT * FROM log_acao";
        List<LogAcao> listaLogAcao = new ArrayList<>();
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                LogAcao logAcao = new LogAcao();
                logAcao.setId(rs.getInt("id"));
                logAcao.setAcao(rs.getString("acao"));
                logAcao.setDescricao(rs.getString("descricao"));
                logAcao.setItem(rs.getString("item"));
                logAcao.setDono(rs.getString("dono"));
                logAcao.setPredio(rs.getString("predio"));
                logAcao.setSala(rs.getString("sala"));
                logAcao.setData_hora(rs.getString("data_hora"));

                listaLogAcao.add(logAcao);
            }
        } catch (SQLException ex) {
            System.out.println("Erro ao listar os Logs: " + ex.getMessage());
        }
        return listaLogAcao;
    }
}

//    public LogAcao getLogAcaoPorID(int id) {
//        String sql = "SELECT * FROM log_acao WHERE id = ?";
//        try {
//            PreparedStatement stmt = conn.prepareStatement(sql);
//            stmt.setInt(1, id);
//            ResultSet rs = stmt.executeQuery();
//
//            if (rs.next()) {
//                LogAcao logAcao = new LogAcao();
//                logAcao.setId(rs.getInt("id"));
//                predio.setNome(rs.getString("nome"));
//                return predio;
//            }
//        } catch (SQLException ex) {
//            System.out.println("Erro ao obter prédio: " + ex.getMessage());
//        }
//        return null;
//    }
