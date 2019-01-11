pragma solidity ^0.4.23;

import "./Access.sol";
import "./BlackInterface.sol";
import "./UserInterface.sol";
import "./CandyInterface.sol";


/**
    @title Holds all common structs, events and base variables.
*/
contract PraboxBase is PraboxAccessControl {
    /*** STORAGE ***/
    //black list
    address public blackContractAddress;
    BlackInterface internal iBlack;

    //user list
    address public userContractAddress;
    UserInterface internal iUser;

    //candy list
    address public candyContractAddress;
    CandyInterface internal iCandy;

    /*** EVENTS ***/
    event ClickEvent(address indexed _user, uint32 indexed _candyId);

    /*** FUNCTION ***/
    function setBlackContract(address _iblack) public onlyAdmin {
        iBlack = BlackInterface(_iblack);
        require(iBlack.isIBlack());
        blackContractAddress = _iblack;
    }

    function setUserContract(address _iuser) public onlyAdmin {
        iUser = UserInterface(_iuser);
        require(iUser.isIUser());
        userContractAddress = _iuser;
    }

    function setCandyContract(address _icandy) public onlyAdmin {
        iCandy = CandyInterface(_icandy);
        require(iCandy.isICandy());
        candyContractAddress = _icandy;
    }

    function click(uint32 _candyId) public whenNotPaused returns (uint32) {
        //check blacklist
        require(iBlack.validAddress(msg.sender), "#PRABOXERROR$101# user is banned");

        //click candy
        require(iUser.click(msg.sender) && iCandy.click(msg.sender, _candyId));
        
        ClickEvent(msg.sender, _candyId);

        return _candyId;
    }
}