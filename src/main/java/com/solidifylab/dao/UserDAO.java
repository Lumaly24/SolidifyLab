package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.solidifylab.model.ConPool;
import com.solidifylab.model.User; 

public class UserDAO {

    public User doRetrieveByEmailAndPassword(String email, String passwordHash) {
        String query = "SELECT * FROM utente WHERE email = ? AND password_hash = ?";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, email);
            ps.setString(2, passwordHash);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setEmail(rs.getString("email"));
                    u.setPasswordHash(rs.getString("password_hash"));
                    u.setUsername(rs.getString("username")); 
                    u.setNome(rs.getString("nome"));
                    u.setCognome(rs.getString("cognome"));
                    u.setRuolo(rs.getString("ruolo"));
                    return u; 
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; 
    }

    public boolean doSave(User user) {
        
        String query = "INSERT INTO utente (email, password_hash, username, ruolo) VALUES (?, ?, ?, 'CLIENTE')";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getUsername()); 
            
            int righeInserite = ps.executeUpdate();
            return righeInserite > 0; 
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}