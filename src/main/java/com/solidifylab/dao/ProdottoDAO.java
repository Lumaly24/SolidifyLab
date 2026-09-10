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

                prodotti.add(p);
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
                    
                    prodotti.add(p);
                }
            }
        } catch (SQLException e) {
            System.out.println("Errore durante l'estrazione dei prodotti per categoria:");
            e.printStackTrace();
        }
        
        return prodotti;
    }
}