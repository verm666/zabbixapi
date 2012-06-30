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

      return result
    end

    def update_host(params)

      message = {
        'method' => 'host.update',
        'params' => params
      }

      response = send_request(message)

      unless response.empty? then
        result = response
      else
        result = nil
      end

      return result
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

      return result
    end

    def get_host(hostname)
  
      message = {
        'method' => 'host.get',
        'params' => {
          'templated_hosts' => 1,
          'select_groups' => 1,
          'output' => 'extend',
          'selectParentTemplates' => 'extend',
          'filter' => {
            'host' => hostname
          }
        }
      }

      response = send_request(message)

      unless response.empty? then
        result = response[0]
      else
        result = nil
      end

      return result
    end
  end
end
