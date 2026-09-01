package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.solidifylab.model.ConPool;
import com.solidifylab.model.User; 

public class UserDAO {

    /**
     * Cerca un utente nel database in base a email e password (per il Login)
     */
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
                    u.setUsername(rs.getString("username")); // <-- AGGIUNTO
                    u.setNome(rs.getString("nome"));
                    u.setCognome(rs.getString("cognome"));
                    u.setRuolo(rs.getString("ruolo"));
                    return u; // Utente trovato!
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Utente non trovato o credenziali errate
    }

    /**
     * Registra un nuovo utente nel database (per la Signup)
     */
    public boolean doSave(User user) {
        // AGGIORNATA: Inseriamo l'username, nome e cognome prenderanno il valore NULL di default
        String query = "INSERT INTO utente (email, password_hash, username, ruolo) VALUES (?, ?, ?, 'CLIENTE')";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getUsername()); // <-- AGGIUNTO
            
            int righeInserite = ps.executeUpdate();
            return righeInserite > 0; // Restituisce true se l'inserimento è andato a buon fine
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}