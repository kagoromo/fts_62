require "rails_helper"

RSpec.describe Admins::UsersController, type: :controller do
  let(:admin) {create :admin}
  before {sign_in admin}

  describe "GET #index" do
    context "without search params" do
      it "populates an array of all users" do
        user = create :user
        other_user = create :user
        get :index
        expect(assigns :users).to match_array [user, other_user]
      end
    end

    context "with search params" do
      it "populates an array of all users, sorted by name in ascending order" do
        user = create(:user, name: "foo")
        other_user = create(:user, name: "bar")
        get :index, q: {s: "name_asc"}
        expect(assigns :users).to match_array [other_user, user]
      end
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new user in the database" do
        expect{post :create, user: attributes_for(:user)}.to change{User.count}.by 1
      end
    end

    context "with invalid attributes" do
      it "fails to save the new user" do
        expect{post :create, user: attributes_for(:user_without_name)}.
          not_to change{User.count}
      end
    end

    it "redirects to admins/users#index" do
      post :create, user: attributes_for(:user)
      expect(response).to redirect_to admins_users_path
    end
  end

  describe "PATCH #update" do
    let(:user) {create :user}
    let(:mock_user) {double "user"}

    it "locates the requested user" do
      patch :update, id: user, user: attributes_for(:user)
    end

    context "with valid attributes" do
      it "changes user's attributes" do
        patch :update, id: user, user: attributes_for(:user,
          name: "foo")
        user.reload
        expect(user.name).to eq "foo"
      end

      it "redirects to admins/users#index" do
        patch :update, id: user, user: attributes_for(:user)
        expect(response).to redirect_to admins_users_path
      end
    end

    context "with invalid attributes" do
      it "does not change user's attributes" do
        patch :update, id: user, user: attributes_for(:user_without_name)
        expect{user.reload}.not_to change{user.name}
      end

      it "renders the :edit template again" do
        allow(User).to receive(:find).and_return(mock_user)
        allow(mock_user).to receive(:update_attributes).and_return false
        patch :update, id: mock_user, user: attributes_for(:user)
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    let(:user) {create :user}
    let(:mock_user) {double "user"}

    it "deletes the user succesfully" do
      user
      expect{delete :destroy, id: user}.to change{User.count}.by -1
    end

    it "may fail to delete the user" do
      allow(User).to receive(:find).and_return(mock_user)
      allow(mock_user).to receive(:destroy).and_return(false)
      expect{delete :destroy, id: mock_user}.not_to change{User.count}
    end

    it "redirects to admins/users#index" do
      delete :destroy, id: user
      expect(response).to redirect_to admins_users_path
    end
  end
end
