# Multi-scope role assignment in Bicep

This is a simple demo of how to (ab)use scoping and extension type resources in Bicep with a `main.bicep` that deploys at the subscription scope the option to create a role assignment at either subscription, resource group or resource scope with one template.

Depending on the `type` parameter the main template invokes one of three templates as modules. Note that due
to missing support (see issues [2245](https://github.com/Azure/bicep/issues/2245), [1761](https://github.com/Azure/bicep/issues/1761)) of fully parametrized scoping in Bicep an ARM template is used for the role assignment on resource scope.

## Parameters

- `principalId` (string): The principal (object) id of the user or serviceprincipal to assign a role for
- `builtInRoleType` (string): One of `Owner`, `Contributor` or `Reader` (default)
- `type` (string): One of `resource`, `resourceGroup` or `subscription` (default)
- `resourceGroupName` (string): the name of a resource group. Only set if `type = resourceGroup`.
- `resourceId` (string): the full id of a resource. Only set if `type = resource`.
- `subscriptionId` (string): the guid of an subscription. Defaults to the id of the deployment scope.

## Usage

### Subscription scope

```bash
az deployment sub create -n roleassignment-subscription -f main.bicep \
    --parameters principalId=<id> type=subscription
```

### Resource Group scope

```bash
az deployment sub create -n roleassignment-rg -f main.bicep \
    --parameters principalId=<id> type=resourceGroup resourceGroupName=<rg name>
```

### Resource scope

```bash
az deployment sub create -n roleassignment-res -f main.bicep \
    --parameters principalId=<id> type=resource resourceId=<resource ID>
```

## More information

- [Set scope for extension resources in Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/scope-extension-resources)
- [Set scope for extension resource in ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/scope-extension-resources?tabs=azure-cli)

> Disclaimer: Tested with Bicep version 0.4.1124