// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Footprint {
    mapping(address => bool) public contractList;
    mapping(address => bool) public claimed;
    ERC20 public useToken;
    address public owner;
    
    constructor(address _useToken) {
        useToken = ERC20(_useToken);
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }
    
    function addContract(address contractAddress) external onlyOwner {
        require(!contractList[contractAddress], "Contract already added");
        contractList[contractAddress] = true;
    }
    
    function removeContract(address contractAddress) external onlyOwner {
        require(contractList[contractAddress], "Contract not added");
        contractList[contractAddress] = false;
    }
    
    function claimToken() external {
        require(contractList[msg.sender], "Contract not on list");
        require(!claimed[msg.sender], "Token already claimed");
        useToken.transfer(msg.sender, 1 ether);
        claimed[msg.sender] = true;
    }
}
