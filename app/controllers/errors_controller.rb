class ErrorsController < ApplicationController
  layout false

  def error_404
    exception   = env["action_dispatch.exception"]
    status_code = ActionDispatch::ExceptionWrapper.new(env, exception).status_code

    @method, @message = if status_code == 404
      ["not_found", env["REQUEST_URI"]]
    else
      ["server_error", "#{exception.message}\n#{exception.backtrace.join('\n')}"]
    end
    render status: status_code
  end

  def error_500
    exception   = env["action_dispatch.exception"]
    status_code = ActionDispatch::ExceptionWrapper.new(env, exception).status_code

    @method, @message = if status_code == 500
      ["not_found", env["REQUEST_URI"]]
    else
      ["server_error", "#{exception.message}\n#{exception.backtrace.join('\n')}"]
    end

    render status: status_code
  end
end