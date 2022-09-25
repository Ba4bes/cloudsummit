
param prefix string
@allowed([
  'development'
  'production'
])
param environment string
param location string = resourceGroup().location

module app 'bicep_modules/app.bicep' = {
  name: 'appdeployment'
  params: {
    location: location
    appServicePlanName: appservice.outputs.appServiceName
    environment: environment
    webAppName: '${prefix}-appname'
    workspaceName: LOG.outputs.workspaceName
  }
}

module appservice 'bicep_modules/appservice.bicep' = {
  name: 'appServiceDeployment'
  params: {
    location: location
    appServicePlanName: '${prefix}-appServicePlan'
    environment: environment
  }
}

module keyvault 'bicep_modules/keyvault.bicep' = {
  name: 'keyvaultdeployment'
  params: {
    location: location
    keyVaultName: '${prefix}-kv'
  }
}

module LOG 'bicep_modules/loganalytics.bicep' = {
  name: 'logdeployment'
  params: {
    location: location
    workspaceName: '${prefix}-log'
  }
}
