module Zabbix

  class ZabbixApi

    def is_template_linked_with_host?(hostid, template)

	  template_id = get_template_id(template)
	  host_template_ids = []

	  #Get linked templates
      linked_templates = get_template_ids_by_host(hostid)
	  linked_templates.each { |result| host_template_ids << result['templateid'] }

      return (host_template_ids.include? template_id)
    end

	def remove_templates_from_host(host, templates)

	  template_ids = get_template_ids(templates)
	  templates_to_remove = []

	  #The host.update method requires a hash parameter for new templates
	  template_ids.each do |template_id|
	  	 templates_to_remove << {'templateid' => template_id}
	  end

      template_ids.each do |template_id|
	    result = update_host({'hostid' => host['hostid'], 'templates_clear' => templates_to_remove})
      end
	end

    def add_templates_to_host(host, templates)

	  host_template_ids = []
	  templates_to_add = []
	  new_template_ids = get_template_ids(templates)

	  #Get linked templates
      linked_templates = get_template_ids_by_host(host['hostid'])
	  linked_templates.each { |result| host_template_ids << result['templateid'] }

	  #We want to add both the old templates and the new ones to the host
	  template_ids_union = new_template_ids | host_template_ids

	  #The host.update method requires a hash parameter for new templates
	  template_ids_union.each do |template_id|
	  	 templates_to_add << {'templateid' => template_id}
	  end
	  result = update_host({'hostid' => host['hostid'], 'templates' => templates_to_add})
	  return result
	end

	def add_template(template_options)

      template_default = {
        'host' => nil,
        'groups' => [],
      }

      template_options['groups'].map! { |group_id| {'groupid' => group_id} }

      template = merge_opt(template_default, template_options)

      message = {
        'method' => 'template.create',
        'params' => template
      }

      response = send_request(message)

      if not ( response.empty? ) then
        result = response['templateids'][0].to_i
      else
        result = nil
      end

      return result
    end

    def get_template_ids_by_host(host_id)

      message = {
        'method' => 'template.get',
        'params' => {
          'hostids' => [ host_id ]
        }
      }

      response = send_request(message)

      unless ( response.empty? ) then
        result = []
		response.each do |template_id|
		  result << template_id
		end
      else
        result = nil
      end

      return result
    end

    def get_templates()

      message = {
        'method' => 'template.get',
        'params' => {
          'extendoutput' => '0'
        }
      }

      response = send_request(message)

      unless response.empty? then
        template_ids = response.keys()
        result = {}

        template_ids.each() do |template_id|
          template_name = response[template_id]['host']
          result[template_id] = template_name
        end
      else
        result = nil
      end

      return result
    end

    def get_template_id(template_name)

      message = {
        'method' => 'template.get',
        'params' => {
          'filter' => {
            'host' => template_name
          }
        }
      }

      response = send_request(message)

      unless response.empty? then
        result = response[0]["templateid"]
      else
        result = nil
      end

      return result

    end

	def link_templates_with_hosts(templates_id, hosts_id)

      if templates_id.class == Array then
        message_templates_id = []
        templates_id.each do |template_id|
          message_templates_id << {'templateid' => template_id}
        end
      else
        message_templates_id = {'templateid' => templates_id}
      end

      if hosts_id == Array then
        message_hosts_id = hosts_id
      else
        message_hosts_id = [ hosts_id ]
      end

      message = {
        'method' => 'template.massAdd',
        'params' => {
          'hosts' => message_hosts_id,
          'templates' => message_templates_id
        }
      }

      response = send_request(message)

      return response
    end


    def get_template_ids(templates)
      template_ids = []
      templates.each do |template|
		template_ids << get_template_id(template)
      end
      return template_ids
    end

    def unlink_templates_from_hosts(templates_id, hosts_id)

      if templates_id.class == Array then
        message_templates_id = []
        templates_id.each do |template_id|
          message_templates_id << {'templateid' => template_id}
        end
      else
        message_templates_id = {'templateid' => templates_id}
      end

      if hosts_id == Array then
        message_hosts_id = hosts_id
      else
        message_hosts_id = [ hosts_id ]
      end

      message = {
        'method' => 'template.massRemove',
        'params' => {
          'hosts' => message_hosts_id,
          'templates' => message_templates_id,
          'force' => '1'
        }
      }

      response = send_request(message)

      return response
    end
  end
end
