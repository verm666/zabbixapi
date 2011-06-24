module Zabbix

  class ZabbixApi
    def add_host(host_options)

      host_default = {
        'host' => nil,
        'port' => 10050,
        'status' => 0,
        'useip' => 0,
        'dns' => '',
        'ip' => '0.0.0.0',
        'proxy_hostid' => 0,
        'groups' => [],
        'useipmi' => 0,
        'ipmi_ip' => '',
        'ipmi_port' => 623,
        'ipmi_authtype' => 0,
        'ipmi_privilege' => 0,
        'ipmi_username' => '',
        'ipmi_password' => ''
      }

      host_options['groups'].map! { |group_id| {'groupid' => group_id} }

      host = merge_opt(host_default, host_options)

      message = {
        'method' => 'host.create',
        'params' => host
      }

      response = send_request(message)

      unless response.empty? then
        result = response['hostids'][0].to_i
      else
        result = nil
      end

      result
    end

    def get_host_id(hostname)
  
      message = {
        'method' => 'host.get',
        'params' => {
          'filter' => {
            'host' => hostname
          }
        }
      }

      response = send_request(message)

      unless response.empty? then
        result = response[0]['hostid'].to_i
      else
        result = nil
      end

      result
    end

    def get_host(params)

      message = {
        'method' => 'host.get',
        'params' => params
      }

      response = send_request(message)

      unless response.empty? then
        result = response[0]
      else
        result = nil
      end

      result
    end

  end
end
