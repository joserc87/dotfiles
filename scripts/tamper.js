// ==UserScript==
// @name         SSO Helper
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Selects the correct AWS account automatically
// @author       Jose Ramon Cano
// @match        https://ravenpacksso.awsapps.com/*
// @icon         https://static.global.sso.amazonaws.com/app-03e8643328913682/icons/default.png
// @require      https://code.jquery.com/jquery-3.6.0.min.js
// @grant        none
// ==/UserScript==


const ACCOUNT_ID = "272551329485"

function wait2Secs() {
  setTimeout(openAWSAccount, 100)
}

function openAWSAccount() {
    var input = $(".selectable")[0]
    if (!input) {
        setTimeout(openAWSAccount, 100)
        return
    }
    input.value = ACCOUNT_ID
    input.dispatchEvent(new Event('input', { bubbles: true }));
    $(".expandIcon").click()
}

(function() {
    'use strict';
    console.log("Script SSO Helper triggered")
    wait2Secs()
    console.log("Script executed")

})();
