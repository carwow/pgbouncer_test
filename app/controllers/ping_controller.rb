class PingController < ApplicationController
  before_action :honey

  def handle
    cpu_sleep = params[:cpu].to_i / 1000.0
    db_sleep = params[:db].to_i / 1000.0

    ApplicationRecord.connection.execute("SELECT pg_sleep(#{db_sleep})")
    sleep cpu_sleep

    render json: { ok: true }
  end

  private

  def honey
    Honeycomb.add_field('queue_time_ms', queue_time_ms)
    Honeycomb.add_field('pgbouncer?', pgbouncer?)
    Honeycomb.add_field('test_name', params[:test_name])
    Honeycomb.add_field('sleep_cpu', params[:cpu])
    Honeycomb.add_field('sleep_db', params[:db])
  end

  def pgbouncer?
    ENV.fetch("PGBOUNCER_ENABLED", "false") == "true"
  end

  def queue_time_ms
    now = (Time.current.to_f * 1000).to_i
    start = request.headers["HTTP_X_REQUEST_START"].to_i

    now - start
  end
end
