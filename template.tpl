___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Copy Across DataLayers",
  "brand": {
    "id": "jacob-montgomery",
    "displayName": "jacob-montgomery"
  },
  "categories": [
    "UTILITY"
  ],
  "description": "This template can be used to copy one or more events across dataLayers, with a key added to show that the event is a copy. Fill in the data layer names and add the names of events to copy.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "oldDataLayer",
    "displayName": "Name of data layer to copy from",
    "simpleValueType": true,
    "help": "Enter the name of the dataLayer that you want to copy from e.g. dataLayer"
  },
  {
    "type": "TEXT",
    "name": "newDataLayer",
    "displayName": "Name of data layer to write to",
    "simpleValueType": true,
    "help": "Enter the name of the dataLayer that you want to copy to e.g. gtmDataLayer. The template will create this if it doesn\u0027t exist."
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "eventTable",
    "displayName": "Events Table",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "List of events",
        "name": "listOfEvents",
        "type": "TEXT"
      }
    ],
    "help": "Enter as many events to copy across as you want one per row, e.g. pageView, addToCart, checkoutCompleted"
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Required API methods
const logToConsole = require('logToConsole');
const copyFromWindow = require('copyFromWindow');
const createQueue = require('createQueue');
const copyFromDataLayer = require('copyFromDataLayer');
const Object = require('Object');

// Constants
const oldDataLayer = data.oldDataLayer;
const newDataLayer = data.newDataLayer;
const eventsToDuplicate = data.eventTable.map(event => event.listOfEvents);

// Initialize the newDataLayer queue
const newDataLayerPush = createQueue(newDataLayer);

// Function to copy an object
function copyObject(obj) {
  if (typeof obj !== Object){
    logToConsole("Incorrect object format");
    data.gtmOnFailure();
  }
  let copy = {};
  for (let key in obj) {
    if (obj.hasOwnProperty(key)) {
      copy[key] = obj[key];
    }
  }
  return copy;
}

// Function to transform and copy data to newDataLayer
function copyDataLayerEvent(eventData) {
  let duplicateEvent = copyObject(eventData);
  duplicateEvent.event_copy = true;
  newDataLayerPush(duplicateEvent);
  logToConsole("Event copied to newDataLayer:", duplicateEvent);
}

// Function to check if an event is in the list of events to duplicate
function isEventToDuplicate(event) {
  for (let i = 0; i < eventsToDuplicate.length; i++) {
    if (eventsToDuplicate[i] === event) {
      return true;
    }
  }
  return false;
}

logToConsole("Script start");

// Function to intercept dataLayer pushes
function dataLayerInterceptor(event) {
  if (event && typeof event === 'object' && !event.event_copy && isEventToDuplicate(event.event)) {
    logToConsole("Intercepted event to duplicate:", event);
    copyDataLayerEvent(event);
  }
  else {
    data.gtmOnFailure();
  }
  originalDataLayer.push(event);
  return true;
}

// Retrieve the original dataLayer array from the window
const originalDataLayer = copyFromWindow(oldDataLayer) || [];
if (originalDataLayer == []){
  logToConsole("Original datalayer empty");
  data.gtmOnFailure();
}
logToConsole("Original dataLayer:", originalDataLayer);

// Override the dataLayer.push method with the interceptor
function overrideDataLayerPush() {
  const originalPush = originalDataLayer.push;
  originalDataLayer.push = function(event) {
    dataLayerInterceptor(event);
  };
}

// Call override function
overrideDataLayerPush();

// Function to duplicate events
(function duplicatePreExistingEvents() {
  for (let i = 0; i < originalDataLayer.length; i++) {
    const event = originalDataLayer[i];
    if (event.event && !event.event_copy && isEventToDuplicate(event.event)) {
      logToConsole("Duplicating pre-existing event:", event);
      copyDataLayerEvent(event);
    }
  }
})();

// Call data.gtmOnSuccess when the tag is finished.
data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "newDataLayer"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "dataLayer"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedKeys",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []
setup: ''


___NOTES___

Created on 28/05/2024, 17:21:56


