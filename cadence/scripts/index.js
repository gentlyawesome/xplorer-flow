import * as fcl from "@onflow/fcl"


const response = await fcl.query({
    cadence: `
      pub fun main(): Int {
        return 1 + 2
      }
    `
  })
  
console.log(response)