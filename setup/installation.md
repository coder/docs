---
title: "Installation"
description: Learn how to install Coder onto your infrastructure.
---

This article walks you through the process of installing Coder onto your
[Kubernetes cluster](kubernetes/index.md).

## Dependencies

Install the following dependencies if you haven't already:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)

**For production deployments:** set up and use an external
[PostgreSQL](https://www.postgresql.org/docs/12/admin.html) instance to store
data, including workspace information and session tokens.

## For public sector deployments

Users with public sector deployments may need to obtain Coder's installation
resources from
[Big Bang](https://repo1.dso.mil/platform-one/big-bang/apps/developer-tools/coder)
(Helm charts) and
[Ironbank](https://repo1.dso.mil/dsop/coder-enterprise/coder-enterprise/coder-service)
(installation images).

> Both the Big Bang and Ironbank repositories are one release behind the latest
> version of Coder.

## Install Coder

1. Create the Coder [namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/):

```console
kubectl create namespace coder
```

1. Add the Coder Helm repo:

   ```console
   helm repo add coder https://helm.coder.com
   ```

1. Install the Helm chart onto your cluster (see the
   [changelog](../changelog/index.md) for a list of Coder versions or run
   `helm search repo coder -l`)

   > This step will install Coder with the default configuration. This does not
   > set up dev URLs, TLS, ingress controllers, or an external database. To
   > configure these recommended features, please see the following sections.

   ```console
   helm install coder coder/coder --namespace coder --version=<VERSION>
   ```

1. Once `coderd` is running, tail the logs to find the randomly generated
   password for the admin user:

   ```console
   kubectl logs -n coder -l coder.deployment=coderd -c coderd \
    --tail=-1 | grep -A1 -B2 Password
   ```

   When this step is done, you will see:

   ```text
   ----------------------
   User:     admin
   Password: kv...k3
   ----------------------
   ```

   You will need these credentials to continue setup using Coder's web UI.

   > If you lose your admin credentials, you can use the
   > [admin password reset](../admin/access-control/users/password-reset.md#resetting-the-site-admin-password)
   > process to regain access.

1. Create a `values.yaml` file to configure Coder:

   ```console
   helm show values coder/coder --namespace coder --version=<VERSION> > values.yaml
   ```

   > View the
   > [configuration options available in the `values.yaml` file.](https://github.com/coder/enterprise-helm#values)

## Set the super admin password

**Optional**: change the admin user password by updating `values.yaml` as
   follows:

   ```yaml
   superAdmin:
     # Options for configuring the secret used to specify the password for the
     # built-in super admin account.
     passwordSecret:
       # coderd.superAdmin.passwordSecret.name -- Name of a secret that should
       # be used to determine the password for the super admin account. The
       # password should be contained in the field `password`, or the manually
       # specified one.
       name: ""
       # coderd.superAdmin.passwordSecret.key -- The key of the secret that
       # contains the super admin password.
       key: "password"
   ```

## Connect an external database

**Optional**: To configure an externally hosted database, set the following
   in `values.yaml`:

   > Ensure that you have superuser privileges to your PostgreSQL database.

   ```yaml
   postgres:
     default:
       enable: false
     host: HOST_ADDRESS
     port: PORT_NUMBER
     user: YOUR_USER_NAME
     database: YOUR_DATABASE
     passwordSecret: secret-name
     sslMode: require
   ```

   a. To create the `passwordSecret`, run:

   ```console
   kubectl create secret generic <NAME> --from-literal="password=UserDefinedPassword"
   ```

   > Put a space before the command to prevent it from being saved in your shell
   > history.
   >
   > Running this command could potentially expose your database password to
   > other users on your system through `/proc`. If this is a concern, you can
   > use `--from-file=password=/dev/stdin` instead of `--from-literal=...` to
   > enter your password and press `Ctrl+D` when you're done to submit it.
   >
   > Ensure that there are no trailing white spaces in your password secret.

   For more detailed configuration instructions,
   [see our PostgreSQL setup guide](../guides/deployments/postgres.md).
   Alternatively, see our [guide on connecting to AWS RDS via IAM credentials](/guides/admin/awsrds.md).

## Enable dev URLs

**Optional**: Enable dev URL usage.
   [You must provide a wildcard domain in the Helm chart](../admin/devurls.md).

   ```yaml
   coderd:
     devurlsHost: "*.my-custom-domain.io"
   ```

## Enable TLS

**Optional:** To set up TLS:

   a. You will need to create a TLS secret. To do so, run the following with the
   `.pem` files provided by your certificate:

   ```console
   kubectl create secret tls tls-secret --key key.pem --cert cert.pem
   ```

   > If your certificate provider does not provide `.pem` files, then you may
   > need to attach the certificate to the LoadBalancer manually.

   b. Attach the secret to the `coderd` service by setting the following values:

   ```yaml
   coderd:
     tls:
       hostSecretName: <tls-secret>
       devurlsHostSecretName: <tls-secret>
   ```

## Set up an ingress controller

**Optional:** If you cannot use a load balancer, you may need an ingress
   controller. To configure one with Coder, set the following in `values.yaml`:

   > We assume that you already have an ingress controller installed in your
   > cluster.

   ```yaml
   coderd:
     devurlsHost: "*.devurls.coderhost.com"
     serviceSpec:
       # The Ingress will route traffic to the internal ClusterIP.
       type: ClusterIP
       externalTrafficPolicy: ""
     tls:
       hostSecretName: <tls-secret>
       devurlsHostSecretName: <tls-secret>
   ingress:
     enable: true
     # Hostname to use for routing decisions
     host: "coder.coderhost.com"
     # Custom annotations to apply to the resulting Ingress object
     # This is useful for configuring other controllers in the cluster
     # such as cert-manager or the ingress controller
     annotations: {}
   ```

## Configure a proxy

**Optional:** To have Coder initiate outbound connections via a proxy, set
   the following (applicable) values:

   ```yaml
   coderd:
      proxy:
         http: ""
         https: ""
         exempt: "cluster.local"
   ```

Once you've implemented all of the changes in `values.yaml`, upgrade Coder
with the following command:

   ```console
   helm upgrade coder coder/coder --namespace coder --version=<VERSION> -f values.yaml
   ```

## Logging

At this time, we recommend reviewing Coder's default
[logging](../guides/admin/logging.md) settings. Logs help monitor the health of
your cluster and troubleshooting, and Coder offers you several options for
obtaining these.

## Accessing Coder

1. To access Coder's web UI, you'll need to get its IP address by running the
   following in the terminal to list the Kubernetes services running:

   ```console
   kubectl --namespace coder get services
   ```

   You'll see a row named **coderd** with an **EXTERNAL-IP** value; this is the
   IP address you need.

1. In your browser, navigate to the external IP.

1. Use the admin credentials you obtained in this installation guide's previous
   step to log in to the Coder platform. If this is the first time you've logged
   in, Coder will prompt you to change your password.

At this point, you're ready to proceed to [configuring Coder](configuration.md).

## EKS troubleshooting

If you're unable to access your Coder deployment via the external IP generated
by EKS, this is likely due to `coderd` being scheduled onto the incorrect node
group, causing the load balancer health checks to fail. Below are two methods to
resolve this:

1. Set the `externalTrafficPolicy` Helm value to `Cluster` by running the
   following command:

   ```console
   helm upgrade --install coder coder/coder --set coderd.serviceSpec.externalTrafficPolicy=Cluster
   ```

   Note that setting `externalTrafficPolicy` to `Cluster` masks the source IP
   address of your Coder users. For more information on this value,
   [see the Kubernetes documentation](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip).

1. Set the `services.nodeSelector` Helm value to a label assigned to the
   `standard-workers` node group created by AWS. Common labels include:

   ```console
   eks.amazonaws.com/nodegroup=standard-workers
   alpha.eksctl.io/nodegroup-name=standard-workers
   beta.kubernetes.io/instance-type=t3.small
   ```

   This option is recommended if you'd like to preserve the source IP. See the
   [Kubernetes documentation](https://kubernetes.io/docs/reference/labels-annotations-taints/)
   for a full list of the standard node labels.
