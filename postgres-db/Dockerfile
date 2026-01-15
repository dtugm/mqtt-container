FROM timescale/timescaledb-ha:pg16.10-ts2.23.0

RUN mkdir -p /var/lib/postgresql/data && chown -R postgres:postgres /var/lib/postgresql/data

COPY postgres-db/init.sql /docker-entrypoint-initdb.d/init.sql

EXPOSE 5432
