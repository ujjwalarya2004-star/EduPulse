import express from 'express';
import path from 'path';
import fs from 'fs';
import mysql from 'mysql2/promise';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// MySQL Connection Pool Configuration
const DB_HOST = process.env.DB_HOST || 'localhost';
const DB_PORT = parseInt(process.env.DB_PORT || '3306', 10);
const DB_USER = process.env.DB_USER || 'root';
const DB_PASSWORD = process.env.DB_PASSWORD !== undefined ? process.env.DB_PASSWORD : 'root';
const DB_NAME = process.env.DB_NAME || 'smart_college_db';

let pool = null;
let isDbConnected = false;

function createPool() {
  try {
    pool = mysql.createPool({
      host: DB_HOST,
      port: DB_PORT,
      user: DB_USER,
      password: DB_PASSWORD,
      database: DB_NAME,
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0,
    });
    return pool;
  } catch (err) {
    console.warn('[DB] Could not initialize connection pool:', err.message);
    return null;
  }
}

async function testConnection() {
  if (!pool) createPool();
  if (!pool) return false;
  try {
    const conn = await pool.getConnection();
    await conn.ping();
    conn.release();
    isDbConnected = true;
    console.log(`[DB] Connected successfully to MySQL (${DB_HOST}:${DB_PORT}/${DB_NAME})`);
    return true;
  } catch (err) {
    isDbConnected = false;
    console.warn(`[DB] MySQL not connected: ${err.message}. (Using in-memory/mock fallback for browser queries if needed)`);
    return false;
  }
}

// Initial connection check
testConnection();

// API Health Endpoint
app.get('/api/health', async (req, res) => {
  const dbStatus = await testConnection();
  res.json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    mysql: {
      connected: dbStatus,
      host: DB_HOST,
      port: DB_PORT,
      database: DB_NAME,
      user: DB_USER,
    },
    version: '1.0.0',
    app: 'Smart College Student Management System',
  });
});

// API: Departments
app.get('/api/departments', async (req, res) => {
  if (isDbConnected && pool) {
    try {
      const [rows] = await pool.query(`
        SELECT d.*, 
          (SELECT COUNT(*) FROM students WHERE dept_id = d.dept_id) as students,
          (SELECT COUNT(*) FROM faculty WHERE dept_id = d.dept_id) as faculty,
          (SELECT COUNT(*) FROM subjects WHERE dept_id = d.dept_id) as subjects
        FROM departments d
        ORDER BY d.dept_name
      `);
      return res.json({ success: true, data: rows });
    } catch (err) {
      console.error('Error fetching departments:', err);
    }
  }
  res.status(503).json({ success: false, message: 'MySQL database not reachable' });
});

// API: Students
app.get('/api/students', async (req, res) => {
  if (isDbConnected && pool) {
    try {
      const [rows] = await pool.query(`
        SELECT s.*, d.dept_code, d.dept_name 
        FROM students s
        LEFT JOIN departments d ON s.dept_id = d.dept_id
        ORDER BY s.student_id DESC
      `);
      return res.json({ success: true, data: rows });
    } catch (err) {
      console.error('Error fetching students:', err);
    }
  }
  res.status(503).json({ success: false, message: 'MySQL database not reachable' });
});

// API: Faculty
app.get('/api/faculty', async (req, res) => {
  if (isDbConnected && pool) {
    try {
      const [rows] = await pool.query(`
        SELECT f.*, d.dept_code, d.dept_name 
        FROM faculty f
        LEFT JOIN departments d ON f.dept_id = d.dept_id
        ORDER BY f.name
      `);
      return res.json({ success: true, data: rows });
    } catch (err) {
      console.error('Error fetching faculty:', err);
    }
  }
  res.status(503).json({ success: false, message: 'MySQL database not reachable' });
});

// API: Academic Risk Analysis
app.get('/api/academic-risk', async (req, res) => {
  if (isDbConnected && pool) {
    try {
      const [rows] = await pool.query(`SELECT * FROM v_academic_risk ORDER BY risk_count DESC`);
      return res.json({ success: true, data: rows });
    } catch (err) {
      console.error('Error fetching academic risk data:', err);
    }
  }
  res.status(503).json({ success: false, message: 'MySQL database not reachable' });
});

// API: Dashboard Stats
app.get('/api/stats', async (req, res) => {
  if (isDbConnected && pool) {
    try {
      const [[studentCount]] = await pool.query(`SELECT COUNT(*) as count FROM students WHERE status='ACTIVE'`);
      const [[facultyCount]] = await pool.query(`SELECT COUNT(*) as count FROM faculty`);
      const [[deptCount]] = await pool.query(`SELECT COUNT(*) as count FROM departments`);
      const [[subjectCount]] = await pool.query(`SELECT COUNT(*) as count FROM subjects`);
      const [[feeStats]] = await pool.query(`SELECT SUM(paid_amount) as totalCollected, SUM(pending_amount) as totalPending FROM student_fees`);

      return res.json({
        success: true,
        data: {
          totalStudents: studentCount.count,
          totalFaculty: facultyCount.count,
          totalDepartments: deptCount.count,
          totalSubjects: subjectCount.count,
          feeCollected: feeStats.totalCollected || 0,
          feePending: feeStats.totalPending || 0,
        }
      });
    } catch (err) {
      console.error('Error fetching stats:', err);
    }
  }
  res.status(503).json({ success: false, message: 'MySQL database not reachable' });
});

// Serve Static Frontend Assets (dist folder)
const distPath = path.resolve(__dirname, 'dist');
if (fs.existsSync(distPath)) {
  app.use(express.static(distPath));
  app.get('*', (req, res) => {
    res.sendFile(path.join(distPath, 'index.html'));
  });
} else {
  app.get('/', (req, res) => {
    res.send(`
      <!DOCTYPE html>
      <html>
      <head>
        <title>Smart College Student Management System</title>
        <style>
          body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #0f172a; color: #f8fafc; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
          .card { background: #1e293b; padding: 2rem; border-radius: 1rem; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.5); max-width: 500px; text-align: center; border: 1px solid #334155; }
          h1 { color: #38bdf8; margin-top: 0; }
          code { background: #0f172a; padding: 0.2rem 0.4rem; border-radius: 4px; color: #a5f3fc; }
          .btn { display: inline-block; background: #0284c7; color: white; padding: 0.75rem 1.5rem; border-radius: 0.5rem; text-decoration: none; font-weight: bold; margin-top: 1rem; }
          .btn:hover { background: #0369a1; }
        </style>
      </head>
      <body>
        <div class="card">
          <h1>Smart College Management System</h1>
          <p>The production build is not yet generated. Run:</p>
          <p><code>npm run build</code></p>
          <p>or start the development server with:</p>
          <p><code>npm run dev</code></p>
          <a href="/api/health" class="btn">Check API & MySQL Status</a>
        </div>
      </body>
      </html>
    `);
  });
}

app.listen(PORT, '0.0.0.0', () => {
  console.log(`====================================================`);
  console.log(`Smart College Management System running on http://localhost:${PORT}`);
  console.log(`API Health: http://localhost:${PORT}/api/health`);
  console.log(`====================================================`);
});
