FROM node:24-slim AS frontend-build

WORKDIR /app/frontend

COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci

COPY frontend/ ./
RUN npm run build


FROM node:24-slim AS production

WORKDIR /app/backend

COPY backend/package.json backend/package-lock.json ./
RUN npm ci --omit=dev

COPY backend/ ./

COPY --from=frontend-build /app/frontend/dist /app/frontend/dist

ENV PORT=3000

EXPOSE 3000

CMD ["npm", "start"]