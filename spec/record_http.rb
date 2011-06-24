# from http://kalv.co.uk/2009/10/13/saving-http-requests-for-testing/
# Record HTTP is to help recording the http calls for further testing
#
# usage:
#   require 'record_http'
# set up the directory it needs to save the responses
#   RecordHttp.save_path = '../spec/data'
#   RecordHttp.include_headers = true
#   RecordHttp.file_prefix = 'http_'
#
# Run your net http requests, tests, gems that use net/http and watch everything save away!
#   Net::HTTP.get(URI.parse("http://localhost"))
require 'net/http'

module RecordHttp

  @@save_path = nil
  @@include_headers = false
  @@file_prefix = "http_"
  @@perform_save = true

  def self.save_path
    @@save_path
  end

  def self.perform_save=(value)
    @@perform_save = value
  end

  def self.perform_save
    @@perform_save
  end

  def self.save_path=(save_path)
    @@save_path = save_path
  end

  def self.include_headers=(include_headers)
    @@include_headers = include_headers
  end

  def self.file_prefix=(file_prefix)
    @@file_prefix = file_prefix
  end

  def self.save_res(address,req,res)
    pathname = req.path.gsub("/","_")
    method = JSON.parse(req.body)["method"]
    #filename = @@save_path+"/"+@@file_prefix + address + (pathname ? pathname: "") + "_" + method
    filename = @@save_path+"/"+@@file_prefix + "_" + method + ".txt"
    File.open(filename,"w") do |file|
      if @@include_headers
        file.write("HTTP/#{res.http_version} #{res.code} #{res.message}\n")
        res.to_hash.each do |key,value|
          file.write("#{key.capitalize}: #{value}\n")
        end
        file.write("\n")
      end
      file.write(res.body)
    end
    puts "Saved file #{filename} with response from http://#{address}#{req.path}"
  end

end

# set save path
RecordHttp.save_path = '../spec/data'
RecordHttp.include_headers = false
RecordHttp.file_prefix = 'http_'

# override Net::Http at request level to get post / get / put / etc
module Net
  class HTTP
    alias :old_request :request

    def request(req, body = nil, &block)
      res = old_request(req, body, &block)
      begin
        RecordHttp.save_res(@address,req,res) if RecordHttp.perform_save == true
      rescue
        puts "Error saving response #{$!}"
      end
      res
    end

  end
end

# Just run Net::Http
#puts Net::HTTP.get(URI.parse("http://localhost"))