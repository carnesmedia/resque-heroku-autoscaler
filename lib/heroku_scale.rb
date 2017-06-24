class HerokuScale
  include HTTParty
  def self.auth
    ENV['HEROKU_API_KEY']
  end

  base_uri 'https://api.heroku.com'
  headers "Accept" => "application/vnd.heroku+json; version=3", "Authorization" => "Bearer #{auth}"

  def self.application_name
    ENV['HEROKU_APP']
  end

  def initialize(process)
    @process = process
  end

  def scale_to(quantity)
    params = { quantity: quantity }
    path = "/apps/#{application}/formation/#{process}"

    self.class.patch path, body: params
  end

  def dyno_count
    path = "/apps/#{application}/formation/#{process}"

    self.class.get(path).fetch('quantity')
  end

  private

  attr_reader :process

  def application
    self.class.application_name
  end

end
