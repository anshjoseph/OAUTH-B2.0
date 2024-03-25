// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;


import "./Modules/ControlSystem.sol";
import "./utils/EventManager.sol";



contract EntryPoint{
    uint32 private secret;
    bool private Debug = true;
    uint128 private key;
    uint8[17] private sbox;
    uint8[][17] private telemetry_data;
    address private Owner;
    
    // control system for program flow management
    ControlSystem private control_system = new ControlSystem(); 
    
    // telemetry events for contract
    EventManager private event_manager = new EventManager(Debug);

    constructor(uint32 _secret,uint128 _key,uint8[17] memory _sbox) public {
        secret = _secret;
        key = _key;
        sbox = _sbox;
        Owner = msg.sender;
        control_system.set_owner(Owner);
    }
    
    function client_communication(uint8[17] memory payload) external returns(uint8[17] memory){
        return control_system.control_system_client(payload);
    }

    function user_communication(uint8[17] memory payload) external returns(uint8[17] memory){
        return control_system.control_system_user(msg.sender, payload);
    }

}