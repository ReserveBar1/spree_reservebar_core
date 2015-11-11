class GuardiansOptInJob < Struct.new(:email)
  require 'httparty'

  class GuardianAPI
    include HTTParty
    # debug_output $stdout

    def set_email(email)
      unless Rails.env == 'production'
        base_uri = 'https://reachv4-pnr.uat.kbmg.com'
        token = '1eb8554d-141f-4d3a-8517-8eb831540347'
      else
        base_uri = 'https://reachv4-pnr.kbmg.com'
        token = 'df8ec201-f816-4135-a7e8-5d4e5f71b0c0'
      end

      body = { 
        'apiToken' => token,
        'Source' => 'RB',
        'SiteName' => 'ReserveBar',
        'Origin' => 'RB Guardian Optin',
        'Request' => [ {"Email" => "#{email}"} ].to_json
      }

      headers = {
        'content-type' => 'application/x-www-form-urlencoded',
        'accept' => 'application/json',
        'content-encoding' => 'utf-8'
      }

      self.class.post("#{base_uri}/People/PeopleSet", body: body, headers: headers)
    end
  end

  def perform
    GuardianAPI.new.set_email(email)
  end

end
