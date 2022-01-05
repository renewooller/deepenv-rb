# frozen_string_literal: true

RSpec.describe Deepenv do
  it "has a version number" do
    expect(Deepenv::VERSION).to_not be nil
  end

  it "parses nulls" do
    ENV['DEEPENV_BLANK'] = ''
    ENV['DEEPENV_NULLSTRING']  = 'null'

    config = Deepenv.to_config()
    expect(config[:blank]).to eq(nil)
    expect(config[:nullstring]).to eq('null')
  end

  it "parses numerics" do 
    ENV['DEEPENV_INT'] = "15"
    ENV['DEEPENV_FLOAT'] = "15.0"

    config = Deepenv.to_config()
    expect(config[:int]).to eq(15)
    expect(config[:float]).to eq(15.0)

  end
end
