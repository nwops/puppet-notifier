require 'slack-notifier'
require 'puppet'
require 'yaml'

if RbConfig::CONFIG['host_os'] =~ /freebsd|dragonfly/i
  SL_SETTINGS_FILE ||= '/usr/local/etc/puppet/slacker.yaml'
else
  SL_SETTINGS_FILE ||= File.exist?('/etc/puppetlabs/puppet/slacker.yaml') ? '/etc/puppetlabs/puppet/slacker.yaml' : '/etc/puppet/slacker.yaml'
end
SL_SETTINGS = YAML.load_file(SL_SETTINGS_FILE)
ICON_URL = SL_SETTINGS[:icon_url] || 'https://dantehranian.files.wordpress.com/2014/11/pl_logo_vertical_rgb_lg.png'

Puppet::Reports.register_report(:slacker) do
  desc <<-DESC
  Send Puppet reports to Slack.
  DESC

  def process
    if self.status == 'failed' or self.status == 'changed'
      Puppet.debug "Sending status for #{self.host} to Slack."
      notifier = Slack::Notifier.new SL_SETTINGS[:hook_link] do
        defaults channel: SL_SETTINGS[:channel],
                 username: SL_SETTINGS[:name]
      end
      message = ":hammer_and_wrench: Puppet run for *#{self.host}* has been finished with *#{self.status}* status :hammer_and_wrench:\n"
      message = Slack::Notifier::LinkFormatter.format(message)
      color = self.status == 'changed' ? 'good' : 'danger'
      message_constructor = {
        text: message,
        color: color,
        fields: [
          {
            title: 'Environment',
            value: self.environment,
            short: true
          },
          {
            title: 'Time',
            value: Time.now.asctime,
            short: true
          }
        ]
      }
      if SL_SETTINGS[:puppetboard_link]
        link = {
          actions: [{
            name: 'puppetboard_link',
            text: 'Puppetboard',
            type: 'button',
            url: "#{SL_SETTINGS[:puppetboard_link]}/report/#{self.host}/#{self.configuration_version}",
            style: 'primary'
          }]
        }
        message_constructor = message_constructor.merge(link)
      end
      notifier.ping attachments: [message_constructor], icon_url: ICON_URL
    end
  rescue StandardError => e
    raise Puppet::Error, "Could not send report to Slack: #{e}\n#{e.backtrace}"
  end

end
