# pgbouncer_test

This application has one endpoint at `/` which does a random `pg_sleep` in the
DB for up to 2s followed by a random `sleep` within ruby to fake some work as a
means to test out how pgbouncer affects application availability where DB
connection utilisation is not maximised.

`PGBOUNCER_ENABLED` will cause dynos to connect to via `pgbouncer` when set to `true`.

Initial testing can be done with some http load testing tool. e.g `ab` (Apache Bench) or `hey` (https://github.com/rakyll/hey)

For example:
- `hey -z 20s -c 700 -m GET https://pgbouncer-test-app.com`
