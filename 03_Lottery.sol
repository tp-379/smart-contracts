// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/// @title Lottery
/// @notice It is a simple lottery contract.
/// @dev This contract is used to test the lottery functionality.
contract Lottery {

    // state variables declaration
    address public manager;
    address payable[] public players;
    
    // Contract constructor: set manager
    constructor() {
        manager = msg.sender;
    }
    
    /// @notice Add player to the lottery
    /// @dev Requires a min contribution to enter to lottery and is payable
    function enter() public payable {
        require(msg.value > .01 ether);
        players.push(payable(msg.sender));
    }
    
    /// @notice Generate a random number
    /// @dev Returns a uint random number
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
    
    /// @notice Pick a winner
    /// @dev Requires a random number, finds index and uses it to pick a winner.
    function pickWinner() public restricted {
        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0);
    }
    
    // access modifier
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    /// @notice Get the players details
    /// @dev Returns the players array
    /// @return players array
    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }
}   