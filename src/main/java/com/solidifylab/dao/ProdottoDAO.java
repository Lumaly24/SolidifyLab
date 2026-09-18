package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.solidifylab.model.ConPool;
import com.solidifylab.model.Prodotto;

public class ProdottoDAO {

    public List<Prodotto> doRetrieveAll() {
        List<Prodotto> prodotti = new ArrayList<>();
        String query = "SELECT * FROM prodotto WHERE cancellato = FALSE";

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                prodotti.add(mapRowToProdotto(rs));
            }
            
        } catch (SQLException e) {
            System.out.println("Errore durante l'estrazione dei prodotti:");
            e.printStackTrace();
        }
        
        return prodotti;
    }

    public Prodotto doRetrieveById(int id) {
        Prodotto prodotto = null;
        String query = "SELECT * FROM prodotto WHERE id = ?";

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    prodotto = mapRowToProdotto(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Errore durante l'estrazione del prodotto per ID:");
            e.printStackTrace();
        }
        
        return prodotto;
    }
    
    public List<Prodotto> doRetrieveByCategoria(int categoriaId) {
        List<Prodotto> prodotti = new ArrayList<>();
        String query = "SELECT * FROM prodotto WHERE cancellato = FALSE AND categoria_id = ?";

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, categoriaId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    prodotti.add(mapRowToProdotto(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Errore durante l'estrazione dei prodotti per categoria:");
            e.printStackTrace();
        }
        
        return prodotti;
    }

    public List<Prodotto> doRetrieveInEvidenza(int limit) {
        List<Prodotto> prodotti = new ArrayList<>();
        String query = "SELECT * FROM prodotto WHERE cancellato = FALSE ORDER BY data_inserimento DESC LIMIT ?";

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    prodotti.add(mapRowToProdotto(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Errore durante l'estrazione dei prodotti in evidenza:");
            e.printStackTrace();
        }
        
        return prodotti;
    }

    public List<Prodotto> doRetrieveByFilters(int categoriaId, double maxPrice, String[] tags) {
        List<Prodotto> prodotti = new ArrayList<>();
        
        StringBuilder query = new StringBuilder();
        
        query.append("SELECT DISTINCT p.* FROM prodotto p ");
        
        if (tags != null && tags.length > 0) {
            query.append("JOIN prodotto_tag pt ON p.id = pt.prodotto_id ");
            query.append("JOIN tag t ON pt.tag_id = t.id ");
        }
        
        query.append("WHERE p.cancellato = FALSE AND p.categoria_id = ? AND p.prezzo_corrente <= ? ");
        
        if (tags != null && tags.length > 0) {
            query.append("AND t.nome IN (");
            for (int i = 0; i < tags.length; i++) {
                query.append("?");
                if (i < tags.length - 1) {
                    query.append(", ");
                }
            }
            query.append(") ");
        }
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query.toString())) {
            
            ps.setInt(1, categoriaId);
            ps.setDouble(2, maxPrice);
            
            if (tags != null && tags.length > 0) {
                int paramIndex = 3;
                for (String t : tags) {
                    ps.setString(paramIndex++, t);
                }
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    prodotti.add(mapRowToProdotto(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Errore durante il filtraggio dei prodotti:");
            e.printStackTrace();
        }
        
        return prodotti;
    }

    public int doSave(Prodotto p) {
        String query = "INSERT INTO prodotto (categoria_id, nome, descrizione, prezzo_corrente, iva_corrente, quantita_disponibile, formato_file, immagine_copertina_url, cancellato) VALUES (?, ?, ?, ?, ?, ?, ?, ?, FALSE)";
        int generatedId = -1;

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, p.getCategoriaId());
            ps.setString(2, p.getNome());
            ps.setString(3, p.getDescrizione());
            ps.setDouble(4, p.getPrezzoCorrente());
            ps.setDouble(5, p.getIvaCorrente());
            ps.setInt(6, p.getQuantitaDisponibile());
            ps.setString(7, p.getFormatoFile());
            ps.setString(8, p.getImmagineCopertinaUrl());
            
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Errore durante l'inserimento del prodotto:");
            e.printStackTrace();
        }
        
        return generatedId;
    }

    public void doSaveTags(int prodottoId, String[] tagIds) {
        if (tagIds == null || tagIds.length == 0) return;
        
        String query = "INSERT INTO prodotto_tag (prodotto_id, tag_id) VALUES (?, ?)";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            for (String tagIdStr : tagIds) {
                ps.setInt(1, prodottoId);
                ps.setInt(2, Integer.parseInt(tagIdStr));
                ps.addBatch();
            }
            ps.executeBatch();
            
        } catch (SQLException e) {
            System.out.println("Errore durante l'inserimento dei tag nella tabella ponte:");
            e.printStackTrace();
        }
    }

    public void doDelete(int id) {
        String query = "UPDATE prodotto SET cancellato = TRUE WHERE id = ?";

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, id);
            ps.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println("Errore durante l'eliminazione (soft delete) del prodotto:");
            e.printStackTrace();
        }
    }

    private Prodotto mapRowToProdotto(ResultSet rs) throws SQLException {
        Prodotto p = new Prodotto();
        p.setId(rs.getInt("id"));
        p.setCategoriaId(rs.getInt("categoria_id"));
        p.setNome(rs.getString("nome"));
        p.setDescrizione(rs.getString("descrizione"));
        p.setPrezzoCorrente(rs.getDouble("prezzo_corrente"));
        p.setIvaCorrente(rs.getDouble("iva_corrente"));
        p.setQuantitaDisponibile(rs.getInt("quantita_disponibile"));
        p.setFormatoFile(rs.getString("formato_file"));
        p.setImmagineCopertinaUrl(rs.getString("immagine_copertina_url"));
        p.setDataInserimento(rs.getString("data_inserimento"));
        p.setCancellato(rs.getBoolean("cancellato"));
        return p;
    }
    
    public void doSaveTagsByNames(int prodottoId, String[] tagNomi) {
        if (tagNomi == null || tagNomi.length == 0) return;
        
        String query = "INSERT INTO prodotto_tag (prodotto_id, tag_id) SELECT ?, id FROM tag WHERE nome = ?";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            for (String nomeTag : tagNomi) {
                ps.setInt(1, prodottoId);
                ps.setString(2, nomeTag); 
                ps.addBatch();
            }
            ps.executeBatch();
            
        } catch (SQLException e) {
            System.out.println("Errore durante l'inserimento dei tag per nome:");
            e.printStackTrace();
        }
    }
}