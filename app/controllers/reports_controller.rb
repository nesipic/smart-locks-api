require 'csv'
class ReportsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_server

  def handle
    if Rails.env.development?
      Entry.delete_all
      Lock.delete_all
    end
    report = params[:report].open
    csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
    CSV.parse(report, csv_options) do |timestamp, lock_id, kind, status_change|
      lock = Lock.find_by_id(lock_id[1])
      if lock
        lock.status = status_change[1]
        lock.save
      else
        lock = Lock.create(id: lock_id[1], kind: kind[1], status: status_change[1])
      end
      Entry.create(timestamp: timestamp[1], status_change: status_change[1], lock: lock)
    end
    render json: { message: "Congrats you have #{Entry.count}entries and #{Lock.count} lock" }
  end
  private
  def authenticate_server
   p code_name = request.headers["X-Server-CodeName"]
    acces_token = request.headers["X-Server-Token"]
    server = Server.find_by(code_name: code_name )
      unless server && server.acces_token == acces_token
        render json: { message: "wrong credentials"}
      end
  end
end
