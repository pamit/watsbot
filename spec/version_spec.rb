require "spec_helper"

module Watsbot
  RSpec.describe VERSION do

    context "version" do
      it "has a version number" do
        expect(Watsbot::VERSION).not_to be nil
      end
    end
  end
end
