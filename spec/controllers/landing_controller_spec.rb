require 'rails_helper'

RSpec.describe LandingController, type: :controller do
  it '#featured renders successfully' do
    get 'featured'
    expect(response).to be_success
    expect(response).to render_template(:featured)
  end

  it '#books_xy renders successfully' do
    get 'books_xy'
    expect(response).to be_success
    expect(response).to render_template(:scatter)
  end

  it '#states_xy renders successfully' do
    get 'states_xy'
    expect(response).to be_success
    expect(response).to render_template(:scatter)
  end

  it '#voter_participation renders successfully' do
    get 'voter_participation'
    expect(response).to be_success
    expect(response).to render_template(:voter_participation)
  end

  it '#words_line renders successfully' do
    get 'words_line'
    expect(response).to be_success
    expect(response).to render_template(:words_line)
  end
end
