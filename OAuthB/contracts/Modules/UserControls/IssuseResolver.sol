pragma solidity >=0.6.12 <0.9.0;

import "../../utils/RandomNumber.sol";
import "./NotificationSystem.sol";
import "../../utils/BitWiseOperation.sol";
contract IssuseResolver{
    RandomNumber private rand = new RandomNumber();
    BitWiseOperation private bitop = new BitWiseOperation();
    NotificationSystem private notification_system = new NotificationSystem();
    uint16[] client_ids;
    uint8 [][] public permits;

    function add_permit(uint8[17] memory message) public returns(bool){
        permits.push(message);
        return true;
    }
    function retrive_all() public returns(uint8[][] memory){
        // remoe this function
        return permits;
    }
    function get_permit(uint16 client_id) public returns(uint8[17] memory){
        for(uint8 i = 0;i < permits.length ; i++){
            if(bitop.bit8_mearge(permits[i][2],permits[i][1]) == client_id){
                // temp = permits[i];
                // delete permits[i];
                return bitop.convert_uint8__to_uint817(permits[i]);
            }
        }
    }




    function genrate_token() internal returns(uint16){
        return uint16(rand.get_random(15));
    }
    function is_in(uint16[] memory list,uint16 token) internal returns(bool){
        for(uint8 i = 0; i < list.length; i++){
            if(list[i] == token){
                return true;
            }
        }
        return false;
    }

    function make_client_id() public returns(uint16){
        // todo: make it secure
        uint16 token;
        while(true){
            token = genrate_token();
            if(token == 0) continue;
            if(is_in(client_ids, token) == false){
                client_ids.push(token);
                break;
            }
        }
        return token;
    }
    function create_premit_request(uint16 token,uint8[] memory permission) public returns(bool){
        if(permission.length <= 8){
            if(is_in(client_ids, token)){
                uint8[17] memory permit_issed =  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
                // permit format
                //todo: make <-15-><activation bit>
                permit_issed[0] = uint8(token >> 8);
                permit_issed[1] = uint8(token & (2**8-1));
                uint8 offset = 2;
                for(uint8 i = 0 ; i < permission.length; i++){
                    permit_issed[offset] =  permission[i];
                    offset += 1;
                }
                if(notification_system.add_message(bitop.convert_uint178__to_uint8(permit_issed))){
                    return true;
                }else return false;
            }else return false;
        }
        else return false;

    }

    function get_notification() public returns(uint8[][] memory){
        return notification_system.retrive_notification();
    }

    function permit_verify(uint8[17] memory permit) public returns(bool){
        // todo apply the checks for elemet acess permission
        uint16 token = bitop.bit8_mearge(permit[2], permit[1]);
        add_permit(permit);
        return notification_system.remove_message(token);

    }
}