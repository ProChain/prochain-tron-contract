pragma solidity ^0.4.23;


/// @title defined the interface that will handle black list
contract BlackInterface {

    /// 验证，防止错误设置合约地址
    function isIBlack() public pure returns (bool);

    function validAddress(address _user) public view returns (bool);
}