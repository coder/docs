---
title: Logging
description: Learn how to set up logging for your Coder deployment.
---

Logging can help you understand what's happening under the hood of your Coder
deployment and is useful for debugging and monitoring the health of your
cluster.

## Accessing logs

You can access your logs at any time by running:

```console
kubectl -n coder logs <podname>
```

## Exporting logs

The following sections show how you can change your Helm chart values to export
logs.

> See our guide to [updating your Helm chart](helm-charts.md) if you're
> unfamiliar with updating a Helm chart.

Please note that:

- Setting either the `/dev/stdout` or `/dev/stderr` value to an empty string to
  disable.

- You can use `/dev/stdout` and `/dev/stderr` interchangeably, since both write
  to the pod's standard output and error directories.

- Coder supports writing logs to multiple output targets.

## Human-readable logs

This is the default value that's set in the Helm chart:

```yaml
logging:
  human: /dev/stderr
```

When set, logs will be sent to the `/dev/stderr` file path and formatted for
human readability.

## JSON-formatted logs

You can get JSON-formatted logs by setting the `json` value:

```yaml
logging:
  json: /dev/stderr
```

## Sending logs to Google Stackdriver

If you deployed your Kubernetes cluster to Google Cloud, you can send logs to
Stackdriver:

```yaml
logging:
  stackdriver: /dev/stderr
```

## Sending logs to Splunk

Coder can send logs directly to Splunk. Splunk uses the HTTP Event Collector
(HEC) to receive data and application logs. See Splunk's docs for
[information on configuring an HEC](https://docs.splunk.com/Documentation/Splunk/8.1.3/Data/UsetheHTTPEventCollector).

Once you've configured an HEC, you'll need to update your Helm chart with your
HTTP (HEC) endpoint and your HEC collector token.

To provide your HTTP (HEC) endpoint:

```yaml
logging:
  splunk:
    url: ""
```

To provide your HEC collector token:

```yaml
logging:
  splunk:
    token: ""
```

Optionally, you can
[specify the Splunk channel](https://docs.splunk.com/Documentation/Splunk/8.1.3/Data/AboutHECIDXAck#About_channels_and_sending_data).
that you'd like associated with your messages. Channels allow logs to be
segmented by client, preventing Coder application logs from affecting other
client logs in your Splunk deployment.

```yaml
logging:
  splunk:
    channel: ""
```
