@description('Name of the resource.')
@allowed([
  'Azure.OpenAI'
  'Azure.ContentSafety'
  'Azure.Speech'
])
param name string

@description('Name of the AI Workspace associated with the Endpoint.')
param workspaceName string
@description('ID of the resource associated with the Endpoint.')
param endpointResourceId string

resource workspace 'Microsoft.MachineLearningServices/workspaces@2023-06-01-preview' existing = {
  name: workspaceName
}

resource workspaceEndpoint 'Microsoft.MachineLearningServices/workspaces/endpoints@2023-08-01-preview' = {
  name: name
  parent: workspace
  properties: {
    name: name
    endpointType: name
    associatedResourceId: endpointResourceId
  }
}

// @description('The deployed ML workspace connection resource.')
// output resource resource = workspace::workspaceEndpoint
// @description('ID for the deployed ML workspace connection resource.')
// output id string = workspace::workspaceEndpoint.id
// @description('Name for the deployed ML workspace connection resource.')
// output name string = workspace::workspaceEndpoint.name
