# frozen_string_literal: true

module CertificatesGateway
  class Stub
    def search_by_postcode(*)
      {
        "results": [
          {
            assessmentId: '123-456',
            dateOfAssessment: '2011-01-01',
            dateRegistered: '2011-01-02',
            dwellingType: 'Top floor flat',
            typeOfAssessment: 'RdSAP',
            totalFloorArea: 50,
            addressSummary: '2 Marsham Street, London, SW1B 2BB',
            currentEnergyEfficiencyRating: 90,
            currentEnergyEfficiencyBand: 'b',
            potentialEnergyEfficiencyRating: 'a',
            potentialEnergyEfficiencyBand: 95,
            postcode: 'SW1B 2BB',
            dateOfExpiry: '2021-01-01'
          },
          {
            assessmentId: '123-987',
            dateOfAssessment: '2011-01-01',
            dateRegistered: '2011-01-02',
            dwellingType: 'Top floor flat',
            typeOfAssessment: 'RdSAP',
            totalFloorArea: 50,
            addressSummary: '1 Marsham Street, London, SW1B 2BB',
            currentEnergyEfficiencyRating: 90,
            currentEnergyEfficiencyBand: 'b',
            potentialEnergyEfficiencyRating: 'a',
            potentialEnergyEfficiencyBand: 95,
            postcode: 'SW1B 2BB',
            dateOfExpiry: '2022-01-01'
          },
          {
            assessmentId: '123-456',
            dateOfAssessment: '2011-01-01',
            dateRegistered: '2011-01-02',
            dwellingType: 'Top floor flat',
            typeOfAssessment: 'RdSAP',
            totalFloorArea: 50,
            addressSummary: '3 Marsham Street, London, SW1B 2BB',
            currentEnergyEfficiencyRating: 90,
            currentEnergyEfficiencyBand: 'b',
            potentialEnergyEfficiencyRating: 'a',
            potentialEnergyEfficiencyBand: 95,
            postcode: 'SW1B 2BB',
            dateOfExpiry: '2023-01-01'
          }
        ],
        "searchPostcode": 'SW1 5RW'
      }
    end

    def search_by_id(*)
      {
        "results": [
          {
            assessmentId: '123-456',
            dateOfAssessment: '2011-01-01',
            dateRegistered: '2011-01-02',
            dwellingType: 'Top floor flat',
            typeOfAssessment: 'RdSAP',
            totalFloorArea: 50,
            addressSummary: '3 Marsham Street, London, SW1B 2BB',
            currentEnergyEfficiencyRating: 90,
            currentEnergyEfficiencyBand: 'b',
            potentialEnergyEfficiencyRating: 'a',
            potentialEnergyEfficiencyBand: 95,
            postcode: 'SW1B 2BB',
            dateOfExpiry: '2023-01-01'
          }
        ],
        "searchPostcode": 'SW1 5RW'
      }
    end

    def search_by_street_name_and_town(street_name, town)
      {
        "results": [
          {
            assessmentId: '1234-5678-9101-1121',
            dateOfAssessment: '2011-01-01',
            dateRegistered: '2011-01-02',
            dwellingType: 'Top floor flat',
            typeOfAssessment: 'RdSAP',
            totalFloorArea: 50,
            addressSummary: '2 Marsham Street, London, SW1B 2BB',
            currentEnergyEfficiencyRating: 90,
            currentEnergyEfficiencyBand: 'b',
            potentialEnergyEfficiencyRating: 'a',
            potentialEnergyEfficiencyBand: 95,
            postcode: 'SW1B 2BB',
            dateOfExpiry: '2021-01-01',
            addressLine1: street_name,
            town: town
          },
          {
            assessmentId: '1234-5678-9101-1122',
            dateOfAssessment: '2011-01-01',
            dateRegistered: '2011-01-02',
            dwellingType: 'Top floor flat',
            typeOfAssessment: 'RdSAP',
            totalFloorArea: 50,
            addressSummary: '1 Marsham Street, London, SW1B 2BB',
            currentEnergyEfficiencyRating: 90,
            currentEnergyEfficiencyBand: 'b',
            potentialEnergyEfficiencyRating: 'a',
            potentialEnergyEfficiencyBand: 95,
            postcode: 'SW1B 2BB',
            dateOfExpiry: '2022-01-01',
            addressLine1: street_name,
            town: town
          },
          {
            assessmentId: '1234-5678-9101-1123',
            dateOfAssessment: '2011-01-01',
            dateRegistered: '2011-01-02',
            dwellingType: 'Top floor flat',
            typeOfAssessment: 'RdSAP',
            totalFloorArea: 50,
            addressSummary: '3 Marsham Street, London, SW1B 2BB',
            currentEnergyEfficiencyRating: 90,
            currentEnergyEfficiencyBand: 'b',
            potentialEnergyEfficiencyRating: 'a',
            potentialEnergyEfficiencyBand: 95,
            postcode: 'SW1B 2BB',
            dateOfExpiry: '2023-01-01',
            addressLine1: street_name,
            town: town
          }
        ],
        "searchPostcode": 'SW1 5RW'
      }
    end

    def fetch(assessment_id)
      {
        addressSummary: '2 Marsham Street, London, SW1B 2BB',
        assessmentId: assessment_id,
        dateOfAssessment: '02 January 2020',
        dateRegistered: '05 January 2020',
        dateOfExpiry: '05 January 2030',
        dwellingType: 'Top floor flat',
        typeOfAssessment: 'RdSAP',
        totalFloorArea: 150,
        currentEnergyEfficiencyRating: 90,
        currentEnergyEfficiencyBand: 'b',
        potentialEnergyEfficiencyRating: 99,
        potentialEnergyEfficiencyBand: 'a',
        postcode: 'SW1B 2BB',
        addressLine1: 'Flat 33',
        addressLine2: '2 Marsham Street',
        addressLine3: '',
        addressLine4: '',
        town: 'London'
      }
    end
  end
end
