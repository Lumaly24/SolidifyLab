package com.solidifylab.model;

public class Prodotto {
    
    private int id;
    private int categoriaId;
    private String nome;
    private String descrizione;
    private double prezzoCorrente;
    private double ivaCorrente;
    private int quantitaDisponibile;
    private String formatoFile;
    private String immagineCopertinaUrl;
    private String dataInserimento; // Lo teniamo come String per stamparlo facilmente sulle JSP
    private boolean cancellato;

    public Prodotto() {}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getCategoriaId() {
		return categoriaId;
	}

	public void setCategoriaId(int categoriaId) {
		this.categoriaId = categoriaId;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getDescrizione() {
		return descrizione;
	}

	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}

	public double getPrezzoCorrente() {
		return prezzoCorrente;
	}

	public void setPrezzoCorrente(double prezzoCorrente) {
		this.prezzoCorrente = prezzoCorrente;
	}

	public double getIvaCorrente() {
		return ivaCorrente;
	}

	public void setIvaCorrente(double ivaCorrente) {
		this.ivaCorrente = ivaCorrente;
	}

	public int getQuantitaDisponibile() {
		return quantitaDisponibile;
	}

	public void setQuantitaDisponibile(int quantitaDisponibile) {
		this.quantitaDisponibile = quantitaDisponibile;
	}

	public String getFormatoFile() {
		return formatoFile;
	}

	public void setFormatoFile(String formatoFile) {
		this.formatoFile = formatoFile;
	}

	public String getImmagineCopertinaUrl() {
		return immagineCopertinaUrl;
	}

	public void setImmagineCopertinaUrl(String immagineCopertinaUrl) {
		this.immagineCopertinaUrl = immagineCopertinaUrl;
	}

	public String getDataInserimento() {
		return dataInserimento;
	}

	public void setDataInserimento(String dataInserimento) {
		this.dataInserimento = dataInserimento;
	}

	public boolean isCancellato() {
		return cancellato;
	}

	public void setCancellato(boolean cancellato) {
		this.cancellato = cancellato;
	}
    
    // Clicca col tasto destro qui e scatena la magia di Eclipse (Generate Getters and Setters -> Select All)
}