require 'rails_helper'

RSpec.describe 'SignInSignOuts', type: :request do
  fixtures :admins
  let(:admin) { admins(:eve) }
  
  describe 'GET /admins/sign_in' do
    it 'renders with new template' do
      get '/admins/sign_in'
      expect(response).to be_success
      expect(response).to render_template('new')
      assert_select "a[href='/admins/sign_in']", 0
      assert_select "a[href='/admins/sign_out']", 0
    end
  end
  
  describe 'POST /admins/sign_in' do
    context 'with valid credentials' do
      it 'logs in with success message' do
        sign_in_count = admin.sign_in_count
        
        post '/admins/sign_in', params: { admin: { email: admin.email, password: 'password89' } }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        assert_select '.flash .notice', 1
        assert_select "a[href='/admins/sign_out']", 1
        
        admin.reload
        expect(admin.sign_in_count).to eq(sign_in_count + 1)
      end
    end
    
    context 'with invalid credentials' do
      it 'rerenders signin with error message' do
        sign_in_count = admin.sign_in_count
        
        post '/admins/sign_in', params: { admin: { email: admin.email, password: 'password!!' } }
        expect(response).to be_success
        expect(response).to render_template('new')
        assert_select '.flash .alert', 1
        assert_select "a[href='/admins/sign_in']", 0
        assert_select "a[href='/admins/sign_out']", 0
        
        admin.reload
        expect(admin.sign_in_count).to eq(sign_in_count)
      end
    end
  end

  describe 'DELETE /admins/sign_out' do
    it 'logs out with success message' do
      sign_in(admin)
      
      delete '/admins/sign_out'
      expect(response).to redirect_to(root_path)
      follow_redirect!
      assert_select '.flash .notice', 1
      assert_select "a[href='/admins/sign_in']", 1
    end
  end
end
