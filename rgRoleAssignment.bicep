targetScope = 'resourceGroup'

@description('The principal to assign the role to')
param principalId string

@description('RoleDefinitionID')
param roleDefinitionId string

@description('A new GUID used to identify the role assignment')
param roleNameGuid string = guid(principalId, roleDefinitionId, resourceGroup().id)

resource roleAssignRg 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleNameGuid
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
  }
}

output id string = roleAssignRg.id
