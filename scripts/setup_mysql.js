import fs from 'fs';
import path from 'path';
import mysql from 'mysql2/promise';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const DB_HOST = process.env.DB_HOST || 'localhost';
const DB_PORT = parseInt(process.env.DB_PORT || '3306', 10);
const DB_USER = process.env.DB_USER || 'root';
const DB_PASSWORD = process.env.DB_PASSWORD !== undefined ? process.env.DB_PASSWORD : 'root';
const DB_NAME = process.env.DB_NAME || 'smart_college_db';

async function initDatabase() {
  console.log('====================================================');
  console.log('Smart College Management System - MySQL Setup');
  console.log('====================================================');
  console.log(`Connecting to MySQL at ${DB_HOST}:${DB_PORT} with user '${DB_USER}'...`);

  let connection;
  try {
    // 1. Connect to MySQL server without selecting database
    connection = await mysql.createConnection({
      host: DB_HOST,
      port: DB_PORT,
      user: DB_USER,
      password: DB_PASSWORD,
      multipleStatements: true,
    });

    console.log('Connected to MySQL server successfully!');

    // 2. Read smart_college_db.sql
    const sqlPath = path.resolve(__dirname, '../smart-college-management-system/smart_college_db.sql');
    if (!fs.existsSync(sqlPath)) {
      throw new Error(`SQL file not found at: ${sqlPath}`);
    }

    console.log(`Reading schema & seed data from ${path.basename(sqlPath)}...`);
    const sqlContent = fs.readFileSync(sqlPath, 'utf8');

    // 3. Execute SQL script
    console.log('Executing database schema and seed data...');
    await connection.query(sqlContent);
    console.log(`Database '${DB_NAME}' created and initialized successfully!`);

    // 4. Verify tables
    const [tables] = await connection.query(`SHOW TABLES FROM \`${DB_NAME}\``);
    console.log('\nVerified Created Tables & Views:');
    tables.forEach((row, idx) => {
      const tableName = Object.values(row)[0];
      console.log(`  ${idx + 1}. ${tableName}`);
    });

    // 5. Check row counts for key tables
    console.log('\nTable Record Counts:');
    for (const row of tables) {
      const tableName = Object.values(row)[0];
      try {
        const [res] = await connection.query(`SELECT COUNT(*) as count FROM \`${DB_NAME}\`.\`${tableName}\``);
        console.log(`  - ${tableName.padEnd(25)} : ${res[0].count} records`);
      } catch (err) {
        // Table might be a view or temporary
      }
    }

    console.log('\n====================================================');
    console.log('MySQL Database Setup Completed Successfully!');
    console.log('====================================================');
  } catch (error) {
    const errorDetail = error.message || error.code || String(error);
    console.error('\nDatabase Setup Error:', errorDetail);
    console.log('\nTroubleshooting Tips:');
    console.log('1. Ensure your MySQL server is running (e.g., MySQL Workbench, XAMPP, or Docker).');
    console.log('2. Check your credentials in .env or provide them via environment variables:');
    console.log('   - DB_HOST (default: localhost)');
    console.log('   - DB_PORT (default: 3306)');
    console.log('   - DB_USER (default: root)');
    console.log('   - DB_PASSWORD (default: root or root123)');
    console.log('3. Or start MySQL with Docker in one command:');
    console.log('   docker-compose up -d mysql');
    process.exit(1);
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

initDatabase();
