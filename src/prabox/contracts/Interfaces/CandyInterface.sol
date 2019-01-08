pragma solidity ^0.4.23;


/// @title defined the interface that will handle candy list
interface CandyInterface {

    /// 验证，防止错误设置合约地址
    function isICandy() public pure returns (bool);

    function click(address _user, uint32 _candyId) public returns (bool);
}