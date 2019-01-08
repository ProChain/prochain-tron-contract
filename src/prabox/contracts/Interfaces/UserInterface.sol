pragma solidity ^0.4.23;


/// @title defined the interface that will handle user levels
contract UserInterface {

    /// 验证，防止错误设置合约地址
    function isIUser() public pure returns (bool);

    function click(address _user) public returns (bool);
}