#from http://willschenk.com/setting-up-testing/

module ControllerHelpers

  def login_with(user = double('user'), scope = :user)
    current_user = "current_#{scope}".to_sym
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => scope})
      allow(controller).to receive(current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(current_user).and_return(user)
    end
  end

  #
  #
  # def sign_in(user = double('user'))
  #   logger.warn("###################################################### ENTERING HELPER SIGNIN")
  #   if user.nil?
  #     allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
  #     allow(controller).to receive(:current_user).and_return(nil)
  #   else
  #     allow(request.env['warden']).to receive(:authenticate!).and_return(user)
  #     allow(controller).to receive(:current_user).and_return(user)
  #   end
  # end
  # def sign_out
  #   sign_in nil
  # end
end