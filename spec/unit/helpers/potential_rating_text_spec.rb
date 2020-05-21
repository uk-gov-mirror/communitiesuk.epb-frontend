# frozen_string_literal: true

describe Sinatra::FrontendService::Helpers do
  class HelpersStub
    include Sinatra::FrontendService::Helpers
  end

  context "given a recommended improvment number" do
    it "number 1" do
      expect(HelpersStub.new.potential_rating_text(1)).to eq("Potential rating after carrying out recommendation 1")
    end

    it "number 2" do
      expect(HelpersStub.new.potential_rating_text(2)).to eq("Potential rating after carrying out recommendations 1 and 2")
    end

    it "number 3 to 9" do
      expect(HelpersStub.new.potential_rating_text(3)).to eq("Potential rating after carrying out recommendations 1 to 3")
    end
  end
end
