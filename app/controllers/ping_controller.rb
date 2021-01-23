class PingController < ApplicationController
  def handle
    db = rand * 2
    cpu = rand
    ApplicationRecord.connection.execute("SELECT pg_sleep(#{db})")
    sleep cpu

    render json: { ok: true }
  end
end
