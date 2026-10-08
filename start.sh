#!/bin/bash
set -e

echo "==============================================================="
echo "    Smart College Student Management System - Quick Start"
echo "==============================================================="
echo ""

if [ ! -d "node_modules" ]; then
    echo "[1/3] Installing dependencies..."
    npm install
fi

if [ ! -d "dist" ]; then
    echo "[2/3] Building production bundle..."
    npm run build
fi

echo "[3/3] Starting Application Server..."
echo "---------------------------------------------------------------"
echo "App URL: http://localhost:3000"
echo "---------------------------------------------------------------"
npm start
