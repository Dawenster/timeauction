require 'spec_helper'

describe EmailDomain do
  it { should validate_presence_of(:domain) }
  it { should validate_uniqueness_of(:domain) }
end
