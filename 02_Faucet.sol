// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/**
 * @title Owned
 * @dev The Owned contract has a payable owner address, sets the msg.sender as owner, and provides access control modifier to determine it is owner who call the function.
  */
contract Owned {
    address payable owner;

    // Contract constructor: set owner
    constructor() {
        owner = payable(msg.sender);
    }

    // Access control modifier
    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }
}

/**
 * @title Mortal
 * @dev The Mortal contract is owned by owner, and provides functions to kill the contract.
 * */
contract Mortal is Owned {
    
    // function to destroy the contract
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
}

/**
 * @title Faucet
 * @dev The Faucet contract is owned by owner, and can recieve and send ethers.
 * */
contract Faucet is Mortal {

    // event triggered when withdraw is called
  event Withdrawal(address indexed to, uint amount);

  // event triggered when deposit is called
	event Deposit(address indexed from, uint amount);

  // Accept any incoming amount
  receive() external payable {
    emit Deposit(msg.sender, msg.value);
  }

  /**
   * @dev Withdraws ethers from the contract.
   * @param _to The address to send the ethers to.
   * @param _withdrawAmount The amount of ethers to withdraw.
    */
  function withdraw(address payable _to, uint _withdrawAmount) public payable {
      // Limit withdrawal amount
      require(_withdrawAmount <= 0.5 ether);

      require(
        address(this).balance >= _withdrawAmount,
        "Insufficient balance in faucet for withdrawal request"
      );

      // Send the amount to the address that requested it
      _to.transfer(_withdrawAmount);

      emit Withdrawal(msg.sender, _withdrawAmount);
  }
}