# Apigee Security Testing

This project exists as a method of automatically testing Apigee proxies for
security implementations using Apickli. 

The current iteration can test
- [x] API Key Authentication
- [x] API Key Authorization
- [x] API Key Logging
- [x] Access Token Validation
- [x] OAuth Scope Validation
- [x] SQL Protection
- [ ] JSON Threat Protection
- [ ] XML Threat Protection
- [ ] PII Data Screening
- [ ] SSL Storage Encryption

The tests are written in plain English in the .feature file
security-test.feature. That English is then translated into test using the
apickli-gherkin file in Apickli.
