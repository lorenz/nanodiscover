# NanoDiscover
*A minimal local network discovery module*

## Installation
    npm install --save nanodiscover

## Usage
Create an announcer:

    discover = require("nanodiscover")
    discover.createAnnouncer("myprogram","1.0.0") // Version is optional

Create a browser:

    discover = require("nanodiscover")
    browser = discover.createBrowser("myprogram","1.0.0")
    browser.on("nodeUp",function (ip) {
      console.log("Found Node with IP ", ip);
    });
    browser.on("nodeDown",function (ip) {
      console.log("Lost node with IP ", ip);
    });

    setTimeout(function () {
      console.log("We know the following nodes: ",browser.nodes);
    },1000);

## License
See LICENSE file
