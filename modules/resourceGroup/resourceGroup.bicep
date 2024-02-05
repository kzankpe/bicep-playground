targetScope = 'subscription'

@description('Azure region where the resource will be deployed')
param Location string

@description('Resource Group Name')
param resourceGroupName string

@description('Tags to apply to the resource group')
param tags object = {}

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: Location
  tags: tags
}

output outResourceGroupId string = rg.id
