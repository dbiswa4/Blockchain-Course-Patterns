pragma solidity ^0.4.4;

/**
 * Creates a registry for contracts
 **/
contract NameRegistry {

  // Manages info about the contract instance
  struct ContractInfo {
    address   owner;
    address   contractInstance;
    // The first version added to registry MUST be >= 1
    // Otherwise the name will NOT be added
    uint16    version;
  }

  // Manages the name to address mapping
  mapping(bytes32 => ContractInfo)  nameInfo;
  modifier  OwnerOnly(address owner) {if(msg.sender != owner) throw; else _;}

  // Adds the version of the contract to be used by apps
  function  registerName (bytes32 name, address conAddress, uint16  ver) returns(bool){

    // Version MUST start with number 1
    if(ver < 1) throw;

    ContractInfo  conInfo = nameInfo[name];
    if(conInfo.contractInstance == 0){
      nameInfo[name] = ContractInfo(msg.sender, conAddress, ver);
    } else {
      if(conInfo.owner != msg.sender)  return false;
      conInfo.contractInstance = this;//conAddress;
      conInfo.version = ver;
    }
    return true;
  }

  // Contracts having a dependency on this contract will invoke this function
  function  getContractInfo(bytes32 name) constant returns(address,uint16){
    return (nameInfo[name].contractInstance, nameInfo[name].version);
  }

  function  removeContract() returns(bool){
    // Code this on your own
    return false;
  }

}
