require 'active_charts/helpers/chart_helper'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  include ActiveCharts::Helpers::ChartHelper
end
