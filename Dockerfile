# Step 1: Build the frontend
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Step 2: Production runtime
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/server.js ./server.js
COPY --from=builder /app/smart-college-management-system/smart_college_db.sql ./smart-college-management-system/smart_college_db.sql
COPY --from=builder /app/scripts ./scripts

EXPOSE 3000

CMD ["node", "server.js"]
