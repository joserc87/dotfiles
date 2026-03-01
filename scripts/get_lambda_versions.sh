#!/usr/bin/env bash


SERVICES=(
  "lambda/st-subscriptions"
  "lambda/st-subscriptions-dispatcher"
  "lambda/st-subscriptions-event-processor"
  "lambda/st-subscriptions-org-updater-event-bus"
  "lambda/st-auth-webhook-notifications-ddb-stream"
  "lambda/st-quota-events-processor"
  "lambda/st-admin-quotas"
  "lambda/st-profiles"
  "lambda/st-api-gateway-authorizer"
  "ecs/st-internal-quota-service"
)

function get_lambda_version() {
    local service_name="$1"
    local env="$2"
    local account="smart-topics-$env-nvirginia"
    # If lambda -> zip-name, if ecs -> image
    param_name=""
    if [[ "$service_name" == lambda* ]]; then
	param_name="$service_name/zip-name"
    elif [[ "$service_name" == ecs* ]]; then
	param_name="$service_name/image"
    else
	echo "Unknown service type for $service_name"
	return 1
    fi
    service_name=$(basename "$service_name")
    aws ssm get-parameter \
	--profile "$account" \
        --name "/$account/$param_name" \
        --region us-east-1 \
        --query "Parameter.Value" \
        --output text | \
	sed "s/$service_name-//;s/.zip//;s/:/-/g"
}
BLUE=$(tput setaf 4)
ORANGE=$(tput setaf 3)
RED=$(tput setaf 1)
CLEAR=$(tput sgr0)
printf " %-50s | ${BLUE}%-15s${CLEAR} | ${ORANGE}%-15s${CLEAR} | ${RED}%-15s${CLEAR}\n" "SERVICE" "DEV" "STG" "PROD"
printf "%s\n" "⎯---------------------------------------------------+-----------------+-----------------+-----------------"
for service in "${SERVICES[@]}"; do
	version_dev=$(get_lambda_version "$service" "dev")
	version_stg=$(get_lambda_version "$service" "stg")
	version_prod=$(get_lambda_version "$service" "prod")
	COLOR_DEV="$BLUE"
	if [[ "$version_dev" != "$version_stg" ]]; then
	    COLOR_STG="$ORANGE"
	else
	    COLOR_STG="$BLUE"
	fi
	if [[ "$version_stg" != "$version_prod" ]]; then
	    COLOR_PROD="$RED"
	else
	    COLOR_PROD="$COLOR_STG"
	fi
	printf " %-50s | ${COLOR_DEV}%-15s${CLEAR} | ${COLOR_STG}%-15s${CLEAR} | ${COLOR_PROD}%-15s${CLEAR}\n" "$service" "$version_dev" "$version_stg" "$version_prod"
done
