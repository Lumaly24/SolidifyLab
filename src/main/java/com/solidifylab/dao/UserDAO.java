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
    
    public void updateProfilo(User user) {
        String query = "UPDATE utente SET nome = ?, cognome = ?, indirizzo = ?, citta = ?, cap = ? WHERE id = ?";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, user.getNome());
            ps.setString(2, user.getCognome());
            ps.setString(3, user.getIndirizzo());
            ps.setString(4, user.getCitta());
            ps.setString(5, user.getCap());
            ps.setInt(6, user.getId());
            
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean updatePassword(String email, String nuovoPasswordHash) {
        String query = "UPDATE utente SET password_hash = ? WHERE email = ?";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, nuovoPasswordHash);
            ps.setString(2, email);
            
            int righeAggiornate = ps.executeUpdate();
            return righeAggiornate > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean esisteEmail(String email) {
        String query = "SELECT id FROM utente WHERE email = ?";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}