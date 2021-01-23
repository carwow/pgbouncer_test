class PingController < ApplicationController
  def handle
    ApplicationRecord.connection.execute("SELECT pg_sleep(#{rand * 2})")

    head 204
  end
end
