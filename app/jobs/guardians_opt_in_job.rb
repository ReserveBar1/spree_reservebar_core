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

      headers = {
        'content-type' => 'application/x-www-form-urlencoded',
        'accept' => 'application/json',
        'content-encoding' => 'utf-8'
      }

      set_body = { 
        'apiToken' => token,
        'Request' => [ {"Email" => "#{email}"} ].to_json
      }
      resp = self.class.post("#{base_uri}/People/PeopleSet", body: set_body, headers: headers)

      set_metadata_body = { 
        'apiToken' => token,
        'personId' => resp['Data']['People'][0]['PersonId'],
        'metadata' => [
          {'Key' => 'Source', 'Value' => 'RB'},
          {'Key' => 'SiteName', 'Value' => 'ReserveBar'},
          {'Key' => 'Origin', 'Value' => 'RB Guardian Optin'}
        ].to_json
      }
      self.class.post("#{base_uri}/People/SetPersonMetadata", body: set_metadata_body, headers: headers)
    end
  end

  def perform
    GuardianAPI.new.set_email(email)
  end

end
