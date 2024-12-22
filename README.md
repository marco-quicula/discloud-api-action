# Discloud API Action [![image](https://github.com/user-attachments/assets/528238b4-547e-4d9e-953d-78c1df182210)](https://discloud.com)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)
![GitHub](https://img.shields.io/github/license/marco-quicula/discloud-api-action)

Automate operations on Discloud with this GitHub Action: manage applications, upload files, and monitor status in streamlined workflows.

## How to Use

Add the following to your workflow:

```yaml
jobs:
  discloud:
    runs-on: ubuntu-latest
    steps:
      - name: Discloud Action Upload
        uses: marco-quicula/discloud-api-action@v1
        with:
          # Insert the Discloud API token.
          discloud_api_token: ${{ secrets.DISCLOUD_API_TOKEN }}
          # Insert the command according to the command list.
          command: "<command>"
          # Insert the parameters according to the parameter list for each command.
          <parameter>: <value>
```

### Required Inputs
- `discloud_api_token`: This is the API token required for authentication. You can obtain it from the Discloud control panel.
  
- `command`: This specifies the action to be executed. The available options for this parameter are listed in the Command List table below.

### Optional Parameters
- `<parameter>`: The parameters that are required for each command are detailed in the Parameter List by Command section below. Some parameters may be optional depending on the command.

## Command List

GitHub Action to interact with the Discloud API. Supports the following commands:

| Command      | Description                         |
|--------------|-------------------------------------|
| **userinfo** | Returns user information.           |
| **status**   | Check the status of an application. |
| **delete**   | Remove an application by ID         |
| **upload**   | Upload a file to Discloud.          |
| **commit**   | Changes an application              |

## Parameter list by command

Parameter List by Command:

| Command      | Parameter      | Required | Default Value | Domain           | Description                                              | Example                         |
|--------------|----------------|----------|---------------|------------------|----------------------------------------------------------|---------------------------------|
| **userinfo** | N/A            | N/A      | N/A           | N/A              | N/A                                                      | N/A                             |
| **delete**   | appId          | true     | N/A           | N/A              | Application ID or `all` for all apps.                    | appId:&nbsp;my-app              |
| **status**   | appId          | true     | N/A           | N/A              | Application ID or `all` for all apps.                    | appId:&nbsp;my-app              |
| **upload**   | file           | true     | N/A           | N/A              | File (.zip) to be uploaded.                              | file:&nbsp;"./path/to/file.zip" |
|              | actionIfExists | false    | `DELETE`      | `DELETE\|COMMIT` | Action to be taken if the application is already active. | actionIfExist:&nbsp;COMMIT      |
| **commit**   | appId          | true     | N/A           | N/A              | Application ID.                                          | appId:&nbsp;my-app              |
|              | file           | true     | N/A           | N/A              | File (.zip) to be uploaded.                              | file:&nbsp;path/to/file.zip"    |

## Status of the test workflow on protected branches

| main                                                                                                                                                                                                                                   | develop                                                                                                                                                                                                                                          |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [![Userinfo - Production](https://github.com/marco-quicula/discloud-api-action/actions/workflows/userinfo-main.yaml/badge.svg?branch=main)](https://github.com/marco-quicula/discloud-api-action/actions/workflows/userinfo-main.yaml) | [![Userinfo - Development](https://github.com/marco-quicula/discloud-api-action/actions/workflows/userinfo-develop.yaml/badge.svg?branch=develop)](https://github.com/marco-quicula/discloud-api-action/actions/workflows/userinfo-develop.yaml) |

## Milestones

| Name                                                                                                       | Version | Estimated Delivery Date |
|------------------------------------------------------------------------------------------------------------|---------|-------------------------|
| [First Version Published in Marketplace](https://github.com/marco-quicula/discloud-api-action/milestone/1) | v0.1.0  | December 28, 2024       |
| [Improved Features & Usability](https://github.com/marco-quicula/discloud-api-action/milestone/2)          | v0.2.0  | January 26, 2025        |

Feel free to contribute by opening issues or submitting pull requests. For major changes, please open an issue first to discuss what you would like to change.

---

## License
This project is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0). See the [LICENSE](./LICENSE) file for more details.

![GitHub](https://img.shields.io/github/license/marco-quicula/discloud-api-action)

## Code of Conduct
This project adheres to the [Contributor Covenant](https://www.contributor-covenant.org). You can view the full text in our [Code of Conduct](./CODE_OF_CONDUCT.md).

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)

## Acknowledgements
Special thanks to DisCloud for their amazing API.

[![image](https://github.com/user-attachments/assets/ae507ba2-2ebf-4228-9b49-21de67c03415)](https://discloud.com)

**IMPORTANT: This project does not imply any sponsorship, endorsement, or affiliation with Discloud.**
