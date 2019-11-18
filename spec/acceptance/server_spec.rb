require 'app'

describe FrontendService do
  describe 'the server having started' do
    context 'responses from /' do
      let(:response) { get '/' }

      it 'renders the home page' do
        expect(response.status).to eq(200)
        expect(response.body).to include('Energy performance of buildings')
      end
    end

    context 'passes a healthcheck' do
      let(:response) { get '/healthcheck' }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end
    end

    context 'errors on a non-existent page' do
      let(:response) { get '/this-page-does-not-exist' }

      it 'returns status 404' do
        expect(response.status).to eq(404)
      end
    end
  end
end
