pragma solidity ^0.4.23;

import "./UserInterface.sol";
import "./Access.sol";


contract UserContract is UserInterface, PraboxAccessControl {
    struct User {
        address userAddress;
        uint256 balance;
        uint8 count;
        uint256 coldtime; //seconds
        uint256 lasttime; //seconds
        uint256 authtime;
        bool isValue;
    }

    /*** STORAGE ***/
    User[] userList;
    mapping(address => User) userAddrMap;

    address public praboxAddress;

    /*** EVENTS ***/
    event Auth(address indexed _user);

    /*** FUNCTION ***/
    function isIUser() public pure returns (bool) {
        return true;
    }

    function setPraboxAddress(address _addr) public onlyAdmin {
        praboxAddress = _addr;
    }

    function auth(address userAddress) public onlyAdmin returns (bool) {
        User storage user = userAddrMap[userAddress];
        if (!user.isValue) {
            user.userAddress = userAddress;
            user.balance = 0;
            user.count = 1;
            user.coldtime = 14400;
            user.lasttime = now;
            user.isValue = true;
        }
        user.authtime = now;

        Auth(userAddress);
        
        return true;
    }

    function delUser(address _user) public onlyAdmin {
        User memory user = userAddrMap[_user];
        require(user.isValue);

        delete userAddrMap[_user];
    }

    function click(address _user) public returns (bool) {
        require(msg.sender == praboxAddress || msg.sender == owner);

        User storage user = userAddrMap[_user];
        require(user.isValue && user.authtime + 3600 * 24 >= now);
        require(user.count > 0 || user.lasttime + user.coldtime < now);

        user.count = user.count - 1;
        user.lasttime = now;

        return true;
    }

    function getUser(address _userAddress) public view returns (
        address, 
        uint256, 
        uint8, 
        uint256, 
        uint256, 
        uint256, 
        bool) {
        User memory user = userAddrMap[_userAddress];
        require(user.isValue);
        return (user.userAddress, user.balance, user.count, user.coldtime, user.lasttime, user.authtime, user.isValue);
    }
}