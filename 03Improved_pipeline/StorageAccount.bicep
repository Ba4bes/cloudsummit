@maxLength(11)
param storageAccountPrefix string = 'bicep'
param location string = resourceGroup().location

var staName = toLower('${storageAccountPrefix}${uniqueString(subscription().id)}')

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: staName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
