# Azure Multi-Container WebApp Lab (az-mcwa-lab)
Azure WebApp (Multi) Container way to do low cost multi HTTP containers deployments for testing.

## Why?

Have you ever needed to dev/test a containerized multiservice application using docker compose,  running in the cloud? Has your application more than one host exposed through HTTP (*)?

(*) As you'll find in the "Limitations" section, under "Docker Compose", being primarily an App Service, attaches itself to a **single** container that exposes ports 8080 or 80, mapping it as the HTTP(S) entry point. *Source post: https://azure.github.io/AppService/2018/05/07/Multi-container-Linux-Web-App.html* 

When working on projects that contain many services (or microservices), a quick option is to use a Docker Compose + Azure Web App for (Multi) Containers. It's an easy way to pack a bunch of microservices (containerized) using Docker Compose, with one of them acting as the main HTTP entry point.

At first sight, a limitation for advance scenarios is its **single** HTTP entry point nature. When multiple HTTP endpoints coexist under the same umbrella the solution seems to fell short.

**We'll show a way to deploy multi HTTP exposed endpoint, bypassing this limitation.**

## How?
Without further due, here's the front page solution: [Envoy](https://www.envoyproxy.io/).

That's right! We'll use a its proxy capabilities, to reach different endpoints from a single entry point.

## What's this?
*[elaborate]*

## Run it!

> Please keep in mind that, although tempting and cheap, going to PROD with something like this, can eventually lead you into troubles down the line. Our suggestion: **use for testing only**

*[elaborate]*