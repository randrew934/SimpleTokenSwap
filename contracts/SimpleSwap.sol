// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./TokenWithOpenZeppelin.sol";

contract SimpleERCTokenSwap{
    ERC20 private token1;
    ERC20 private token2;
    string public pair1;
    string public pair2;
    uint256 public rate;

    event TokenExchanged(address account, uint256 amount, uint256 rate);

    constructor(ERC20 _token1, ERC20 _token2, uint256 _rate){
        token1 = _token1;
        token2 = _token2;
        rate = _rate;
        pair1 = token1.name();
        pair2 = token2.name();
    }

    function exchangePair1ForPair2Rate(uint256 _value) internal view returns(uint256){
        uint256 tokenValue = _value * rate;
        return tokenValue;
    }

    function exchangePair2ForPair1Rate(uint256 _value) internal view returns(uint256){
        uint256 tokenValue = _value / rate;
        return tokenValue;
    }

    function getEthBalance() external view returns(uint256){
        return address(this).balance;
    }

    function getToken1Balance() external view returns(uint256){
        return token1.balanceOf(address(this));
    }

    function getToken2Balance() external view returns(uint256){
        return token2.balanceOf(address(this));
    }

    function getToken1BalanceOfSender() external view returns(uint256){
        return token1.balanceOf(msg.sender);
    }

    function getToken2BalanceOfSender() external view returns(uint256){
        return token2.balanceOf(msg.sender);
    }



    function exchangePair1ForPair2(uint256 _amount) external{
        require(_amount >= 1 ether, "Amount is too low");
        //Token Amount
        uint256 tokenAmount = exchangePair1ForPair2Rate(_amount);
        //Check if the caller has sufficient supply of Token
        require(token1.balanceOf(msg.sender) >= _amount, "Insufficient Supply");
        //Check if the token amount is available in the Swap
        require(token2.balanceOf(address(this)) >= tokenAmount, "Insufficient Supply");
        //Transfer the Pair1
        token1.transferFrom(msg.sender, address(this), _amount);
        //Transfer the Pair2
        token2.transferFrom(address(this), msg.sender, tokenAmount);

        emit TokenExchanged(msg.sender, _amount, rate);
    }


        function exchangePair2ForPair1(uint256 _amount) external{
        require(_amount >= 1 ether, "Amount is too low");
        //Token Amount
        uint256 tokenAmount = exchangePair2ForPair1Rate(_amount);
        //Check if the caller has sufficient supply of Token
        require(token2.balanceOf(msg.sender) >= _amount, "Insufficient Supply");
        //Check if the token amount is available in the Swap
        require(token1.balanceOf(address(this)) >= tokenAmount, "Insufficient Supply");
        //Transfer the Pair2
        token2.transferFrom(msg.sender, address(this), _amount);
        //Transfer the Pair1
        token1.transferFrom(address(this), msg.sender, tokenAmount);

        emit TokenExchanged(msg.sender, _amount, rate);
    }



}