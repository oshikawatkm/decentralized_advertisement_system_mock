pragma solidity ^0.6.2;

import './IDAD.sol';
import './OwnerManager.sol';


contract DAD is IDAD, OwnerManager  {
    
    struct Poster {
        uint256 _id;
        address _owner;
        uint256 _depositedEth;
        uint256 _oneClickEthValue;
        string _posterIpfsHash;
        bool _published;
    }
    
    modifier _hasDepositedPoster(uint256 _posterId, uint256 _value) {
        require (posters[_posterId]._depositedEth.value >= _value, "This Poster don't have enough deposit.");
        _;
    }
    
    modifier _isOwner(uint256 _posterId) {
        require(posters[_posterId]._owner == msg.sender);
        _;
    }
    
    mapping(uint256 => Poster[]) posters;
    mapping(address => uint256[]) posterByOwnerAddress;
    
    
    function posterClicked(uint256 _posterId) external override _hasDepositedPoster(_posterId) {
        msg.value += posters[_posterId]._oneClickEthValue;
    }
    
    function depositEth(address payable _address, uint256 _value) external override _onlyWhitelisted {
        require (msg.value == _value, "You don't have enough ETH.");
        posterByOwnerAddress[_address]._depositedEth = _value;
    }
    
    function addPoster(uint256 _id, uint256 _depositedEth, uint256 _oneClickEthValue, string calldata _posterIpfsHash) external override _onlyWhitelisted {
        require(_depositedEth == msg.value);
        posterByOwnerAddress[msg.sender].push(Poster(_id, msg.sender, _oneClickEthValue, _posterIpfsHash, true));
    }
    
    function getPoster(uint256 _id) external view override returns(uint256, address, uint256, uint256, string) {
        Poster poster = posters[_id];
        require (poster._published == true, "This Poster can't use;");
        return (poster._id, poster._owner, poster._depositedEth, poster._oneClickEthValue, poster._posterIpfsHash);
    }
    
    function getPosterByOwner(uint256 _id) external view override _isOwner returns(uint256, address, uint256, uint256, string, bool) {
        Poster poster = posters[_id];
        return (poster._id, poster._owner, poster._depositedEth, poster._oneClickEthValue, poster._posterIpfsHash, poster._published);
    }
    
    function updatePosterStatus(uint256 _posterId, bool status) external override _isOwner {
        require (posterByOwnerAddress[msg.sender][_posterId]._owner == msg.sender);
        posterByOwnerAddress[msg.sender][_posterId]._published = status;
    }
    
    function deletePoster(uint256 _posterId) external override _isOwner {
        delete posterByOwnerAddress[msg.sender]._posterId;
        delete posters[Poster[_posterId]];
    }
}