
targetScope = 'subscription'



resource mma_log_windows 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
    name:'MMA-Windows'
    properties:{
      description:'Install MMA extension on Windows instance and connect it to Log Analytics Workspace'
      displayName:'Install MMA extension on Windows instance and connect it to Log Analytics Workspace'
      metadata: {
        category:'Monitoring'
        version:'1.0.0'
      }
      mode:'All'
      parameters:{}
      policyType:'Custom'
      policyRule:{
        if:{
          allof:[
            {
              field: 'type'
              equals: ''
            }
            {
              field: ''
              equals: ''
            }
          ]
        }
        then: {
          effect: ''
          details: {
            roleDefinitionIds: []
            type:''
            existenceCondition: {}
            deployment:{}
          }
        }
      }
    }
}


resource mma_log_linux 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name:'OMS-Linux'
  properties:{
    description:'Install MMA extension on Linux instance and connect it to Log Analytics Workspace'
    displayName:'Install MMA extension on Linux instance and connect it to Log Analytics Workspace'
    metadata: ''
    mode:''
    parameters:{}
    policyRule:''
    policyType:'Custom'
  }
}
