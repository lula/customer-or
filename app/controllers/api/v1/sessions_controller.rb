class Api::V1::SessionsController < DeviseController #ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  
  def create
    user = User.find_by(email: params[:email])

    if user.valid_password?(params[:password])
      sign_in(resource_name, user)
      render :json=> {:success=>true, :email=>user.email}
      return
    end
    
    render :json=> {:success=>false, :email=>user.email}
  end

  def destroy
    sign_out(resource_name)
  end
end