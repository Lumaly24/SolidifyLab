package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.solidifylab.model.Carrello;
import com.solidifylab.model.ConPool;
import com.solidifylab.model.ItemCarrello;
import com.solidifylab.model.Ordine;
import com.solidifylab.model.Prodotto;
import com.solidifylab.model.User;

public class OrdineDAO {

    public List<Ordine> doRetrieveAll() {
    	
        List<Ordine> ordini = new ArrayList<>();
        
        String query = "SELECT o.*, u.nome as utente_nome, u.cognome as utente_cognome, u.email as utente_email " +
                       "FROM ordine o " +
                       "JOIN utente u ON o.utente_id = u.id " +
                       "ORDER BY o.data_ordine DESC";

        try (Connection con = ConPool.getConnection();
        		
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
            	
                Ordine ordine = new Ordine();
                ordine.setId(rs.getInt("id"));
                ordine.setDataOrdine(rs.getTimestamp("data_ordine")); 
                ordine.setTotale(rs.getDouble("totale"));
                ordine.setStato(rs.getString("stato"));

                User utente = new User();
                utente.setId(rs.getInt("utente_id"));
                utente.setNome(rs.getString("utente_nome"));
                utente.setCognome(rs.getString("utente_cognome"));
                utente.setEmail(rs.getString("utente_email"));
                
                ordine.setUtente(utente);

                ordini.add(ordine);
            }

        } catch (SQLException e) {
        	
            System.out.println("Errore durante l'estrazione degli ordini:");
            e.printStackTrace();
        }

