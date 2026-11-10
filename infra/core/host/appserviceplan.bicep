param name string
param location string = resourceGroup().location
param tags object = {}

param kind string = ''
param reserved bool = true
param sku object = {}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: name
  location: location
  tags: tags
  sku: {
      name: 'S1'
      tier: 'Standard'
      size: 'S1'
      family: 'S'
      capacity: 1
    }
  kind: kind
  properties: {
    reserved: reserved
  }
}

output id string = appServicePlan.id
