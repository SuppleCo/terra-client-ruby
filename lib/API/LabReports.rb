#  Copyright 2022 Terra Enabling Developers Limited
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

require 'httparty'
require 'API/TerraError'
require 'API/TerraResponse'

module LabReports
    # Upload lab report files (PDF, PNG, JPEG) for biomarker extraction
    # @param dev_id [String] Developer ID
    # @param api_key [String] API key
    # @param api_path [String] API base path
    # @param files [Array<String>, String] File path(s) to upload (max 10 files)
    # @param reference_id [String, nil] Optional reference ID for the patient/user
    # @return [Hash] Response with upload_id and files list
    def self.upload(dev_id, api_key, api_path, files, reference_id: nil)
        # Ensure files is an array
        files = [files] unless files.is_a?(Array)

        # Build multipart body with files
        body = files.map do |file_path|
            [:files, File.open(file_path, 'rb')]
        end.to_h

        # For multiple files, HTTParty needs array format
        if files.length > 1
            body = { files: files.map { |f| File.open(f, 'rb') } }
        else
            body = { files: File.open(files.first, 'rb') }
        end

        options = {
            headers: {
                "X-API-Key" => api_key,
                "dev-id" => dev_id,
            },
            body: body,
        }

        url = "#{api_path}/lab-reports"
        url += "?reference_id=#{reference_id}" if reference_id

        res = HTTParty.post(url, options)

        # Close file handles
        if body[:files].is_a?(Array)
            body[:files].each(&:close)
        else
            body[:files].close
        end

        case res.code
            when 200, 202
                return TerraResponse::parseBody(res)
            when 400...600
                raise TerraError.new(res)
        end
    end
end

