require 'rails_helper'

RSpec.describe LandingController, type: :controller do
  it '#featured renders successfully' do
    get 'featured'
    expect(response).to be_success
    expect(response).to render_template(:featured)
  end

  it '#voter_participation renders successfully' do
    get 'voter_participation'
    expect(response).to be_success
    expect(response).to render_template(:voter_participation)
  end
end
