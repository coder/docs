---
title: Kubernetes Logs
description: Learn how to set up logging in Kubernetes
---

Kubernetes logs can help you understand what's happening under the hood of your Coder
deployment. These logs can be utilized for debugging Coder services and
monitoring the overall health of your cluster. Below are the logging
configuration options available in the [Helm chart](https://github.com/cdr/enterprise-helm).

Coder supports writing logs to multiple output targets. Set these
values to an empty string to disable. Note that both `/dev/stdout` and `/dev/stderr`
can be used interchangeably, as both write to the pod's standard output
and error directories. You can access such logs by running the following:

```kubectl
kubectl -n coder logs <podname>
```

## Human-readable logging

This is the default value set in the Helm chart, as reflected below:

```yaml
logging:
    human: /dev/stderr
```

When set, logs will be sent to the `/dev/stderr` file path, and formatted for human
readability.

## Google Stackdriver logging

If your Kubernetes cluster is deployed on Google Cloud (GCP), you can send logs that
are formatted for Google Stackdriver, by setting the below:

```yaml
logging:
    stackdriver: /dev/stderr
```

## JSON formatted logging

Setting the `json` value will send logs formatted as JSON.

```yaml
logging:
    json: /dev/stderr
```

## Logging to Splunk

Coder can send Kubernetes logs directly to your Splunk deployment for
monitoring and analysis. Splunk uses the HTTP Event Collector (HEC) to
receive data and application logs. See the official [Splunk documentation](https://docs.splunk.com/Documentation/Splunk/8.1.3/Data/UsetheHTTPEventCollector)
on configuring an HEC.

### HEC URL

Input your Splunk HTTP (HEC) endpoint.

```yaml
logging:
    splunk:
        url: ""
```

### HEC token

Input your Splunk HEC collector token.

```yaml
logging:
    splunk:
        token: ""
```

### HEC channel

(Optional) Specify the Splunk channel you'd like to associate all all
messages. Channels allow logs to be segmented per client, helping to
prevent the Coder application logs from impacting other client logs in your
Splunk deployment. See more on [Splunk's official documentation](https://docs.splunk.com/Documentation/Splunk/8.1.3/Data/AboutHECIDXAck#About_channels_and_sending_data).

```yaml
logging:
    splunk:
        channel: ""
```
