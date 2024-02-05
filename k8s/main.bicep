
param subscriptionId string
param rgName string = 'rgk8s'
param location string = 'westeurope'
param clusterName string
param workerName string
param skuName string = '20.04-LTS'
param adminName string
@secure()
param adminPassCluster string

@secure()
param adminPassWorker string

param nicName string = 'NIC'

module rg '../modules/resourceGroup/resourceGroup.bicep' = {
  scope: subscription(subscriptionId)
  name: 'rgDeply'
  params: {
    resourceGroupName: rgName
    Location: location
    tags: {
      iac: 'bicep'
      app: 'k8s'
    }
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'vnet-k8s'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'cluster-sub'
        properties: {
          addressPrefix: '10.20.0.0/24'
        }
      }
      {
        name: 'worker-sub'
        properties: {
          addressPrefix: '10.20.1.0/24'
        }
      }
    ]
  }
}

resource networkInterfaceClust 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${clusterName}${nicName}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetwork.properties.subnets[0].id
          }
        }
      }
    ]
  }
}

resource networkInterfaceWorker 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${workerName}${nicName}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetwork.properties.subnets[1].id
          }
        }
      }
    ]
  }
}


resource ubuntuVMCluster 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: clusterName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_A2_v2'
    }
    osProfile: {
      computerName: clusterName
      adminUsername: adminName
      adminPassword: adminPassCluster
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: skuName
        version: 'latest'
      }
      osDisk: {
        name: clusterName
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceClust.id
        }
      ]
    }
  }
}

resource ubuntuVMWorker 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: workerName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_A2_v2'
    }
    osProfile: {
      computerName: workerName
      adminUsername: adminName
      adminPassword: adminPassWorker
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: skuName
        version: 'latest'
      }
      osDisk: {
        name: clusterName
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceWorker.id
        }
      ]
    }

  }
}

