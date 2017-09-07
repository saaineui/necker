require 'rails_helper'

RSpec.describe WordsController, type: :controller do
  it '#index renders successfully' do
    get 'index'
    expect(response).to be_success
    expect(response).to render_template(:index)
  end
end
