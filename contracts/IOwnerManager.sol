pragma solidity ^0.6.2;


interface IOwnerManager {

    event AddedToWhitelist(address indexed account);
    event RemovedFromWhitelist(address indexed account);
    
    function addOwner(address _address) external;
    function removeOwner(address _address) external;
    function isWhitelisted(address _address) external view returns(bool);
    function likeOwner(address _address) external;
    function unlikeOwner(address _address) external;
    function getOwnerLike (address _address) external view returns(uint256);
    function getOwnerUnlike(address _address) external view returns(uint256);
}