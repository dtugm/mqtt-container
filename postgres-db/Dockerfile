FROM timescale/timescaledb-ha:pg16.10-ts2.23.0

# Copy initialization script
COPY postgres-db/init.sql /docker-entrypoint-initdb.d/init.sql

# Set default environment variables (will be overridden by Railway)
ENV POSTGRES_USER=bi-digital-twin
ENV POSTGRES_PASSWORD=""
ENV POSTGRES_DB=bi-digital-twin

# Expose PostgreSQL port
EXPOSE 5432

