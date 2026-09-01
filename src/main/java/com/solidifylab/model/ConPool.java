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
            
            // Parametri di connessione aggiornati per TiDB Cloud
         // Parametri di connessione aggiornati per TiDB Cloud
            p.setUrl("jdbc:mysql://gateway01.eu-central-1.prod.aws.tidbcloud.com:4000/solidify_studio?sslMode=VERIFY_IDENTITY&tlsVersions=TLSv1.2,TLSv1.3");
            p.setDriverClassName("com.mysql.cj.jdbc.Driver");
            
            // Credenziali del database cloud TiDB
            p.setUsername("2WS95AkGE3JaEFF.root"); 
            p.setPassword("QfWt0sI2enwCPk4n");
            
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

    // Metodo opzionale ma consigliato per chiudere il pool quando Tomcat si ferma
    public static void terminate() {
        if (datasource != null) {
            datasource.close();
            datasource = null;
        }
    }
}