targetScope = 'subscription'

param principalId string

@allowed([
  'Owner'
  'Contributor'
  'Reader'
])
param builtInRoleType string = 'Reader'

// Only use if type is resourceGroup
param resourceGroupName string = ''

// Only use if type is subscription or resourceGroup
param subscriptionId string = subscription().subscriptionId

// Only use if type is resource
param resourceId string = ''

@allowed([
  'resourceGroup'
  'subscription'
  'resource'
])
param type string = 'resourceGroup'

var roleMap = {
  Owner: '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Contributor: '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader: '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7'
}

// This is a hack to transform a resource ID: /subscriptions/<id>/resourceGroups/<rg-id>/<res-id> -> <rg-id>
//   1) /subscriptions/<id>/resourceGroups/<rg-id>/<res-id -> [ '/subscriptions/id', '<rg-id>/<res-id>' ]
//      and with the last entry
//   2) <rg-id>/<res-id> -> <rg-id>
var rgFromResourceId = (type == 'resource') ? split(split(resourceId, '/resourceGroups/')[1], '/')[0] : ''

// if type == resource
module resourceRoleAssignment 'resourceRoleAssignment.json' = if (type == 'resource') {
  name: 'foo-resource'
  scope: resourceGroup(subscriptionId, rgFromResourceId)
  params: {
    resourceId: resourceId
    principalId: principalId
    roleDefinitionId: roleMap[builtInRoleType]
  }
}

// if type == subscription
module subscriptionRoleAssignment 'subscriptionRoleAssignment.bicep' = if (type == 'subscription') {
  name: 'foo-sub'
  scope: subscription(subscriptionId)
  params: {
    principalId: principalId
    roleDefinitionId: roleMap[builtInRoleType]
  }
}

// if type == resourceGroup
module resourceGroupRoleAssignment 'rgRoleAssignment.bicep' = if (type == 'resourceGroup') {
  name: 'foo-rg'
  scope: resourceGroup(resourceGroupName)
  params: {
    principalId: principalId
    roleDefinitionId: roleMap[builtInRoleType]
  }
}

// Conditional outputs depending on type
output resourceGroupRoleAssignmentId string = (type == 'resourceGroup') ? resourceGroupRoleAssignment.outputs.id : ''
output resourceRoleAssignmentId string = (type == 'resource') ? resourceRoleAssignment.outputs.id : ''
output subscriptionRoleassignmentId string = (type == 'subscription') ? subscriptionRoleAssignment.outputs.id : ''