        return ordini;
    }
    
    public boolean doSave(Ordine ordine, Carrello carrello) {
    	
        String queryOrdine = "INSERT INTO ordine (data_ordine, totale, stato, utente_id) VALUES (?, ?, ?, ?)";
        String queryRiga = "INSERT INTO riga_ordine (ordine_id, prodotto_id, quantita, prezzo_unitario_storico, iva_storica) VALUES (?, ?, ?, ?, ?)";
        
        Connection con = null;
        
        try {
        	
            con = ConPool.getConnection();
            con.setAutoCommit(false);

            try (PreparedStatement psOrdine = con.prepareStatement(queryOrdine, PreparedStatement.RETURN_GENERATED_KEYS)) {
            	
                psOrdine.setTimestamp (1, ordine.getDataOrdine());
                psOrdine.setDouble(2, ordine.getTotale());
                psOrdine.setString(3, ordine.getStato());
                psOrdine.setInt(4, ordine.getUtente().getId());
                
                int affectedRows = psOrdine.executeUpdate();
                
                if (affectedRows == 0) {
                	
                    con.rollback();
                    return false;
                }

                try (ResultSet rs = psOrdine.getGeneratedKeys()) {
                	
                    if (rs.next()) {
                    	
                        ordine.setId(rs.getInt(1));
                        
                    } else {
                    	
                        con.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement psRiga = con.prepareStatement(queryRiga)) {
            	
                for (ItemCarrello item : carrello.getProdotti()) {
                	
                    psRiga.setInt(1, ordine.getId());
                    psRiga.setInt(2, item.getProdotto().getId());
                    psRiga.setInt(3, item.getQuantita());
                    psRiga.setDouble(4, item.getProdotto().getPrezzoCorrente()); 
                    psRiga.setDouble(5, item.getProdotto().getIvaCorrente());
                    psRiga.addBatch();
                }
                
                psRiga.executeBatch();
            }

            con.commit();
            
            return true;

        } catch (SQLException e) {
        	
            if (con != null) {
            	
                try {
                	
                    con.rollback();
                } catch (SQLException ex) {
                	
                    ex.printStackTrace();
                }
            }
            
            System.out.println("Errore durante il salvataggio dell'ordine e delle sue righe:");
            e.printStackTrace();
            
        } finally {
        	
            if (con != null) {
            	
                try {
                	
                    con.setAutoCommit(true);
                    con.close();
                    
                } catch (SQLException e) {
                	
                    e.printStackTrace();
                }
            }
        }
        
        return false;
    }
    
    public List<Ordine> doRetrieveByUtente(int utenteId) {
    	
        List<Ordine> ordini = new ArrayList<>();
        String query = "SELECT o.*, u.nome as utente_nome, u.cognome as utente_cognome, u.email as utente_email " +
                       "FROM ordine o " +
                       "JOIN utente u ON o.utente_id = u.id " +
                       "WHERE o.utente_id = ? " +
                       "ORDER BY o.data_ordine DESC";

        try (Connection con = ConPool.getConnection();
        		
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, utenteId);
            
            try (ResultSet rs = ps.executeQuery()) {
            	
                while (rs.next()) {
                	
                    Ordine ordine = new Ordine();
                    ordine.setId(rs.getInt("id"));
                    ordine.setDataOrdine(rs.getTimestamp("data_ordine")); 
                    ordine.setTotale(rs.getDouble("totale"));
                    ordine.setStato(rs.getString("stato"));

                    User utente = new User();
                    utente.setId(rs.getInt("utente_id"));
                    utente.setNome(rs.getString("utente_nome"));
                    utente.setCognome(rs.getString("utente_cognome"));
                    utente.setEmail(rs.getString("utente_email"));
                    
                    ordine.setUtente(utente);
                    ordine.setArticoli(getArticoliPerOrdine(ordine.getId(), con));
                    ordini.add(ordine);
                }
            }
            
        } catch (SQLException e) {
        	
            System.out.println("Errore durante l'estrazione degli ordini per utente:");
            e.printStackTrace();
        }
        
        return ordini;
    }
    
    public Ordine doRetrieveById(int id) {
        
        Ordine ordine = null;
        String query = "SELECT o.*, u.nome as utente_nome, u.cognome as utente_cognome, u.email as utente_email " +
                       "FROM ordine o " +
                       "JOIN utente u ON o.utente_id = u.id " +
                       "WHERE o.id = ?";

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                
                if (rs.next()) {
                    
                    ordine = new Ordine();
                    ordine.setId(rs.getInt("id"));
                    ordine.setDataOrdine(rs.getTimestamp("data_ordine")); 
                    ordine.setTotale(rs.getDouble("totale"));
                    ordine.setStato(rs.getString("stato"));

                    User utente = new User();
                    utente.setId(rs.getInt("utente_id"));
                    utente.setNome(rs.getString("utente_nome"));
                    utente.setCognome(rs.getString("utente_cognome"));
                    utente.setEmail(rs.getString("utente_email"));
                    
                    ordine.setUtente(utente);
                    
                    ordine.setArticoli(getArticoliPerOrdine(ordine.getId(), con));
                }
            }
            
        } catch (SQLException e) {
        	
            System.out.println("Errore durante l'estrazione dell'ordine per ID:");
            e.printStackTrace();
        }
        
        return ordine;
    }
    
    private List<ItemCarrello> getArticoliPerOrdine(int ordineId, Connection con) {
        
        List<ItemCarrello> articoli = new ArrayList<>();

        String query = "SELECT ro.quantita, ro.prezzo_unitario_storico, ro.iva_storica, p.nome FROM riga_ordine ro JOIN prodotto p ON ro.prodotto_id = p.id WHERE ro.ordine_id = ?";
        
        try (PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, ordineId);
            
            try (ResultSet rs = ps.executeQuery()) {
                
                while(rs.next()) {
                    
                    ItemCarrello item = new ItemCarrello(null, ordineId);
                    Prodotto p = new Prodotto();
                    p.setNome(rs.getString("nome"));
                    p.setPrezzoCorrente(rs.getDouble("prezzo_unitario_storico"));
                    
                    p.setIvaCorrente(rs.getDouble("iva_storica"));
                    
                    item.setProdotto(p);
                    item.setQuantita(rs.getInt("quantita"));
                    articoli.add(item);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return articoli;
    }
}