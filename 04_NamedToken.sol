// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// importing ERC721 from OpenZeppelin
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';

/// @title NamedToken
/// @notice You can use this contract to generate ERC721 tokens with unique names.
/// @dev This contract is based on ERC721 contract.
contract NamedToken is ERC721 {

  // to find out who owns the NFT
  address public owner;

  // increase the value with each token minted
  uint256 tokenId = 1;

  // properties of each token
  struct Name {
    uint tokenId;
    string tokenName;
    address owner;
  }

  // list to keep track of all the tokens
  Name[] public allTokens;

  // mapping to find out all tokens owned by an address
  mapping(address => Name[]) public tokenAddress;

  // mapping to check if a token already exists
  mapping(string => bool) public tokenExists;

  // constructor for ERC721
  constructor() ERC721('NamedToken', 'MNT') {
    // message sender is the owner
    owner = msg.sender;
  }

  /// @notice Get all tokens
  /// @dev returns all the tokens
  function getAllTokens() public view returns (Name[] memory) {
    return allTokens;
  }

  /// @notice Get tokens of a specific address
  /// @dev returns all the tokens of a specific address
  function getMyTokens() public view returns (Name[] memory) {
    return tokenAddress[msg.sender];
  }

  /// @notice Function to mint tokens
  /// @dev Mints a new token with a unique name
  /// @param _tokenName to be used to generate the token
  function mintToken(string calldata _tokenName) public payable {
    // check if token already exists
    require(!tokenExists[_tokenName], "Token already exists");

    // create a new token, comes from ERC721 contract
    _safeMint(msg.sender, tokenId);

    // add the token to the list
    allTokens.push(Name(tokenId, _tokenName, msg.sender));

    // add the token to the mapping
    tokenAddress[msg.sender].push(Name(tokenId, _tokenName, msg.sender));

    // update token exists to true
    tokenExists[_tokenName] = true;

    // update token id
    tokenId++;

  }

}
