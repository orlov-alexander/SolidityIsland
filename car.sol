pragma solidity ^0.4.24;
// pragma experimental ABIEncoderV2;

contract Crutch {
    function onERC721Received(address, address, uint32) {}
}

contract CarContract {
    constructor(string name) {
        Crutch crutch = Crutch("crutch_name");
        NameReg(crutch.lookup(1)).register(name);
    }
    
    struct Car {
        uint32 token_id;
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
    
    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _token_id The NFT to transfer
    function safeTransferFrom(address _from, address _to, 
                              uint32 _token_id) external payable{
        require(_from == msg.sender);
        require(_to != address(0));
        transfer(_to, _token_id);
        Crutch crutch = Crutch("crutch_kek");
        if (isContract(_to)) {
            magic = crutch.onERC721Received(_from, _to, _token_id);
            if (!bytes4(keccak256(magic))) {
                revert;
            }
        }
    }
}