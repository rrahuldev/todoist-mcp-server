# Stage 1: Build
FROM node:20-slim as builder

WORKDIR /app

# Install dependencies and build
COPY package.json package-lock.json* ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Run
FROM node:20-slim

WORKDIR /app

# System deps for node + todoist sdk (if needed, can be trimmed)
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/dist ./dist
COPY package.json ./
COPY .env ./

# Only install runtime deps
RUN npm install --omit=dev

ENV NODE_ENV=production

# Export path for todoist-mcp-server cli
ENV PATH="/app/node_modules/.bin:${PATH}"

ENTRYPOINT ["node", "dist/index.js"]