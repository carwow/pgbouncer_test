class PingController < ApplicationController
  before_action :add_queue_time
  before_action :add_test_name

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

    Honeycomb.add_field('queue_time_ms', queue_time_ms)
  end

  def add_test_name
    Honeycomb.add_field('test_name', params[:test_name])
  end
end
