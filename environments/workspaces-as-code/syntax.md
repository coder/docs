---
title: "Writing a Workspace template"
description: "Learn how to write a template for creating workspaces"
state: beta
---

## About YAML syntax

Workspace template files are written as YAML and have a .yml or .yaml file
extension. Coder looks for your template at the following path

```
<repository-root>/.coder/coder.yaml
```

## Reference

The following is an example workspace template that makes use of all available
fields. You may not need all of these fields depending on your use case. For
more detailed information on select fields [see below](#config-fields).

```yaml
version: 0.1
workspace:
  type: kubernetes
  spec:
    image: index.docker.io/ubuntu:18.04
    container-based-vm: true
    cpu: 4
    memory: 16
    disk: 128
    gpuCount: 1
    labels:
      com.coder.custom.hello: "hello"
      com.coder.custom.world: "world"
    tolerations:
      - key: my-key
        operator: Equal
        value: my-value
        effect: NoExecute
        tolerationSeconds: 3600
  configure:
    - name: "install curl"
      run: |
        apt update
        apt install -y curl
    - name: "install Go binary"
      run: "go install"
      directory: /home/coder/go/src/github.com/my-project
      shell: "bash"
      env:
        GOPATH: /home/coder/go
```

## Template Fields

### version

The version of the template file being used. The current version is `0.1`.

### workspace

**Required**. Contains all configuration related to the environment.

### workspace.type

**Required**. Determines the type of workspace to be created. The only
acceptable value is `kubernetes`.

### workspace.spec

**Required**. Contains configuration specific to the `workspace.type`.

### workspace.spec.image

**Required**. The image to use for the environment. The image should include the
registry and optionally the tag, i.e. `docker.io/ubuntu:18.04`. If the tag is
omitted, it will default to `latest`.

The image must already be imported on the platform else building the environment
will fail.

### workspace.spec.labels

Kubernetes labels to be added to the environment pod.

#### Labels Example

```yaml
workspace:
  labels:
    com.coder.custom.hello: hello
    com.coder.custom.world: world
```

### workspace.spec.tolerations

A list of
[Kubernetes tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
to be added to the environment pod.

#### Tolerations Example

```yaml
workspace:
  tolerations:
    - key: my-key
      operator: equals
      value: my-value
      effect: NoExecute
      tolerationSeconds: 3600
```

### workspace.spec.gpucount

The number of GPUs to inject into the environment. Defaults to 0. Requires
[GPU acceleration](../../admin/environment-management/gpu-acceleration.md).

### workspace.spec.container-based-vm

Determines whether the environment should be created as a
[container-based VM](../cvms.md). Defaults to `false`.

### workspace.spec.cpu

**Required**. Number of CPU cores to allocate to environments built from this
template.

### workspace.spec.memory

**Required**. Memory in gigabytes to allocate to environments built from this
template.

### workspace.spec.disk

**Required**. Disk space in gigabytes to allocate to environments built from
this template.

### workspace.configure

A list of commands that are run within the environment when an environment is
built.

### workspace.configure.start

A list of commands to run every time an environment is built.

### workspace.configure.start[*].command

**Required**. Runs the provided command within the environment. May use a single
or multi-line command.

- A single-line command:

  ```yaml
  - name: Install curl
    run: apt install -y curl
  ```

- A multi-line command:

  ```yaml
  - name: Update and install curl
    run: |
      apt update
      apt install -y curl
  ```

### workspace.configure.start[*].name

The name of the command being run.

### workspace.configure.start[*].shell

The shell to use for the command.

#### Shell Example

```yaml
start:
  - name: My first step
    shell: /bin/bash
```

### workspace.configure.start[*].directory

The working directory from which the command is run.

#### Directory Example

```yaml
start:
  - name: My first step
    directory: /home/coder
```

### workspace.configure.start[*].env

A map of environment variables to set for the command.

#### Environment Variables Example

```yaml
start:
  - name: My first step
    env:
      HOME: /home/coder
      GOPATH: /home/coder/go
```
