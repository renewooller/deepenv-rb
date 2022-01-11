# frozen_string_literal: true
require 'json'

RSpec.describe Deepenv do

  before(:each) do 
    ENV.reject! { |k| k.start_with? "DEEPENV_" } # delete all the configuration for each test
  end

  it "has a version number" do
    expect(Deepenv::VERSION).to_not be nil
  end

  it "parses nulls" do
    ENV['DEEPENV_BLANK'] = ''
    ENV['DEEPENV_SPACES'] = '   '
    ENV['DEEPENV_NULLTEXT']  = 'null'
    ENV['DEEPENV_NILTEXT'] = 'nil'
    ENV['DEEPENV_UNDEFINEDTEXT'] = 'undefined'

    config = Deepenv.to_config()
    expect(config[:blank]).to eq(nil)
    expect(config[:spaces]).to eq('   ')
    expect(config[:nulltext]).to eq('null')
    expect(config[:niltext]).to eq('nil')
    expect(config[:undefinedtext]).to eq('undefined')
  end

  it "parses numerics" do 
    ENV['DEEPENV_INT'] = "15"
    ENV['DEEPENV_FLOAT'] = "15.0"
    ENV['DEEPENV_FLOAT2'] = "0.001"
    ENV['DEEPENV_MALFORMEDFLOAT'] = ".123"
    ENV['DEEPENV_MALFORMEDFLOAT2'] = "123."

    config = Deepenv.to_config()
    expect(config[:int]).to eq(15)
    expect(config[:float]).to eq(15.0)
    expect(config[:float2]).to eq(0.001)
    expect(config[:malformedfloat]).to eq(".123")
    expect(config[:malformedfloat2]).to eq("123.")

  end

  it "parses booleans" do 
    ENV['DEEPENV_BOOLEANTRUE'] = 'true'
    ENV['DEEPENV_BOOLEANFALSE'] = 'false'
    ENV['DEEPENV_BOOLEANTRUE_UC'] = 'TRUE'
    ENV['DEEPENV_BOOLEANFALSE_UC'] = 'FALSE'
    ENV['DEEPENV_BOOLEANTRUE_NC'] = 'True'
    ENV['DEEPENV_BOOLEANFALSE_NC'] = 'False'
    ENV['DEEPENV_ONE_NOT_BOOL'] = '1'
    ENV['DEEPENV_ZERO_NOT_BOOL'] = '0'
    
    config = Deepenv.to_config()

    expect(config[:booleantrue]).to eq(true)
    expect(config[:booleanfalse]).to eq(false)
    expect(config[:booleantrue_uc]).to eq(true)
    expect(config[:booleanfalse_uc]).to eq(false)
    expect(config[:booleantrue_nc]).to eq(true)
    expect(config[:booleanfalse_nc]).to eq(false)
    expect(config[:one_not_bool]).not_to eq(true)
    expect(config[:zero_not_bool]).not_to eq(true)

  end

  it "parses json" do
    json_string = '{"levelOne":{"levelTwo":{"levelThree":{}}},"num":0,"txt":"txt","boolTrue":true,"boolFalse":false,"arr":[1,2]}'
    json_malf_string = '{"levelOne":{"levelTwo":{"levelThree":{}}},"num":0,"txt":"txt","boolTrue":true,"boolFalse":false,"arr":[1,2]'
    ENV['DEEPENV_JSON'] = json_string.dup
    ENV['DEEPENV_MALFORMED_JSON'] = json_malf_string.dup
    config = Deepenv.to_config()

    expect(config[:json]).to eq(JSON.parse(json_string))
    expect(config[:malformed_json]).to eq json_malf_string
  end

  it "parses multilevel environment keys" do
    ENV['DEEPENV_LEVELONE__LEVELTWO__LEVELTHREE'] = "myvalue"

    config = Deepenv.to_config()

    expect(config).to eq({
      :levelone => {
        :leveltwo => {
          :levelthree => "myvalue"
        }
      }
    })

  end

  it "merges existing config" do
    ENV['DEEPENV_NEW'] = '1'

    existing = { existing: 5, "stringkey" => "asdf"}

    config = Deepenv.to_config(existing)

    expect(config).to eq({new:1, existing:5, "stringkey" => "asdf"})

  end

  it "can use custom prefix" do 
    ENV['MYAPP_PARAM'] = 'text'
    
    config = Deepenv.to_config({}, {prefix: "MYAPP_"})
    expect(config).to eq({param: 'text'}) 

    ENV.delete('MYAPP_PARAM')

  end

  it "can use custom delimiter" do
    ENV["DEEPENV_ONE_DD_TWO_DD_THREE"] = '16'

    config = Deepenv.to_config({}, {nesting_delimiter: "_DD_"})
    expect(config).to eq({one: {two: { three: 16}}})


  end

end
