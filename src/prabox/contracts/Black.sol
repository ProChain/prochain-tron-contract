pragma solidity ^0.4.23;

import "./BlackInterface.sol";
import "./Access.sol";


contract BlackContract is BlackInterface, PraboxAccessControl {

    struct Black {
        address userAddress;
        uint8 blackType; //至少 > 0
        bool isValue;
    }

    /*** STORAGE ***/
    mapping(address => Black) public blackUserMap;

    function isIBlack() public pure returns (bool) {
        return true;
    }

    function validAddress(address _user) public view returns (bool) {
        Black storage black = blackUserMap[_user];
        return (!black.isValue);
    }

    function addblack(address _user) public onlyAdmin {
        Black memory black = Black({
            userAddress: _user,
            blackType: 1,
            isValue: true
        });

        blackUserMap[_user] = black;
    }

    function addblack(address _user, uint8 _blackType) public onlyAdmin {
        require(_blackType > 0);

        Black memory black = Black({
            userAddress: _user,
            blackType: _blackType,
            isValue: true
        });

        blackUserMap[_user] = black;
    }

    function delblack(address _user) public onlyAdmin {
        Black memory black = blackUserMap[_user];
        require(black.isValue);

        delete blackUserMap[_user];
    }
}