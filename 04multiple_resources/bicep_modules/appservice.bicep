// an app service plan to use with web apps or functions
param appServicePlanName string

@allowed([
  'development'
  'production'
])
param environment string

@allowed([
  'Windows'
  'linux'
])
param servicePlanOS string = 'linux'

param tags object = {}
param location string = resourceGroup().location

var environmentSettings = {
  development: {
    sku: 'b1'
  }
  production: {
    sku: 'P1v3'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  tags: tags
  location: location
  kind: servicePlanOS
  sku: {
    name: environmentSettings[environment].sku
  }
  properties: {
    reserved: true
  }
}

output appServicePlan object = appServicePlan
output appServiceName string = appServicePlan.name
