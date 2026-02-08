// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;
import "hardhat/console.sol";

contract HardwareMarketplace {
    address public organizer;

    struct Item {
        uint256 id;
        string name;
        uint256 price;
        bool isSold;
        address buyer;
    }

    uint256 public nextItemId;
    mapping(uint256 => Item) public inventory;

    constructor() {
        organizer = msg.sender; // The person who deploys the contract
    }

    // Only you can add hardware to the store
    function addItem(string memory _name, uint256 _priceInWei) public {
        require(msg.sender == organizer, "Only organizer can add items");
        inventory[nextItemId] = Item(nextItemId, _name, _priceInWei, false, address(0));
        nextItemId++;
    }

    // The function teams call to "buy" hardware
    function buyItem(uint256 _id) public payable {
        Item storage item = inventory[_id];

        require(_id < nextItemId, "Item does not exist");
        require(msg.value >= item.price, "Not enough ETH sent");
        require(!item.isSold, "Item already sold");

        item.isSold = true;
        item.buyer = msg.sender;
    }

    // At the end of the hackathon, you can take the ETH back
    function withdraw() public {
        require(msg.sender == organizer, "Only organizer can withdraw");
        payable(organizer).transfer(address(this).balance);
    }
}
