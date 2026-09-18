package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.solidifylab.model.Commissione;
import com.solidifylab.model.ConPool;

public class CommissioneDAO {

    public synchronized void doSave(Commissione c) throws SQLException {
        String insertSQL = "INSERT INTO commissione "
                + "(utente_id, email_contatto, richiede_stampa_3d, richiede_modello_3d, richiede_texture, "
                + "descrizione_principale, file_riferimento_url, indirizzo_spedizione, "
                + "materiale_stampa, desc_materiale, tipo_postproduzione, desc_postproduzione, "
                + "include_texture_modello, descrizione_texture_modello, include_animazione, descrizione_animazione, "
                + "include_rigging, descrizione_rigging, include_uv_mapping, desc_uv_mapping, include_materiali_pbr, desc_materiali_pbr, stato) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'IN_ATTESA')";

        try (Connection connection = ConPool.getConnection();
             PreparedStatement ps = connection.prepareStatement(insertSQL)) {

            if (c.getUtenteId() != null && c.getUtenteId() > 0) {
                ps.setInt(1, c.getUtenteId());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }

            ps.setString(2, c.getEmail());
            ps.setBoolean(3, c.isRichiedeStampa3d());
            ps.setBoolean(4, c.isRichiedeModello3d());
            ps.setBoolean(5, c.isRichiedeTexture());
            ps.setString(6, c.getDescrizione());
            ps.setString(7, c.getFileRiferimentoUrl());

            String indirizzoCompleto = null;
            if (c.getVia() != null && !c.getVia().trim().isEmpty()) {
                indirizzoCompleto = c.getVia() + ", " + 
                                  (c.getCitta() != null ? c.getCitta() : "") + " " + 
                                  (c.getCap() != null ? c.getCap() : "");
            }
            ps.setString(8, indirizzoCompleto);

            ps.setString(9, c.getMaterialeStampa());
            ps.setString(10, c.getDescMateriale());
            ps.setString(11, c.getTipoPostproduzione());
            ps.setString(12, c.getDescPostproduzione());

            ps.setBoolean(13, c.isIncludeTextureModello());
            ps.setString(14, c.getDescrizioneTextureModello());
            ps.setBoolean(15, c.isIncludeAnimazione());
            ps.setString(16, c.getDescrizioneAnimazione());
            ps.setBoolean(17, c.isIncludeRigging());
            ps.setString(18, c.getDescrizioneRigging());

            ps.setBoolean(19, c.isIncludeUvMapping());
            ps.setString(20, c.getDescUvMapping());
            ps.setBoolean(21, c.isIncludeMaterialiPbr());
            ps.setString(22, c.getDescMaterialiPbr());

            ps.executeUpdate();
        }
    }

    public List<Commissione> getAllCommissioni() {
        List<Commissione> list = new ArrayList<>();
        String query = "SELECT * FROM commissione ORDER BY data_richiesta ASC";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapRowToCommissione(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Errore recupero commissioni", e);
        }
        return list;
    }

    public List<Commissione> getCommissioniByEmail(String email) {
        List<Commissione> list = new ArrayList<>();
        String query = "SELECT * FROM commissione WHERE email_contatto = ? ORDER BY data_richiesta DESC";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToCommissione(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Errore recupero commissioni per email", e);
        }
        return list;
    }

    public void updateStato(int id, String nuovoStato) {
        String query = "UPDATE commissione SET stato = ?, data_aggiornamento = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, nuovoStato);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Errore aggiornamento stato", e);
        }
    }

    public void segnaComeVisionata(int id) {
        String query = "UPDATE commissione SET visionata = TRUE WHERE id = ?";
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Errore aggiornamento visualizzazione", e);
        }
    }

    private Commissione mapRowToCommissione(ResultSet rs) throws SQLException {
        Commissione c = new Commissione();
        c.setId(rs.getInt("id"));
        c.setEmail(rs.getString("email_contatto"));
        c.setDescrizione(rs.getString("descrizione_principale"));
        c.setFileRiferimentoUrl(rs.getString("file_riferimento_url"));
        c.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
        
        c.setRichiedeStampa3d(rs.getBoolean("richiede_stampa_3d"));
        c.setRichiedeModello3d(rs.getBoolean("richiede_modello_3d"));
        c.setRichiedeTexture(rs.getBoolean("richiede_texture"));

        List<String> tipiList = new ArrayList<>();
        if (c.isRichiedeStampa3d()) tipiList.add("Stampa 3D");
        if (c.isRichiedeModello3d()) tipiList.add("Modello 3D");
        if (c.isRichiedeTexture()) tipiList.add("Texture");
        c.setTipi(String.join(", ", tipiList));
        
        // -- OPZIONI EXTRA STAMPA 3D --
        c.setMaterialeStampa(rs.getString("materiale_stampa"));
        c.setDescMateriale(rs.getString("desc_materiale"));
        c.setTipoPostproduzione(rs.getString("tipo_postproduzione"));
        c.setDescPostproduzione(rs.getString("desc_postproduzione"));

        // -- OPZIONI EXTRA MODELLO 3D --
        c.setIncludeTextureModello(rs.getBoolean("include_texture_modello"));
        c.setDescrizioneTextureModello(rs.getString("descrizione_texture_modello"));
        c.setIncludeAnimazione(rs.getBoolean("include_animazione"));
        c.setDescrizioneAnimazione(rs.getString("descrizione_animazione"));
        c.setIncludeRigging(rs.getBoolean("include_rigging"));
        c.setDescrizioneRigging(rs.getString("descrizione_rigging"));

        // -- OPZIONI EXTRA TEXTURE --
        c.setIncludeUvMapping(rs.getBoolean("include_uv_mapping"));
        c.setDescUvMapping(rs.getString("desc_uv_mapping"));
        c.setIncludeMaterialiPbr(rs.getBoolean("include_materiali_pbr"));
        c.setDescMaterialiPbr(rs.getString("desc_materiali_pbr"));

        c.setStato(rs.getString("stato")); 
        c.setVisionata(rs.getBoolean("visionata"));
        c.setDataRichiesta(rs.getTimestamp("data_richiesta"));
        
        return c;
    }
}