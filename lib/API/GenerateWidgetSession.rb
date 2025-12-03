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
require 'json'
require 'API/TerraError'
require 'API/TerraResponse'

module GWS
    def self.generate_widget_session(
        dev_id,
        api_key,
        api_path,
        referenceId,
        providers,
        language,
        auth_success_redirect_url,
        auth_failure_redirect_url
    )
        data = {
            "reference_id" => referenceId,
            "providers" => providers.join(','),
            "auth_failure_redirect_url" => auth_failure_redirect_url,
            "auth_success_redirect_url" => auth_success_redirect_url,
            "language" => language
        }

        data = data.to_json
        
        options = {
            "headers" => {
              "X-API-Key" => api_key,
              "dev-id" => dev_id,
              "Content-Type" => "application/json",
            }
        }

        res = HTTParty.post(
            "#{api_path}/auth/generateWidgetSession", 
            :headers=>options["headers"], 
            :body=>data
        )
        
        body = JSON.parse(res.body)
        case body["status"]
            when "success"
                return TerraResponse::parseBody(res)
            else
                raise TerraError.new(res)
        end
    end

    def self.authenticate_user(
        dev_id,
        api_key,
        api_path,
        resource,
        reference_id: nil,
        language: nil,
        auth_success_redirect_url: nil,
        auth_failure_redirect_url: nil
    )
        data = {}
        data["reference_id"] = reference_id if reference_id
        data["language"] = language if language
        data["auth_success_redirect_url"] = auth_success_redirect_url if auth_success_redirect_url
        data["auth_failure_redirect_url"] = auth_failure_redirect_url if auth_failure_redirect_url

        options = {
            "headers" => {
              "X-API-Key" => api_key,
              "dev-id" => dev_id,
              "Content-Type" => "application/json",
            }
        }

        res = HTTParty.post(
            "#{api_path}/auth/authenticateUser?resource=#{resource}", 
            :headers=>options["headers"], 
            :body=>data.to_json
        )
        
        body = JSON.parse(res.body)
        case body["status"]
            when "success"
                return TerraResponse::parseBody(res)
            else
                raise TerraError.new(res)
        end
    end
end