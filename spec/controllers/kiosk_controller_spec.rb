require 'rails_helper'

RSpec.describe KioskController, type: :controller do
  describe 'GET #inbox' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
