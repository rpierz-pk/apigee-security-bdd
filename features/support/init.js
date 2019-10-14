'use strict';

const apickli = require('apickli');
const {Before} = require('cucumber');
const fs = require('fs');


Before(function() {
  this.apickli = new apickli.Apickli('http', 'rpierz-eval-test.apigee.net/bdd-security');
  this.apickli.addRequestHeader('Cache-Control', 'no-cache');
  
  
  this.apickli.setGlobalVariable('clientId',fs.readFileSync('features/support/credentials/client-id.txt').toString().trim('%0A'));
  this.apickli.setGlobalVariable('clientSecret',fs.readFileSync('features/support/credentials/client-secret.txt').toString().trim('%0A'));
 });

