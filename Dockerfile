# Base image de Bun
FROM oven/bun:alpine AS base

# Step 1. Rebuild the source code only when needed
FROM base AS builder

WORKDIR /app

# Instalar dependencias usando Bun
COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile

# Copiar archivos necesarios para la compilación de Next.js
COPY app ./app
COPY public ./public
COPY components ./components
COPY lib ./lib
COPY next.config.ts .
COPY prisma ./prisma
COPY components.json .
COPY tailwind.config.ts .
COPY tsconfig.json .
COPY postcss.config.mjs .

# Variables de entorno para el tiempo de compilación
ARG DATABASE_URL
ENV DATABASE_URL=${DATABASE_URL}
ARG BETTER_AUTH_SECRET
ENV BETTER_AUTH_SECRET=${BETTER_AUTH_SECRET}
ARG BETTER_AUTH_URL
ENV BETTER_AUTH_URL=${BETTER_AUTH_URL}
#ARG BASIC_AUTH_USER
#ENV BASIC_AUTH_USER=${BASIC_AUTH_USER}
#ARG BASIC_AUTH_PASSWORD
#ENV BASIC_AUTH_PASSWORD=${BASIC_AUTH_PASSWORD}

# Compilar el proyecto con Bun
RUN bun run build

# Step 2. Imagen de producción
FROM oven/bun:alpine AS runner

WORKDIR /app

# Crear usuario y grupo sin privilegios
RUN addgroup -S nextjs && adduser -S nextjs -G nextjs
USER nextjs

# Copiar archivos necesarios para producción
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# Redefinir variables de entorno para tiempo de ejecución
ARG DATABASE_URL
ENV DATABASE_URL=${DATABASE_URL}
ARG BETTER_AUTH_SECRET
ENV BETTER_AUTH_SECRET=${BETTER_AUTH_SECRET}
ARG BETTER_AUTH_URL
ENV BETTER_AUTH_URL=${BETTER_AUTH_URL}
#ARG BASIC_AUTH_USER
#ENV BASIC_AUTH_USER=${BASIC_AUTH_USER}
#ARG BASIC_AUTH_PASSWORD
#ENV BASIC_AUTH_PASSWORD=${BASIC_AUTH_PASSWORD}

EXPOSE 3000

ENV PORT 3000
CMD ["bun", "run", "server.js"]



