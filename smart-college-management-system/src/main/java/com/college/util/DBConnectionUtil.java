package com.college.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Central Database Connection Utility.
 * Uses HikariCP for high-performance connection pooling.
 * Safely reads credentials from db.properties or system environment variables.
 */
public class DBConnectionUtil {

    private static final Logger LOGGER = Logger.getLogger(DBConnectionUtil.java.getName());
    private static HikariDataSource dataSource;

    static {
        try {
            Properties props = new Properties();
            InputStream in = DBConnectionUtil.class.getClassLoader().getResourceAsStream("db.properties");
            if (in != null) {
                props.load(in);
            } else {
                LOGGER.warning("db.properties not found in classpath, falling back to defaults.");
            }

            String host = System.getenv().getOrDefault("DB_HOST", props.getProperty("db.host", "localhost"));
            String port = System.getenv().getOrDefault("DB_PORT", props.getProperty("db.port", "3306"));
            String dbName = System.getenv().getOrDefault("DB_NAME", props.getProperty("db.name", "smart_college_db"));
            String user = System.getenv().getOrDefault("DB_USER", props.getProperty("db.user", "root"));
            String pass = System.getenv().getOrDefault("DB_PASSWORD", props.getProperty("db.password", "root123"));

            String jdbcUrl = "jdbc:mysql://" + host + ":" + port + "/" + dbName 
                    + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";

            HikariConfig config = new HikariConfig();
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");
            config.setJdbcUrl(jdbcUrl);
            config.setUsername(user);
            config.setPassword(pass);

            config.setMaximumPoolSize(Integer.parseInt(props.getProperty("db.pool.maxSize", "10")));
            config.setMinimumIdle(Integer.parseInt(props.getProperty("db.pool.minIdle", "2")));
            config.setIdleTimeout(Long.parseLong(props.getProperty("db.pool.idleTimeout", "30000")));
            config.setConnectionTimeout(Long.parseLong(props.getProperty("db.pool.connectionTimeout", "20000")));
            config.setMaxLifetime(Long.parseLong(props.getProperty("db.pool.maxLifetime", "1800000")));

            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

            dataSource = new HikariDataSource(config);
            LOGGER.info("HikariCP Connection Pool initialized successfully for database: " + dbName);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize Database Connection Pool", e);
            throw new RuntimeException("Database pool initialization error", e);
        }
    }

    private DBConnectionUtil() {
        // Private constructor prevents instantiation
    }

    /**
     * Obtains an active connection from the pool.
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("HikariDataSource is not initialized.");
        }
        return dataSource.getConnection();
    }

    /**
     * Closes the entire data source pool on application shutdown.
     */
    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            LOGGER.info("HikariCP Connection Pool shutdown successfully.");
        }
    }
}
