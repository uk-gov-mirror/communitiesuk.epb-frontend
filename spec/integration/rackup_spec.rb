require 'net/http'

describe 'starts server outside of ruby' do
  describe 'the server running live' do
    before(:all) do
      process = IO.popen('rackup -q')
      @process_id = process.pid

      sleep 2
    end

    after(:all) { Process.kill('KILL', @process_id) }

    let(:request) { Net::HTTP.new('localhost', 9_292) }

    context 'when the server is up' do
      it 'renders the home page' do
        req = Net::HTTP::Get.new('/')
        response = request.request(req)
        expect(response.code).to eq('200')
        expect(response.body).to include('Energy performance of buildings')
      end

      it 'passes a healthcheck' do
        req = Net::HTTP::Get.new('/healthcheck')
        response = request.request(req)
        expect(response.code).to eq('200')
      end

      it 'errors on a non-existent page' do
        req = Net::HTTP::Get.new('/this-page-does-not-exist')
        response = request.request(req)
        expect(response.code).to eq('404')
      end
    end
  end
end
