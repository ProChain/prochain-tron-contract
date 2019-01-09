pragma solidity ^0.4.23;

import "./CandyInterface.sol";
import "./Access.sol";


/// @title defined the interface that will handle candy list
contract Candy is CandyInterface, PraboxAccessControl {
    struct Candy {
        uint32 candyId;
        uint256 total;
        uint256 balance;
        uint256 perclick;
        TokenInterface token;
        bool isValue;
    }

    /*** STORAGE ***/
    Candy[] candyList;
    mapping(uint32 => Candy) public candyMap;

    address public praboxAddress;

    /*** FUNCTION ***/
    function isICandy() public pure returns (bool) {
        return true;
    }

    function setPraboxAddress(address _addr) public onlyAdmin {
        praboxAddress = _addr;
    }

    function getCandy(uint32 _candyId) public view returns (
        uint32, 
        uint256, 
        uint256, 
        uint256, 
        address, 
        bool) {
        Candy memory candy = candyMap[_candyId];
        require(candy.isValue);
        return (candy.candyId, candy.total, candy.balance, candy.perclick, candy.token, candy.isValue);        
    }

    function addCandy(
        uint32 _id,
        uint256 _total,
        uint256 _balance,
        uint256 _perclick,
        TokenInterface _token
    ) public onlyAdmin returns (uint32) {
        require(_id <= 65535);

        Candy memory candy = Candy({
            candyId: _id,
            total: _total,
            balance: _balance,
            perclick: _perclick,
            token: _token,
            isValue: true
        });

        candyMap[_id] = candy;
        return _id;
    }

    function delCandy(uint32 _candyId) public onlyAdmin {
        Candy memory candy = candyMap[_candyId];
        require(candy.isValue);

        delete candyMap[_candyId];
    }

    function click(address _user, uint32 _candyId) public returns (bool) {
        require(msg.sender == praboxAddress || msg.sender == owner);

        Candy memory candy = candyMap[_candyId];
        require(candy.isValue && candy.candyId > 0);
        require(candy.perclick <= candy.balance);

        candy.token.transfer(msg.sender, candy.perclick);
        candy.balance = candy.balance - candy.perclick;

        return true;
    }
}


contract TokenInterface {
    constructor () public {}
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {}
    function transfer(address _to, uint256 _value) public returns(bool) {}
}