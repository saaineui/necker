require 'rails_helper'

RSpec.describe 'FeaturedWithData', type: :request do
  fixtures :admins, :datasheets, :rows, :columns
  let(:admin) { admins(:eve) }
  let(:state_data) { fixture_file_upload("#{fixture_path}/files/state_data.csv", 'text/csv') }
  let(:state_datasheet) { { name: 'Per Capita Carbon Emissions and Racial Diversity by State', file: state_data } }
  let(:books_data) { fixture_file_upload("#{fixture_path}/files/books_data.csv", 'text/csv') }
  let(:books_datasheet) { { name: 'Book Ratings: Me vs. Goodreads Average', file: books_data } }
  
  describe 'GET /states_xy and /voter_participation' do
    it 'render with data' do
      sign_in(admin)
      post admin_datasheets_path, params: { datasheet: state_datasheet }
    
      get states_xy_path
      expect(response).to have_http_status(200)
      expect(response).to render_template('scatter')
      assert_select 'circle', 10
      
      get voter_participation_path
      expect(response).to have_http_status(200)
      expect(response).to render_template('voter_participation')
      assert_select '.ac-bar-chart-bar', 4
    end
  end

  describe 'GET /books_xy' do
    it 'render with data' do
      sign_in(admin)
      post admin_datasheets_path, params: { datasheet: books_datasheet }
    
      get books_xy_path
      expect(response).to have_http_status(200)
      expect(response).to render_template('scatter')
      assert_select 'circle', 14
    end
  end
end
