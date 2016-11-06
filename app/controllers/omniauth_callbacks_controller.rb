class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"])

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          update_status
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          redirect_to root_url
        end
      end
    }
  end

  [:vkontakte, :facebook].each do |provider|
    provides_callback_for provider
  end

  private

    def update_status
      ActionCable.server.broadcast "chat_list",
        update_list: true,
        user: current_user.id,
        status: current_user.status
    end

end