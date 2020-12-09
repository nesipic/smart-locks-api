Rails.application.routes.draw do
  post "/handle_report", to: "reports#handle", defaults: { format: :json }
end
