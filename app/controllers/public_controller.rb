class PublicController < ApplicationController
skip_before_action :authenticate_user!


def index 
    render layout: "public"
  end    

end