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

    /**
     * Estrae tutti i prodotti attivi dal database.
     * Perfetto per riempire il catalogo e il carosello della Home Page!
     */
    public List<Prodotto> doRetrieveAll() {
        // Creiamo una lista vuota che conterrà i nostri prodotti
        List<Prodotto> prodotti = new ArrayList<>();
        
        // La nostra query SQL (escludiamo quelli cancellati logicamente)
        String query = "SELECT * FROM prodotto WHERE cancellato = FALSE";

        // Il blocco try-with-resources chiude in automatico la connessione quando finisce!
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            // Per ogni riga trovata nel database...
            while (rs.next()) {
                // ...creiamo un nuovo "scatolone" Prodotto
                Prodotto p = new Prodotto();
                
                // ...e lo riempiamo con i dati estratti dalle colonne!
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

                // Aggiungiamo il prodotto finito alla nostra lista
                prodotti.add(p);
            }
            
        } catch (SQLException e) {
            System.out.println("Errore durante l'estrazione dei prodotti:");
            e.printStackTrace();
        }
        
        // Restituiamo la lista piena (o vuota se c'è stato un errore)
        return prodotti;
    }
}