require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      # p req.query_string
      @params = route_params
      parse_www_encoded_form(req.query_string)
      parse_www_encoded_form(req.body)
    end

    def [](key)
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      return nil if www_encoded_form.nil?
      form = URI.decode_www_form(www_encoded_form)
      p form

      form.each do |arr|
        parsed_key = parse_key(arr.first)
        level = @params
        parsed_key[0..-2].each do |key|
          level[key] ||= {}
          level = level[key]
        end
        level[parsed_key.last] = arr.last
      end
    end

    # set params[key] equal to empty hash
    #
    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
