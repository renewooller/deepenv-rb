# frozen_string_literal: true
require 'json'
require_relative "deepenv/version"

module Deepenv
  class Error < StandardError; end
  
  
  class << self
  
    @@prefix = "DEEPENV_"
    @@nesting_delimiter = "__"

    def deep_set(hash, value, *keys)
      hash.default_proc = proc { |h,k| h[k] = Hash.new(&h.default_proc) }
      keys[0...-1].inject(hash) do |acc, key|
        acc.public_send(:[], key.to_sym)
      end.public_send(:[]=, keys.last, value)
    end

    def to_config (original={}, opts={})
      
      to_ret = ENV.filter {|k| k.start_with? @@prefix}
      .map {|k, v| [k, parse_env_value(v)]}
      .each_with_object(
        JSON.parse(original.to_json) 
      ) do |kv,hash| 
        deep_set(
          hash, 
          kv[1], 
          *kv[0].dup
            .downcase!
            .sub(/^#{Regexp.escape(@@prefix.downcase)}/, '') 
            .split(@@nesting_delimiter).map(&:to_sym)
        )
      end
      to_ret
    end

    def parse_env_value(val_in) 
      val = val_in.strip
      if /^ +$/ =~ val_in then  # if one ore more whitespaces only, assume it's on purpose
        val_in
      elsif val === '' then     # blank goes to nil
        nil
      elsif val === 'null' then # return null as string so as not to be parsed by json later
        val 
      elsif /^\d+\.\d+$/ =~ val
        val.to_f
      elsif /^\d+$/ =~ val
        val.to_i
      elsif /^true$/i =~ val
        true
      elsif /^false$/i =~ val
        false
      else 
        begin
          JSON.parse(val)
        rescue
          val
        end
      end
    end

  end
end
