require 'rails_helper'

RSpec.describe DatasheetsController, type: :controller do
  fixtures :datasheets
  
  it '#index renders successfully' do
    get 'index'
    expect(response).to be_success
    expect(response).to render_template(:index)
  end
  
  it '#show renders successfully' do
    get 'show', params: { id: datasheets(:donors).id }
    expect(response).to be_success
    expect(response).to render_template(:show)
  end
end
