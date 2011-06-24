# -*- encoding: utf-8 -*-

#
# Author:: Edmund Haselwanter (<office@iteh.at>)
# Copyright:: Copyright (c) 2011 Edmund Haselwanter
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require File.join(File.dirname(__FILE__), "/spec_helper")
require 'ap'

describe Zabbix::ZabbixApi do

  before(:each) do
    @api_url = "http://192.168.1.29/zabbix/api_jsonrpc.php"
    @api_login = "api_user"
    @api_password = "api_user"
  end

  context 'Initialization' do

    FakeWeb.register_uri(:post, "http://192.168.1.29/login_success_user.authenticate.txt", :response => fixture_file("login_success_user.authenticate.txt"))
    FakeWeb.register_uri(:post, "http://192.168.1.29/failed_auth_wrong_password_user.authenticate.txt", :response => fixture_file("failed_auth_wrong_password_user.authenticate.txt"))

    it 'should login with correct data' do
      RecordHttp.file_prefix = 'login_success'
      RecordHttp.perform_save = false
      FakeWeb.allow_net_connect = false

      @api_url = "http://192.168.1.29/login_success_user.authenticate.txt"
      zbx = Zabbix::ZabbixApi.new(@api_url, @api_login, @api_password)
      zbx.auth.should_not be_nil
    end

    it 'should no login with wrong data' do
      RecordHttp.file_prefix = 'failed_auth_wrong_password'
      RecordHttp.perform_save = false
      FakeWeb.allow_net_connect = false

      @api_url = "http://192.168.1.29/failed_auth_wrong_password_user.authenticate.txt"
      @api_login = "wrong_user"
      zbx = Zabbix::ZabbixApi.new(@api_url, @api_login, @api_password)
      lambda { zbx.auth}.should raise_error(Zabbix::AuthError)
    end

  end

  context 'get host' do

    FakeWeb.register_uri(:post, "http://192.168.1.29/get_existing_host_host.get.txt",
                         [:response => fixture_file("login_success_user.authenticate.txt"),
                          :response => fixture_file("get_existing_host_host.get.txt")])
    FakeWeb.register_uri(:post, "http://192.168.1.29/get_nil_for_unknown_host_host.get.txt",
                         [:response => fixture_file("login_success_user.authenticate.txt"),
                          :response => fixture_file("get_nil_for_unknown_host_host.get.txt")])

    it "should get the host" do
      api_url = "http://192.168.1.29/get_existing_host_host.get.txt"
      zbx = Zabbix::ZabbixApi.new(api_url, @api_login, @api_password)

      RecordHttp.file_prefix = 'get_existing_host'
      RecordHttp.perform_save = false

      FakeWeb.allow_net_connect = false

      host = zbx.get_host({"filter" => {"dns" => "vagrantup.com"}})
      host.should_not be_nil
    end

    it "should not get a unknown host" do

      api_url = "http://192.168.1.29/get_nil_for_unknown_host_host.get.txt"
      zbx = Zabbix::ZabbixApi.new(api_url, @api_login, @api_password)

      RecordHttp.file_prefix = 'get_nil_for_unknown_host'
      RecordHttp.perform_save = false

      FakeWeb.allow_net_connect = false

      host = zbx.get_host({"filter" => {"dns" => "no-host.com"}})
      host.should be_nil
    end

  end

end