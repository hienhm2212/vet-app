class HealthController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def index
    health_status = {
      status: 'healthy',
      timestamp: Time.current.iso8601,
      version: Rails.application.config.version,
      environment: Rails.env,
      database: database_status,
      redis: redis_status
    }
    
    render json: health_status, status: :ok
  end
  
  private
  
  def database_status
    ActiveRecord::Base.connection.execute('SELECT 1')
    'connected'
  rescue => e
    'error'
  end
  
  def redis_status
    # If you have Redis configured
    'not_configured'
  rescue => e
    'error'
  end
end
