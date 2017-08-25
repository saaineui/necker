require 'rails_helper'

RSpec.describe Admin::DatasheetsController, type: :controller do
  fixtures :admins, :datasheets, :rows, :columns
  let(:admin) { admins(:eve) }
  let(:datasheet) { datasheets(:donors) }
  let(:good_csv) { fixture_file_upload('files/co2_per_capita.csv', 'text/csv') }
  let(:bad_csv) { fixture_file_upload('files/co2_per_capita_numbers.csv', 'text/csv') }
  let(:good_datasheet) { { name: 'Good Sheet', file: good_csv } }
  let(:bad_csv_datasheet) { { name: 'Bad Sheet', file: bad_csv } }
  let(:bad_name_datasheet) { { name: '', file: good_csv } }
  
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
      post 'create', params: { datasheet: good_datasheet }
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
    
    it '#show renders successfully' do
      sign_in(admin)
      get 'show', params: { id: datasheet.id }
      expect(response).to be_success
      expect(response).to render_template(:show)
    end
    
    context 'with properly formatted csv' do
      context 'with name' do
        it '#create creates new datasheet with csv data' do
          sign_in(admin)
          post 'create', params: { datasheet: good_datasheet }

          new_datasheet = Datasheet.last

          expect(response).to redirect_to(admin_datasheet_path(new_datasheet))
          expect(new_datasheet.name).to eq(good_datasheet[:name])
          expect(new_datasheet.rows.count).to eq(5)
        end
      end

      context 'without name' do
        it '#create rerenders new without creating datasheet' do
          datasheet_count = Datasheet.count
          
          sign_in(admin)
          post 'create', params: { datasheet: bad_name_datasheet }

          expect(response).to be_success
          expect(response).to render_template(:new)
          expect(datasheet_count).to eq(Datasheet.count)
        end
      end
    end
    
    context 'with numbers file with extension changed to csv manually' do
      it '#create creates new empty datasheet' do
        sign_in(admin)
        post 'create', params: { datasheet: bad_csv_datasheet }

        new_datasheet = Datasheet.last

        expect(response).to redirect_to(admin_datasheet_path(new_datasheet))
        expect(new_datasheet.name).to eq(bad_csv_datasheet[:name])
        expect(new_datasheet.populated?).to be(false)
      end
    end
  end
end
