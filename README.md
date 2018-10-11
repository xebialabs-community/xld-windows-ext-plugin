# XL Deploy Windows Extension Plugin

## Introduction:

The XL Deploy Windows Extension Plugin creates some extensions on the existing Windows Plugin.  Specifically for Windows shops that are building their own Windows Services the deployables in this plugin allow for the installation of these services and service activation.

## installation

1. Install the XebiaLabs windows-plugin
2. Install the xld-windows-ext-plugin by copying the plugin file to the XL Deploy plugins folder and restarting the server.


## Using the deployables and deployeds

### Deployable vs Container table

The following table describes which deployable/container combinations are possible:

|         Deployable        |   Container    |  Generated deployed   |
|---------------------------|----------------|-----------------------|
| windows.dotnetServiceSpec | overthere.Host | windows.dotnetService |
| windows.deployServiceSpec | overthere.Host | windows.deployService |

### Deployable Properties

#### docNet Service Spec

  |  Name                    | Type           | Required | Default    |
  |--------------------------|----------------|----------|------------|
  | serviceName              | string         |          |            |  
  | serviceDisplayName       | string         |    X     |            |
  | DotNetVersion            | string         |    X     | v4.0.30319 |
  | serviceDescription       | string         |          |            |
  | binaryPathName           | string         |    X     |            |
  | dependsOn                | list_of_string |          |            |
  | startupType              | string         |          | Automatic  |
  | targetPath               | string         |    X     |            |
  | targetPathShared         | boolean        |    X     |  true      |
  | createTargetPath         | boolean        |    X     |  true      |
  | username                 | string         |          |            |
  | password                 | password       |          |            |
  | startTimeout             | integer        |    X     |    30      |
  | stopTimeout              | integer        |    X     |    30      |
  | stopStartOnNoop          | boolean        |          |  true      |
  | startOnDeploy            | boolean        |          |  true      |

#### Service Spec

  |  Name                    | Type           | Required | Default    |
  |--------------------------|----------------|----------|------------|
  | serviceName              | string         |          |            |  
  | serviceDisplayName       | string         |    X     |            |
  | serviceDescription       | string         |          |            |
  | binaryPathName           | string         |    X     |            |
  | dependsOn                | list_of_string |          |            |
  | startupType              | string         |          | Automatic  |
  | targetPath               | string         |    X     |            |
  | targetPathShared         | boolean        |    X     |  true      |
  | createTargetPath         | boolean        |    X     |  true      |
  | username                 | string         |          |            |
  | password                 | password       |          |            |
  | startTimeout             | integer        |    X     |    30      |
  | stopTimeout              | integer        |    X     |    30      |
  | stopStartOnNoop          | boolean        |          |  true      |
  | startOnDeploy            | boolean        |          |  true      |

### Control Tasks:

  This plugin also provides control tasks as follows:
  - Stop Service
  - Start Service
  
