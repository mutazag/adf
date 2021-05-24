<!-- TOC -->

- [1. Prep](#1-prep)
- [2. ADF](#2-adf)
    - [2.1. validate pipeline](#21-validate-pipeline)
    - [2.2. build arm templates](#22-build-arm-templates)

<!-- /TOC -->

# 1. Prep
in nodejs console, run
```bash
npm install
```

this will require the file `package.json` to be present in the same folder, with the following content:

```json
{
    "scripts": {
        "build": "node node_modules/@microsoft/azure-data-factory-utilities/lib/index"
    },
    "dependencies": {
        "@microsoft/azure-data-factory-utilities": "^0.1.5"
    }
}

```

the installation will create a folder named `node_modules`, add this folder to the [`.gitignore`](.gitgnore) file if not already done.


# 2. ADF

## 2.1. validate pipeline

-- below are ok

``` bash
npm run build validate c:\git\adf /subscriptions/<Subscription ID>/resourceGroups/datafactorydev/providers/Microsoft.DataFactory/factories/<ADF Name>
```


## 2.2. build arm templates



before:
no need yet to: ---Install-Module Az.DataFactory -Force -AllowClobber

needed to create `arm-template-parameters-definition.json`, param syntax in this url link:
https://docs.microsoft.com/en-us/azure/data-factory/continuous-integration-deployment#custom-parameter-syntax


```bash
npm run build export c:\git\adf /subscriptions/<Subscription ID>/resourceGroups/datafactorydev/providers/Microsoft.DataFactory/factories/<ADF Name> "ArmTemplate"
```

