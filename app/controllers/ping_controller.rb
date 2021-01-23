class PingController < ApplicationController
  before_action :add_queue_time

  def handle
    db = rand * 2
    cpu = rand
    ApplicationRecord.connection.execute("SELECT pg_sleep(#{db})")
    sleep cpu

    render json: { ok: true }
  end

  private

  def add_queue_time
    now = (Time.current.to_f * 1000).to_i
    start = request.headers["HTTP_X_REQUEST_START"].to_i

    queue_time_ms = now - start

    Honeycomb.add_field('request.queue_time_ms', queue_time_ms)
  end
end
