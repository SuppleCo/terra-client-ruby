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

require "httparty"
require "API/Athelete"
require "API/GenerateWidgetSession"
require "API/Providers"
require "API/Subscribers"
require "API/Users"
require "API/TerraData"
require "API/Helpers"
require "API/TerraWebhook"


module TerraAPI 
    class Terra
        def initialize(dev_id, api_key)

            @api_path = "https://api.tryterra.co/v2"

            options = {
                "headers" => {
                    "X-API-Key" => api_key,
                    "dev-id" => dev_id,
                    "Content-Type" => "application/json",
                },
            }

            res = HTTParty.get("#{@api_path}/subscriptions", :headers=>options["headers"])
            case res.code
                when 200
                    @api_key = api_key
                    @dev_id = dev_id
                    puts "Successfuly connected to the API"
                when 400...600
                    raise TerraError.new(res)
            end
        end

        def get_athelete(user_id, to_webhook=false)
            return Athelete::get(@dev_id, @api_key, @api_path, user_id, to_webhook,)
        end

        def generate_widget_session(
            reference_id,
            providers,
            language,
            auth_success_redirect_url,
            auth_failure_redirect_url
        )
            return GWS::generate_widget_session(
                @dev_id,
                @api_key,
                @api_path,
                reference_id,
                providers,
                language,
                auth_success_redirect_url,
                auth_failure_redirect_url
            )
        end

        def get_providers()
            return Provider::get_providers(@dev_id, @api_key, @api_path)
        end

        def get_subscribers()
            return Subscribers::get_subscribers(@dev_id, @api_key, @api_path)
        end

        def get_user(user_id)
            return Users::get_user(@dev_id, @api_key, @api_path, user_id)
        end

        def deauth_user(user_id)
            return Users::deauth_user(@dev_id, @api_key, @api_path, user_id)
        end

        private def get_data(type, user_id, start_date, end_date, to_webhook=false)
            return TerraData::get_data(type, @dev_id, @api_key, @api_path, user_id, start_date, end_date, to_webhook)
        end

        def get_activity(user_id, start_date, end_date=nil, to_webhook=false)
            return get_data("activity", user_id, start_date, end_date, to_webhook)
        end

        def get_daily(user_id, start_date, end_date=nil, to_webhook=false)
            return get_data("daily", user_id, start_date, end_date, to_webhook)
        end

        def get_body(user_id, start_date, end_date=nil, to_webhook=false)
            return get_data("body", user_id, start_date, end_date, to_webhook)
        end

        def get_sleep(user_id, start_date, end_date=nil, to_webhook=false)
            return get_data("sleep", user_id, start_date, end_date, to_webhook)
        end

        def get_menstruation(user_id, start_date, end_date=nil, to_webhook=false)
            return get_data("menstruation", user_id, start_date, end_date, to_webhook)
        end

        def get_nutrition(user_id, start_date, end_date=nil, to_webhook=false)
            return get_data("nutrition", user_id, start_date, end_date, to_webhook)
        end

        def get_planned_workouts(user_id, start_date, end_date=nil, to_webhook=false)
            return get_data("plannedWorkout", user_id, start_date, end_date, to_webhook)
        end

        def parse_webhook(payload, type, user_id=nil)
            return TerraWebhook.new(playload, type, user_id)
        end
    end
end

