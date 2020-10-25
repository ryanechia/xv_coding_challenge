'use strict';

exports.handler = (event, context, callback) => {
    let noCacheHeaders = {
        'cache-control': [{
            key: 'Cache-Control',
            value: 'no-cache'
        }],
        'pragma': [{
            key: 'Pragma',
            value: 'no-cache'
        }],
        'content-type': [{
            key: 'Content-Type',
            value: 'application/json'
        }]
    };

    const response = {
                    status: '200',
                    statusDescription: 'OK',
                    headers: noCacheHeaders,//cachedHeaders,
                    body: 'Hello, logs!';
                };
    callback(null, response);
}