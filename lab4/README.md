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

## Dashboard and Charts

Show how can see the failure and drill into analysis and compare build 1 to 2

1. First we can examine the error rates.

   <img src="images/order-errors.png" >

## Triage performance issues

Show how can see the look at the hot spots and exceptions from build 2

# Lab 4 Checklist

In this lab, you should have completed the following:

:white\_check\_mark: Run an automated pipeline to execute tests with an automated service level validations

:white\_check\_mark: How to use out of the box Dashboard and Charts to review test results

:white\_check\_mark: Additional Dynatrace features to triage issues

<hr>

:arrow_backward: [Previous Lab](../lab3) | [Next Lab](../lab5) :arrow_forward: 
