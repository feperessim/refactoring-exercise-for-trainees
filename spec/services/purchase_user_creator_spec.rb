require 'rails_helper'

RSpec.describe 'PurchaseUserCreator', type: :model do
  describe '#call' do
    context 'when cart has a user' do
      let!(:cart_user) { create(:cart).user }

      it 'does not create a user' do
        expect do
          PurchaseUserCreator.call({ cart_user: cart_user })
        end.not_to change { User.count }
      end

      it 'returns cart user' do
        expect(PurchaseUserCreator.call({ cart_user: cart_user })).to eq(cart_user)
      end
    end

    context 'when cart does not have a user' do
      let(:user_params) { { first_name: 'Gilbert', last_name: 'Strang', email: 'gilbert@email.com' } }

      it 'creates a guest user' do
        expect do
          PurchaseUserCreator.call({ user_params: user_params })
        end.to change { User.count }
        expect(User.first).to be_guest
      end

      it 'returns a new user object with proper params' do
        expect(PurchaseUserCreator.call({ user_params: user_params })).to have_attributes(user_params.merge(guest: true))
      end
    end
  end
end
