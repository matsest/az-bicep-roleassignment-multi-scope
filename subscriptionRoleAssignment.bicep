targetScope = 'subscription'

@description('The principal to assign the role to')
param principalId string

@description('RoleDefinitionId')
param roleDefinitionId string

@description('A new GUID used to identify the role assignment')
param roleNameGuid string = guid(principalId, roleDefinitionId, subscription().subscriptionId)

resource roleAssignSub 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleNameGuid
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
  }
}

output id string = roleAssignSub.id
