# Настройка Turbo для работы с формами
Rails.application.config.to_prepare do
  # Отключаем редиректы для Turbo Stream запросов
  ActionController::Redirecting.prepend(
    Module.new do
      def redirect_to(options = {}, response_options = {})
        if request.format == :turbo_stream
          # Для Turbo Stream запросов не делаем редирект
          self.status = 200
          self.content_type = Mime[:turbo_stream]
          self.response_body = nil
        else
          super
        end
      end
    end
  )
end