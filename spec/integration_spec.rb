require_relative 'spec_helper'

require 'multi_json'

read_files = ->() {
  Dir.tap {|it| it.chdir('spec/test-resources/src/main/resources') } \
     .glob('*.json') \
     .map {|f| File.read f }
}

describe Halibut do

  it "tests against test-resources" do
    files  = read_files[]

    refilled  = files.map {|f| MultiJson.load f }
    resources = files.map {|f| Halibut::HAL::Resource.from_json f }.map &:as_json

    zipped = refilled.zip resources
    zipped.each do |json, hal|
      json.must_equal hal
    end
  end

end
