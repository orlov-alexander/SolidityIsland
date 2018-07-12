pragma solidity ^0.4.24;

contract CarContract {
    struct Car {
        uint token_id;
        address owner;
        string color;
        string engine;
        string reg_number;
    }
    /// vin = token_id
    mapping(uint32 => Car) cars;
    mapping(uint32 => address) ownerOf;

    uint32 public total_cars = 0;
    
    event Transfer(address from, address to, uint32 token_id);
    
    function transfer(address _to, uint32 _token_id) public {
        require(ownerOf[_token_id] == msg.sender);
        ownerOf[_token_id] = _to;
        emit Transfer(msg.sender, _to, _token_id);
    }
    
    function createCar(string _color, string _engine) public {
        total_cars++;
        uint32 id = total_cars;
        address car_owner = msg.sender;
        ownerOf[id] = car_owner;
        cars[id] = Car({token_id: id, owner: car_owner,
                       color: _color, engine: _engine, reg_number: ''});
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
}