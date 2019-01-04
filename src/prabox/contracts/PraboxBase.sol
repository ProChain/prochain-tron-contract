pragma solidity ^0.5.0;

import "./PraboxAccessControl.sol";


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
    struct Candy {
        uint32 candyId;
        string imgurl;
        string backurl;
        string brief;
        string title;
        string landurl;
        uint256 total;
        uint256 balance;
        uint256 perclick;
    }

    struct User {
        address userAddress;
        uint256 balance;
        uint8 count;
        uint256 coldtime; //seconds
        uint256 lasttime; //seconds
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

    /*** FUNCTION ***/
    constructor() public {
        owner = msg.sender;
    }

    function addCandy(
        string memory _img,
        string memory _back,
        string memory _brief,
        string memory _title,
        string memory _landurl,
        uint256 _total,
        uint256 _balance,
        uint256 _perclick
    ) public onlyAdmin returns (uint32) {
        //id++
        uint32 id = uint32(candyList.length) + 1;

        require(id <= 65535);

        Candy memory candy = Candy({
            candyId: id,
            imgurl: _img,
            backurl: _back,
            brief: _brief,
            title: _title,
            landurl: _landurl,
            total: _total,
            balance: _balance,
            perclick: _perclick
        });

        candyList.push(candy);
        candyMap[id] = candy;

        return id;
    }

    function click(uint32 _candyId) public validAddress returns (uint32) {
        Candy memory candy = candyMap[_candyId];
        require(candy.candyId > 0);

        User memory user = userAddrMap[msg.sender];
        require(user.count > 0);

        //TODO: erc20 transfer
        //_address.transfer(candy.perclick);
    }
}