class LandingController < ApplicationController
  def home
    @datasheets = Datasheet.all
  end
end
