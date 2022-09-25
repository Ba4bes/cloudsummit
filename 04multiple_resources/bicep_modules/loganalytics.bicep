param location string = resourceGroup().location
param workspaceName string

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: workspaceName
  location: location
  properties: { 
  }
}

output workspace object = workspace
output workspaceName string = workspace.name
