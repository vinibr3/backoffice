class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_errors
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_error
  rescue_from BackofficeError, with: :render_backoffice_error

  def render_record_invalid_errors(exception)
    render jsonapi_errors: jsonapi_record_errors(exception.record.errors),
           status: :unprocessable_entity
  end

  def render_record_not_found_error
    errors = [title: 'Not Found', status: '404']

    render jsonapi_errors: errors,
           status: :not_found
  end

  def render_backoffice_error(exception)
    error = {
              title: exception.title,
              detail: exception.message,
              status: '422',
              source: { pointer: exception.pointer,
                        parameter: exception.parameter },
              meta: { backtrace: exception.backtrace.first(10) }
            }

    render jsonapi_errors: [error],
           status: :unprocessable_entity
  end

  def jsonapi_record_errors(errors)
    errors.keys.flat_map do |key|
      errors.full_messages_for(key).map do |message|
        JSONAPI::Rails::SerializableActiveModelError.new(field: key,
                                                         message: message,
                                                         pointer: "data/attributes/#{key}")
                                                    .as_jsonapi

      end
    end
  end

  def authenticate_bearer_token!
    authenticate_or_request_with_http_token do |token, options|
      auth_digest =
        Rails.application.credentials[Rails.env.to_sym][:authorization_key_sha256_digest]
      token_digest = Digest::SHA2.new(256).hexdigest(token)

      ActiveSupport::SecurityUtils.secure_compare(auth_digest, token_digest)
    end
  end

  def authenticate_payment_gateway_key!
    authenticate_or_request_with_http_token do |token, options|
      key = Rails.application.credentials[Rails.env.to_sym][:gateway_authorization_key]

      ActiveSupport::SecurityUtils.secure_compare(key, token)
    end
  end

  def json_api_error(message_code, attribute, status = '422')
    {
      status: status,
      detail: I18n.t("errors.messages.#{message_code}") + ' ' + I18n.t("attributes.#{attribute}"),
      title: I18n.t("errors.messages.#{message_code}"),
      source: { pointer: "data/attributes/#{attribute}" }
    }
  end

  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || 25
  end

  def pagination_links(query)
    links = {}

    uri = URI(request.original_url)
    query_params = Rack::Utils.default_query_parser.parse_nested_query(uri.query)

    uri.query = query_params.merge(page: 1).to_query
    links.merge!(first_page: query.total_count ? uri.to_s : nil)

    uri.query = query_params.merge(page: query.current_page).to_query
    links.merge!(self_page: query.current_page ? uri.to_s : nil)

    uri.query = query_params.merge(page: query.next_page).to_query
    links.merge!(next_page: query.next_page ? uri.to_s : nil)

    uri.query = query_params.merge(page: query.total_pages).to_query
    links.merge!(last_page: query.total_pages ? uri.to_s : nil)

    uri.query = query_params.merge(page: query.prev_page).to_query
    links.merge!(prev_page: query.prev_page ? uri.to_s : nil)

    links
  end
end
