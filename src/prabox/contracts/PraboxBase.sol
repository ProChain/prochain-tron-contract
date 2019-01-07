pragma solidity ^0.4.23;

import "./Access.sol";


library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0); // Solidity only automatically asserts when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        if (b > a) {
            return 0;
        } else {
            uint256 c = a - b;
            return c;
        }
    }

    /**
    * @dev Adds two numbers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}


/**
    @title Holds all common structs, events and base variables.
*/
contract PraboxBase is PraboxAccessControl {
    // struct Candy {
    //     uint32 candyId;
    //     string imgurl;
    //     string backurl;
    //     string brief;
    //     string title;
    //     string landurl;
    //     uint256 total;
    //     uint256 balance;
    //     uint256 perclick;
    // }

    struct Candy {
        uint32 candyId;
        uint256 total;
        uint256 balance;
        uint256 perclick;
        TokenInterface token;
        bool isValue;
    }
    
    struct User {
        address userAddress;
        uint256 balance;
        uint8 count;
        uint256 coldtime; //seconds
        uint256 lasttime; //seconds
        uint256 authtime;
        bool isValue;
    }

    struct Black {
        address userAddress;
        uint32 errorCount; //至少 > 0
    }

    /*** CONSTANTS ***/
    uint32[14] public cooldowns = [
        uint32(1 minutes),
        uint32(2 minutes),
        uint32(5 minutes),
        uint32(10 minutes),
        uint32(30 minutes),
        uint32(1 hours),
        uint32(2 hours),
        uint32(4 hours),
        uint32(8 hours),
        uint32(16 hours),
        uint32(1 days),
        uint32(2 days),
        uint32(4 days),
        uint32(7 days)
    ];

    /*** STORAGE ***/
    User[] userList;
    mapping(address => User) userAddrMap;

    Candy[] candyList;
    mapping(uint32 => Candy) public candyMap;

    mapping(address => Black) blackUserMap;

    /*** MODIFIER ***/
    modifier validAddress() {
        address _address = msg.sender;
        Black memory black = blackUserMap[_address];
        require(black.errorCount > 0);
        _;
    }

    /*** EVENTS ***/
    event ClickEvent(address indexed _user, uint32 indexed _candyId, uint256 _perclick);

    /*** FUNCTION ***/
    constructor() public {
        owner = msg.sender;
    }

    function addCandy(
        uint32 _id,
        uint256 _total,
        uint256 _balance,
        uint256 _perclick,
        TokenInterface _token
    ) public onlyAdmin returns (uint32) {
        //id++

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

    function click(uint32 _candyId) public whenNotPaused returns (uint32) {
        Candy storage candy = candyMap[_candyId];
        require(candy.candyId > 0 && candy.isValue);

        User storage user = userAddrMap[msg.sender];
        require(user.isValue && user.authtime + 3600 * 24 >= now);
        require(user.count > 0 || user.lasttime + user.coldtime < now);
        require(candy.perclick <= candy.balance);
        candy.token.transfer(msg.sender, candy.perclick);
        candy.balance = candy.balance - candy.perclick;
        user.count = 0;
        user.lasttime = now;

        ClickEvent(msg.sender, candy.candyId, candy.perclick);

        return _candyId;
    }

    function auth(address userAddress) public onlyAdmin returns (bool) {
        User storage user = userAddrMap[userAddress];
        if (!user.isValue) {
            user.userAddress = msg.sender;
            user.balance = 0;
            user.count = 1;
            user.coldtime = 14400;
            user.lasttime = now;
            user.isValue = true;
        }
        user.authtime = now;
        return true;
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


contract TokenInterface {
    constructor () public {}
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {}
    function transfer(address _to, uint256 _value) public returns(bool) {}
}