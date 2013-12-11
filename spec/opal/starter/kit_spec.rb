require 'spec_helper'
describe Opal::Starter::Kit::RvmUtil do

  describe ".rvm_version" do


    it "should be true" do
      version = "2.0.0p247"

      expect(subject.rvm_versionize(version)).to eq("2.0.0-p247")
    end

  end

end
