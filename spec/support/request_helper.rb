module RequestHelper
  def json_body
    JSON.parse(response.body).with_indifferent_access
  end
end
