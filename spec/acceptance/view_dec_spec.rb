# frozen_string_literal: true

describe "Acceptance::DisplayEnergyCertificate", type: :feature do
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
      expect(response.body).to include(
        ">Energy performance of this building</h2>",
      )
      expect(response.body).to include(
        "The building’s energy performance is based on its carbon dioxide (CO2) emissions for the last year.",
      )
      expect(response.body).to include(
        "It is given a score and an energy rating on a scale from A (lowest emissions) to G (highest emissions).",
      )
      expect(response.body).to include(
        "Typical energy performance for a public building is 100. This typical score gives an energy rating of D.",
      )
      expect(response.body).to include(">1 | A</text>")
      expect(response.body).to include(
        'You can read <a href="https://www.gov.uk/government/publications/display-energy-certificates-and-advisory-reports-for-public-buildings">guidance on Display Energy Certificates and advisory reports for public buildings</a>.',
      )
    end

    it "shows the previous operational ratings section" do
      expect(response.body).to include("Previous Operational Ratings")
      expect(response.body).to include("January 2020")
      expect(response.body).to include("1 | A")
      expect(response.body).to include("January 2019")
      expect(response.body).to include("24 | A")
      expect(response.body).to include("January 2018")
      expect(response.body).to include("40 | B")
    end

    it "shows the total CO2 emissions section" do
      expect(response.body).to include("Total CO2 emissions")
      expect(response.body).to include(
        "This tells you how much carbon dioxide the building emits. It shows tonnes per year of CO2.",
      )
      expect(response.body).to have_css "th.govuk-table__header", text: "Date"
      expect(response.body).to have_css "th.govuk-table__header",
                                        text: "January 2020"
      expect(
        response.body,
      ).to have_css "th.govuk-table__header.govuk-table__header--numeric",
                    text: "Electricity"
      expect(
        response.body,
      ).to have_css "td.govuk-table__cell.govuk-table__cell--numeric", text: "7"
      expect(
        response.body,
      ).to have_css "th.govuk-table__header.govuk-table__header--numeric",
                    text: "Heating"
      expect(
        response.body,
      ).to have_css "td.govuk-table__cell.govuk-table__cell--numeric", text: "3"
      expect(
        response.body,
      ).to have_css "th.govuk-table__header.govuk-table__header--numeric",
                    text: "Renewables"
      expect(
        response.body,
      ).to have_css "td.govuk-table__cell.govuk-table__cell--numeric", text: "0"
    end

    it "shows the technical information section" do
      expect(response.body).to include(
        '<h2 class="govuk-heading-l">Technical Information</h2>',
      )
      expect(response.body).to include(
        "This tells you technical information about how energy is used in this building. Consumption data based on actual meter readings.",
      )
      expect(response.body).to include(">Main heating fuel</dt>")
      expect(response.body).to include(">Natural Gas</dd>")
      expect(response.body).to include(">Building environment</dt>")
      expect(response.body).to include(">Heating and Natural Ventilation</dd>")
      expect(response.body).to include(">Total useful floor area (m2)</dt>")
      expect(response.body).to include(">99</dd>")
      expect(response.body).to include(">Asset Rating</dt>")
      expect(response.body).to include(">1</dd>")
      expect(response.body).to include(">Energy use</th>")
      expect(response.body).to include(">Heating</th>")
      expect(response.body).to include(">Electricity</th>")
      expect(response.body).to include(">Annual Energy Use (kWh/m2/year)</th>")
      expect(response.body).to include(">11</td>")
      expect(response.body).to include(">12</td>")
      expect(response.body).to include(">Typical Energy Use (kWh/m2/year)</th>")
      expect(response.body).to include(">13</td>")
      expect(response.body).to include(">14</td>")
      expect(response.body).to include(">Energy from renewables</th>")
      expect(response.body).to include(">15%</td>")
      expect(response.body).to include(">16%</td>")
    end
  end
end
