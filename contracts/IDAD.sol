pragma solidity ^0.6.2;


interface IDAD {

    function posterClicked(uint256 _posterId) external;
    function depositEth(address payable _address, uint256 _value) external;
    function addPoster(uint256 _id, uint256 _depositedEth, uint256 _oneClickEthValue, string calldata _posterIpfsHash) external;
    function updatePosterStatus(uint256 _posterId, bool status) external;
    function deletePoster(uint256 _posterId) external;
}