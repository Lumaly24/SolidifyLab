package com.solidifylab.model;

import java.util.ArrayList;
import java.util.List;

public class Carrello {
    
    private List<ItemCarrello> prodotti;
    private double sconto;

    public Carrello() {
        this.prodotti = new ArrayList<>();
    }

    public List<ItemCarrello> getProdotti() {
        return prodotti;
    }

    public double getSubtotale() {
        double totale = 0;
        for (ItemCarrello item : prodotti) {
            totale += item.getProdotto().getPrezzoCorrente() * item.getQuantita();
        }
        return totale;
    }

    public double getTasse() {
        return getSubtotale() - (getSubtotale() / 1.22);
    }

    public double getTotaleFinale() {
        return getSubtotale() - sconto;
    }

	public double getSconto() {
		return sconto;
	}

	public void setSconto(double sconto) {
		this.sconto = sconto;
	}
}