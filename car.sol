pragma solidity ^0.4.24;
// pragma experimental ABIEncoderV2;

contract Crutch {
    function onERC721Received(address, address, uint32, bytes) returns (bytes4);
}

contract CarContract {
    
    struct Car {
        uint32 token_id;
        address owner;
        string color;
        string engine;
        string reg_number;
    }
    mapping(uint32 => Car) cars;
    mapping(uint32 => address) ownerOf;

    uint32 public total_cars = 0;
    bytes4 private constant magic = 0x150b7a02;
    
    event Transfer(address from, address to, uint32 token_id);
    
    function transfer(address _to, uint32 _token_id) public {
        require(ownerOf[_token_id] == msg.sender);
        Car car = cars[_token_id];
        car.owner = _to;
        cars[_token_id] = car;
        ownerOf[_token_id] = _to;
        emit Transfer(msg.sender, _to, _token_id);
    }
    
    function createCar(string _color, string _engine) public {
        uint32 id = total_cars;
        address car_owner = msg.sender;
        ownerOf[id] = car_owner;
        cars[id] = Car({token_id: id, owner: car_owner,
                       color: _color, engine: _engine, reg_number: ''});
        total_cars++;
    }
    
    function changeColor(uint32 _token_id, string _color) public {
        require(ownerOf[_token_id] == msg.sender);
        cars[_token_id].color = _color;
    }
    
    function changeEngine(uint32 _token_id, string _engine) public {
        require(ownerOf[_token_id] == msg.sender);
        cars[_token_id].engine = _engine;
    }
    
    function changeRegNumber(uint32 _token_id, string _reg_number) public {
        require(ownerOf[_token_id] == msg.sender);
        cars[_token_id].reg_number = _reg_number;
    }
    
    function demolishCar(uint32 _token_id) public {
        require(ownerOf[_token_id] == msg.sender);
        cars[_token_id] = Car({token_id: _token_id, owner: address(0),
                               color: '', engine: '', reg_number: ''});
        ownerOf[_token_id] = address(0);
    }

    function get_car(uint32 _token_id) public returns (uint32, address, 
        string, string, string)
    {
        Car car = cars[_token_id];
        return (car.token_id, car.owner, car.color, car.engine, car.reg_number);
    }
    
    function isContract(address _addr) private returns (bool isContract){
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }
    
    function safeTransferFrom(address _from, address _to, 
                              uint32 _token_id) external payable{
        require(_from == msg.sender);
        require(_to != address(0));
        transfer(_to, _token_id);
        if (isContract(_to)) {
            bytes4 value = Crutch(_to).onERC721Received(_from, _to, _token_id, "");
            require(bytes4(keccak256(value)) != magic);
        }
    }
}