class PingController < ApplicationController
  def handle
    ApplicationRecord.connection.execute("SELECT pg_sleep(#{rand * 2})")

    render json: { ok: true }
  end
end
