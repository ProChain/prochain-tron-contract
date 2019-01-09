pragma solidity ^0.4.23;

import "./BlackInterface.sol";
import "./Access.sol";


contract Blacklist is BlackInterface, PraboxAccessControl {

    struct Black {
        address userAddress;
        uint32 errorCount; //至少 > 0
    }

    /*** STORAGE ***/
    mapping(address => Black) public blackUserMap;

    function isIBlack() public pure returns (bool) {
        return true;
    }

    function validAddress(address _user) public view returns (bool) {
        Black storage black = blackUserMap[_user];
        return (black.errorCount > 0);
    }

    function addblack(address _user) public onlyAdmin {
        Black memory black = Black({
            userAddress: _user,
            errorCount: 1
        });

        blackUserMap[_user] = black;
    }

    function addblack(address _user, uint32 _errorCount) public onlyAdmin {
        require(_errorCount > 0);

        Black memory black = Black({
            userAddress: _user,
            errorCount: _errorCount
        });

        blackUserMap[_user] = black;
    }

    function delblack(address _user) public onlyAdmin {
        Black memory black = blackUserMap[_user];
        require(black.errorCount > 0);

        delete blackUserMap[_user];
    }
}