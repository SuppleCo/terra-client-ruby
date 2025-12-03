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

module TerraWrite
    def self.post_data(type, dev_id, api_key, api_path, user_id, data)
        options = {
            "headers" => {
                "X-API-Key" => api_key,
                "dev-id" => dev_id,
                "Content-Type" => "application/json",
            },
        }

        res = HTTParty.post(
            "#{api_path}/#{type}?user_id=#{user_id}",
            :headers => options["headers"],
            :body => data.to_json
        )

        case res.code
            when 200, 201
                return TerraResponse::parseBody(res)
            when 400...600
                raise TerraError.new(res)
        end
    end

    def self.delete_data(type, dev_id, api_key, api_path, user_id, ids)
        options = {
            "headers" => {
                "X-API-Key" => api_key,
                "dev-id" => dev_id,
                "Content-Type" => "application/json",
            },
        }

        # API inconsistency: /body uses "log_ids", others use "data"
        body_key = type == "body" ? "log_ids" : "data"
        body = { body_key => ids }

        res = HTTParty.delete(
            "#{api_path}/#{type}?user_id=#{user_id}",
            :headers => options["headers"],
            :body => body.to_json
        )

        case res.code
            when 200, 207
                return TerraResponse::parseBody(res)
            when 400...600
                raise TerraError.new(res)
        end
    end
end

