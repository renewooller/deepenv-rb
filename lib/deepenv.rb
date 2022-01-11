# frozen_string_literal: true
require 'deep_enumerable'
require_relative "deepenv/version"

module Deepenv
  class Error < StandardError; end
  
  
  class << self
  
    def to_config (original={}, opts={})
      @@prefix = opts.fetch(:prefix, "DEEPENV_")
      @@nesting_delimiter = opts.fetch(:nesting_delimiter, '__').downcase

      ENV.filter {|k| k.start_with? @@prefix}
      .map {|k, v| [k, parse_env_value(v)]}
      .each_with_object(
        original.deep_dup()
      ) do |kv,hash| 
        hash.deep_set(
            kv[0].dup
              .downcase!
              .sub(/^#{Regexp.escape(@@prefix.downcase)}/, '') 
              .split(@@nesting_delimiter).map(&:to_sym),
            kv[1]
          ) 
      end
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
