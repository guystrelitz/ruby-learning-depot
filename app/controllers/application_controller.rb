class ApplicationController < ActionController::Base
	before_action :authorise
	before_action :set_i18n_locale_from_params

	protected

	def authorise
		unless User.find_by(id: session[:user_id])
			redirect_to login_url, notice: 'Please log in'
		end
	end

	def set_i18n_locale_from_params
		locale = params[:locale] || I18n.default_locale
		if locale
			# if I18n.available_locales.map(&:to_s).include? locale
			if I18n.available_locales.include? locale.to_sym
				I18n.locale = locale
			else
				flash.now[:notice] ="#{locale} translation not available"
				logger.error flash.now[:notice]
			end
		end
	end

end
