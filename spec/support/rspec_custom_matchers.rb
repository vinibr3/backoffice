RSpec::Matchers.define :be_jsonapi_array_of_type do |model|
  match do |actual|
    data = JSON.parse(actual.body)['data']

    data.is_a?(Array) &&
    data.any? &&
    data.all? { |d| d['type'] == model }
  end
end

RSpec::Matchers.define :be_jsonapi_data_of_type do |model|
  match do |actual|
    data = JSON.parse(actual.body)['data']

    data.any? &&
    data.dig('type') == model
  end
end

RSpec::Matchers.define :be_error_with_title do |model|
  match do |actual|
    errors = JSON.parse(actual.body)['errors']

    errors.select{ |e| e['title'] == model }.present?
  end
end
