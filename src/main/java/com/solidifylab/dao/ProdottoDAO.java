package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
}