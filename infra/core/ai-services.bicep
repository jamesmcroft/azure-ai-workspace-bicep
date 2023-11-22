@description('Name of the resource.')
param name string
@description('Location to deploy the resource. Defaults to the location of the resource group.')
param location string = resourceGroup().location
@description('Tags for the resource.')
param tags object = {}

type roleAssignmentInfo = {
  roleDefinitionId: string
  principalId: string
}

@description('List of deployments for the AI Services.')
param deployments array = []
@description('Whether to enable public network access. Defaults to Enabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'
@description('Role assignments to create for the AI Services instance.')
param roleAssignments roleAssignmentInfo[] = []

resource aiServices 'Microsoft.CognitiveServices/accounts@2023-10-01-preview' = {
  name: name
  location: location
  tags: tags
  kind: 'AIServices'
  properties: {
    customSubDomainName: toLower(name)
    publicNetworkAccess: publicNetworkAccess
  }
  sku: {
    name: 'S0'
  }
}

@batchSize(1)
resource deployment 'Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview' = [for deployment in deployments: {
  parent: aiServices
  name: deployment.name
  properties: {
    model: contains(deployment, 'model') ? deployment.model : null
    raiPolicyName: contains(deployment, 'raiPolicyName') ? deployment.raiPolicyName : null
  }
  sku: contains(deployment, 'sku') ? deployment.sku : {
    name: 'Standard'
    capacity: 20
  }
}]

resource assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for roleAssignment in roleAssignments: {
  name: guid(aiServices.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
  scope: aiServices
  properties: {
    principalId: roleAssignment.principalId
    roleDefinitionId: roleAssignment.roleDefinitionId
    principalType: 'ServicePrincipal'
  }
}]

@description('ID for the deployed AI Services resource.')
output id string = aiServices.id
@description('Name for the deployed AI Services resource.')
output name string = aiServices.name
@description('Endpoint for the deployed AI Services resource.')
output endpoint string = aiServices.properties.endpoint
@description('Host for the deployed AI Services resource.')
output host string = split(aiServices.properties.endpoint, '/')[2]
