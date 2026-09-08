#!/usr/bin/env bash


SERVICES=(
  "lambda/st-subscriptions"
  "lambda/st-subscriptions-dispatcher"
  "lambda/st-subscriptions-event-processor"
  "lambda/st-subscriptions-org-updater-event-bus"
  "lambda/st-auth-webhook-notifications-ddb-stream"
  "lambda/st-quota-events-processor"
  "lambda/st-quota-consumption-calculator"
  "lambda/st-admin-quotas"
  "lambda/st-profiles"
  "lambda/st-api-gateway-authorizer"
  "ecs/internal-quota-service"
  "ecs/internal-subscriptions-service"
  "ecs/internal-users-service"
  "ecs/st-authorizer"
)

ENVS=(dev stg prod)

# One get-parameters-by-path call per env instead of one get-parameter call
# per service/env, so we make 3 AWS calls total instead of 3 x #SERVICES.
# Run the 3 calls in parallel since they're independent per-account requests.
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT
for env in "${ENVS[@]}"; do
    account="smart-topics-$env-nvirginia"
    aws ssm get-parameters-by-path \
        --profile "$account" \
        --path "/$account" \
        --recursive \
        --region us-east-1 \
        --query "Parameters[].{Name:Name,Value:Value}" \
        --output json > "$TMP_DIR/$env.json" &
done
wait

declare -A PARAMS_JSON
for env in "${ENVS[@]}"; do
    PARAMS_JSON[$env]=$(cat "$TMP_DIR/$env.json")
done

function get_lambda_version() {
    local service_name="$1"
    local env="$2"
    local account="smart-topics-$env-nvirginia"
    # If lambda -> zip-name, if ecs -> image
    param_name=""
    if [[ "$service_name" == lambda* ]]; then
	param_name="$service_name/zip-name"
    elif [[ "$service_name" == "ecs/st-authorizer" ]]; then
	param_name="$service_name/image-version"
    elif [[ "$service_name" == ecs* ]]; then
	param_name="$service_name/image"
    else
	echo "Unknown service type for $service_name"
	return 1
    fi
    service_name=$(basename "$service_name")
    jq -r --arg name "/$account/$param_name" \
        '.[] | select(.Name == $name) | .Value' <<<"${PARAMS_JSON[$env]}" | \
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
