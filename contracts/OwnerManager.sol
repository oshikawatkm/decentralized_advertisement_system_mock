pragma solidity ^0.6.2;

// import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import './IOwnerManager.sol';

contract OwnerManager is IOwnerManager {
    
    struct whitelistedOwner {
        address owner;
        uint256 like;
        uint256 unlike;
        bool whitelisted;
    }
    
    uint256 whitelist_exclusion_threshold = 100;
    
    modifier _onlyWhitelisted() {
        require(isWhitelisted(msg.sender));
        _;
    }
    
    modifier _notSameAddress(address _address) {
        require(msg.sender != _address);
        _;
    }
    
    mapping(address => whitelistedOwner) whitelist;
    event AddedToWhitelist(address indexed account);
    event RemovedFromWhitelist(address indexed account);
    
    function addOwner(address _address) external override _onlyWhitelisted {
        whitelist[_address].whitelisted = true;
        emit AddedToWhitelist(_address);
    }
    
    function removeOwner(address _address) external override {
        whitelist[_address].whitelisted = false;
        emit RemovedFromWhitelist(_address);
    }
    
    function isWhitelisted(address _address) public view override returns(bool)  {
        return whitelist[_address].whitelisted;
    }
    
    function likeOwner(address _address) external override _notSameAddress(msg.sender) {
        whitelist[_address].like++;
    }
    
    function unlikeOwner(address _address) external  override _notSameAddress(msg.sender) {
        whitelist[_address].unlike++;
        uint256 poster_hate_count = whitelist[_address].like - whitelist[_address].unlike;
        if (poster_hate_count >= whitelist_exclusion_threshold) {
            whitelist[_address].whitelisted = false;
            emit RemovedFromWhitelist(_address);
        }
    }
    
    function getOwnerLike (address _address) external view override returns(uint256) {
        return whitelist[_address].like;
    }
    
    function getOwnerUnlike(address _address) external view override returns(uint256) {
        return whitelist[_address].unlike;
    }
}