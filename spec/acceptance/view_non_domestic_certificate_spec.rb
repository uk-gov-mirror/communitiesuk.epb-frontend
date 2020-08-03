# frozen_string_literal: true

describe "Acceptance::NonDomesticEnergyPerformanceCertificate" do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "/energy-performance-certificate/1234-5678-1234-5678-1234"
  end

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
      FetchAssessmentSummary::AssessmentStub.fetch_cepc(
        "1234-5678-1234-5678-1234",
        "b",
      )
    end

    it "returns status 200" do
      expect(response.status).to eq 200
    end

    it "shows the non-domestic energy performance certificate title" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Non-domestic Energy Performance Certificate</h1>',
      )
    end

    describe "viewing the summary section" do
      it "shows the address summary" do
        expect(response.body).to include(
          '<p class="epc-address govuk-body">Flat 33<br>2 Marsham Street<br>London<br>SW1B 2BB</p>',
        )
      end

      it "shows the energy rating title" do
        expect(response.body).to include(
          '<p class="epc-rating-title govuk-body">Energy Rating</p>',
        )
      end

      it "shows the current energy energy efficiency band" do
        expect(response.body).to include(
          '<p class="epc-rating-result govuk-body">B</p>',
        )
      end

      it "shows the date of expiry" do
        expect(response.body).to include(
          '<p class="govuk-body epc-extra-box">Valid until 5 January 2030</p>',
        )
      end

      it "shows the certificate number label" do
        expect(response.body).to include("<label>Certificate Number</label>")
      end

      it "shows the certificate number" do
        expect(response.body).to include("<b>1234-5678-1234-5678-1234</b>")
      end

      it "shows the property type" do
        expect(response.body).to include("B1 Offices and Workshop businesses")
      end

      it "shows the total floor area" do
        expect(response.body).to include("403 square metres")
      end
    end

    context "when viewing the Rules on letting this property section" do
      it "shows the section heading" do
        expect(response.body).to include(
          '<h2 class="govuk-heading-l">Rules on letting this property</h2>',
        )
      end

      it "shows the letting info text" do
        expect(response.body).to include(
          '<p class="govuk-body">Properties can be let if they have an energy rating of A+ to E.</p>',
        )

        expect(response.body).to include(
          '<p class="govuk-body">If a property has an energy rating of F or G, the landlord cannot grant a tenancy to new or existing tenants, unless an exemption has been registered.</p>',
        )

        expect(response.body).to include(
          '<p class="govuk-body">From 1 April 2023, landlords will not be allowed to continue letting a non-domestic property on an existing lease if that property has an energy rating of F or G.</p>',
        )
      end

      it "shows the guidance for landlords link" do
        expect(response.body).to include(
          '<p class="govuk-body">You can read <a href="https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/824018/Non-Dom_Private_Rented_Property_Minimum_Standard_-_Landlord_Guidance.pdf">guidance for landlords on the regulations and exemptions</a>.</p>',
        )
      end

      context "with an energy rating of F/G" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_cepc(
            "1234-5678-1234-5678-1234",
            "g",
          )
        end

        it "shows the letting info warning text" do
          expect(response.body).to include(
            '<strong class="govuk-warning-text__text"><span class="govuk-warning-text__assistive">Warning</span>You may not be able to let this property.</strong>',
          )
        end

        it "shows the letting info text" do
          expect(response.body).to include(
            '<p class="govuk-body">This property has an energy rating of G. The landlord cannot grant a tenancy to new or existing tenants, unless an exemption has been registered.</p>',
          )

          expect(response.body).to include(
            '<p class="govuk-body">From 1 April 2023, landlords will not be allowed to continue letting a non-domestic property on an existing lease if that property has an energy rating of F or G.</p>',
          )
        end

        it "shows the guidance for landlords link" do
          expect(response.body).to include(
            '<p class="govuk-body">You can read <a href="https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/824018/Non-Dom_Private_Rented_Property_Minimum_Standard_-_Landlord_Guidance.pdf">guidance for landlords on the regulations and exemptions</a>.</p>',
          )
        end

        it "shows the recommendation text" do
          expect(response.body).to include(
            '<p class="govuk-body">Properties can be let if they have an energy rating of A+ to E. The <a href="#">recommendation report</a> sets out changes you can make to improve the property’s rating.</p>',
          )
        end
      end
    end

    context "when viewing the Energy efficiency rating for this building section" do
      it "shows the section heading" do
        expect(response.body).to include(
          '<h2 class="govuk-heading-l">Energy efficiency rating for this building</h2>',
        )
      end

      it "shows the current energy rating text" do
        expect(response.body).to include(
          '<p class="govuk-body">This building’s current energy rating is B.</p>',
        )
      end

      it "shows the SVG title" do
        expect(response.body).to include(
          '<title id="svg-title">This building’s energy rating is B (35)</title>',
        )
      end

      it "shows the net zero carbon emissions text" do
        expect(response.body).to include(
          '<text x="420" y="65" class="small">Net zero CO₂</text>',
        )
      end

      it "shows the SVG with energy ratings" do
        expect(response.body).to include('<svg width="615" height="426"')
      end

      it "shows the SVG with energy rating band numbers" do
        expect(response.body).to include('<tspan x="8" y="105">0-25</tspan>')
      end

      it "shows the energy rating description" do
        expect(response.body).to include(
          '<p class="govuk-body govuk-!-margin-top-3">Buildings are given a rating from A+ (most efficient) to G (least efficient).</p>',
        )
      end

      it "shows the energy rating score description" do
        expect(response.body).to include(
          '<p class="govuk-body">Buildings are also given a score. The larger the number, the more expensive your fuel bills are likely to be.</p>',
        )
      end

      it "shows the how this building compares to others section" do
        expect(response.body).to include("How this building compares to others")
        expect(response.body).to include("28 | B")
        expect(response.body).to include("81 | D")
      end

      it "shows the breakdown of this buildings energy performance section" do
        expect(response.body).to include(
          ">Breakdown of this building's energy performance</h2>",
        )
        expect(response.body).to include("Natural Gas")
        expect(response.body).to include("Air Conditioning")
        expect(response.body).to include("3")
        expect(response.body).to include("67.09")
        expect(response.body).to include("413.22")
      end

      it "shows the contact section" do
        expect(response.body).to include(
          ">Contacting the assessor and accreditation scheme</h2>",
        )
        expect(response.body).to include(">Assessor contact details</h3>")
        expect(response.body).to include("TEST NAME BOI")
        expect(response.body).to include("012345")
        expect(response.body).to include("test@testscheme.com")
        expect(response.body).to include("Quidos")
        expect(response.body).to include("SPEC000000")
        expect(response.body).to include("01225 667 570")
        expect(response.body).to include("info@quidos.co.uk")
      end

      it "shows the assessment details" do
        expect(response.body).to include(">Assessment details</h3>")
        expect(response.body).to include("4 January 2020")
        expect(response.body).to include("5 January 2020")
        expect(response.body).to include("Joe Bloggs Ltd")
        expect(response.body).to include(
          "Lloyds House, 18 Lloyd Street, Manchester, M2 5WA",
        )
        expect(response.body).to include("No connection to the property")
      end

      it "shows the link to the Recommendation Report" do
        expect(response.body).to include(">Recommendation Report</h2>")
        expect(response.body).to include(
          "/energy-performance-certificate/4192-1535-8427-8844-6702",
        )
      end

      it "shows the other certificates section" do
        expect(response.body).to include("Other certificates for this property")
      end
    end 

    describe "viewing the report contents section" do
      it "shows the report contents title" do
        expect(response.body).to include(">Certificate Contents</h3>")
      end

      it "shows the section links" do
        expect(response.body).to include(
                                     '<p class="govuk-body"><a href="#renting">Rules on letting this property</a></p>',
                                     )
        expect(response.body).to include(
                                     '<p class="govuk-body"><a href="#energy_rating_section">Energy efficiency rating for this building</a></p>',
                                     )
        expect(response.body).to include(
                                     '<p class="govuk-body"><a href="#how_this_building_compares">How this building compares to others</a></p>',
                                     )
        expect(response.body).to include(
                                     '<p class="govuk-body"><a href="#energy_peformance_breakdown">Breakdown of this building\'s energy performance</a></p>',
                                     )
        expect(response.body).to include(
                                     '<p class="govuk-body"><a href="#related_report">Recommendation Report</a></p>',
                                     )
        expect(response.body).to include(
                                     '<p class="govuk-body"><a href="#contact">Contacting the assessor and accreditation scheme</a></p>',
                                     )
        expect(response.body).to include(
                                     '<p class="govuk-body"><a href="#other_reports">Other certificates for this property</a></p>',
                                     )
      end

      it "can navigate to each section" do
        expect(response.body).to include('id="renting"')
        expect(response.body).to include('id="energy_rating_section"')
        expect(response.body).to include('id="how_this_building_compares"')
        expect(response.body).to include('id="energy_peformance_breakdown"')
        expect(response.body).to include('id="related_report"')
        expect(response.body).to include('id="contact"')
        expect(response.body).to include('id="other_reports"')
      end
    end
  end
end
