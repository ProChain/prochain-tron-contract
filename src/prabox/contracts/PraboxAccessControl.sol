pragma solidity ^0.5.0;


/**
 @title manages special access privileges
 */
contract PraboxAccessControl {

    // the addresses of the accounts (or contracts) that can execute actions
    address public owner;
    address public adminA;
    address public adminB;

    // whether the contract is paused
    bool public paused = false;

    modifier onlyAdmin() {
        require(
            msg.sender == adminA ||
            msg.sender == adminB ||
            msg.sender == owner
        );
        _;
    }

    function setAdminA(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0));
        adminA = newAdmin;
    }

    function setAdminB(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0));
        adminB = newAdmin;
    }

    // Modifier to allow actions only when the contract IS NOT paused
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    // Modifier to allow actions only when the contract IS paused
    modifier whenPaused {
        require(paused);
        _;
    }

    function pause() public onlyAdmin whenNotPaused {
        paused = true;
    }

    function unpause() public onlyAdmin whenPaused {
        paused = false;
    }
}