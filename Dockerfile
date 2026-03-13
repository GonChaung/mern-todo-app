FROM node:18-alpine AS frontend-build

WORKDIR /app/frontend

COPY TODO/todo_frontend/package*.json ./
RUN npm install
COPY TODO/todo_frontend/ ./
RUN npm run build

FROM node:18-alpine

WORKDIR /app

COPY TODO/todo_backend/package*.json ./
RUN npm install --omit=dev
COPY TODO/todo_backend/ ./

COPY --from=frontend-build /app/frontend/build ./static/build

ENV PORT=5000

EXPOSE 5000

CMD ["node", "server.js"]