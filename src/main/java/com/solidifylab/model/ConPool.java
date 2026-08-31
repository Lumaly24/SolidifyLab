package com.solidifylab.model;

import java.sql.Connection;
import java.sql.SQLException;
import org.apache.tomcat.jdbc.pool.DataSource;
import org.apache.tomcat.jdbc.pool.PoolProperties;

public class ConPool {
    
    private static DataSource datasource;

    public static Connection getConnection() throws SQLException {
        if (datasource == null) {
            PoolProperties p = new PoolProperties();
            
            // Parametri di connessione al database
            p.setUrl("jdbc:mysql://localhost:3306/solidify_studio?serverTimezone=Europe/Rome");
            p.setDriverClassName("com.mysql.cj.jdbc.Driver");
            
            // ATTENZIONE: Inserisci qui le tue credenziali di MySQL
            p.setUsername("root"); 
            p.setPassword("240105"); 
            
            // Impostazioni avanzate del Pool 
            p.setMaxActive(100);       
            p.setInitialSize(10);      
            p.setMinIdle(10);          
            p.setRemoveAbandonedTimeout(60); 
            p.setRemoveAbandoned(true);
            
            datasource = new DataSource();
            datasource.setPoolProperties(p);
        }
        return datasource.getConnection();
    }
}