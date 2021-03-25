# frozen_string_literal: true

module UseCase
  class FetchDecSummary < UseCase::Base
    def execute(assessment_id)
      response = @gateway.fetch_dec_summary(assessment_id)

      raise_errors_if_exists(response) do |error|
        raise Errors::AssessmentNotFound if error[:code] == "NOT_FOUND"
        raise Errors::AssessmentNotFound if error[:code] == "GONE"
        raise Errors::AssessmentNotFound if error[:code] == "NOT_A_DEC"
        raise Errors::AssessmentUnsupported if error[:code] == "INVALID_REQUEST"
      end

      response
    end
  end
end
