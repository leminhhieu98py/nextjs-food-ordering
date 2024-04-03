ARG NODE_VERSION=node:18-alpine
FROM $NODE_VERSION as builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM $NODE_VERSION

WORKDIR /app

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone .
COPY --from=builder /app/.next/static ./.next/static

EXPOSE 3000

CMD HOSTNAME="0.0.0.0" node server.js
