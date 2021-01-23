class PingController < ApplicationController
  def handle
    Honeycomb.add_field('queue_time_ms', queue_time_ms)
    Honeycomb.add_field('test_name', test_name)
    Honeycomb.add_field('pgbouncer?', pgbouncer?)

    sleep_db
    sleep_cpu

    render json: { ok: true }
  end

  private

  def sleep_cpu
    sleep rand
  end

  def sleep_db
    ApplicationRecord.connection.execute("SELECT pg_sleep(#{rand * 2})")
  end

  def queue_time_ms
    now = (Time.current.to_f * 1000).to_i
    start = request.headers["HTTP_X_REQUEST_START"].to_i

    now - start
  end

  def pgbouncer?
    ENV.fetch("PGBOUNCER_ENABLED", "false") == "true"
  end

  def test_name
    params[:test_name]
  end
end
