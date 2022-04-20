# Azure Multi-Container WebApp Lab (az-mcwa-lab)
Sample Azure WebApp MultiContainer repo for low cost multi site deployments.

## Why?
When working on projects that contain many services (or microservices), a rapid choice is to use a Docker Compose + Azure Web App for (Multi) Containers. An easy way to pack a bunch of microservices (containerized) with one of them acting as the main HTTP entry point, by using Docker Compose.

At first sight, a limitation for advance scenarios is this Single HTTP entry point nature. When multiple HTTP endpoints coexist under the same umbrella, sharing resources/services (i.e. a Cache or Pub/Sub), the solution seems to fell short.

**We'll show a way to deploy multi HTTP exposed endpoint, bypassing this limitation.**

## How?
Without further due, here's the front page solution: [Envoy](https://www.envoyproxy.io/).

That's right! We'll use a its proxy capabilities, to reach different endpoints.

