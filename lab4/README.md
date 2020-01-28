# Lab 4 Overview

Learn how to run automated performance tests within a pipeline and add in a step that validates a Service Level automatically.

In this lab, you will:

1. [Jenkins server setup](#Jenkins-server-setup)
1. [Run the pipeline](#Run-the-pipeline)
1. [Run the pipeline with Service Level Validation](#Run-the-pipeline-with-Service-Level-Validation)
1. [Dashboard and Charts](#Dashboard-and-Charts)
1. [Triage performance issues](#Triage-performance-issues)

The picture below shows what we will complete in this lab.

<img src="images/lab4.png" >

## Jenkins server setup

The lab has a script that will install Jenkins and configure it with the plugin, jobs, and global variables that the jobs expect. To install Jenkins, just run these commands.

```
cd ~/scripts
sudo ./deploy-jenkins.sh
```

This process will take about 2 minutes and at the end it will display the URL to Jenkins

```
=========================================
Running start-jenkins.sh...
Ready!!
=========================================

Jenkins Server
http://x.x.x.x:8080
```

Now open Jenkins in a browser and login with the credentials provided

<img src="images/jenkins-login.png"  width="400">

## Run the pipeline

The pipeline we have provided will deploy the application, execute tests, and push Dynatrace deployment and test events. Here is a diagram of the pipeline steps and interactions with Dynatrace.

<img src="images/jenkins-flow.png" >

1. Navigate to the ```lab3``` section and click on the "pipeline" task

    <img src="images/jenkins-job.png" >

1. Choose the "build with parameters" and click the "build" button to run the pipeline as shown below and then review console log as it runs.

    <img src="images/jenkins-gate-job.png" >

1. Now go back to the "transaction and services" within Dynatrace and choose the order service.  Review newly created events.

1. For the same order service, click on the "view Dynamic requests" and see how the request attributes for the Load Test Name (LTN) was filled in

1. Re-Run the pipeline with the order service version "2" and review console log as it runs.

1. While the job is running, lets review the Jenkinsfile to see the details for the pipeline.

    ```
    cd ~/workshop/lab4
    cat Jenkinsfile
    ```

## Run the pipeline with Service Level Validation

Here is a diagram of the additional validation step and interactions with Dynatrace.

<img src="images/jenkins-flow-gate.png" >

1. The Jenkinsfile will call the validate-service-levels.sh that we manually ran in the previous lab.

    ```
    cd ~/workshop/lab4
    cat Jenkinsfile.withgate
    ```

1. Run the pipeline and review console log as it runs. This will deploy app, execute tests, and push events.  This time notice, new service level parameters.

    <img src="images/jenkins-gate-job.png" >

1. Re-Run the pipeline with the order service version "2" and review console log as it runs.   To see how the automated validation stopped the build.

## Dashboards, Charts and Problems

1. First we can examine the error rates.

   <img src="images/order-errors.png" >
 
1. Now let's adjust the anomaly detection for the order service. 

   <img src="images/anomoly-adjustment.png" >
  
  We will need to change these settings
  * Turn off "global settings"
  * change "Detect increase failure rate" to use "fixed thresholds"
  * change "Alert" to use 3%

1. Run another pipline build with the order service version "2".

   After a few moments, we should see a problem card in Dynatrace.

   <img src="images/problem-card.png" >   

   Now we can also dive into the Problem details.

   <img src="images/problem-details.png" >

## Triage performance issues

Now we can continue and use Dynatrace to analyze the errors.

Use the problem card to drill down into the details, then we will click on the errors on the service.

   <img src="images/failure-rate.png" >

We can then examine the Failure Rates over time,

   <img src="images/failure-chart.png" >

From here click on the "Analyze failure rate degradation", then we will see the error details.

   <img src="images/error-details.png" >  

# Lab 4 Checklist

In this lab, you should have completed the following:

:white\_check\_mark: Run an automated pipeline to execute tests with an automated service level validations

:white\_check\_mark: How to use out of the box Dashboard and Charts to review test results

:white\_check\_mark: Additional Dynatrace features to triage issues

<hr>

:arrow_backward: [Previous Lab](../lab3) | [Next Lab](../lab5) :arrow_forward: 
