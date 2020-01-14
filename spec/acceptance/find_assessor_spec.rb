# frozen_string_literal: true

describe 'find assessor' do
  describe '.get /find-an-assessor' do
    let(:response) { get '/find-an-assessor' }

    it 'redirects to /find-an-assessor/search' do
      expect(response).to redirect_to '/find-an-assessor/search'
    end
  end

  describe '.get /find-an-assessor/search' do
    context 'when search page rendered' do
      let(:response) { get '/find-an-assessor/search' }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'displays the find an assessor page heading' do
        expect(response.body).to include('Find an energy assessor')
      end

      it 'has a postcode input field' do
        expect(response.body).to include('<input id="postcode" name="postcode"')
      end

      it 'has a Find button' do
        expect(response.body).to include(
          '<button class="govuk-button" data-module="govuk-button">Find</button>'
        )
      end

      it 'does not display an error message' do
        expect(response.body).not_to include('govuk-error-message')
      end
    end

    context 'when entering an empty postcode' do
      let(:response) { get '/find-an-assessor/search?postcode=' }

      it 'returns status 400' do
        expect(response.status).to eq(400)
      end

      it 'displays the find an assessor page heading' do
        expect(response.body).to include('Find an energy assessor')
      end

      it 'displays an error message' do
        expect(response.body).to include(
          '<span id="postcode-error" class="govuk-error-message">'
        )
        expect(response.body).to include('Enter a real postcode')
      end
    end

    context 'when entering an invalid postcode' do
      let(:response) { get '/find-an-assessor/search?postcode=NOT+A+POSTCODE' }

      it 'returns status 400' do
        expect(response.status).to eq(400)
      end

      it 'displays the find an assessor page heading' do
        expect(response.body).to include('Find an energy assessor')
      end

      it 'displays an error message' do
        expect(response.body).to include(
          '<span id="postcode-error" class="govuk-error-message">'
        )
        expect(response.body).to include('Enter a real postcode')
      end
    end

    context 'when entering a valid postcode' do
      before do
        stub_request(
          :get,
          'http://test-api.gov.uk/api/assessors/search/SW1A%202AA'
        )
          .to_return(
          status: 200,
          body: {
            "results": [
              {
                "assessor": {
                  "firstName": 'Juan',
                  "lastName": 'Uno',
                  "contactDetails": {
                    "telephoneNumber": 'string', "email": 'user@example.com'
                  },
                  "searchResultsComparisonPostcode": 'SW1A 1AA',
                  "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' }
                },
                "distanceFromPostcodeInMiles": 0.1
              },
              {
                "assessor": {
                  "firstName": 'Doux',
                  "lastName": 'Twose',
                  "contactDetails": {
                    "telephoneNumber": 'string', "email": 'user@example.com'
                  },
                  "searchResultsComparisonPostcode": 'SW1A 1AA',
                  "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' }
                },
                "distanceFromPostcodeInMiles": 0.26780459
              },
              {
                "assessor": {
                  "firstName": 'Tri',
                  "lastName": 'Triple',
                  "contactDetails": {
                    "telephoneNumber": 'string', "email": 'user@example.com'
                  },
                  "searchResultsComparisonPostcode": 'SW1A 1AA',
                  "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' }
                },
                "distanceFromPostcodeInMiles": 0.3
              }
            ],
            "searchPostcode": 'SW1 5RW'
          }.to_json
        )
      end

      let(:response) { get '/find-an-assessor/search?postcode=SW1A+2AA' }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'displays the find an assessor page heading' do
        expect(response.body).to include(
          'Results for energy assessors near you'
        )
      end
    end
  end
end
