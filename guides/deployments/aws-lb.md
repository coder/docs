---
title: AWS' Elastic Load Balancing
description: Learn how to use AWS' Elastic Load Balancing.
---

If you'd like to use AWS' Elastic Load Balancing (ELB), or Classic Load
Balancer, you can do by [updating your Helm
chart](../../guides/admin/helm-charts.md) to include the following (make sure
the replace the placeholder values with those applicable to your AWS account):

```yaml
ingress:
 service:
  annotations:
   service.beta.kubernetes.io/aws-load-balancer-ssl-cert: arn:aws:acm:[region]:[account number]:certificate/[certificate id]
   service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "443"
```

You are welcome to use [additional
annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/service/annotations/),
such as:

```yaml
service.beta.kubernetes.io/aws-load-balancer-internal: "true"
service.beta.kubernetes.io/aws-load-balancer-scheme: "internal"
```

> Please note that AWS' Application Load Balancer (ALB) doesn't support SSH or
> raw TCP and we discourage its use with Coder.
