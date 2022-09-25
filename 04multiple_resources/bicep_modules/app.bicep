// an app service plan to use with web apps or functions

param appServicePlanName string
param workspaceName string
@allowed([
  'development'
  'production'
])
param environment string

param linuxFxVersion string = 'DOTNETCORE|6.0'

param tags object = {}
param location string = resourceGroup().location

//  Azure web app
param webAppName string

var environmentSettings = {
  development: {
    httpsEnforced: false
  }
  production: {
    httpsEnforced: true
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' existing = {
  name: appServicePlanName
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' existing = {
  name: workspaceName
}

resource webApp 'Microsoft.Web/sites@2020-12-01' = {
  name: webAppName
  tags: tags
  location: location
  properties: {
    httpsOnly: environmentSettings[environment].httpsEnforced
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: insights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: insights.properties.ConnectionString
        }
      ]
      linuxFxVersion: linuxFxVersion
    }
  }
}

resource insights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${webAppName}-insights'
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspace.id
    IngestionMode: 'LogAnalytics'
  }
}

output webApp object = webApp
