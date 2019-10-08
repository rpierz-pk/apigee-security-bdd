Feature:
    Test the Apigee proxy to make sure that it correctly utilizes Security policies

    Scenario: Verify API Key
        Given I set query parameters to
            | parameter   | value                            |
            | apikey      | ${apikey}                        |
         When I GET /verifyapikey
         Then response code should be 200

    Scenario: Verify Incorrect API Key
        Given I set query parameters to
            | parameter |  value                             |
            | apikey    |  abcdefghijklmnopqrstuvwxyz1234567 |
         When I GET /verifyapikey
         Then response code should be 401

    Scenario: Authorize API Key
        Given I have basic authentication credentials ${apikey} and ${apisecret}
          And I set query parameters to
            | parameter  | value              |
            | grant_type | client_credentials |
         When I GET /authorizeapikey
         Then response code should be 200
          And I store the value of body path $.access_token as valid_token in global scope

    Scenario: Fail to authorize invalid API Key
        Given I have basic authentication credentials abcdefghijklmnopqrstuvwxyz1234567 and abcdefg123456
          And I set query parameters to
            | parameter  | value               |
            | grant_type | client_credentials  |
         When I GET /authorizeapikey
         Then response code should be 401

    Scenario: Verify Access Token
        Given I set Authorization header to Bearer `valid_token`
         When I GET /verifyoauth
         Then response code should be 200

    Scenario: Restrict access with invalid Access Token
        Given I set Authorization header to Bearer abcdefghijklmnopqrstuvwxyz12
         When I GET /verifyoauth
         Then response code should be 401

    Scenario: Verify OAuth Scope
        Given I set Authorization header to Bearer `valid_token`
         When I GET /oauthscope
         Then response code should be 200

    Scenario: Restrict access with Invalid Access Token scope
        Given I set Authorization header to Bearer abcdefghijklmnopqrstuvwxyz12
         When I GET /oauthscope
         Then response code should be 401

     Scenario: Deny requests when malicious SQL code is sent as Query Param
         Given I set query parameters to
             | parameter | value                                 |
             | sqlcode   | SELECT * FROM Users; DROP TABLE Users |
          When I GET /sql
          Then response code should be 500

     Scenario: Log requests with API Keys
         Given I set User-Agent header to apickli
           And I set query parameters to
             | parameter | value                                 |
             | apikey    | ${apikey}                             |
          When I GET /logapikey
          Then response code should be 200
