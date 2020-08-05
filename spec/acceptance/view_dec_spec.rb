# frozen_string_literal: true

describe "Acceptance::DisplayEnergyCertificate" do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "/energy-performance-certificate/0000-0000-0000-0000-1111"
  end

  context "when a dec exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec(
        "0000-0000-0000-0000-1111",
        "2030-02-21",
      )
    end

    it "shows the page title" do
      expect(response.body).to include("Display Energy Certificate")
    end

    it "shows the summary box" do
      expect(response.body).to include("0000-0000-0000-0000-1111")
      expect(response.body).to include("Valid until 21 February 2030")
      expect(response.body).to include("A")
      expect(response.body).to include("2 Lonely Street")
      expect(response.body).to include("Post-Town1")
      expect(response.body).to include("A0 0AA")
    end

    it "shows the rating section" do
      expect(response.body).to include(">Energy performance Operational Rating for this building</h2>")
      expect(response.body).to include(
        '<p class="govuk-body">This tells you how efficiently energy has been used in the building. The numbers do not represent actual units of energy consumed; they represent comparative energy efficiency.</p>',
      )
      expect(response.body).to include(
        '<p class="govuk-body">100 would be typical for this kind of building.</p>',
      )
      expect(response.body).to include(">1 |</text>")
      expect(response.body).to include(">A</text>")
      expect(response.body).to include(
        '<p class="govuk-body">The operational rating is based on meter readings of all the energy actually used in the building including for lighting, heating, cooling, ventilation and hot water. It is compared to a benchmark that represents performance indicative of all buildings of this type.</p>',
      )
      expect(response.body).to include(
        '<p class="govuk-body">You can read <a href="https://www.gov.uk/government/publications/display-energy-certificates-and-advisory-reports-for-public-buildings">guidance on Display Energy Certificates and advisory reports for public buildings</a>.</p>',
      )
    end
  end
end
