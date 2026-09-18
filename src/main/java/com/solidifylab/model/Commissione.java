package com.solidifylab.model;

import java.sql.Timestamp;

public class Commissione {
    
    private int id; 
    private Integer utenteId;
    private String email;
    private String tipi;
    
    private String descrizione;
    private String fileRiferimentoUrl;
    
    private String via;
    private String citta;
    private String cap;
    private String indirizzoSpedizione;
    
    private boolean richiedeStampa3d;
    private String materialeStampa;
    private String descMateriale;
    private String tipoPostproduzione;
    private String descPostproduzione;
    
    private boolean richiedeModello3d;
    private boolean includeTextureModello;
    private String descrizioneTextureModello;
    private boolean includeAnimazione;
    private String descrizioneAnimazione;
    private boolean includeRigging;
    private String descrizioneRigging;
    
    private boolean richiedeTexture;
    private boolean includeUvMapping;
    private String descUvMapping;
    private boolean includeMaterialiPbr;
    private String descMaterialiPbr;

    private String stato;
    private boolean visionata;
    private Timestamp dataRichiesta;

    public Commissione() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Integer getUtenteId() { return utenteId; }
    public void setUtenteId(Integer utenteId) { this.utenteId = utenteId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getTipi() { return tipi; }
    public void setTipi(String tipi) { this.tipi = tipi; }

    public String getDescrizione() { return descrizione; }
    public void setDescrizione(String descrizione) { this.descrizione = descrizione; }

    public String getFileRiferimentoUrl() { return fileRiferimentoUrl; }
    public void setFileRiferimentoUrl(String fileRiferimentoUrl) { this.fileRiferimentoUrl = fileRiferimentoUrl; }

    public String getVia() { return via; }
    public void setVia(String via) { this.via = via; }

    public String getCitta() { return citta; }
    public void setCitta(String citta) { this.citta = citta; }

    public String getCap() { return cap; }
    public void setCap(String cap) { this.cap = cap; }

    public String getIndirizzoSpedizione() { return indirizzoSpedizione; }
    public void setIndirizzoSpedizione(String indirizzoSpedizione) { this.indirizzoSpedizione = indirizzoSpedizione; }

    public boolean isRichiedeStampa3d() { return richiedeStampa3d; }
    public void setRichiedeStampa3d(boolean richiedeStampa3d) { this.richiedeStampa3d = richiedeStampa3d; }

    public String getMaterialeStampa() { return materialeStampa; }
    public void setMaterialeStampa(String materialeStampa) { this.materialeStampa = materialeStampa; }

    public String getDescMateriale() { return descMateriale; }
    public void setDescMateriale(String descMateriale) { this.descMateriale = descMateriale; }

    public String getTipoPostproduzione() { return tipoPostproduzione; }
    public void setTipoPostproduzione(String tipoPostproduzione) { this.tipoPostproduzione = tipoPostproduzione; }

    public String getDescPostproduzione() { return descPostproduzione; }
    public void setDescPostproduzione(String descPostproduzione) { this.descPostproduzione = descPostproduzione; }

    public boolean isRichiedeModello3d() { return richiedeModello3d; }
    public void setRichiedeModello3d(boolean richiedeModello3d) { this.richiedeModello3d = richiedeModello3d; }

    public boolean isIncludeTextureModello() { return includeTextureModello; }
    public void setIncludeTextureModello(boolean includeTextureModello) { this.includeTextureModello = includeTextureModello; }

    public String getDescrizioneTextureModello() { return descrizioneTextureModello; }
    public void setDescrizioneTextureModello(String descrizioneTextureModello) { this.descrizioneTextureModello = descrizioneTextureModello; }

    public boolean isIncludeAnimazione() { return includeAnimazione; }
    public void setIncludeAnimazione(boolean includeAnimazione) { this.includeAnimazione = includeAnimazione; }

    public String getDescrizioneAnimazione() { return descrizioneAnimazione; }
    public void setDescrizioneAnimazione(String descrizioneAnimazione) { this.descrizioneAnimazione = descrizioneAnimazione; }

    public boolean isIncludeRigging() { return includeRigging; }
    public void setIncludeRigging(boolean includeRigging) { this.includeRigging = includeRigging; }

    public String getDescrizioneRigging() { return descrizioneRigging; }
    public void setDescrizioneRigging(String descrizioneRigging) { this.descrizioneRigging = descrizioneRigging; }

    public boolean isRichiedeTexture() { return richiedeTexture; }
    public void setRichiedeTexture(boolean richiedeTexture) { this.richiedeTexture = richiedeTexture; }

    public boolean isIncludeUvMapping() { return includeUvMapping; }
    public void setIncludeUvMapping(boolean includeUvMapping) { this.includeUvMapping = includeUvMapping; }

    public String getDescUvMapping() { return descUvMapping; }
    public void setDescUvMapping(String descUvMapping) { this.descUvMapping = descUvMapping; }

    public boolean isIncludeMaterialiPbr() { return includeMaterialiPbr; }
    public void setIncludeMaterialiPbr(boolean includeMaterialiPbr) { this.includeMaterialiPbr = includeMaterialiPbr; }

    public String getDescMaterialiPbr() { return descMaterialiPbr; }
    public void setDescMaterialiPbr(String descMaterialiPbr) { this.descMaterialiPbr = descMaterialiPbr; }

    public String getStato() { return stato; }
    public void setStato(String stato) { this.stato = stato; }

    public boolean isVisionata() { return visionata; }
    public void setVisionata(boolean visionata) { this.visionata = visionata; }

    public Timestamp getDataRichiesta() { return dataRichiesta; }
    public void setDataRichiesta(Timestamp dataRichiesta) { this.dataRichiesta = dataRichiesta; }
}