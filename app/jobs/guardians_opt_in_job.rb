class GuardiansOptInJob < Struct.new(:email)
  require 'httparty'

  class GuardianAPI
    include HTTParty
    base_uri 'https://reachv4-pnr.uat.kbmg.com'

    def set_email(email)
      body = { 
        'apiToken' => '1eb8554d-141f-4d3a-8517-8eb831540347',
        'Request' => [ {"Email"=>"#{email}"} ].to_json
      }

      headers = {
        'content-type' => 'application/x-www-form-urlencoded',
        'accept' => 'application/json',
        'content-encoding' => 'utf-8'
      }

      self.class.post('/People/PeopleSet', body: body, headers: headers)
    end
  end

  def perform
    GuardianAPI.new.set_email(email)
  end

end
