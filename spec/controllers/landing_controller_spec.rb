require 'rails_helper'

RSpec.describe LandingController, type: :controller do
  it '#home renders successfully' do
    get 'home'
    expect(response).to be_success
    expect(response).to render_template(:home)
  end
end
