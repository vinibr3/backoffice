module JsonApiHelper
  def self.relationship_ids(relationship_name, response)
    data = JSON.parse(response.body)['data']

    data.map { |t| t['relationships'][relationship_name]['data']['id'] }
  end

  def self.relationship_attributes(relationship_name, attribute, response)
    ids = JsonApiHelper.relationship_ids(relationship_name, response)
    includeds = JSON.parse(response.body)['included']
    includeds.select! { |i| i['type'] == relationship_name.pluralize && i['id'].in?(ids) }

    includeds.map { |i| i['attributes'][attribute] }
  end

  def self.map_attribute(attribute, response)
    data = JSON.parse(response.body)['data']

    data.map { |d| d['attributes'][attribute] }
  end

  def self.map_id_and_type(response)
    data = JSON.parse(response.body)['data']

    data.map { |d| [d['id'], d['type']] }
  end
end
