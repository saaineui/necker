require 'rails_helper'

RSpec.describe Admin::DatasheetsController, type: :controller do
  fixtures :admins, :datasheets, :rows, :columns
  let(:admin) { admins(:eve) }
  let(:datasheet) { datasheets(:donors) }
  let(:data_file) { fixture_file_upload('files/co2_per_capita.csv', 'text/csv') }
  let(:datasheet_params) { { name: 'String', file: data_file } }
  
  context 'without logging in' do
    it '#index redirects to sign in' do
      get 'index'
      expect(response).to redirect_to(new_admin_session_path)
    end
    
    it '#new redirects to sign in' do
      get 'new'
      expect(response).to redirect_to(new_admin_session_path)
    end
    
    it '#create redirects to sign in without creating datasheet' do
      post 'create', params: { datasheet: datasheet_params }
      expect(response).to redirect_to(new_admin_session_path)
    end
    
    it '#show redirects to sign in' do
      get 'show', params: { id: datasheet.id }
      expect(response).to redirect_to(new_admin_session_path)
    end
  end

  context 'logged in as admin' do
    it '#index renders successfully' do
      sign_in(admin)
      get 'index'
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
    
    it '#new renders successfully' do
      sign_in(admin)
      get 'new'
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
    
    it '#create creates new datasheet with csv data' do
      sign_in(admin)
      post 'create', params: { datasheet: datasheet_params }
      
      new_datasheet = Datasheet.last
      
      expect(response).to redirect_to(admin_datasheet_path(new_datasheet))
      expect(new_datasheet.rows.count).to eq(5)
    end
    
    it '#show renders successfully' do
      sign_in(admin)
      get 'show', params: { id: datasheet.id }
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
  end
end
