require 'spec_helper'

describe MicropostsController do
  describe "POST create" do
    context "with authenticated users" do
      context "with valid attributes" do
        it "redirects to the root path" do
          current_user = Fabricate(:user)
          cookies[:remember_token] = current_user.remember_token
          post :create, micropost: Fabricate.attributes_for(:micropost)
          expect(response).to redirect_to root_url
        end

        it "creates a new micropost in the database" do
          current_user = Fabricate(:user)
          cookies[:remember_token] = current_user.remember_token
          post :create, micropost: Fabricate.attributes_for(:micropost)
          expect(Micropost.count).to eq(1)
        end

        it "creates a new micropost associated with the signed in user" do
          current_user = Fabricate(:user)
          cookies[:remember_token] = current_user.remember_token
          post :create, micropost: Fabricate.attributes_for(:micropost)
          expect(Micropost.first.user).to eq(current_user)
        end

        it "shows the success message" do
          current_user = Fabricate(:user)
          cookies[:remember_token] = current_user.remember_token
          post :create, micropost: Fabricate.attributes_for(:micropost)
          expect(flash[:success]).not_to be_blank
        end
      end

      context "with invalid attributes" do
        it "does not save a new micropost in the database" do
          current_user = Fabricate(:user)
          cookies[:remember_token] = current_user.remember_token
          post :create, micropost: Fabricate.attributes_for(:micropost, content: nil)
          expect(Micropost.count).to eq(0)
        end

        it "assigns an empty array to @feed_items" do
          current_user = Fabricate(:user)
          cookies[:remember_token] = current_user.remember_token
          post :create, micropost: Fabricate.attributes_for(:micropost, content: nil)
          expect(assigns(:feed_items)).to eq([])
        end

        it "re-renders the static_pages/home template" do
          current_user = Fabricate(:user)
          cookies[:remember_token] = current_user.remember_token
          post :create, micropost: Fabricate.attributes_for(:micropost, content: nil)
          expect(response).to render_template 'static_pages/home'
        end
      end
    end

    context "with unauthenticated users" do
      it "redirects to the user sign in page for unauthenticated users" do
        post :create
        expect(response).to redirect_to signin_path
      end
    end
  end

  describe "DELETE destroy" do
    context "with authenticated users" do
      it "redirects to the root path" do
        current_user = Fabricate(:user)
        cookies[:remember_token] = current_user.remember_token
        micropost = Fabricate(:micropost, user_id: current_user.id)
        delete :destroy, id: micropost.id
        expect(response).to redirect_to root_url
      end

      it "deletes the micropost from the database" do
        current_user = Fabricate(:user)
        cookies[:remember_token] = current_user.remember_token
        micropost = Fabricate(:micropost, user_id: current_user.id)
        delete :destroy, id: micropost.id
        expect(Micropost.count).to eq(0)
      end

      it "redirects to the root path if the micropost associated with another user" do
        current_user = Fabricate(:user)
        cookies[:remember_token] = current_user.remember_token
        another_user = Fabricate(:user)
        micropost = Fabricate(:micropost, user_id: another_user.id)
        delete :destroy, id: micropost.id
        expect(response).to redirect_to root_url
      end

      it "does not delete the micropost if it associated with another user" do
        current_user = Fabricate(:user)
        cookies[:remember_token] = current_user.remember_token
        another_user = Fabricate(:user)
        micropost = Fabricate(:micropost, user_id: another_user.id)
        delete :destroy, id: micropost.id
        expect(Micropost.count).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it "redirects to the user sign in page for unauthenticated users" do
        user = Fabricate(:user)
        micropost = Fabricate(:micropost, user_id: user.id)
        delete :destroy, id: micropost.id
        expect(response).to redirect_to signin_path
      end
    end
  end
end
