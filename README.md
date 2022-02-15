# Demo JIT Gateway server for Marqeta (Node.js/Express)

## Setup

### Set up a Marqeta developer account.

### Load initial data

Reference the `create-initial-data.sh` script, which will run `curl` requests to create the following:

1. Program gateway funding source
2. Card product
3. User `jit-john`, with card
4. User `jit-jane`, with card

The script must be edited. Insert your Marqeta credentials.

Initially, to test JIT funding requests, you can use a Mockbin URL for your program gateway funding source URL. Later, after you have deployed your JIT gateway, you would update the URL for the program gateway funding source to use your deployment URL.

## Local deploy

### Run ngrok

Run `ngrok http 8080` to open a tunnel to your `localhost:8080`.

Copy the HTTPS forwarding URL for your ngrok tunnel.

### Update program gateway funding source URL

[Update the URL for your program gateway funding source](https://www.marqeta.com/docs/core-api/program-gateway-funding-sources#_update_program_gateway_source) to use your ngrok HTTPS forwarding URL (instead of the Mockbin URL).

### Start server

`node index.js`

## Send transaction authorization requests

To test, [simulate transactions](https://www.marqeta.com/docs/core-api/simulating-transactions) on the two cards.
