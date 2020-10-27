'use strict';

const axios = require('axios');

const apikey = process.env.OKTA_API_KEY;

const createAppHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': `SSWS ${apikey}`
}

// url and authURL are intentionally wrong because i don't understand this API yet.
// the signonmode is also seemingly incorrect for lambda integration
const createAppBody = {
    "name": "template_basic_auth",
    "label": "Sample Basic Auth App",
    "signOnMode": "BASIC_AUTH",
    "settings": {
        "app": {
            "url": "https://example.com/login.html",
            "authURL": "https://example.com/auth.html"
        }
    }
}

try {
    axios.post(
        'https://outlook-rc-xv-challenge.okta.com/api/v1/apps',
        createAppBody,
        {headers: createAppHeaders}
    ).then(
        (response) => {
            console.log(response)
            /*
                since intending to use https://github.com/Widen/cloudfront-auth as the lambda generator,
                we can use `fs.writefile` to save the information it requires in a ENV file to be read later,

                OR

                fork an implementation in a local function.
             */
        },
        (err) => {
            console.error(err)
        }
    );

} catch (e) {
    console.error(e);
}
