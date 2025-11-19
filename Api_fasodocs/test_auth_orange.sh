#!/bin/bash

# Script de test pour l'authentification Orange SMS
# Utilisez ce script pour tester l'authentification directement

echo "🧪 Test d'authentification Orange SMS API"
echo "=========================================="
echo ""

# Credentials
CLIENT_ID="eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG"
CLIENT_SECRET="5LywHmVzKBh2xiUWsqY17wiLfjqcPluDMrAojfcRFhEX"

# Encoder en Base64
CREDENTIALS_BASE64=$(echo -n "${CLIENT_ID}:${CLIENT_SECRET}" | base64)

echo "Client ID: ${CLIENT_ID}"
echo "Client Secret: ${CLIENT_SECRET}"
echo "Authorization Header: Basic ${CREDENTIALS_BASE64}"
echo ""
echo "Test 1: URL standard (v3)"
echo "-------------------------"
curl -X POST https://api.orange.com/oauth/v3/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Basic ${CREDENTIALS_BASE64}" \
  -d "grant_type=client_credentials" \
  -v

echo ""
echo ""
echo "Test 2: URL standard (v3) avec scope"
echo "------------------------------------"
curl -X POST https://api.orange.com/oauth/v3/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Basic ${CREDENTIALS_BASE64}" \
  -d "grant_type=client_credentials" \
  -d "scope=SMS" \
  -v

echo ""
echo ""
echo "Test 3: URL v2 (alternative)"
echo "---------------------------"
curl -X POST https://api.orange.com/oauth/v2/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Basic ${CREDENTIALS_BASE64}" \
  -d "grant_type=client_credentials" \
  -v

