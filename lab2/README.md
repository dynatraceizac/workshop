# Lab 2 Overview

In this lab, learn how to use Dynatrace features that support Performance testing for each phase: scripting, analysis, and reporting.

<img src="images/process.png" width="600"/>

We will use the same demo application from the previous lab and use a simple unix shell script to automate load.  

# Exercises

1. [Tag Tests with HTTP headers](#Tag-Tests-with-HTTP-headers)
1. [Add Request Attributes rules](#Add-Request-Attributes-Rules)
1. [Add Request Naming rules](#Add-Request-Naming-rules)
1. [Add Dynatrace API Token](#Add-Dynatrace-API-Token)
1. [Call Events API](#Call-Events-API)
1. [Call Metrics v2 API](#Call-Metrics-v2-API)
1. [Stop the sample application](#Stop-the-sample-application)

## Tag Tests with HTTP headers

While executing a load test from your load testing tool of choice (JMeter, Neotys, LoadRunner, etc) each simulated HTTP request can be tagged with additional HTTP headers that contain test-transaction information (for example, script name, test step name, and virtual user ID). Dynatrace can analyze incoming HTTP headers and extract such contextual information from the header values and tag the captured requests with request attributes. Request attributes enable you to filter your monitoring data based on defined tags.

You can use any (or multiple) HTTP headers or HTTP parameters to pass context information. The extraction rules can be configured via Settings > Server-side service monitoring > Request attributes.

The header ```x-dynatrace-test``` is used one or more key/value pairs for the header.  Here are some examples:

|Key|Description|
|-----|-----------|
|VU|Virtual User ID of the unique user who sent the request.|
|SI|Source ID identifies the product that triggered the request (JMeter, LoadRunner, Neotys, or other)|
|TSN|Test Step Name is a logical test step within your load testing script (for example, Login or Add to cart.|
|LSN|Load Script Name - name of the load testing script. This groups a set of test steps that make up a multi-step transaction (for example, an online purchase).|
|LTN|The Load Test Name uniquely identifies a test execution (for example, 6h Load Test – June 25)|
|PC|Page Context provides information about the document that is loaded in the currently processed page.|

### Exercise Steps

1. Review the simple shell script 

    ```
    cd ~/hotday/lab2
    more catalog_loadtest.sh
    ```
    This script calls three Order service URLS:
    * open search page: ```/catalog/searchForm.html```
    * perform a search: ```/catalog/searchByName.html```
    * view item detail: ```/catalog/1.html```

    Notice how the each request adds in ```x-dynatrace-test``` header using several keys/pairs for LSN, LTN, and TSN.

        ```
        curl -s "$url/catalog/searchForm.html" -w "%{http_code}" -H "x-dynatrace-test: LSN=$loadScriptName;LTN=$loadTestName;TSN=$testStepName;" -o /dev/nul
        ```

1. In Dynatrace on the left menu, navigate to ```settings --> server-side monitoring --> request attributes```

1. Click ```define a new request attribute``` button and type in the name ```LTN``` and leave the default values

1. Configure the request attribute according to this picture:

    <img src="images/request-attribute.png"/>

    1. Click ```add a new data source``` button and configure as shown below.
    1. ensure ```HTTP request header``` is selected
    1. Fill in the value ```x-dynatrace-test``` for parameter name 
    1. Expand the ```Further restrict or process captured parameters (optional)``` section 
    1. fill in the ```1. Preprocess parameter by extracting substring``` value of ```LSN```
    1. To verify, paste in this values and click the ```preview processed output``` button to verify. 
        ```
        x-dynatrace-test: LSN=MyloadScriptName;LTN=MyLoadTestName;TSN=MytestStepName;
        ```
        <img src="images/request-attribute-verify.png" width="400"/>

1. Save the request attribute rule. 

1. Now repeat the above steps for two more request attributes.  

    |Request attributes Name|Description|Preprocessing parameter|
    |-----|-----------|----|
    |LTN|Load Test Name|LTN=|
    |LSN|Load Step Name|LSN=|
    |TSN|Test Script Name|TSN=|

    At the end you should have three.

    <img src="images/request-attribute-list.png" width="400"/>

1. Run the shell script for 120 seconds 

    ```
    cd ~/hotday/lab2
    ./loadtest.sh 120
    ```

    The output will show the calls along with the HTTP status code.  You should see the HTTP ```200``` code for each call.
    ```
    Load Test Started. DURATION=6 URL=http://[Your IP] THINKTIME=5
    x-dynatrace-test: LSN=order_loadtest.sh;LTN=manual 2019-12-17_14:16:58;
    14:16:58
    calling TSN=CatalogSearchLanding; 200
    calling TSN=CatalogSearch; 200
    calling TSN=CatalogItemView; 200
    ...
    ```

1. Lets checkout Dynatrace and see what happened.  First navigate to ```transactions and services``` and click on the ```order``` service.  On the order service, click on the ```dynamic requests``` button.

    <img src="images/dynamic-requests.png" width="400"/>

1. Now click on the ```request attributes``` button and and review the requests with the names that are defined in the load test.
<img src="images/request-attribute-pages.png" width="500"/>

## Add Request Naming rules

Within Dynatrace, you can use request naming rules to adjust how your requests are tracked and to define business transactions in your customer-facing workflow that are critical to the success of your digital business. With such end-to-end tracing, Dynatrace enables you to view and monitor important business transactions from end to end.

For the demo catalog service, each request URL to view a catalog item has the format ```##.html``` where the number is the product number, so we are going to define a naming rule so that all these request are just called 'product detail.

<img src="images/catalog-requests-before.png" width="400"/>

### Exercise Steps

1. To add a naming rule, click on the ```web request naming rule``` button

    <img src="images/edit-request-names.png" width="400"/>

    NOTE: You can also get to rules at the top of the services page and choosing the ```edit``` option as shown below.

    <img src="images/edit-catalog.png" width="400"/>

1. Within in the service settings, navigate to ```Web request naming``` and click the ```Add rule``` button.

    <img src="images/catalog-naming-rule.png" width="500"/>

1. Configure the rule according to this picture:

    <img src="images/add-rule.png" width="400"/>

    1. Fill in the value ```Item Detail``` for naming patter 
    1. Choose ```URL Path``` and ```contains regex``` with the value ```/\d+.html```
    1. To verify, click the ```preview processed output``` button to verify

1. Save the rule

1. The change will not update past requests, so we need to load script again so that the rule gets applied

    ```
    cd ~/hotday/lab2
    ./loadtest.sh 600
    ```
1. Now we can navigate back the service and click the ```view dynamic requests```

    <img src="images/catalog-view-requests.png" width="500"/>

1. Review the change for the requests.  You may still see the old requests without the new name.

    <img src="images/catalog-requests-after.png" width="400"/>

    Click on the name to make it filtered with the time-series chart.

    By using request attributes in combination with naming rules, you can capture even more context around your requests and use this additional detail to slice and dice your monitoring data.

## Add Dynatrace API Token

Dynatrace has a large set of APIs to manage the Dynatrace configuration such as tag, alert, maintainence windows and the environment such as retrieving timeseries and topology metrics, managing problems and events.

We need to a secure Dynatrace API token for access to the Dynatrace REST-based API.  All API calls pass this token in the request header as in this code sample:

```
curl --request GET \
  --url https://[YOUR TENANT].live.dynatrace.com/api/v1/event \
  --header 'Authorization: Api-Token [YOUR API TOKEN]' 
```

### Exercise Steps

1. To add a new API token, in Dynatrace in the left menu navigate to ```settings --> integration --> Dynatrace API```

1. Click the ```generate token``` button and enter the name ```hotday``` and enable the ```read & write configation``` settings as shown below.

    <img src="images/add-token.png" width="400"/>

1. Save both your Dynatrace URL your token to your cheatsheet file on your laptop. You will need this now and for the other labs.

    ```
    Dyntrace URL: https://[YOUR TENANT].live.dynatrace.com 
    Dyntrace Token: [YOUR DYNATRACE API TOKEN]
    ```

## Call Events API

We are going to review how to use the [events API](https://www.dynatrace.com/support/help/extend-dynatrace/dynatrace-api/environment-api/events/post-event/) to push information-only events to the monitored entities in our tests.  There are serveral types, but will cover the CUSTOM_DEPLOYMENT and CUSTOM_ANNOTATION types.

Here is how a CUSTOM_DEPLOYMENT looks like in Dynatrace. The benefit is that it provides immediate context and links back to tools and teams responsible for changes in the environment.  

<img src="images/event.png" width="400"/>

Each event type takes parameters as shown in the table below.

<img src="images/event-parameters.png" width="500"/>

### Exercise Steps

1. Review the push event script and notice the ```tagRule```. This script will send a CUSTOM_DEPLOYMENT event to all the services with the ENVIRONMENT tag ```app:keptn-orders```.

    ```
    cd ~/hotday/lab2
    cat pushevent.sh
    ```

1. Run the push event script and provide your Dynatrace tenant and API token as parameters 

    ```
    cd ~/hotday/lab2
    ./pushevent.sh https://[YOUR TENANT].live.dynatrace.com [YOUR DYNATRACE API TOKEN]
    ```

    You should see output like this.  NOTE: Those numbers at the end map the to matching Dynatrace entity IDs.

        ```
        Pushing event to: https://[YOUR TENANT].live.dynatrace.com/api/v1/events

        {"storedEventIds":[-6767884103997654659,-8278467612792737421,
        ...
        ...
        ,"3582171445072147045_1576
        726279528","8471371692288947486_1576726279528"],"storedCorrelationIds":[]}
        ```

1. Review event in Dynatrace, by navigating to any of the services.  The event table should look like this.

    <img src="images/mock-event.png" width="500"/>

## Call Metrics v2 API

Many use cases within your software development and delivery pipelines depend on the real-time metrics that your Dynatrace environment collects. One example is the automatic check of monthly load-test results for performance reporting based on Dynatrace synthetic tests.

The Dynatrace REST API endpoint ```/api/v1/timeseries``` has long enabled API consumers to ingest individual metrics for the implementation of external use-cases. In the summer of 2019, an updated of metrics API endpoint ```/api/v2/metrics/series``` based on an improved metrics framework now provides:
* A logical tree structure for all available metric types
* Globally unique metric keys that better integrate over multiple Dynatrace environments
* Flexibility to extend Dynatrace and better fit it to your specific business cases

Lets just show how to call it and can later read more in this [blog](https://www.dynatrace.com/news/blog/integrate-dynatrace-more-easily-using-the-new-metrics-rest-api/) and the [Dynatrace docs](https://www.dynatrace.com/support/help/extend-dynatrace/dynatrace-api/environment-api/metric-v2/)

### Exercise Steps

1. In Dynatrace, navigate to the environment API page from the top right "person" icon

    <img src="images/config-menu.png" width="300"/>

1. On the API web page, pick the 'environment v2' API from the drop down 

    <img src="images/api-v2.png" width="500"/>

1. Pick the 'Authorize' button, scroll to find the 'DataExport section', paste in your API Token, and pick 'Authorize' button

    <img src="images/api-authorize-v2.png" width="400"/>

1. Lets first review the metrics available using the 'GET Metrics' endpoint.  This endpoint lists all metric definitions, with the parameters of each metric. 

    * click the ```Try it``` button
    * Below the 'ClearJust pick the Response content type of ```tex/csv``` 
    * click the ```Execute``` button

    <img src="images/api-call-v2.png" width="500"/>

    I have saved the output to Excel and sorted it. Here are some of the service metrics available.

    <img src="images/metrics-excel.png" width="600"/>

1. Lets now try pulling back some metrics. 

    * Expand the 'GET /metrics/series/{selector}' section.
    * Fill in these values as to get the REQUEST COUNT for the orders service and click the 'Execute' button

    | Parameters | Value |
    |---|---|
    | selector | builtin:service.requestCount.server |
    | resolution | 10m |
    | from | now-2h |
    | scope | tag(service:order),tag([Environment]app:keptn-orders) |

    The results will look like this.  Note the entity ID that is Dynatrace's internal ID for this service.

    <img src="images/api-results-v2.png" width="500"/>

    Experiment with other metrics and times:
    * builtin:service.requestCount.server
    * builtin:service.response.time:avg
    * builtin:service.response.time:percentile(90)

## Stop the sample application

1. Stop the running application so that we can run the next lab

    ```
    # stop up the application
    cd ~/hotday/lab1
    sudo docker-downcompose down
    ```

:arrow_forward: [Next Lab](../lab3)