pragma solidity ^0.4.23;

contract Prabox {
    address owner;
    constructor(address _owner) public {
        owner = _owner;
    }

    function click(TokenInterface token) public returns (bool) {
        token.transfer(msg.sender, 1);
    }

}

contract TokenInterface {
    constructor () {}
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {}
    function transfer(address _to, uint256 _value) public returns(bool) {}
}