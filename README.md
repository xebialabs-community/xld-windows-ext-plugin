# XL Deploy Windows Extension Plugin

[![Build Status][xld-windows-ext-plugin-travis-image]][xld-windows-ext-plugin-travis-url]
[![License: MIT][xld-windows-ext-plugin-license-image]][xld-windows-ext-plugin-license-url]
![Github All Releases][xld-windows-ext-plugin-downloads-image]
![Codacy Badge][xld-windows-ext-plugin-codacy-image]

[xld-windows-ext-plugin-travis-image]: https://travis-ci.org/xebialabs-community/xld-windows-ext-plugin.svg?branch=master
[xld-windows-ext-plugin-travis-url]: https://travis-ci.org/xebialabs-community/xld-windows-ext-plugin
[xld-windows-ext-plugin-license-image]: https://img.shields.io/badge/License-MIT-yellow.svg
[xld-windows-ext-plugin-license-url]: https://opensource.org/licenses/MIT
[xld-windows-ext-plugin-downloads-image]: https://img.shields.io/github/downloads/xebialabs-community/xld-windows-ext-plugin/total.svg
[xld-windows-ext-plugin-codacy-image]: https://api.codacy.com/project/badge/Grade/4212b8dfa4cd4cb6893322b162261f31

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
