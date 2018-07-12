class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    def hello
        render html: "やあ、待ったかい？"
    end

    def goodbye
        render html: "Good night, 今日はもう眠ろう"
    end
end
