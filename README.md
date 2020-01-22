# Overview

This workshop shows you how to automate performance test execution and analysis tasks within your software delivery pipelines as to scale up the frequency of testing and improve quality of your applications.

The workshop is broken into a set of mini-labs that are meant to be followed sequentially. The lab starts with the all the block and ends with a fully automated process.

* [lab1](./lab1/README.md) - Connect to workshop VM, setup Dynatrace and demo application 
* [lab2](./lab2/README.md) – How Dynatrace helps with performance analysis and automation
* [lab3](./lab3/README.md) – Automated performance test and analysis within a CI/CD pipeline 
* [lab4](./lab4/README.md) – Advanced performance test automation using Neoload

The workshop labs will all use an order processing application that has been designed with built-in performance issues.  The demo application and these problems are described [here](APPLICATION.md)

# Prerequisites

1. This workshop assumes that you are using a pre-built Amazon AMI image that has all the tools and scripts pre-loaded. For details on this image, check out [this repo](https://github.com/dynatrace-neoload-perf-workshop-infra/infra-tooling) that has the automation scripts to built it.

2. This workshop assumes you will have a [Dynatrace SaaS tenant](https://www.dynatrace.com/trial/) and a [Neoload SaaS account and license](https://www.neotys.com/).
