AUTH_URL = 'https://login.microsoftonline.com/botframework.com/oauth2/v2.0/token'
API_URL = 'https://smba.trafficmanager.net/apis/v3/conversations/'
SCOPE = 'https://api.botframework.com/.default'

require 'puppet'
require 'yaml'
require 'rest-client'
require 'json'

if RbConfig::CONFIG['host_os'] =~ /freebsd|dragonfly/i
  SETTINGS_FILE ||= '/usr/local/etc/puppet/skyper.yaml'
else
  SETTINGS_FILE ||= File.exist?('/etc/puppetlabs/puppet/skyper.yaml') ? '/etc/puppetlabs/puppet/skyper.yaml' : '/etc/puppet/skyper.yaml'
end
SETTINGS = YAML.load_file(SETTINGS_FILE)

Puppet::Reports.register_report(:skyper) do

  desc <<-DESC
  Send Puppet reports to Skype.
  DESC

  def fetch_token
    params = {
      grant_type: 'client_credentials',
      client_id: SETTINGS[:client_id],
      client_secret: SETTINGS[:client_secret],
      scope: SCOPE
    }
    res = RestClient.post AUTH_URL, params
    return JSON.parse(res)['access_token']
  rescue StandardError => e
    puts "Failed with error: #{e}"
  end

  def send_message(message, token)
    message_json = { type: 'message', text: message }.to_json
    url = "#{API_URL}#{SETTINGS[:chat_id]}/activities"
    RestClient.post url, message_json, Authorization: "Bearer #{token}"
  rescue StandardError => e
    raise Puppet::Error, "Could not send message to Skype.\nSkyper URL: #{url} #{e}\n#{message}\n#{e.backtrace}"
  end

  def process
    #cache = File.join(File.dirname(SETTINGS_FILE), 'skyper.cache')
    if self.status == "failed" or self.status == "changed"
      Puppet.debug "Sending status for #{self.host} to Skype."
      message = "(star) Puppet run for *#{self.host}* in *#{self.environment}* has been finished with *#{self.status}* status (star)<br/>"
      if SETTINGS[:puppetboard_link]
        message << "(tiefighter) *Puppetboard:* #{SETTINGS[:puppetboard_link]}/report/#{self.host}/#{self.configuration_version}<br/>"
      end
      send_message(message, fetch_token)
    end
  rescue StandardError => e
    raise Puppet::Error, "Could not send report to Skype: #{e}\n#{e.backtrace}"
  end
end
