describe UseCase::FetchDecSummary do
  context "When executing the fetch dec summary" do
    before do
      CertificatesGateway::UnsupportedSchemaStub.fetch_dec_summary(
        "0000-0000-0000-0000-0001",
      )
    end

    let(:use_case_object) do
      container = Container.new
      container.get_object(:fetch_dec_summary_use_case)
    end

    it "should return the response" do
      expect {
        use_case_object.execute("0000-0000-0000-0000-0001")
      }.to raise_error(Errors::AssessmentUnsupported)
    end
  end
end
