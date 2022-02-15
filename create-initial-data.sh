#!/bin/sh

# From your Marqeta Developer dashboard page
MQ_APPLICATION_TOKEN="INSERT YOUR APPLICATION TOKEN HERE"
MQ_ADMIN_ACCESS_TOKEN="INSERT YOUR ADMIN ACCESS TOKEN HERE"

# Create a mockbin at https://mockbin.org, then insert mockbin URL here
MOCKBIN_URL="INSERT YOUR MOCKBIN URL HERE"

# Make sure to remove trailing slash from the URL
MQ_BASE_URL="https://sandbox-api.marqeta.com/v3"

GATEWAY_TOKEN="jit_gateway_01"
CARD_PRODUCT_TOKEN="jit_card_product_01"
USER_1_TOKEN="jit_john"
CARD_1_TOKEN="jit_john_card_01"
USER_2_TOKEN="jit_jane"
CARD_2_TOKEN="jit_jane_card_01"

# Create program gateway, using MOCKBIN_URL as gateway endpoint (for now).
curl -i \
  -X POST \
  -H 'Content-Type: application/json' \
  --user $MQ_APPLICATION_TOKEN:$MQ_ADMIN_ACCESS_TOKEN \
  --data '{
  "token":"'"$GATEWAY_TOKEN"'",
  "url":"'"$MOCKBIN_URL"'",
  "basic_auth_username":"unused",
  "basic_auth_password":"This password is 26 characters long.",
  "name":"JIT Gateway Funding Source",
  "active": true
}' \
  $MQ_BASE_URL/fundingsources/programgateway

# Create card product
curl -i \
  -X POST \
  -H 'Content-Type: application/json' \
  --user $MQ_APPLICATION_TOKEN:$MQ_ADMIN_ACCESS_TOKEN \
  --data '{
  "config": {
    "jit_funding": {
      "programgateway_funding_source": {
        "funding_source_token": "'"$GATEWAY_TOKEN"'",
        "always_fund": false,
        "enabled": true,
        "refunds_destination":"GATEWAY"
      }
    },
    "card_life_cycle": {
      "activate_upon_issue": true
    },
    "fulfillment": {
      "payment_instrument": "VIRTUAL_PAN"
    }
  },
  "active": true,
  "name":"JIT Gateway funded card product 01",
  "token":"'"$CARD_PRODUCT_TOKEN"'",
  "start_date":"2022-01-01"
}' \
  $MQ_BASE_URL/cardproducts

# Create user John
curl -i \
  -X POST \
  -H 'Content-Type: application/json' \
  --user $MQ_APPLICATION_TOKEN:$MQ_ADMIN_ACCESS_TOKEN \
  --data '{
  "token":"'"$USER_1_TOKEN"'",
  "first_name":"John"
}' \
  $MQ_BASE_URL/users

# Create user Jane
curl -i \
  -X POST \
  -H 'Content-Type: application/json' \
  --user $MQ_APPLICATION_TOKEN:$MQ_ADMIN_ACCESS_TOKEN \
  --data '{
  "token":"'"$USER_2_TOKEN"'",
  "first_name":"Jane"
}' \
  $MQ_BASE_URL/users

# Create card for John
curl -i \
  -X POST \
  -H 'Content-Type: application/json' \
  --user $MQ_APPLICATION_TOKEN:$MQ_ADMIN_ACCESS_TOKEN \
  --data '{
  "token":"'"$CARD_1_TOKEN"'",
  "user_token":"'"$USER_1_TOKEN"'",
  "card_product_token":"'"$CARD_PRODUCT_TOKEN"'"
}' \
  $MQ_BASE_URL/cards

# Create card for Jane
curl -i \
  -X POST \
  -H 'Content-Type: application/json' \
  --user $MQ_APPLICATION_TOKEN:$MQ_ADMIN_ACCESS_TOKEN \
  --data '{
  "token":"'"$CARD_2_TOKEN"'",
  "user_token":"'"$USER_2_TOKEN"'",
  "card_product_token":"'"$CARD_PRODUCT_TOKEN"'"
}' \
  $MQ_BASE_URL/cards