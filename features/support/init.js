'use strict';

const apickli = require('apickli');
const {Before} = require('cucumber');

Before(function() {
  this.apickli = new apickli.Apickli('http', 'rpierz-eval-test.apigee.net/bdd-security-testing');
  this.apickli.addRequestHeader('Cache-Control', 'no-cache');
});

