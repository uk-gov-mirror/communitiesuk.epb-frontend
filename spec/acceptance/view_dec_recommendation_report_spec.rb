# frozen_string_literal: true

describe "Acceptance::DecRecommendationReport", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) { get "/energy-certificate/1234-5678-1234-5678-1234" }

  context "when the assessment does not exist" do
    before do
      FetchAssessmentSummary::NoAssessmentStub.fetch("1234-5678-1234-5678-1234")
    end

    it "returns status 404" do
      expect(response.status).to eq 404
    end

    it "shows the error page" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Page not found</h1>',
      )
    end
  end

  context "when the assessment exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2030-01-01",
      )
    end

    it "shows the page title" do
      expect(response.body).to include(
        "Display energy certificate (DEC) recommendation report",
      )
    end

    it "has a tab content that shows" do
      expect(response.body).to include(
        " <title>Recommendation report - Find an energy certificate - GOV.UK</title>",
      )
    end

    it "shows the contents section" do
      expect(response.body).to have_css "h2", text: "Report contents"
      expect(response.body).to have_link "Operational rating and DEC",
                                         href: "#rating"
      expect(response.body).to have_link "Recommendations",
                                         href: "#recommendations"
      expect(response.body).to have_link "Building and report details",
                                         href: "#building"
      expect(response.body).to have_link "Assessor’s details", href: "#assessor"
      expect(response.body).to have_link "Other reports for this property",
                                         href: "#other_reports"
    end

    it "shows the summary section" do
      expect(response.body).to have_css "span", text: "1 Lonely Street"
      expect(response.body).to have_css "span", text: "Post-Town0"
      expect(response.body).to have_css "span", text: "A0 0AA"
      expect(response.body).to have_css "label", text: "Report number"
      expect(response.body).to have_css "span", text: "1234-5678-1234-5678-1234"
      expect(response.body).to have_css "label", text: "Valid until"
      expect(response.body).to have_css "span", text: "1 January 2030"
      expect(response.body).to have_text "Print this report"
    end

    it "shows the rating section" do
      expect(response.body).to have_css "h2", text: "Operational rating and DEC"
      expect(response.body).to have_css "p",
                                        text: "This building’s operational rating is A."
      expect(response.body).to have_css "p",
                                        text: "see the DEC for this building."
      expect(response.body).to have_link "see the DEC for this building",
                                         href: "/energy-certificate/0000-0000-0000-0000-1111"
    end

    it "shows the Recommendations section" do
      expect(response.body).to have_css "h2", text: "Recommendations"
      expect(response.body).to have_css "p",
                                        text:
                                          "Make these changes to improve the property’s energy efficiency."
      expect(response.body).to have_css "p",
                                        text:
                                          "Recommended improvements are grouped by the estimated time it would take for the change to pay for itself. The assessor may also make additional recommendations."
      expect(response.body).to have_css "p",
                                        text:
                                          "Each recommendation is marked as low, medium or high. This shows the potential impact of the change on reducing the property’s carbon emissions."
      expect(response.body).to have_css "th", text: "Recommendation"
      expect(response.body).to have_css "th", text: "Potential impact"
      expect(response.body).to have_css "caption",
                                        text: "Changes that pay for themselves within 3 years"
      expect(response.body).to have_css "th",
                                        text:
                                          "Consider thinking about maybe possibly getting a solar panel but only one."
      expect(response.body).to have_css "td", text: "Medium"
      expect(response.body).to have_css "th",
                                        text:
                                          "Consider introducing variable speed drives (VSD) for fans, pumps and compressors."
      expect(response.body).to have_css "td", text: "Low"
      expect(response.body).to have_css "caption",
                                        text: "Changes that pay for themselves within 3 to 7 years"
      expect(response.body).to have_css "th",
                                        text:
                                          "Engage experts to propose specific measures to reduce hot waterwastage and plan to carry this out."
      expect(response.body).to have_css "td", text: "Low"
      expect(response.body).to have_css "caption",
                                        text: "Changes that pay for themselves in more than 7 years"
      expect(response.body).to have_css "th",
                                        text: "Consider replacing or improving glazing."
      expect(response.body).to have_css "td", text: "Low"
      expect(response.body).to have_css "caption",
                                        text: "Additional recommendations"
      expect(response.body).to have_css "th", text: "Add a big wind turbine."
      expect(response.body).to have_css "td", text: "High"
    end

    it "shows the Building and report details section" do
      expect(response.body).to have_css "h2",
                                        text: "Building and report details"
      expect(response.body).to have_css "dt", text: "Building occupier"
      expect(response.body).to have_css "dd", text: "City Council"
      expect(response.body).to have_css "dt", text: "Building type"
      expect(response.body).to have_css "dd", text: "University campus"
      expect(response.body).to have_css "dt", text: "Building environment"
      expect(response.body).to have_css "dd",
                                        text: "Heating and natural ventilation"
      expect(response.body).to have_css "dt",
                                        text: "On-site renewable energy sources"
      expect(response.body).to have_css "dd", text: "Renewable energy source"
      expect(response.body).to have_css "dt",
                                        text: "Separable energy uses discounted"
      expect(response.body).to have_css "dd", text: "Separable energy use"
      expect(response.body).to have_css "dt", text: "Electricity used"
      expect(response.body).to have_css "dd", text: "751445 kW h"
      expect(response.body).to have_css "dt", text: "Gas used"
      expect(response.body).to have_css "dd", text: "72956 kW h"
      expect(response.body).to have_css "dt", text: "Total useful floor area"
      expect(response.body).to have_css "dd", text: "935 square metres"
      expect(response.body).to have_css "dt", text: "Building reference"
      expect(response.body).to have_css "dd", text: "90806560123"
      expect(response.body).to have_css "dt", text: "Report issued on"
      expect(response.body).to have_css "dd", text: "22 September 2010"
      expect(response.body).to have_css "dt", text: "Calculation tool"
      expect(response.body).to have_css "dd", text: "DCLG, ORCalc, v3.6.2"
      expect(response.body).to have_css "dt", text: "Type of inspection"
      expect(response.body).to have_css "dd", text: "Physical"
    end

    it "shows the Assessor’s details section" do
      expect(response.body).to have_css "h2", text: "Assessor’s details"
      expect(response.body).to have_css "dt", text: "Assessor’s name"
      expect(response.body).to have_css "dd", text: "John Howard"
      expect(response.body).to have_css "dt", text: "Employer’s name"
      expect(response.body).to have_css "dd", text: "Joe Bloggs Ltd"
      expect(response.body).to have_css "dt", text: "Employer’s address"
      expect(response.body).to have_css "dd",
                                        text: "123 My Street, My City, AB3 4CD"
      expect(response.body).to have_css "dt", text: "Assessor ID"
      expect(response.body).to have_css "dd", text: "SPEC000000"
      expect(response.body).to have_css "dt", text: "Accreditation scheme"
      expect(response.body).to have_css "dd", text: "test scheme"
    end

    it "shows the Other reports for this property section" do
      expect(response.body).to have_css "h2",
                                        text: "Other reports for this property"
      expect(response.body).to have_css "p",
                                        text:
                                          "If you are aware of previous reports for this property and they are not listed here, please contact us at mhclg.digital-services@communities.gov.uk, or call our helpdesk on 020 3829 0748."
      expect(response.body).to have_css "dt", text: "Certificate number"
      expect(response.body).to have_link "9457-0000-0000-0000-2000",
                                         href: "/energy-certificate/9457-0000-0000-0000-2000"
      expect(response.body).to have_css "dt", text: "Valid until"
      expect(response.body).to have_css "dd", text: "4 May 2026"
      expect(response.body).to have_css "dt", text: "Certificate number"
      expect(response.body).to have_link "9457-0000-0000-0000-2001",
                                         href: "/energy-certificate/9457-0000-0000-0000-2001"
      expect(response.body).to have_css "dt", text: "Valid until"
      expect(response.body).to have_css "dd", text: "4 May 2019"
      expect(response.body).to have_css "dd", text: "EXPIRED"
    end
  end

  context "when there are no related assessments" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2030-01-01",
        related_assessments: [],
      )
    end

    it "shows the no related reports text" do
      expect(response.body).to have_css "p",
                                        text: "There are no related reports for this property."
    end
  end

  context "when there are no related assessments of the same type" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2030-01-01",
        related_assessments: [
          {
            "assessmentId": "9273-1041-0269-0300-1495",
            "assessmentStatus": "EXPIRED",
            "assessmentType": "DEC",
            "assessmentExpiryDate": "2017-09-29",
          },
        ],
      )
    end

    it "shows the no related reports text" do
      expect(response.body).to have_css "p",
                                        text: "There are no related reports for this property."
    end
  end

  context "when the assessment expires" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2011-02-10",
      )
    end

    it "shows the expired summary section" do
      expect(response.body).to have_css "label", text: "This report expired on"
      expect(response.body).to have_css "span", text: "10 February 2011"
    end
  end
end
