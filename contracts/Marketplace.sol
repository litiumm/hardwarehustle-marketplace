// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

contract HardwareMarketplace {
    address public organizer;

    struct Item {
        uint256 id;
        string name;
        uint256 price;
        uint256 count;
        address payable seller;
    }

    uint256 public nextItemId;
    mapping(uint256 => Item) public inventory;

    // item id => user address => count
    mapping(uint256 => mapping(address => uint256)) public userPurchases;

    event AddItem(
        address indexed from,
        string name,
        uint256 price
    );

    event BuyItem(
        address indexed from,
        uint256 indexed id,
        uint256 price
    );

    constructor() {
        organizer = msg.sender;
        addInitialStock("Arduino Uno", 0.01 ether, 10);
        addInitialStock("ESP32 DevKit", 0.005 ether, 15);
        addInitialStock("Raspberry Pi 4", 0.04 ether, 5);
    }

    function addInitialStock(string memory name, uint256 price, uint256 count) internal {
        inventory[nextItemId] = Item(nextItemId, name, price, count, payable(msg.sender));
        nextItemId++;
    }

    function addItem(string memory _name, uint256 _priceInWei, uint256 _count) public {
        require(msg.sender == organizer, "Only organizer can add items");
        inventory[nextItemId] = Item(nextItemId, _name, _priceInWei, _count, payable(msg.sender));
        emit AddItem(msg.sender, _name, _priceInWei);
        nextItemId++;
    }

    function buyItem(uint256 _id) public payable {
        Item storage item = inventory[_id];

        require(_id < nextItemId, "Item does not exist");
        require(msg.value >= item.price, "Not enough ETH sent");
        require(item.count > 0, "Item stock over");

        item.count -= 1;
        userPurchases[_id][msg.sender] += 1;

        emit BuyItem(msg.sender, _id, msg.value);
    }

    function withdraw() public {
        require(msg.sender == organizer, "Only organizer can withdraw");
        payable(organizer).transfer(address(this).balance);
    }

    function getBuyers(uint256 id, address user) public view returns (uint256) {
        return userPurchases[id][user];
    }
}
