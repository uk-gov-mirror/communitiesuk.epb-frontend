# frozen_string_literal: true

describe "Acceptance::NonDomesticEnergyPerformanceCertificate",
         type: :feature do
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
      FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                          "1234-5678-1234-5678-1234",
                                                        energyEfficiencyBand:
                                                          "b"
    end

    it "returns status 200" do
      expect(response.status).to eq 200
    end

    it "has a tab content that shows the page title" do
      expect(response.body).to include(
                                 " <title>Energy performance certificate (EPC) - Find an energy certificate - GOV.UK</title>",
                               )
    end

    it "shows the non-domestic energy performance certificate title heading" do
      expect(response.body).to include(
                                 '<h1 class="govuk-heading-xl">Energy performance certificate (EPC)</h1>',
                               )
    end

    describe "viewing the summary section" do
      it "shows the address summary" do
        expect(response.body).to have_css "p.epc-address",
                                          text: "Flat 332 Marsham StreetLondonSW1B 2BB"
      end

      it "shows the energy rating title" do
        expect(response.body).to include(
                                   '<p class="epc-rating-title govuk-body">Energy rating</p>',
                                 )
      end

      it "shows the current energy energy efficiency band" do
        expect(response.body).to include(
                                   '<p class="epc-rating-result govuk-body">B</p>',
                                 )
      end

      it "shows the date of expiry" do
        expect(response.body).to have_css "label", text: "Valid until"
        expect(response.body).to have_css "p", text: "5 January 2030"
      end

      it "shows the certificate number label" do
        expect(response.body).to include("<label>Certificate number</label>")
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
                                   '<p class="govuk-body">Properties can be let if they have an energy rating from A+ to E.</p>',
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
                                   '<p class="govuk-body">You can read <a class="govuk-link" href="https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/824018/Non-Dom_Private_Rented_Property_Minimum_Standard_-_Landlord_Guidance.pdf">guidance for landlords on the regulations and exemptions</a>.</p>',
                                 )
      end

      context "with an energy rating of F/G" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                              "1234-5678-1234-5678-1234",
                                                            energyEfficiencyBand:
                                                              "g"
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
                                     '<p class="govuk-body">You can read <a class="govuk-link" href="https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/824018/Non-Dom_Private_Rented_Property_Minimum_Standard_-_Landlord_Guidance.pdf">guidance for landlords on the regulations and exemptions</a>.</p>',
                                   )
        end

        it "shows the recommendation text" do
          expect(response.body).to include(
                                     '<p class="govuk-body">Properties can be let if they have an energy rating from A+ to E. The <a class="govuk-link" href="#related_report">recommendation report</a> sets out changes you can make to improve the property’s rating.</p>',
                                   )
        end
      end

      context "with the property is in Northern Ireland" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                              "1234-5678-1234-5678-1234",
                                                            energyEfficiencyBand:
                                                              "g",
                                                            postcode: "BT4 3WS"
        end

        it "shows the letting info warning text" do
          expect(response.body).to_not include(
                                         '<h2 class="govuk-heading-l">Rules on letting this property</h2>',
                                       )
        end
      end
    end

    context "when viewing the Energy efficiency rating for this building section" do
      it "shows the section heading" do
        expect(response.body).to include(
                                   '<h2 class="govuk-heading-l">Energy efficiency rating for this property</h2>',
                                 )
      end

      it "shows the current energy rating text" do
        expect(response.body).to include(
                                   '<p class="govuk-body">This property’s current energy rating is B.</p>',
                                 )
      end

      it "shows the SVG alternate text title" do
        expect(response.body).to include(
                                   '<title id="svg-title">Energy efficiency chart</title>',
                                 )
      end

      it "shows the SVG alternate text description" do
        expect(response.body).to include(
                                   '<desc id="svg-desc">This property’s current energy rating is B with a score of 35.</desc>',
                                 )
      end

      it "shows the net zero carbon emissions text" do
        expect(response.body).to have_css "text", text: "Net zero CO2"
      end

      it "shows the SVG with energy ratings" do
        expect(response.body).to include('<svg width="615" height="426"')
      end

      it "shows the SVG with energy rating band numbers" do
        expect(response.body).to include('<tspan x="8" y="105">0-25</tspan>')
      end

      it "shows the energy rating description" do
        expect(response.body).to include(
                                   '<p class="govuk-body govuk-!-margin-top-3">Properties are given a rating from A+ (most efficient) to G (least efficient).</p>',
                                 )
      end

      it "shows the energy rating score description" do
        expect(response.body).to include(
                                   '<p class="govuk-body">Properties are also given a score. The larger the number, the more carbon dioxide (CO2) your property is likely to emit.</p>',
                                 )
      end

      it "shows the how this property compares to others section" do
        expect(response.body).to include("How this property compares to others")
        expect(response.body).to include("28 | B")
        expect(response.body).to include("81 | D")
      end

      it "shows the breakdown of this buildings energy performance section" do
        expect(response.body).to include(
                                   ">Breakdown of this property’s energy performance</h2>",
                                 )
        expect(response.body).to include("Natural Gas")
        expect(response.body).to include("Air Conditioning")
        expect(response.body).to include("3")
        expect(response.body).to include("67.09")
        expect(response.body).to include("413\n") # Check the value is rounded
      end

      it "shows the primary energy use explanation" do
        expect(response.body).to include("What is primary energy use?")
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
      end

      it "shows the corresponding related party disclosures" do
        related_party_disclosures = {
          "1": "The assessor is not related to the owner of the property",
          "2": "The assessor is a relative of the property owner",
          "3":
            "The assessor is a relative of the professional dealing with the property transaction.",
          "4":
            "The assessor has an indirect relation to the owner (for example, somebody in the assessor’s family might be employed by the property owner).",
          "5": "The assessor occupies the property.",
          "6":
            "The assessor is the owner or director of the organisation dealing with the property transaction.",
          "7":
            "The assessor is employed by the organisation dealing with the property transaction.",
          "8":
            "The assessor has declared a financial interest in the property.",
          "9": "The assessor is employed by the property owner.",
          "10":
            "The assessor is contracted by the owner to provide other energy assessment services.",
          "11":
            "The assessor is contracted by the owner to provide services other than energy assessment.",
          "12":
            "The assessor has a previous relation to the owner (for example, they might previously have been an employee or contractor).",
          "13":
            "The assessor has not indicated whether they have a relation to this property",
        }

        related_party_disclosures.each do |key, disclosure|
          FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                              "1234-5678-1234-5678-1234",
                                                            energyEfficiencyBand:
                                                              "b",
                                                            related_rrn:
                                                              "4192-1535-8427-8844-6702",
                                                            related_party_disclosure:
                                                              key

          response = get "/energy-certificate/1234-5678-1234-5678-1234"

          expect(response.body).to include(disclosure)
        end
      end

      it "shows the link to the Recommendation Report" do
        expect(response.body).to include(">Recommendation report</h2>")
        expect(response.body).to include(
                                   "/energy-certificate/4192-1535-8427-8844-6702",
                                 )
      end

      it "shows the other certificates section" do
        expect(response.body).to include("Other certificates for this property")
      end
    end

    describe "viewing the report contents section" do
      it "shows the report contents title" do
        expect(response.body).to include(">Certificate contents</h2>")
      end

      it "shows the section links" do
        expect(response.body).to include(
                                   '<p class="govuk-body"><a class="govuk-link" href="#renting">Rules on letting this property</a></p>',
                                 )
        expect(response.body).to include(
                                   '<p class="govuk-body"><a class="govuk-link" href="#energy_rating_section">Energy efficiency rating for this property</a></p>',
                                 )
        expect(response.body).to include(
                                   '<p class="govuk-body"><a class="govuk-link" href="#how_this_building_compares">How this property compares to others</a></p>',
                                 )
        expect(response.body).to include(
                                   '<p class="govuk-body"><a class="govuk-link" href="#energy_peformance_breakdown">Breakdown of this property’s energy performance</a></p>',
                                 )
        expect(response.body).to include(
                                   '<p class="govuk-body"><a class="govuk-link" href="#related_report">Recommendation report</a></p>',
                                 )
        expect(response.body).to include(
                                   '<p class="govuk-body"><a class="govuk-link" href="#contact">Contacting the assessor and accreditation scheme</a></p>',
                                 )
        expect(response.body).to include(
                                   '<p class="govuk-body"><a class="govuk-link" href="#other_reports">Other certificates for this property</a></p>',
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

    it "shows the Other EPCs for this property section" do
      expect(response.body).to have_css "h2",
                                        text: "Other certificates for this property"
      expect(response.body).to have_css "p",
                                        text:
                                          "If you are aware of previous certificates for this property and they are not listed here, please contact us at mhclg.digital-services@communities.gov.uk, or call our helpdesk on 020 3829 0748."
      expect(response.body).to have_css "dt", text: "Certificate number"
      expect(response.body).to have_link "0000-0000-0000-0000-0001",
                                         href: "/energy-certificate/0000-0000-0000-0000-0001"
      expect(response.body).to have_css "dt", text: "Valid until"
      expect(response.body).to have_css "dd", text: "4 May 2026"
      expect(response.body).not_to have_link "0000-0000-0000-0000-0002",
                                             href: "/energy-certificate/0000-0000-0000-0000-0002"
      expect(response.body).not_to have_css "dd", text: "4 May 2019 (Expired)"
    end

    context "when there are no related assessments" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                            "1234-5678-1234-5678-1234",
                                                          energyEfficiencyBand:
                                                            "b",
                                                          related_rrn:
                                                            "4192-1535-8427-8844-6702",
                                                          related_assessments: []
      end

      it "shows the related assessments section title" do
        expect(response.body).to have_css "h2",
                                          text: "Other certificates for this property"
      end

      it "shows the no related assessments content" do
        expect(response.body).to have_css "p",
                                          text: "There are no related certificates for this property."
      end
    end
  end

  context "when the assessment exists without primary energy value" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                          "1234-5678-1234-5678-1234",
                                                        energyEfficiencyBand:
                                                          "b",
                                                        primaryEnergyUse: nil
    end

    it "hides the primary energy use explanation" do
      expect(response.body).not_to include("What is primary energy use?")
    end
  end

  context "when a non domestic certificate is both NI and opted out" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id: "1234-5678-1234-5678-1234",
                                                        energyEfficiencyBand: "b",
                                                        postcode: "BT1 1AA",
                                                        opt_out: true
    end

    it "removes assessor contact details" do
      expect(response.body).to include(
                                 ">Contacting the assessor and accreditation scheme</h2>",
                               )
      expect(response.body).not_to include(">Assessor contact details</h3>")
      expect(response.body).not_to include("TEST NAME BOI")
      expect(response.body).not_to include("012345")
      expect(response.body).not_to include("test@testscheme.com")
      expect(response.body).to include("Quidos")
      expect(response.body).to include("SPEC000000")
      expect(response.body).to include("01225 667 570")
      expect(response.body).to include("info@quidos.co.uk")
      expect(response.body).to include(">Assessment details</h3>")
      expect(response.body).to include("4 January 2020")
      expect(response.body).to include("5 January 2020")
      expect(response.body).not_to include("Joe Bloggs Ltd")
      expect(response.body).not_to include(
                                 "Lloyds House, 18 Lloyd Street, Manchester, M2 5WA",
                                 )
    end
  end
end
