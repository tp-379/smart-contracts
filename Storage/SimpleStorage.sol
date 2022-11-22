// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;  // solidity version to use

// contract definition
contract SimpleStorage {

    // gets initialized to zero on creation
    // default visiblity is private
    uint256 favoriteNumber; 

    // People public person = People({favoriteNumber: 55, name: "John"});

    // mapping
    mapping(string => uint256) public nameToFavoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    // uint256[] public favoriteNumberList;
    People[] public people;

    // virtual keyword to override this function in ExtraStorage Contract
    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
    }
    
    // view, pure - don't need any gas to execute
    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    // calldata, memory, storage
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // people.push(People(_favoriteNumber, _name));
        // People memory newPerson = People({favoriteNumber: _favoriteNumber, name: _name});
        People memory newPerson = People(_favoriteNumber, _name);
        people.push(newPerson);

        // add to mapping
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

}