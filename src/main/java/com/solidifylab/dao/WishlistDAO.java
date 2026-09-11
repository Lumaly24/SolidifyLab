package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.solidifylab.model.ConPool;
import com.solidifylab.model.Prodotto;

public class WishlistDAO {

    // 1. AGGIUNGI PRODOTTO
    public void aggiungiProdotto(int idUtente, int idProdotto) {
        String query = "INSERT IGNORE INTO wishlist (utente_id, prodotto_id) VALUES (?, ?)";
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, idUtente);
            ps.setInt(2, idProdotto);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 2. RIMUOVI PRODOTTO
    public void rimuoviProdotto(int idUtente, int idProdotto) {
        String query = "DELETE FROM wishlist WHERE utente_id = ? AND prodotto_id = ?";
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, idUtente);
            ps.setInt(2, idProdotto);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 3. RECUPERA I PRODOTTI COMPLETI (Per la pagina Carrello/Wishlist dedicata)
    public List<Prodotto> getWishlistByUtente(int idUtente) {
        List<Prodotto> wishlist = new ArrayList<>();
        String query = "SELECT p.* FROM prodotto p JOIN wishlist w ON p.id = w.prodotto_id WHERE w.utente_id = ? AND p.cancellato = FALSE";
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, idUtente);
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
                    wishlist.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return wishlist;
    }

    // NUOVO: 4. VERIFICA SE IL PRODOTTO È GIÀ NELLA WISHLIST (Per il "Toggle" nella Servlet)
    public boolean isProdottoInWishlist(int idUtente, int idProdotto) {
        String query = "SELECT 1 FROM wishlist WHERE utente_id = ? AND prodotto_id = ?";
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, idUtente);
            ps.setInt(2, idProdotto);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Ritorna true se trova il record
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // NUOVO: 5. RECUPERA SOLO GLI ID (Per accendere i cuoricini nella JSP)
    public List<Integer> getWishlistIdsByUtente(int idUtente) {
        List<Integer> ids = new ArrayList<>();
        String query = "SELECT prodotto_id FROM wishlist WHERE utente_id = ?";
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, idUtente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("prodotto_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ids;
    }
}