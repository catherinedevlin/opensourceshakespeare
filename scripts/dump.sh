#!/usr/bin/env bash
set -e
pg_dump --no-owner --clean --if-exists --schema=shakespeare sampledb -f shakespeare.sql
