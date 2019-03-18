#!/usr/bin/env bash
set -e

# Create database if not exists
createdb sampledb || true

# Install to DB in single transaction
psql -X1v ON_ERROR_STOP=1 sampledb -f scripts/schema_pg.sql

