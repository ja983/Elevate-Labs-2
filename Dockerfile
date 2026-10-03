# ---------- Stage 1: test (build fails here if tests fail) ----------
FROM node:20-alpine AS test
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm test

# ---------- Stage 2: production image ----------
FROM node:20-alpine AS production
WORKDIR /app
ENV NODE_ENV=production PORT=3000
COPY package*.json ./
RUN npm ci --omit=dev
COPY app.js server.js ./
EXPOSE 3000
USER node
CMD ["npm", "start"]
